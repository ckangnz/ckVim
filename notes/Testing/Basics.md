# Theory

- [ Original post ](https://www.freecodecamp.org/news/testing-react-hooks/)

#### _"The more your tests resemble the way your software is used the more confidence they can give you."_

### What is testing?

- `Arrange` => `Act` => `Assert`
- Arrange
  - Original State
- ACt
  - Event
- Assert
  - Hypothesis on new state

### Why test?

- To ensure your app work as intended for end users.
- Meks your app more robust and less error prone.

### What to test?

- Functionality of the app
- How will it be used by end users

### What not to test?

- Implementation details (not end user functionality)
- Third party libraries.

### Types of testing

- Unit Testing
  - ex: a component renders with the default props.
- Integration Testing
  - ex: different component can change states of current component
- End to end Testing
  - Multi step test combining multiple unit and integration tests into one big test.
  - ex: testing an entire authentication flow

## Enzyme

```bash
yarn add enzyme enzyme-to-json enzyme-adapter-react-16
```

```javascript
//src/setupTests.js
import { configure } from "enzyme";
import Adapter from "enzyme-adapter-react-16";

configure({ adapter: new Adapter() });
```

### Snapshot Testing

```javascript
import { shallow } from "enzyme";
import toJson from "enzyme-to-json";

it("renders correctly enzyme", () => {
  const wrapper = shallow(<Basic />);
  expect(toJson(wrapper)).toMatchSnapshot();
});
```

## React Testing Library

```bash
yarn add @testing-library/react
```

```javascript
//...
import TestHook from "../Testhook.js";
import { render, fireEvent, cleanup } from "@testing-library/react";

afterEach(cleanup);

it("change state", () => {
  const { getByText, getByTestId, container } = render(<TestHook />);
  expect(getByText(/Initial/i).textContent).toBe("Initial State");

  fireEvent.click(getByText("State Change button"));
  //fireEvent.change(getByText("Input Text:"), {target:value:'new text!'});
  //if we have a <form data-test-id="form"></form>
  //fireEvent.submit(getByTestId("form"), {target: {text1: {value: 'Text'}} });

  expect(getByText(/Initial/i).textContent).toBe("Initial State changed");
});
```

## Cypress

```bash
yarn add cypress
```

```json
//package.json
"scripts":{
  //...
  'cypress':'node_modules/.bin/cypress open'
}
```

```javascript
import React from "react";

describe("Complete e to e Testing with Cypress", () => {
  it("e to e test", function() {
    cy.visit("/");
    cy.contains("Some text in the app");
    cy.contains("button text").click();
    cy.contains("Text has been changed");
    cy.get("#text1").type("Some value typed in {enter}");
    cy.request("https://someurl").should(res => {
      expect(res.body).not.to.be.null;
      cy.contains(res.body.title);
    });
  });
});
```
