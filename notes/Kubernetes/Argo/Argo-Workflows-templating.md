# Argo Workflows Templates

> There are several types of templates, divided into two different categories: Work and Orchestration

## WORK

- [Container](#container) (Most common)
  - run multiple containers in a single pod
  - useful when you want the containers to share a common workspace, or when you want to consolidate pod spin-up time into on step in your workflow
- Container Set
- Data
  - get data from storage (e.g. S3)
  - useful when each item of data represents an item of work that needs doing
- Resource
  - create a K8s resource and wait for it to meet a condition (e.g. successful)
  - useful if you want to interoperate with another K8s system (e.g. AWS Spark EMR)
- Script
  - run a script in a container
  - similar to container template but when you've added a script to it

## ORCHESTRATES

> [!NOTE] Orchestration templates do NOT run pods

- [DAG](#dag-template-orchestration-type)<Directed Acyclic Graph> (Most common)
- Steps
  - run a series of steps in sequence
- Suspend
  - automatically suspend a workflow
    - e.g. while waiting on manual approval, or while an external system does some work

## Templating

> There are many more different tags, you can [read more about template tags in the docs](https://argo-workflows.readthedocs.io/en/latest/variables/).

> [!TIP] You can run these templates by `argo submit --watch <yaml-file>.yaml`

### Container Template

```yaml
# Example of Container Template
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: container-
spec:
  entrypoint: main
  templates:
    - name: main
      container: # creates a container template
        image: docker/whalesay
        command: [cowsay]
        args: ["hello {{workflow.name}}"] #you can use template tags using {{ and }}
```

### DAG Template (Orchestration Type)

```yaml
# Example of DAG (Directed acyclic graph) Template
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: dag-
spec:
  entrypoint: main
  templates:
    - name: main
      dag: # new DAG template
        tasks:
          - name: a
            template: whalesay #runs whalesay container template
          - name: b
            template: whalesay #runs whalesay container but depends on task a
            dependencies:
              - a

    - name: whalesay
      container: #same template as in the container example
        image: docker/whalesay
        command: [cowsay]
        args: ["hello world"]
```

The outcome should show something like

```bash
STEP          TEMPLATE  PODNAME              DURATION  MESSAGE
 ✔ dag-shxn5  main
 ├─✔ a        whalesay       dag-shxn5-289972251  6s
 └─✔ b        whalesay       dag-shxn5-306749870  6s
```

### Loops

The ability to run large parallel processing jobs is one of the key features of Argo Workflows.
The two items will run at the same time.

#### withItems

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: with-items-
spec:
  entrypoint: main
  templates:
    - name: main
      dag:
        tasks:
          - name: print-message
            template: whalesay
            arguments:
              parameters:
                - name: message
                  value: "{{item}}" #this will be replaced by 'hello world' and 'goodbye world'
            withItems: # performs loop
              - "hello world"
              - "goodbye world"

    - name: whalesay
      inputs:
        parameters:
          - name: message
      container:
        image: docker/whalesay
        command: [cowsay]
        args: ["{{inputs.parameters.message}}"]
```

The outcome should be something like :

```bash
STEP                                 TEMPLATE  PODNAME                      DURATION  MESSAGE
 ✔ with-items-4qzg9                  main
 ├─✔ print-message(0:hello world)    whalesay  with-items-4qzg9-465751898   7s
 └─✔ print-message(1:goodbye world)  whalesay  with-items-4qzg9-2410280706  5s
```

#### withSequence

Loops over a sequence of numbers using `withSequence`.
All pods will run at the same time and will have item values in the name.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: with-sequence-
spec:
  entrypoint: main
  templates:
    - name: main
      dag:
        tasks:
          - name: print-message
            template: whalesay
            arguments:
              parameters:
                - name: message
                  value: "{{item}}"
            withSequence:
              count: 5

    - name: whalesay
      inputs:
        parameters:
          - name: message
      container:
        image: docker/whalesay
        command: [cowsay]
        args: ["{{inputs.parameters.message}}"]
```

The outcome should be something like:

```bash
STEP                     TEMPLATE  PODNAME                         DURATION  MESSAGE
 ✔ with-sequence-8nrp5   main
 ├─✔ print-message(0:0)  whalesay  with-sequence-8nrp5-3678575801  9s
 ├─✔ print-message(1:1)  whalesay  with-sequence-8nrp5-1828425621  7s
 ├─✔ print-message(2:2)  whalesay  with-sequence-8nrp5-1644772305  13s
 ├─✔ print-message(3:3)  whalesay  with-sequence-8nrp5-3766794981  15s
 └─✔ print-message(4:4)  whalesay  with-sequence-8nrp5-361941985   11s
```

#### onExit (Exit handler)

If you need to perform a task after something has finished, use the exit handler.
An exit handler can be run at the end of a template, or at the end of a workflow.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: exit-handler-
spec:
  entrypoint: main
  onExit: tidy-up # triggers 'tidy-up' template when workflow ends

  templates:
    - name: main
      dag:
        tasks:
          - name: a
            template: whalesay
            onExit: tidy-up # triggers 'tidy-up' template when 'whalesay' template ends

    - name: whalesay
      container:
        image: docker/whalesay
        command: [cowsay]

    - name: tidy-up
      container:
        image: docker/whalesay
        command: [cowsay]
        args: ["tidy up!"]
```

The outcome should be something like this:

```bash
STEP                          TEMPLATE  PODNAME                        DURATION  MESSAGE
 ✔ exit-handler-plvg7         main # triggers when 'a' finishes
 ├─✔ a                        whalesay  exit-handler-plvg7-1651124468  5s #Runs first
 └─✔ a.onExit                 tidy-up   exit-handler-plvg7-3635807335  6s #Triggered by exit-handler
 ✔ exit-handler-plvg7.onExit  main # triggers when 'exit-handler' finishes
```
