# Argo Workflows Inputs & Outputs

There are two types of input and output:

- Parameters
  - Just short strings
- Artifacts
  - Files/directories compressed and uploaded to artifactory repository such as S3

## Parameters

- Plain string values
- Useful for most simple cases

### Inputs Parameters

Example workflow file below:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: input-parameters-
spec:
  entrypoint: main
  arguments:
    parameters:
      - name: message
        value: hello world
  templates:
    - name: main
      inputs:
        parameters:
          - name: message # input parameter named 'message'
      container:
        image: docker/whalesay
        command: [cowsay]
        args: ["{{inputs.parameters.message}}"]
```

If a workflow has parameters, you can change the parameters using`-p` using the CLI

```bash
argo submit --watch <your-yaml>.yaml -p message="Welcome to Argo!"
```

### Outputs Parameters

Example workflow file below:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: parameters-
spec:
  entrypoint: main #<---1. Sets main DAG as the entry point
  templates:
    - name: main
      dag:
        tasks:
          - name: generate-parameter #<-----2. Runs whalesay template
            template: whalesay

          - name: consume-parameter
            template: print-message
            dependencies:
              - generate-parameter #<----5. Triggers once generate-parameter task completes
            arguments:
              parameters:
                - name: message #<---6. Passes down the input parameter 'message' with 'hello-param' from generate-parameter
                  value: "{{tasks.generate-parameter.outputs.parameters.hello-param}}"

    - name: whalesay
      container:
        image: docker/whalesay
        command: [sh, -c]
        args: ["echo -n hello world > /tmp/hello_world.txt"] #<---3. Creates hello_world.txt file with 'hello world' text
      outputs:
        parameters:
          - name: hello-param #<----4. Outputs parameter 'hello-param'
            valueFrom:
              path: /tmp/hello_world.txt # value comes from the hello_world.txt

    - name: print-message
      inputs:
        parameters:
          - name: message #<-----7. Retrieves paramater 'message'
      container:
        image: docker/whalesay
        command: [cowsay]
        args: ["{{inputs.parameters.message}}"] #<---8. Uses 'message'
```

## Artifacts

Artifacts are typically uploaded into a bucket within some kind of storage such as AWS S3 or GCP GCS.

- Inputs artifacts: file downloaded from storage (e.g. S3) and mounted as a volume within the container
- Outputs artifacts: file created in the container that is uploaded to storage

### Inputs Artifacts

```yaml
template:
  - name: print-message
    inputs:
      artifacts:
        - name: message # the name of artifact
          path: /tmp/message # where it should be created
    container:
      image: docker/whalesay
      command: [sh, -c]
      args: ["cat /tmp/message"]
```

### Outputs Artifacts

```yaml
template:
  - name: save-message
    container:
      image: docker/whalesay
      command: [sh, -c]
      args: ["cowsay hello world > /tmp/hello_world.txt"]
    outputs: #exports the artifact
      artifacts:
        - name: hello-art # artifact name
          path: /tmp/hello_world.txt # where can it be found
```

### Using Inputs and Outputs Artifacts

You can't use inputs and ouputs in isolation. You need to compbine them toegether using either steps of DAG template

```yaml
entrypoint: main
template:
  - name: main
    dag:
      tasks:
        - name: generate-artifact
          template: save-message # outputs the artifact called 'hello-art' from /tmp/hello_world.txt

        - name: consume-artifact
          template: print-message # prints artifact 'message'
          dependencies:
            - generate-artifact # runs after generate-artifact
          arguments:
            artifacts:
              - name: message # inserts an artifact 'message' from 'hello-art'
                from: "{{tasks.generate-artifact.outputs.artifacts.hello-art}}"
```
