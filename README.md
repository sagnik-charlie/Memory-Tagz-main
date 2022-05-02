# `Memory Tagz`

Memory App demonstrates key features and the idea of `Memory Tagz`:

+ Connect to our Memory Book Device using bluetooth,

+ Pair your device and 'auto-connect' (without pin) using Connect to Memory Book Button inside our app,

+ Opening Bluetooth settings if necessary,

+ The Dashboard Screen shows all the tags removed from the memory book in the form of NOTES,

+ Stores all your data into Cloud Firestore database,

+ Click a picture after a tag removal,

+ Uses our in-app image-classifier Machine Learning model to describe your picture and stores it,

+ Remove tags to label objects and store those picture inside our database,

+ Our app will take the responsibility to remind you of your things

+ Your labelled objects will be a part of a quiz model game inspired to improve your memory power.


#### Screens 

Main screen and options |  Discovery and Connection  |  Dashboard  | Popup and Notification | Login/Signup Page  |  Quiz Model | 

<img src="https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.23%20AM.jpeg" width="80px" height="150" /> |
<img src="https://storage.googleapis.com/memory_tagz/App_Screens/Home%20Screen.jpg" width="80px" height="150" /> | <img src="https://storage.googleapis.com/memory_tagz/App_Screens/connecting%20page.jpeg" width="80px" height="150" /> | <img src="https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.21%20AM%20(1).jpeg" width="80px" height="150" /> |  <img src="https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.21%20AM.jpeg" width="80px" height="150" /> | <img src="https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.18%20AM%20(1).jpeg" width="80px" height="150" />  | <img src="https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.20%20AM.jpeg" width="80px" height="150" /> | <img src= "https://storage.googleapis.com/memory_tagz/App_Screens/WhatsApp%20Image%202022-04-21%20at%203.06.22%20AM.jpeg" width="80px" height="150" /> | <img src= "https://storage.googleapis.com/memory_tagz/App_Screens/Quiz%20model.jpg" width="80px" height="150" /> | <img src= "https://storage.googleapis.com/memory_tagz/App_Screens/Quiz%20Q%26A.jpg" width="80px" height="150" />


## Sumary

#### Side-App Drawer
Memory Panel is our Side App Drawer which is handy for any user switching between screens.

#### Explore Nearby devices page
Searches for any devices named Memory Book device near it.

#### Connect to Memory Book
Connect to a paired Memory Book device by using auto-connect (without pin).

#### Dashboard
Shows all the removed tags you stored in your database as 'Notes' after passing through our ML algorithm with the clicked pictures.
Stores data in the cloud firestore.

Continuously listens on the Bluetooth port connectde to Memory Book device.

Alert users through pop up is screen if on, otherwise via notification.

#### Login/Signup Page
Allow users to create a account and stay signed in with all their data in sync.

#### Quiz Model Page
It is for both children and adults. Anybody can test their memory power by recollecting the use of a memory-tag and stored memory. Earn points and improve your memory.
