## iOS Parking App

This is our first indoor positioning app. This app is used for finding the free spots in the parking lot. Users can also find their cars afterwards because their parking locations will be saved in the CoreData.Through this app the drivers can save so much time and find the closest parking spot around.

## Group members

- Phan Dang Hai
- Yasamin Salami
- Tehetena Masresha

## Features

The project is intended to help users find empty spots inside of a parking lot. 
- It gives information on the status of a parking lot, weather the spot is free or taken. 
- Users can also navigate using the direction navigator provided. When user reaches the spot there will be a park button activated. 
- After parking users can also look for their car using a direction navigator built in the project

## Screenshots

![alt tag](http://i.imgur.com/GeQIMai.jpg)

![alt tag](http://i.imgur.com/PIpSqCw.jpg)

![alt tag](http://i.imgur.com/rHZ3lc3.jpg)
## How to build

1) Clone the repository

```bash
$ git clone https://github.com/akzuki/iOSParking.git
```
2) Install pods

```bash
$ pod install
```
3) Open the workspace in Xcode

```bash
$ open "SwiftProject.xcworkspace"
```
4) Compile and run the app in your devices (recommended: iPhone 4S or newer)

# Requirements

- Xcode 7.3+
- iBeacon (at least 4 to create a rectangular map)
- iPhone 4s or newer

# Frameworks used

- [Estimote IndoorLocation SDK](https://github.com/Estimote/iOS-Indoor-SDK)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
