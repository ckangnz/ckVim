# Image

```js
//import Image from react-native
import {Image} from 'react-native';


//Local Image
import local_image from './src/img/img.jpg'
<Image resizeMode="cover" source={local_image}/>


//External URL image
const image = { 
  uri: "http://placehold.it/20x20"
}
<Image resizeMode="contain" source={image}/>
```
