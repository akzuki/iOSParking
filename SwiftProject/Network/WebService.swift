//
//  WebService.swift
//  SwiftProject
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebService: NSObject {
    
    //MARK: baseURL
    private let baseUrl = "https://boiling-springs-67739.herokuapp.com/api/v1/spots/"
    
    static let sharedInstance = WebService()
    
    //Get all spot information (id, coordinate x,y and status) from the server
    func getSpots(completionHandler:(result: [Spot])->Void ) {
        var result = [Spot]()
        Alamofire.request(.GET, baseUrl)
            .responseJSON { response in
                if (response.result.error == nil) {
                    for spot in response.result.value as! [AnyObject] {
                        if let id = spot["id"] as? Int, x = spot["x"] as? String, y = spot["y"] as? String, status = spot["status"] as? Bool {
                            let newSpot = Spot(id: id, x: Double(x)!, y: Double(y)!, status: status)
                            result.append(newSpot)
                        }
                    }
                    completionHandler(result: result)
                }
        }
    }
    
    //Count the number of empty spots
    func countEmptySpots(completionHandler:(result: String)->Void) {
        Alamofire.request(.GET, baseUrl + "empty")
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(response.result.value!)
                    if let count = json[0]["count"].string {
                        completionHandler(result: count)
                    }
                }
        }
    }
    
    //Change the status if users park or unpark their cars
    func changeStatus(spot: Spot, completionHandler:(result: [AnyObject])->Void) {
        let url = baseUrl + String(spot.getId())
        Alamofire.request(.PUT, url, parameters: ["status": spot.getStatus()] )
            .responseJSON { response in
                if (response.result.error == nil) {
                    completionHandler(result: response.result.value as! [AnyObject])
                }
        }
    }
}