//
//  PedoViewController.swift
//  MarsApp
//
//  Created by Niklas Mayr on 03.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit
import Charts

class PedoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //@IBOutlet weak var labelStepCount: UILabel!
    //@IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonStartActivity: UIButton!
    
    @IBOutlet weak var pieChartView: PieChartView!
    let descr = ["","",""]
    var data = [22.0,100.0,22.0]
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var gradient : CAGradientLayer!
    
    var loop = true
    var pedo:Pedometer!
    var connector:ServerConnector!
    var steps:Steps!
    var person:Person!
    var width:CGFloat!
    
    
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
        
        
        pedo = Pedometer()
        connector = ServerConnector.connector
        steps = Steps()
        
        setupPieChartView()
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        //labelStepCount.text = "0"
        //labelDistance.text = "0"
        
        steps.startTime = Int(NSDate().timeIntervalSince1970)
        
        appDel.person.steps = steps
        
        pedo.calculateSteps { (steps) -> Void in
            let distance : Double = Double(self.appDel.person.stepLength*steps/100)
            let time = (Int(NSDate().timeIntervalSince1970) - self.appDel.person.steps.startTime)
            let speed = Double(Double(distance) / Double(time)) * 3.6
            
            self.appDel.person.steps.speed = speed
            self.appDel.person.steps.distance = distance
        }
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        if appDel.person.steps.startTime == nil {
            return
        }
        
        appDel.person.steps.endTime = Int(NSDate().timeIntervalSince1970)
        appDel.person.steps.steps = pedo.steps
        
        appDel.person.steps.mail = appDel.person.mail
        appDel.person.steps.pw = appDel.person.pw
        
        connector.sendMessage(appDel.person.steps.objectToString(), functionName: "uploadSteps") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
        }
        
        pedo.stopCalculating()
        
        appDel.person.steps.startTime = nil
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        pieChartDataSet.drawValuesEnabled = false
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        colors.append(UIColor.clearColor())
        colors.append(UIColor.whiteColor())
        colors.append(UIColor.clearColor())
        
        pieChartDataSet.colors = colors
        
    }
    
    func setupPieChartView(){
        
        setChart(descr, values: data)
        
        pieChartView.usePercentValuesEnabled = false
        pieChartView.holeRadiusPercent = 0.90
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.backgroundColor = UIColor.clearColor()
        pieChartView.holeColor = UIColor.clearColor()
        pieChartView.legend.enabled = false
        pieChartView.descriptionTextColor = UIColor.clearColor()
    }
    @IBAction func startActivity(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.pieChartView.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.EaseOutExpo)
        }
    }
    
}

