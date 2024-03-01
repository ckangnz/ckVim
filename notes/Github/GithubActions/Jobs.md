# Jobs

A workflow run is made up of one or more `jobs`, which run in parallel by default.

```yaml
jobs:
  my_first_job:
    name: My first job

  sequencial_job:
    name: Depends on first job
    needs: my_first_job

  final_job:
    name: Runs last
    needs: [my_first_job, sequencial_job]

  always_run_job:
    name: Always run even it fails!
    if: ${{ always() }}
    needs: final_job
```
