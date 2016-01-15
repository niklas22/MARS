//
//  PedoViewController.swift
//  MarsApp
//
//  Created by Niklas Mayr on 03.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class PedoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //@IBOutlet weak var labelStepCount: UILabel!
    //@IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonStartActivity: UIButton!
    @IBOutlet weak var activityView:UIImageView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var gradient : CAGradientLayer!
    
    var loop = true
    var pedo:Pedometer!
    var connector:ServerConnector!
    var steps:Steps!
    var person:Person!
    var width:CGFloat!
    
    var pictureArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.frame.width
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.backgroundView = UIView(frame: CGRectZero)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1).CGColor, (UIColor.whiteColor().CGColor)]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        // setup button ui
        buttonStartActivity.backgroundColor = UIColor.clearColor()
        buttonStartActivity.layer.cornerRadius = 25
        buttonStartActivity.layer.borderWidth = 1
        buttonStartActivity.layer.borderColor = UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1).CGColor
        
        // setup progressImages
        
        dispatch_async(dispatch_get_main_queue()){
            self.loadImages()
            self.activityView.animationImages = self.pictureArray
            self.activityView.animationRepeatCount = 1
            self.activityView.startAnimating()
            
        }
        
        
        pedo = Pedometer()
        connector = ServerConnector.connector
        steps = Steps()
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        //labelStepCount.text = "0"
        //labelDistance.text = "0"
        
        steps.startTime = Int(NSDate().timeIntervalSince1970)
        
        pedo.calculateSteps { (steps) -> Void in
         //   self.labelStepCount.text = "\(String(steps)) steps"
        //    self.labelDistance.text = "\(String(self.appDel.person.stepLength*steps/100)) meter"
        }
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        steps.endTime = Int(NSDate().timeIntervalSince1970)
        steps.steps = pedo.steps
        
        steps.mail = appDel.person.mail
        steps.pw = appDel.person.pw
        
        connector.sendMessage(steps.objectToString(), functionName: "uploadSteps") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
        }
        
        pedo.stopCalculating()
        
        print(steps.startTime)
        print(steps.endTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StepCell", forIndexPath: indexPath) as! SportItemCell
        
        cell.layer.borderColor = UIColor.clearColor().CGColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 0
        
        // specific items
        
        // Time
        if indexPath.row == 0 {
            cell.unitLabel?.text = "Time"
            cell.valueLabel?.text = "0:00"
            cell.symbolImage.image = UIImage(named: "timeIcon")
        }
        // Distance
        else if indexPath.row == 1 {
            cell.unitLabel?.text = "Distance"
            cell.valueLabel?.text = "10 m"
            cell.symbolImage.image = UIImage(named: "speedIcon")
        }
        // Steps
        else if indexPath.row == 2 {
            cell.unitLabel?.text = "Steps"
            cell.valueLabel?.text = "120"
            cell.symbolImage.image = UIImage(named: "stepsIcon")
        }
        // Energy
        else if indexPath.row == 3 {
            cell.unitLabel?.text = "Energy"
            cell.valueLabel?.text = "120 Kcal"
            cell.symbolImage.image = UIImage(named: "energyIcon")
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.setColorForComponents(UIColor.whiteColor())
        
        
        
        
        return cell
    }
         
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: width/4  , height: 90)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SportItemCell
        
        cell.backgroundColor = UIColor(red: 245/255, green: 209/255, blue: 205/255, alpha: 1)
        cell.setColorForComponents(UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1))
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SportItemCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.setColorForComponents(UIColor.whiteColor())
    }
    
    private func loadImages() {
        for ind in 0...100 {
            pictureArray.append(UIImage(named: "progress\(ind)")!)
        }
    }
}

