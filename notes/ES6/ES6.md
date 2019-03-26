# ECMA Script 6 Scripts

## Workflow 
`ES6` => `Babel(Compile ES6 to ES5)` => `ES5(All Browsers)`

---

### Tutorials

#### 1. `const` & `let`
* No more `var`
* `const` is NOT mutable variable
* `let` is mutable variable
* `const` and `let` is always local scoped
* can't declare the same variable again

#### 2. Template Strings

```js
//ES5
var intro = "My name is " + name + ", and I am " + age + " years old."

//ES6
const intro = `My name is ${name}, and I am ${age} years old.`
const rawText = String.raw`This\nis\nline\nbreak`;
```

#### 3. Foreach
```js
const array = ['1','2','3','4'];

//ES5
for(var i = 0; i < array.length; i++){
  console.log(array[i]);
}

//ES6
array.forEach((item)=>{
  console.log(item)
})
```

#### 4. Map (Array helper)
 - Always returns an array
```js
//ES5
var numbers = [1,2,3,4,5]
var otherArray = [];

for (var i = 0; i < numbers.length; i++){
  otherArray.push(numbers[i]*10)
}

//ES6
const numbers = [ 1,2,3,4,5 ]
const otherArray = numbers.map((number)=>{
  return number * 10
})
```

#### 5. Filter
 - Always returns an array depending on the condition
```js
const products = [
  {name:'ipad', category:'devices'},
  {name:'Sony 3d', category:'TV'},
  {name:'Super vision', category:'TV'},
]

const result = products.filter((product){
  return product.category === 'TV' //returns two array items
})
```

#### 6. Find
 - Always returns the top matching array item that matches the condition
```js
const products = [
  {name:'ipad', category:'devices'},
  {name:'Sony 3d', category:'TV'},
  {name:'Super vision', category:'TV'},
]

const result = products.find((product){
  return product.category === 'TV' //returns two items
})
```

#### 7. Every & Some
 - Returns boolean depending on the condition
```js
const students = [
{name:"Chris",grade:10},
{name:"Kang",grade:4},
{name:"Heya",grade:6},
]

let didAllPass = students.every((student)=>{
  return student.grade >= 4
})
console.log(didAllpass) // true

let didAtLeastOnePass = students.some((student)=>{
  return student.grade >= 4
})
console.log(didAtLeastOnePass) // true
```

#### 8. Reduce
 - Loops and updates the first argument
```js
const beginning = 0;
const items = [
  {type:'guitar',cost:1000},
  {type:'microphone', cost: 300},
  {type:'keyboard',cost: 800},
]

const total = items.reduce( (start, item)=>{
  return start + item.cost;
}, beginning)
```

```js
const users = [
{name:'Chris' ,  age:23},
{name:'Kang'  ,  age:23},
{name:'Heya'  ,  age:23},
]
const names = users.reduce( (start,user)=>{
  start.push(user.name);
  return start;
}, []);
```
```js
const computers = [
  {type:'Laptop' , price:124 , os:"Windows"} ,
  {type:'Desk'   , price:124 , os:"Mac"}     ,
  {type:'Desk'   , price:124 , os:"Windows"} ,
  {type:'Laptop' , price:124 , os:"Mac"}     ,
  {type:'Laptop' , price:124 , os:"Windows"} ,
]

let osTypes = computers.reduce((start,item)=>{
  return item.os === 'Mac'
  ? {mac: start.mac + 1 , windows:start.windows}
  : {mac: start.mac     , windows:start.windows + 1}
}, {mac:0, windows:0}) 
```

#### 9. For .. of
```js
const list = [ "one" , "two", "three" ]
for (let item of lists){
  console.log(item)
}
```

#### 10. => Function
```js
//ES5
var value = function(name){
  return "My name is " + name + ".";
}
//ES6
const value = (name) => {
  return `My name is ${name}.`;
}
const value = name => `My name is ${name}.`
```

#### 11. Object Literals
```js
//ES5
var createCharacter = function(name,powers){
  return {
    name:name,
    powers:powers,
    getInfo:function(){
      return this.name + "has following powers : " + powers;
    }
  }
}

//ES6
const createCharacter = (name, powers)=> {
  return {
    name,
    powers,
    getInfo(){
      return `${this.name} has following powers : ${powers}`
    }
  }
}
```

