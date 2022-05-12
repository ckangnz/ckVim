# WYSIWYG Text editor on react

```bash
yarn add react-draft-wysiwyg draft-js draft-js-export-html
```

```js
import { Editor } from 'react-draft-wysiwyg';
import { EditorState, convertFromRaw, convertToRaw } from 'draft-js';
import { stateToHTML } from 'draft-js-export-html';

    ...
    state = {
        editorState:EditorState.createEmpty(),
        ...
    }
    ...

    onEditorStateChange = (editorState) => {
        let contentState = editorState.getCurrentContent();
        let rawState = convertToRaw(contentState) // Store this to db
        let html = stateToHTML(contentState) // Show this in frontend

        this.setState({
            editorState
        })
    }

    <Editor
        editorState={this.state.editorState}
        wrapperClassName="myEditor-wrapper"
        editorClassName="myEditor-editor"
        onEditorStateChange={this.onEditorStateChange}
    />
```

- Import the css file from the `node_modules` to project for styling

## To render WYSIWYG HTML in JSX

```js
<div dangerouslySetInnerHTML={{ __html: article.text }}></div>
```
