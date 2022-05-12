# Checking Prop types

- Install prop-types

```bash
npm install prop-types
yarn add prop-types
```

- Usage

```js
import PropTypes from 'prop-types';

const ComponentName = (props) => {
  return <div>hi</div>;
};

ComponentName.propTypes = {
  //Only allow such types
  propField: PropTypes.string, //number, array, bool, object, func

  //Allow only values in array
  propField: PropTypes.oneOf(['value', 'value2']),

  // Allow only such types in an array e.g. ['string','string']
  propField: PropTypes.arrayOf(PropTypes.string),

  propField: function (props, propName, componentName) {
    //props == { propField:"...", ... }
    //propName == "propField"
    //componentName == "ComponentName"
  },
};
```
