Frida
========

Frida is a smart fridge, and an organizing tool for all your groceries.

## Overview
Frida is built on open source software, and uses well supported technologies to make everything happen.
To see how Frida works, check out our [video].

## Getting started
You can build Frida yourself.
The most important thing is the API, or [application server].
Check out the different folders in this repository, and how to get those up and running.

Frida is brought together by the following clients.
#### [MyFridge]
An iOS-app, which let's you see your fridge content, manage a shopping list and see the temperature and status of your fridge.

#### [Tablet-app]
An [AngularJS]-based webapp, optimized for a tablet meant to be on the front side of your fridge.

#### [Frida+DateSelect]
An iOS-app which should be located on the inside of the fridge door, which recives messages about scanned items and let's you select a date for a grocery item.

#### [Arduino]
All the arduino-code meant to run the scanner, and all the sensors relaying information from your fridge, to the application server and into the database. Which will then propagat to all clients using WebSockets.

#### [Frida+Importer]
A simple iOS-app which connects to a calories counter-service (let's leave this unnamed) and let's the user scan items which is then put into the Frida-database.
This app was used internaly to easily add barcodes and item-information into the system.

## Down the road
Further development will include:
* Implemented date-handling with push-notifications
* Smart algoritms on your shopping habits
* Real data for analytics
* Much more.


[video]: https://vimeo.com/67434248
[application server]: https://github.com/Jensen2k/Frida/tree/master/webserver
[MyFridge]: https://github.com/Jensen2k/Frida/tree/master/MyFridge
[Tablet-app]: https://github.com/Jensen2k/Frida/tree/master/tablet
[Frida+DateSelect]: https://github.com/Jensen2k/Frida/tree/master/Frida+DateSelect
[Arduino]: https://github.com/Jensen2k/Frida/tree/master/arduino
[Frida+Importer]: https://github.com/Jensen2k/Frida/tree/master/Frida+Importer