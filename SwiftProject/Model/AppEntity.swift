//
//  AppEntity.swift
//  SwiftProject
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation

class Spot: UIImageView{
    
    // MARK: -Properties
    
    private var id: Int?
    private var x: Double?
    private var y: Double?
    private var status : Bool?
    
    //MARK
    init(id: Int, x: Double, y: Double, status: Bool) {
        super.init(frame: CGRectMake(0, 0, 40, 40))
        self.id = id
        self.x = x
        self.y = y
        self.status = status
//        self.backgroundColor = UIColor.grayColor()
        if (status) {
            self.image = UIImage(named: "carIcon")
        } else {
            self.image = UIImage(named: "greenDot")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Methods
    func changeStatus() {
        if let _status = status {
            status = !_status
            if (!_status) {
                self.image = UIImage(named: "carIcon")
            } else {
                self.image = UIImage(named: "greenDot")
            }
        }
    }
    
    func getId() -> Int {
        return self.id!
    }
    
    func getX() -> Double {
        return self.x!
    }
    
    func getY() -> Double {
        return self.y!
    }
    
    func getStatus() -> Bool {
        return self.status!
    }
    
    func getCoordinate() -> EILOrientedPoint {
        return EILOrientedPoint(x: self.x!, y: self.y!)
    }
    
    func getIdentifier() -> String {
        return "spot"+String(self.getId())
    }
    
    func getInfo() -> String {
        return "id: \(self.id!) x: \(self.x!) y: \(self.y!) status: \(self.status!)"
    }
    
}
