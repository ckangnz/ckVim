# Creating Form Components

```js
class User extends Component {
  state = {
    formData: {
      name: {
        element: 'input',
        value: '',
        label: true,
        labelText: 'Name',
        config: {
          name: 'name_input',
          type: 'text',
          placeholder: 'Enter your name',
        },
      },
      lastname: {
        element: 'input',
        value: '',
        label: true,
        labelText: 'Lastname',
        config: {
          name: 'lastname_input',
          type: 'text',
          placeholder: 'Enter your Lastname',
        },
      },
      message: {
        element: 'textarea',
        value: '',
        label: true,
        labelText: 'Message',
        config: {
          name: 'message_input',
          rows: 4,
          cols: 36,
        },
      },
      age: {
        element: 'select',
        value: '',
        label: true,
        labelText: 'Age',
        config: {
          name: 'age_input',
          options: [
            { val: '1', text: '10-20' },
            { val: '2', text: '20-30' },
            { val: '3', text: '+30' },
          ],
        },
      },
    },
  };

  submitForm = (e) => {
    e.preventDefault();
    let dataToSubmit = {};
    for (let key in this.state.formData) {
      dataToSubmit[key] = this.state.formData[key].value;
    }
    console.log(dataToSubmit);
  };

  updateForm = (newState) => {
    this.setState({
      formData: newState,
    });
  };

  render() {
    return (
      <div className="container">
        <form onSubmit={this.submitForm}>
          <FormFields
            formData={this.state.formData}
            change={(newState) => this.updateForm(newState)}
          />
          <button type="submit">Submit</button>
        </form>
      </div>
    );
  }
}
```

```js
const FormFields = (props) => {
  const renderFields = () => {
    const formArray = [];

    for (let elementName in props.formData) {
      formArray.push({
        id: elementName,
        settings: props.formData[elementName],
      });
    }

    return formArray.map((item, i) => {
      return (
        <div key={i} className="form_element">
          {renderTemplates(item)}
        </div>
      );
    });
  };

  const changeHandler = (e, id) => {
    const newState = props.formData;
    newState[id].value = e.target.value;
    props.change(newState);
  };

  const renderTemplates = (data) => {
    let formTemplate = null;
    let values = data.settings;

    switch (values.element) {
      case 'input':
        formTemplate = (
          <div>
            {showLabel(values.label, values.labelText)}
            <input
              value={values.value}
              {...values.config}
              onChange={(event) => changeHandler(event, data.id)}
            />
          </div>
        );
        break;
      case 'textarea':
        formTemplate = (
          <div>
            {showLabel(values.label, values.labelText)}
            <textarea
              {...values.config}
              value={values.value}
              onChange={(event) => changeHandler(event, data.id)}
            ></textarea>
          </div>
        );
        break;
      case 'select':
        formTemplate = (
          <div>
            {showLabel(values.label, values.labelText)}
            <select
              value={values.value}
              name={values.config.name}
              onChange={(event) => changeHandler(event, data.id)}
            >
              {values.config.options.map((item, i) => (
                <option key={i} value={item.val}>
                  {item.text}
                </option>
              ))}
            </select>
          </div>
        );
        break;
      default:
        formTemplate = null;
    }
    return formTemplate;
  };

  const showLabel = (show, label) => {
    return show ? <label>{label}</label> : null;
  };

  return <div>{renderFields()}</div>;
};
```
