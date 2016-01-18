//
//  PedoViewController.swift
//  MarsApp
//
//  Created by Niklas Mayr on 03.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class PedoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    //@IBOutlet weak var labelStepCount: UILabel!
    //@IBOutlet weak var labelDistance: UILabel!
    var locationManager : CLLocationManager!
    var lon = 0.0
    var lat = 0.0
    var gpsData = [GeoPoint]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonStartActivity: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var addonLabel: UILabel!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var pieChartView: PieChartView!
    let descr = ["","",""]
    
    var gradient : CAGradientLayer!
    
    var loop = true
   
    var connector:ServerConnector!

    var width:CGFloat!
    
    
    // MARK: - Measuremntsproperties
    var hrObject:HeartRateDelegate!
    var pedo:Pedometer!
    var steps:Steps!
    var person:Person!
    var userinfo:Dictionary<String,String!>!
    
    var timer:NSTimer!
    var timeformatter:NSDateFormatter!
    var clockFormatter:NSDateFormatter!
    var startTime:NSTimeInterval!
    var currentTime:NSTimeInterval!
    var isRunning:Bool = false
    
    
    // MARK: - Maxvalues
    let maxTimerValinSeconds: Double = 30
    let maxDistanceVal: Double = 1000
    let maxStepsVal: Double = 100
    let maxCaloryVal: Double = 500
    
    // MARK: - sportcells
    
    var currentIndexPath: NSIndexPath!
    
    var timerIndexPath: NSIndexPath!
    var distanceIndexPath: NSIndexPath!
    var stepsIndexPath: NSIndexPath!
    var energyIndexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = self.view.frame.width
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.dataLabel.textColor = UIColor.whiteColor()
        self.addonLabel.textColor = UIColor.whiteColor()
        self.dataLabel.adjustsFontSizeToFitWidth = true
        self.addonLabel.adjustsFontSizeToFitWidth = true
        self.addonLabel.text = "12:00"
        
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
        
        // setup Activites
        setupTimer()
        setupPedoMeasurement()
        setupHeartRateMeasurement()
        
        // setup UI
        setupPieChartView()
        
        connector = ServerConnector.connector
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        currentIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        //labelStepCount.text = "0"
        //labelDistance.text = "0"
        
        let indexPathFirst = NSIndexPath(forRow: 0, inSection: 0)
        self.collectionView.selectItemAtIndexPath(indexPathFirst, animated: false, scrollPosition: UICollectionViewScrollPosition.None)

   
    }
    
    func startGPS() {
        //Setup Locationmanager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 2
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopGPS() {
        
        let sendData = "email=\(appDel.person.mail)&pw=\(appDel.person.pw)&points=\(gpsData.toJsonArray())"
        
        ServerConnector.connector.sendMessage(sendData, functionName: "uploadGeoPoints", completion: { (jsonString, error) -> Void in
            print(jsonString)
            print(self.gpsData.toJsonArray())
        })
        
        locationManager.stopUpdatingLocation()
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
            cell.valueLabel?.text = "00:00"
            cell.symbolImage.image = UIImage(named: "timeIcon")
            cell.progressMaxValue = maxTimerValinSeconds
            timerIndexPath = indexPath
        }
        // Distance
        else if indexPath.row == 1 {
            cell.unitLabel?.text = "Distance"
            cell.valueLabel?.text = "0 m"
            cell.symbolImage.image = UIImage(named: "speedIcon")
            cell.progressMaxValue = maxDistanceVal
            distanceIndexPath = indexPath
            
        }
        // Steps
        else if indexPath.row == 2 {
            cell.unitLabel?.text = "Steps"
            cell.valueLabel?.text = "0"
            cell.symbolImage.image = UIImage(named: "stepsIcon")
            cell.progressMaxValue = maxStepsVal
            stepsIndexPath = indexPath
        }
        // Energy
        else if indexPath.row == 3 {
            cell.unitLabel?.text = "Energy"
            cell.valueLabel?.text = "0 Kcal"
            cell.symbolImage.image = UIImage(named: "energyIcon")
            cell.progressMaxValue = maxCaloryVal
            energyIndexPath = indexPath
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
        
        currentIndexPath = indexPath
        
        self.collectionView(collectionView, didDeselectItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SportItemCell
        
        cell.backgroundColor = UIColor(red: 245/255, green: 209/255, blue: 205/255, alpha: 1)
        cell.setColorForComponents(UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1))
        
        setChart(descr, values: cell.progressData)
        
        dispatch_async(dispatch_get_main_queue()){
            self.pieChartView.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.EaseOutExpo)
        }
        
        updateLabelText(cell)
        
        
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
     //   setChart(descr, values: data)
        
        pieChartView.usePercentValuesEnabled = false
        pieChartView.holeRadiusPercent = 0.90
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.backgroundColor = UIColor.clearColor()
        pieChartView.holeColor = UIColor.clearColor()
        pieChartView.legend.enabled = false
        pieChartView.descriptionTextColor = UIColor.clearColor()
    }
    
    @IBAction func startActivity(sender: AnyObject) {
        
        if isRunning {
            stopTimer()
            stopPedoMeasurement()
            stopHeartRateMeasurement()
            isRunning = false
            buttonStartActivity.setTitle("Start Activity", forState: UIControlState.Normal)
        } else {
            startTimer()
            startPedoMeasurement()
            startHeartRateMeasurement()
            isRunning = true
            buttonStartActivity.setTitle("Stop Activity", forState: UIControlState.Normal)
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.pieChartView.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.EaseOutExpo)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        let coord = loc.coordinate
        
        lon = coord.longitude
        lat = coord.latitude
        
        connector.getHeightData("\(lat),\(lon)", key: "AIzaSyBEsjG1o1IHmamjNpXB62qyKJCia7ScdVk") { (jsonString,error) -> Void in
            //print(jsonString)
            print(error)
            
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                for item in json["results"].arrayValue {
                    
                    let lon = self.lon
                    let lat = self.lat
                    let alt = item["elevation"].doubleValue
                    let time = Int(NSDate().timeIntervalSince1970)*1000
                    
                    print(alt)
                    
                    let gp = GeoPoint(_lon: lon, _lat: lat, _alt: alt, _time: String(time))
                    
                    self.gpsData.append(gp)
                }
            }
        }
    }
    
    func updateLabelText(cell: SportItemCell) {
        dataLabel.text = cell.valueLabel.text!
    }
    
    
    // MARK: - HeartRate functions
    
    func setupHeartRateMeasurement() {
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHeartRate:", name: "newHeartRate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messureHeartRate:", name: "changeHeartRateSource", object: nil)
        
        
        HeartRate.checkAvailability { (isAvailable) -> Void in
            if isAvailable == true {
                self.appDel.hkAvailable = true
                self.hrObject = HealthFactory.createHeartRateSensor()
            }
            else {
                self.appDel.hkAvailable = false
                self.hrObject = HealthFactory.createHeartRateSensor()
            }
        }
    }
    
    
    func startHeartRateMeasurement(){
        hrObject.startMonitoring()
    }
    
    
    func stopHeartRateMeasurement() {
        
        hrObject.stopMonitoring()
        
        ServerConnector.connector.sendMessage(appDel.person.heartRatesToString(), functionName: "uploadHeartrates", completion: { (jsonString, error) -> Void in
            print(jsonString)
        })
        

    }
    
    func updateHeartRate(notification: NSNotification){
        
        userinfo = notification.userInfo as! Dictionary<String,String!>
        let hr = Double(userinfo["bpm"]!)
        let d = userinfo["date"]!
        
        let hrObject = HeartRateObject(heartRate: hr!, date: d)
        self.appDel.person.heartRates.append(hrObject)
        
        let incrementVal = 100 / maxCaloryVal
        let energy = Double(round(1000*self.appDel.person.calcEE())/1000)
        
        if self.currentIndexPath == self.energyIndexPath {
            
            self.updateProgressView(incrementVal, cell: self.collectionView.cellForItemAtIndexPath(self.energyIndexPath) as! SportItemCell, data: String(energy),updateChart: true)
            self.dataLabel.text = String(energy)
            self.addonLabel.text = String(Int(hr!))
            
        }
        
        else {
            self.updateProgressView(incrementVal, cell: self.collectionView.cellForItemAtIndexPath(self.energyIndexPath) as! SportItemCell, data: String(energy),updateChart: false)
        }
    }
    
    // MARK: - Pedo functions
    
    func setupPedoMeasurement(){
        pedo = Pedometer()
        steps = Steps()
    }
    
    func startPedoMeasurement() {
        steps.startTime = Int(NSDate().timeIntervalSince1970)*1000
        
        appDel.person.steps = steps
        
        pedo.calculateSteps { (steps) -> Void in
            let distance : Double = Double(self.appDel.person.stepLength*steps/100)
            let time = (Int(NSDate().timeIntervalSince1970)*1000 - self.appDel.person.steps.startTime)
            let speed = Double(Double(distance) / Double(time)) * 3.6
            
            let incrementPedo:Double = 100 /  self.maxStepsVal
            let incrementDistance:Double = 100 / self.maxDistanceVal
            
            if self.currentIndexPath == self.stepsIndexPath {
                self.updateProgressView(incrementPedo, cell: self.collectionView.cellForItemAtIndexPath(self.stepsIndexPath) as! SportItemCell, data: String(steps),updateChart: true)
                
                self.dataLabel.text = String(steps)
                
            } else {
                self.updateProgressView(incrementPedo, cell: self.collectionView.cellForItemAtIndexPath(self.stepsIndexPath) as! SportItemCell, data: String(steps),updateChart: false)
            }
            
            if self.currentIndexPath == self.distanceIndexPath {
                print("is in")
                self.updateProgressView(incrementDistance, cell: self.collectionView.cellForItemAtIndexPath(self.distanceIndexPath) as! SportItemCell, data: "\(String(round(100*distance)/100)) m",updateChart: true)
                self.addonLabel.text = "\(String(speed)) km/h"
                self.dataLabel.text = "\(String(round(100*distance)/100)) m"
            } else {
                print("not in")
                 self.updateProgressView(incrementDistance, cell: self.collectionView.cellForItemAtIndexPath(self.distanceIndexPath) as! SportItemCell, data: String(Int(distance)),updateChart: false)
            }
            
            
            self.appDel.person.steps.distance = distance
        }
    }
    
    func stopPedoMeasurement() {
        if appDel.person.steps.startTime == nil {
            return
        }
        
        appDel.person.steps.endTime = Int(NSDate().timeIntervalSince1970)*1000
        appDel.person.steps.steps = pedo.steps
        
        appDel.person.steps.mail = appDel.person.mail
        appDel.person.steps.pw = appDel.person.pw
        pedo.stopCalculating()
        
        
        connector.sendMessage(appDel.person.steps.objectToString(), functionName: "uploadSteps") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
            
            self.appDel.person.steps.startTime = nil
        }
    }
    
    // MARK: - Timer functions
    
    func setupTimer(){
        startTime = NSTimeInterval()
        timeformatter = NSDateFormatter()
        timeformatter.dateFormat = "hh:mm"
    }
    
    func startTimer(){
        let aSelector : Selector = "updateTime"
        startTime = NSDate.timeIntervalSinceReferenceDate()
        addonLabel.text = timeformatter.stringFromDate(NSDate())
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
    }
    
    func stopTimer() {
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
    }
    
    dynamic private func updateTime(){
        
        currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        if Int(seconds) >= Int(maxTimerValinSeconds) {
            self.stopTimer()
        }
        
        let incrementval:Double = 100 /  maxTimerValinSeconds

        if currentIndexPath == timerIndexPath {
            updateProgressView(incrementval, cell: collectionView.cellForItemAtIndexPath(timerIndexPath) as! SportItemCell, data: "\(strMinutes):\(strSeconds)",updateChart: true)
            dataLabel.text = "\(strMinutes):\(strSeconds)"
        } else {
            updateProgressView(incrementval, cell: collectionView.cellForItemAtIndexPath(timerIndexPath) as! SportItemCell, data: "\(strMinutes):\(strSeconds)",updateChart: false)
        }
        
    }
    
    func updateProgressView(incrementVal: Double, cell: SportItemCell, data: String, updateChart: Bool) {
        cell.progressData[1] += incrementVal
        cell.progressData[2] -= incrementVal
        
        if updateChart {
           setChart(descr, values: cell.progressData)
        }
        
        
        cell.valueLabel.text = data
    }
}