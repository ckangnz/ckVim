# Pure Component

> Pure Component does not re-render if state and nextState has the same value.

```js
import { PureComponent } from 'react';

class ComponentName extends PureComponent {
}
```

* Pure Component does not require shouldComponentUpdate(), but automatically checks them.
