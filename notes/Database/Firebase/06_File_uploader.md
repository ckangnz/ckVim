# React Firebase Uploader

```bash
npm install react-firebase-file-uploader
yarn add react-firebase-file-uploader
```

```js
import FileUploader from 'react-firebase-file-uploader';

state = {
    name:'',
    isUploading:false,
    progress:0,
    fileURL:'',
}
handleUploadStart = () => {
    this.setState( {isUploading:true, progress:0} )
}
handleUploadError = (error) => {
    this.setState({isUploading:false})
}
handleUploadSuccess = (filename) => {
    this.setState({
        name:filename,
        progress:100,
        isUploading:false,
    })
    firebase.storage().ref('images').child(filename).getDownloadURL()
        .then( url => {
            this.setState({fileURL : url})
        })

    // Store the randomly generated filename somewhere in states
    this.props.storeFilename(filename)
}

handleProgress = (progress) => {
    this.setState({
        progress,
    })
}

...
<FileUploader
    accept="image/*"
    name="image"
    randomizeFilename
    storageRef={firebase.storage().ref('images')}
    onUploadStart={this.handleUploadStart}
    onUploadError={this.handleUploadError}
    onUploadSuccess={this.handleUploadSuccess}
    onProgress={this.handleProgress}
/>
...
```

### To retrieve the data

```js
firebase.storage().ref('images').child(filename).getDownloadURL()
```
