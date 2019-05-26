# List

List automatically creates scrollable view

```js
import { FlatList , SectionList } from 'react-native';

<FlatList
  data={[
    { key: 'string', data: ['item1', 'item2'] },
    { key: 'string', data: ['item1', 'item2'] },
    { key: 'string', data: ['item1', 'item2'] },
  ]}
  renderItem={ ({item}) => ( <Text>{item.key}</Text> ) }
/>
<SectionList />

<SectionList
  sections={[
    {title: 'Title1', data: ['item1', 'item2']},
    {title: 'Title2', data: ['item3', 'item4']},
    {title: 'Title3', data: ['item5', 'item6']},
  ]}
  renderItem={({item, index, section}) => <Text key={index}>{item}</Text>}
  renderSectionHeader={({section: {title}}) => (
    <Text style={{fontWeight: 'bold'}}>{title}</Text>
  )}
  keyExtractor={(item, index) => item + index}
/>
```
