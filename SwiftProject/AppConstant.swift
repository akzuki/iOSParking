//
//  AppConstants.swift
//  SwiftProject
//
//  Created by iosdev on 1.5.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation

struct AppConstant {
    static let corePoints: [EILOrientedPoint] = [EILOrientedPoint(x: 2, y: 2),
                                          EILOrientedPoint(x: 4.5, y: 2),
                                          EILOrientedPoint(x: 7, y: 2),
                                          EILOrientedPoint(x: 2, y: 4.5),
                                          EILOrientedPoint(x: 4.5, y: 4.5),
                                          EILOrientedPoint(x: 7, y: 4.5),
                                          EILOrientedPoint(x: 2, y: 7),
                                          EILOrientedPoint(x: 4.5, y: 7),
                                          EILOrientedPoint(x: 7, y: 7)]
}

//        Method for building the map

//        let locationBuilder = EILLocationBuilder()
//        locationBuilder.setLocationName("Classroom B305-ver2")
//        locationBuilder.setLocationBoundaryPoints([
//            EILPoint(x: 0.00, y: 0.00),
//            EILPoint(x: 0.00, y: 9),
//            EILPoint(x: 9, y: 9),
//            EILPoint(x: 9, y: 0.00)])
//
//        locationBuilder.addBeaconIdentifiedByMac("f0d9c4f70527",
//            atBoundarySegmentIndex: 0, inDistance: 5, fromSide: .LeftSide)
//        locationBuilder.addBeaconIdentifiedByMac("ce59e89bd34e",
//            atBoundarySegmentIndex: 1, inDistance: 2, fromSide: .RightSide)
//        locationBuilder.addBeaconIdentifiedByMac("e2208d08b720",
//            atBoundarySegmentIndex: 2, inDistance: 5, fromSide: .LeftSide)
//        locationBuilder.addBeaconIdentifiedByMac("de0f1c1fe1e8",
//            atBoundarySegmentIndex: 3, inDistance: 5, fromSide: .RightSide)
//
//        locationBuilder.setLocationOrientation(230)
//        locationBuilder.addDoorsWithLength(2, atBoundarySegmentIndex: 0, inDistance: 1, fromSide: .RightSide)
//        locationBuilder.addWindowWithLength(3, atBoundarySegmentIndex: 3, inDistance: 2, fromSide: .LeftSide)
//
//        location = locationBuilder.build()
//        // You can get them by adding your app on https://cloud.estimote.com/#/apps
//        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
//        let addLocationRequest = EILRequestAddLocation(location: location)
//        addLocationRequest.sendRequestWithCompletion { (location, error) in
//            if error != nil {
//                NSLog("Error when saving location: \(error)")
//            } else {
//                NSLog("Location saved successfully: \(location!.identifier)")
//            }
//        }