#### 12. Default Function Arguments
```js
//ES5
function cars(brand){
  if(!brand){
    brand="Ford"
  }
  console.log("My brand is " + brand)
}

//ES6
const cars = (brand="Ford")=>{
  console.log(`My brand is ${brand}`)
}
```

#### 13. Rest Operator
```js
//ES5
function args(arg1, arg2, arg3){
  var arguments = [arg1, arg2, arg3];
  console.log(arguments[1]);
}

//ES6
const args = (...args)=>{
  console.log(args[1]);
}
```

#### 14. Spread Operator
```js
const brand = ["Ford", "Nissan"];
const otherBrand = ["Audi", "BMW"];

//ES5
var newArray = brands.concat(otherBrand);
newArray.push('Other brand')

//ES6
const newArray = [...brand,...otherBrand,'Other brand'];
```

#### 15. Classes
```js
//ES5
function Car(){}
Car.prototype = {
  status: 'new',
  wheels: 4,
  avail : function(){
    console.log('available')
  }
}
var ford = new Car();


//ES6
class Car {
  constructor(){
    this.status = 'new';
    this.wheels = 4;
    this.avail = ()=>{ console.log('available') }
  }
}
const car = new Car();

class Ford extends Car{
  constructor(){
    super();
  }
}
const ford = new Ford();
```

#### 16. Destructuring 
 - Destructuring Objects
```js
const user = {
  name:"Chris",
  lastname:"Kang",
  age:28
}

//ES5
var name = user.name;
var lastname = user.lastname;
var age = user.age;

console.log(name);

//ES6
const {name, lastname, age} = user;

console.log(name);
```
 - Destructuring Array
```js
const brands = [
  'BMW',
  'Merc',
  'Audi',
]

//ES5
var bmw = brands[0];
var merc = brans[1];
var audi = brans[2];

//ES6
const [bmw, merc, audi] = brands;
```

#### 17. Promises
 - Makes the process hold until satisfied condition
 - Promise has these states : Unresolved/Pending => Resolved/Fulfilled => Rejected
```js
let promise = new Promise((resolved, rejected)=>{
  resolved();
  //rejected();
})
.then(()=>{console.log("resolved")})
.catch((error)=>{console.log(error)})
```

#### 18. Fetch
 - Fetch is a promise
```js
const url = "https://api.call.json"
fetch(url)
.then(response=>response.json())
.then(data=>console.log(data))
.catch(error=>console.log(error))
```
 - Post request
```js
fetch(url,{
  method  : 'POST',
  headers : {
    'Content-Type': 'application;json'
  }
})
.then(response=>response.json())
.then(data=>console.log(data))
.catch(error=>console.log(error))
```

#### 19. Strings and Numbers
```js
//Repeating strings
console.log("hello".repeat(3))

//Index Of
const word = "camera"
word.indexOf('cam') //0
word.startsWith("cam") //true
word.startsWith("cam", 1) //false
word.endsWith("era") //true
word.endsWith("era", 4) //false ( first 4 characters 'came' )
word.includes('ame') //true
word.includes('ame', 2) //false ( chop off first 2 characters 'mera' )

//Numbers
Number.isSafeInteger(20) //true
Number.isSafeInteger(0.23) //false
Number.isInteger(20) //true

//Rounding up closer to zero
Math.trunc(24.3) //24
Math.trunc(-12.12) //-12
```

#### 20. Modules
```js
//main.js
import { array } from './app.js'
import defaultExp from './app.js'

//app.js
export const array = [ 1, 2, 3 ];
export default defaultExp = [ 1, 2, 3 ]; //can have only one default export
```

#### 21. Generators
 - a function that can stop and continue
```js
function *generator(){
  // Run this on first run
  yield 'First run';
  // Run this on second run
  yield 'Second run';
  // Run this on third run
  yield 'Third run';
  // Run this on fourth run
  yield* othergenerator(); //copy yields from this generator
  return true;
}

function* othergenerator(){
  yield 'From othergenerator 1';
  yield 'From othergenerator 2';
}

const gen = generator();
gen.next(); //repeat .next() to run the next yield

let array = []
for( var i of brands() ){
  array = [...array, i];
}
```
