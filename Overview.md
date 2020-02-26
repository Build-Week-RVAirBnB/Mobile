
## Role Description
You have now gone beyond the fundamental skills needed to build a functional iOS application. You can implement more complex user interfaces, add networking to communicate with external REST APIs, and implement local persistence using Core Data.
Unit 2 explored the following topics:

* Networking using URLSession, including making GET, PUT, POST, and DELETE requests
* How to authenticate your requests with an API using bearer token authorization
* Implementing more complex UI design including, custom views, controls, and animations
* Using Core Data to persist data locally, including using multiple NSManagedObjectContexts to ensure that data is saved and loaded efficiently
* Using NSFetchedResultsControllers to have a reactive table view or collection view display the objects saved in the application's NSPersistentStore

Your primary role as an iOS Developer II is:
As you will be sharing one Xcode project with your iOS teammates, you will have your roles separated. Your role in building the application are (in no particular order) as follows:
* Adding local persistence using Core Data. Determine the structure of your model objects with your teammates including the web developers who are making the backend in order to ensure it will work for everyone.

* Implementing the networking. You are responsible for the fetching from and saving data to the REST backend. You should also synchronize your local persistent store with the backend.

* Putting the app on TestFlight and the App Store.


A few general tips to follow when working with multiple people in a single Xcode project:
Modularizing your project as much as possible will prevent merge conflicts. This means following good MVC practices. This also means that if you are going to have multiple people working on UI at the same time, consider breaking up your Main.storyboard into smaller storyboards by feature or view controller. Storyboards are notoriously easy to create merge conflicts.
Get some practice with using branches and creating a branch for every feature you make.
Communication is key. Make sure you know what everyone on your team is working on so you don't "step on their toes" so to speak.

## Timeline

25 FEB: Kick Off

26FEB: Create Xcode Project and complete basic UI

27FEB: Models written and networking code written and running with mock data

28FEB - 1 MAR: Set up app store connect and TestFlight

2 MAR: Implement controller layers, including model controllers, and view controllers

3 MAR: Basic UI works, app should be near-working. Switch networking controller over to live data provided by backend

4 MAR: Finish MVP and implement visual design. Submit to TestFlight by 11PM pacific

5 MAR: Feature Freeze


