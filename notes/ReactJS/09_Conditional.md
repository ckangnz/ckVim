# Conditional (If) in render

### Basic conditions in templates

```js
const Conditional = () => {
  const value = false;
  const returnBoolean = () => {
    return value ? <div>This is true</div> : <div>This is false</div>;
  };

  return (
    <div>
      {value ? <div>This is true</div> : <div>This is false</div>}
      {returnBoolean()}
    </div>
  );
};
```
