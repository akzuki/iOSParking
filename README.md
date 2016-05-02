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

![alt tag](https://scontent-arn2-1.xx.fbcdn.net/hphotos-xlt1/v/t34.0-12/13090503_990255014389383_2092258249_n.jpg?oh=cb3e9dd6cc869add6ec996cf12d49f3f&oe=57296743)

![alt tag](https://scontent-arn2-1.xx.fbcdn.net/v/t34.0-12/13153432_990255007722717_7054084_n.jpg?oh=c385f15810a4921e975f9b75c5a570e1&oe=5729A7D8)

![alt tag](https://scontent-arn2-1.xx.fbcdn.net/v/t34.0-12/13101321_990254991056052_15025546_n.jpg?oh=0aecea9b8dff28ee5450b39975a13700&oe=57296E57)
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
