//
//  MapViewController.swift
//  SwiftProject
//
//  Created by iosdev on 18.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController, EILIndoorLocationManagerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var parkUnpark: UIButton!
    @IBOutlet weak var locationView: EILIndoorLocationView!
    
    //MARK: Variables
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    var currentPosition : EILOrientedPoint?
    var selectedSpot: Spot?
    var userCar: Spot?
    var isFindingCar: Bool?
    var isParking: Bool?
    var navigationLayer: CAShapeLayer!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var destinationIcon: UIImageView!
    
    //Testing method used when testing with simulator, comment it out when testing with real devices
//    func test(sender: UITapGestureRecognizer) {
//        let currentPoint = locationView.calculateRealPointFromPicturePoint(sender.locationInView(locationView))
//        self.currentPosition = EILOrientedPoint(x: currentPoint.x, y: currentPoint.y)
//        updateUI()
//    }
    
    //ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradientBackground()
        makeRoundedBorder(parkUnpark)
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        
        destinationIcon = UIImageView.init(frame: CGRectMake(0, 0, 35, 50))
        destinationIcon.image = UIImage(named: "destinationIcon")
        
        //commit this out when testing with real devices
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MapViewController.test))
//        locationView.userInteractionEnabled = true
//        locationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        //Show loading indicator
        view.addSubview(loading)
        loading.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.locationManager.delegate = self
        
        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "classroom-b305-ver2-ajz")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location
                //Set up the locationView
                self.locationView.showTrace = false
                self.locationView.rotateOnPositionUpdate = true
                self.locationView.locationBorderColor = UIColor.purpleColor()
                self.locationView.locationBorderThickness = 4
                self.locationView.windowColor = UIColor.yellowColor()
                self.locationView.drawLocation(location)
                //Update current position
                self.locationManager.startPositionUpdatesForLocation(self.location)
                //Get spots information from the server and draw them in the map
                WebService.sharedInstance.getSpots({ (result) -> Void in
                    for spot in result {
                        self.drawSpot(spot)
                    }
                    //Hide loading indicator
                    self.loading.removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
            } else {
                print("can't fetch location: \(error)")
            }
        }
        setUpParkUnparkButton()
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didUpdatePosition position: EILOrientedPoint!, withAccuracy positionAccuracy: EILPositionAccuracy, inLocation location: EILLocation!) {
        var accuracy: String!
        switch positionAccuracy {
        case .VeryHigh: accuracy = "+/- 1.00m"
        case .High:     accuracy = "+/- 1.62m"
        case .Medium:   accuracy = "+/- 2.62m"
        case .Low:      accuracy = "+/- 4.24m"
        case .VeryLow:  accuracy = "+/- ? :-("
        default: accuracy = "Something weird happended"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@", position.x, position.y, position.orientation, accuracy))
        currentPosition = position
        self.locationView.updatePosition(position)
        updateUI()
    }
    
    func spotTapped(sender: UITapGestureRecognizer) {
        let spot = sender.view as! Spot
        print("Spot tapped:  \(spot.getInfo())")
        self.selectedSpot = spot
        updateUI()
    }
    
    func updateNavigation(fromPoint: EILOrientedPoint, toPoint: EILOrientedPoint) {
        let path = UIBezierPath()
        let currentPoint = locationView.calculatePicturePointFromRealPoint(fromPoint)
        let point1 = locationView.calculatePicturePointFromRealPoint(closestPoint(fromPoint))
        let point2 = locationView.calculatePicturePointFromRealPoint(closestPoint(toPoint))
        let destinationPoint = locationView.calculatePicturePointFromRealPoint(toPoint)
        
        path.moveToPoint(currentPoint)
        path.addLineToPoint(CGPoint(x: point1.x, y: currentPoint.y))
        path.addLineToPoint(point1)
        path.addLineToPoint(CGPoint(x: point2.x, y: point1.y))
        path.addLineToPoint(point2)
        path.addLineToPoint(CGPoint(x: destinationPoint.x, y: point2.y))
        path.addLineToPoint(destinationPoint)
        
        if navigationLayer != nil {
            navigationLayer.removeFromSuperlayer()
        }

        navigationLayer = CAShapeLayer()
        navigationLayer.path = path.CGPath
        navigationLayer.strokeColor = UIColor.redColor().CGColor
        navigationLayer.fillColor = UIColor.clearColor().CGColor
        navigationLayer.lineWidth = 3
        navigationLayer.lineDashPattern = [3,6]
        navigationLayer.lineCap = kCALineCapRound
        locationView.layer.insertSublayer(navigationLayer, atIndex: 0)
    }
    
    func drawDestinationIcon(selectedSpot: Spot) {
        let pointToDraw = EILOrientedPoint(x: selectedSpot.getX(), y: selectedSpot.getY()+0.5)
        if (locationView.objectWithidentifier("locationIcon") == nil) {
            self.locationView.drawObjectInForeground(destinationIcon, withPosition: pointToDraw, identifier: "locationIcon")
        } else {
            self.locationView.moveObjectWithIdentifier("locationIcon", toPosition: pointToDraw, animated: false)
        }
    }
    
    func updateUI() {
        if let currentPosition = self.currentPosition, selectedSpot = self.selectedSpot {
            updateNavigation(currentPosition, toPoint: selectedSpot.getCoordinate())
            
            drawDestinationIcon(selectedSpot)
            
            if (selectedSpot.getStatus()) {
                status.text = "Status: Not Available"
            } else {
                status.text = "Status: Available"
            }
            distance.text = "Distance: " + String(format:"%.2f", currentPosition.distanceToPoint(selectedSpot.getCoordinate())) + " m away"
            
            if (isFindingCar!) {
                if (currentPosition.distanceToPoint(selectedSpot.getCoordinate()) <= 1) {
                    parkUnpark.enabled = true
                } else {
                    parkUnpark.enabled = false
                }
            } else {
                if (currentPosition.distanceToPoint(selectedSpot.getCoordinate()) <= 1) {
                    if (isParking! && !selectedSpot.getStatus()) {
                        parkUnpark.enabled = true
                    }
                } else {
                    parkUnpark.enabled = false
                }
            }
        }
    }
    
    //Park and Unpark methods
    func setUpParkUnparkButton() {
        if (self.isFindingCar!) {
            self.selectedSpot = self.userCar!
            isParking = false
                        locationView.userInteractionEnabled = false
            parkUnpark.setTitle("UNPARK", forState: UIControlState.Normal)
            parkUnpark.addTarget(self, action: #selector(MapViewController.unPark), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            parkUnpark.setTitle("PARK", forState: UIControlState.Normal)
            parkUnpark.addTarget(self, action: #selector(MapViewController.park), forControlEvents: UIControlEvents.TouchUpInside)
            if let userCar = self.userCar {
                parkUnpark.enabled = false
                isParking = false
            } else {
                isParking = true
            }
        }
    }
    
    func park() {
        if let selectedSpot = self.selectedSpot {
            selectedSpot.changeStatus()
            WebService.sharedInstance.changeStatus(selectedSpot, completionHandler: {(result) -> Void in
                let entity =  NSEntityDescription.entityForName("UserCar",
                    inManagedObjectContext:self.managedContext)
                
                let savedSpot = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: self.managedContext)
                
                savedSpot.setValue(selectedSpot.getId(), forKey: "id")
                savedSpot.setValue(selectedSpot.getX(), forKey: "x")
                savedSpot.setValue(selectedSpot.getY(), forKey: "y")
                savedSpot.setValue(selectedSpot.getStatus(), forKey: "status")
                
                do {
                    try self.managedContext.save()
                    self.updateSpot(selectedSpot)
                    
                    let alert = UIAlertView(title: "Alert", message: "Done", delegate: nil, cancelButtonTitle: "Close")
                    alert.show()
                    
                    self.parkUnpark.enabled = false
                    self.isParking = false
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            })
        }
    }
    
    func unPark() {
        if let selectedSpot = self.selectedSpot {
            selectedSpot.changeStatus()
            WebService.sharedInstance.changeStatus(selectedSpot, completionHandler: {(result) -> Void in
                let coord = self.appDelegate.persistentStoreCoordinator
                
                let fetchRequest = NSFetchRequest(entityName: "UserCar")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try coord.executeRequest(deleteRequest, withContext: self.managedContext)
                    self.updateSpot(selectedSpot)
                    
                    let alert = UIAlertView(title: "Alert", message: "Done", delegate: nil, cancelButtonTitle: "Close")
                    alert.show()
                    
                    self.parkUnpark.enabled = false
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            })
        }
        
    }
    
    //Draw a spot and update a spot methods
    func drawSpot(spot: Spot) {
        self.locationView.drawObjectInBackground(spot, withPosition: spot.getCoordinate(), identifier: spot.getIdentifier())
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MapViewController.spotTapped(_:)))
        spot.userInteractionEnabled = true
        spot.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateSpot(selectedSpot: Spot) {
        self.locationView.removeObjectWithIdentifier(selectedSpot.getIdentifier())
        self.locationView.drawObjectInBackground(selectedSpot, withPosition: selectedSpot.getCoordinate(), identifier: selectedSpot.getIdentifier())
    }
    
    func closestPoint(point: EILOrientedPoint) -> EILOrientedPoint {
        var resultPoint = AppConstant.corePoints[0]
        for corePoint in AppConstant.corePoints {
            if (point.distanceToPoint(corePoint) < point.distanceToPoint(resultPoint)) {
                resultPoint = corePoint
            }
        }
        return resultPoint
    }
    
    func makeGradientBackground() {
        let colorTop = UIColor(red: 15.0/255.0, green: 118.0/255.0, blue: 128.0/255.0, alpha: 1).CGColor
        let colorBottom = UIColor(red: 84.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1).CGColor
        let gradientBackground = CAGradientLayer()
        gradientBackground.frame = self.view.bounds
        gradientBackground.colors = [colorTop, colorBottom]
        gradientBackground.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientBackground, atIndex: 0)
        print("Gradient Background: Done")
    }
    
    func makeRoundedBorder(view: UIView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clearColor().CGColor
        view.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




