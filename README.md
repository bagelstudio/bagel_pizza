
# Bagel Pizza
This app comes to demonstrate the use of the ```bagel_db``` flutter [package](https://pub.dev/packages/bagel_db).  The app simulates the process of ordering a pizza, without processing payments.

**BagelDB** is a headless-CMS with the power of a DB.

This sample app is divided into models, UI main widgets and controller, with state management based on scoped model. 
The UI consists of three widgets: a widget for the selection screen for pizza toppings and size, a widget for the screen that centralizes all the pizzas that the user ordered and allows them to delete or edit them, and a widget for the screen where the user enters his or her details in order to order the pizza. The animations built using Rive.

All uses of the ```bagel_db``` package to communicate with BagelDB are centralized in the controller, and are marked by comments.

### BagelDB Data Structure
For this project BagelDB consisted of 4 collections, as follows:

 1. **Collection Name**: pizzas 
ID: ```pizzas```
Schema:

|Field Name| slug | Field Type|
|--|--|--|
|Name|name|Plain Text|
|toppings|toppings|Reference|
|size|size|Plain Text|
|price|price|number|

2. **Collection Name**: toppings 
ID: ```toppings```
Schema:

|Field Name| slug | Field Type|
|--|--|--|
|name|name|Plain Text|
|small image|smallImage|Image|
|pizza image|size|Plain Text|
|Price|price|number|

3. **Collection Name**: sizes 
ID: ```sizes```
Schema:

|Field Name| slug | Field Type|
|--|--|--|
|name|name|Plain Text|
|Price|price|number|
  
4. **Collection Name**: carts 
ID: ```carts```
Schema:

|Field Name| slug | Field Type|
|--|--|--|
|name|name|Plain Text|
|pizza|pizza|Reference|
|phone|phone|Phone|
|email|email|Plain Text|
|adress|adress|Plain Text|
|total price|totalPrice|number|

### Info
For more info about **BagelDB** visit us at bageldb.com or signup at app.bageldb.com/signup.
For questions or comments, join us on [Discord](https://discord.gg/49hq7wu).

![Screenshot_1](/Users/rani/Desktop/screens/Simulator Screen Shot - iPhone 11 - 2020-09-13 at 14.47.37.png)   
![Screenshot_2](/Users/rani/Desktop/screens/Simulator Screen Shot - iPhone 11 - 2020-09-13 at 14.48.31.png)   
![Screenshot_3](/Users/rani/Desktop/screens/Simulator Screen Shot - iPhone 11 - 2020-09-13 at 14.48.42.png)    
