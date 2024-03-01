# Variables

You can create environment variables

```yaml
env:
  VARIABLE_NAME: hello

jobs:
  hello_world:
  env:
    NAME: Chris
  steps:
    - name: "Dear $NAME"
      run: echo "$VARIABLE_NAME $LAST_NAME"
      env:
        LAST_NAME: Kang
```
