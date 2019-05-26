# React Native
  > Learn once, write everywhere

```bash
npm create-react-native-app .
npm init react-native-app .
yarn create react-native-app .

npm run start
yarn start
```

* Download Expo Client app from your mobile device
* Use camera to scan the QR code and open with Expo Client
* Or install simulator

### React Native Tag Elements

```html
<!--HTML-->
<div></div>
<p>Text value</p>
<input/>
<button>Value</button>

<!--React Native-->
import { ScrollView, View, Text, TextInput, Button } from 'react-native';
<ScrollView></ScrollView>
<View></View>
<Text>Text value</Text>
<TextInput />
<Button title="Value"/>
```

### React Native Styling
```js
import { StyleSheet, View } from 'react-native';

<View style={styles.container}>
  <View style={styles.inputContainer}> </View>
</View>

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 36,
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'flex-start',
    },
    inputContainer : {
        flexDirection:'row',
        width:"100%",
        justifyContent:'space-between',
        alignItems: 'center',
    },
    //...
});
```
