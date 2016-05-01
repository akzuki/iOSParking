//
//  ViewController.swift
//  SwiftProject
//
//  Created by iosdev on 8.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emptySpotLabel: UILabel!
    
    //MARK: Variables
    private var userCar: Spot?
    var isFindingCar: Bool?
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up the layout
        makeGradientBackground()
        emptySpotLabel.layer.borderColor = UIColor.whiteColor().CGColor
        emptySpotLabel.layer.borderWidth = 3
        makeRoundedBorder(emptySpotLabel)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Get the number of empty spots from server
        WebService.sharedInstance.countEmptySpots({ (result) -> Void in
            self.emptySpotLabel.text = "EMPTY SPOTS: " + result
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Check if the user has parked or not
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "UserCar")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let userCar = results as! [NSManagedObject]
            if (userCar.count > 0) {
                let firstResult = Spot(id: userCar[0].valueForKey("id") as! Int, x: userCar[0].valueForKey("x") as! Double, y: userCar[0].valueForKey("y") as! Double, status: userCar[0].valueForKey("status") as! Bool)
                self.userCar = firstResult
            } else {
                self.userCar = nil
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: IBActions
    @IBAction func findingEmptySpot(sender: UIButton) {
        self.isFindingCar = false
        self.performSegueWithIdentifier("mapViewSegue", sender: nil)
    }
    
    @IBAction func findingCar(sender: UIButton) {
        if let userCar = self.userCar {
            self.isFindingCar = true
            performSegueWithIdentifier("mapViewSegue", sender: nil)
        } else {
            let alert = UIAlertView(title: "Alert", message: "You haven't parked yet.", delegate: nil, cancelButtonTitle: "Close")
            alert.show()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapViewSegue")  {
            let mapVC = segue.destinationViewController as! MapViewController
            if let userCar = self.userCar {
                mapVC.userCar = userCar
            }
            mapVC.isFindingCar = self.isFindingCar
        }
    }

    func makeGradientBackground() {
        let colorTop = UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 134.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 35.0/255.0, green: 109.0/255.0, blue: 84.0/255.0, alpha: 1.0).CGColor
        let gradientBackground = CAGradientLayer()
        gradientBackground.frame = self.view.bounds
        gradientBackground.colors = [colorTop, colorBottom]
        gradientBackground.locations = [0.0, 80.0]
        self.view.layer.insertSublayer(gradientBackground, atIndex: 0)
        print("Gradient Background: Done")
    }
    
    func makeRoundedBorder(view: UIView) {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.cornerRadius = 10
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

