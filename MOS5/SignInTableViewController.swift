//
//  SignInTableViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 09.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class SignInTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textPar: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var textHeight: UITextField!
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPasswordConfirm: UITextField!
    @IBOutlet weak var textStepLength: UITextField!

    @IBOutlet weak var LogRegSegment: UISegmentedControl!
    
    @IBOutlet weak var labelMale: UILabel!
    @IBOutlet weak var labelFemale: UILabel!
    
    @IBOutlet weak var switchGender: UISwitch!
    
    @IBOutlet weak var pictureInfo: UIImageView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var person = Person()

    var options:[String]!
    
    var pickerView : UIPickerView!
    
    var connector:ServerConnector!
    
    var simulation:HeartRateSimulation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connector = ServerConnector.connector
        
        simulation = HeartRateSimulation()
        
        pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        textAge.inputView = pickerView
        textHeight.inputView = pickerView
        textWeight.inputView = pickerView
        textPar.inputView = pickerView
        textStepLength.inputView = pickerView
        
        let recognizer = UITapGestureRecognizer(target: self, action: "maleTapped")
        labelMale.userInteractionEnabled = true
        labelMale.addGestureRecognizer(recognizer)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: "femaleTapped")
        labelFemale.userInteractionEnabled = true
        labelFemale.addGestureRecognizer(recognizer2)
        
        let recognizer3 = UITapGestureRecognizer(target: self, action: "infoTapped")
        pictureInfo.userInteractionEnabled = true
        pictureInfo.addGestureRecognizer(recognizer3)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
    }
    
    func maleTapped() {
        switchGender.setOn(true, animated: true)
    }
    
    func femaleTapped() {
        switchGender.setOn(false, animated: true)
    }
    
    func infoTapped() {
        let alert = UIAlertController()
        
        alert.title = "Info"
        alert.message = "Use the number (0 – 7) that best describes your physical activity level for the previous month: \n 0-1: Do not participate regularly in programmed recreation sport or heavy physical activity \n 2-3: Participate regularly in recreation or work requiring modest physical activity, such as golf, horseback riding, calisthenics, gymnastics, table tennis, bowling, weightlifting, yard work \n 4-7: Participate regularly in heavy physical exercise such as running or jogging, swimming, cycling, rowing, skipping rope, running in place or engaging in vigorous activity exercise such as tennis, basketball, or handball work"
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func LogRegSegmentValueChanged(sender: UISegmentedControl) {
        tableView.reloadData()
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesInRange: range)
        self.tableView.reloadSections(sections, withRowAnimation: .Bottom)
    }
    
    @IBAction func textAgeEditing(sender: AnyObject) {
        options = []
        for (var i = 10; i < 61; i++) { options.append("\(i)") }
        pickerView.reloadAllComponents()
    }
    @IBAction func textHeightEditing(sender: UITextField) {
        options = []
        for (var i = 100; i < 221; i++) { options.append("\(i)") }
        pickerView.reloadAllComponents()
    }
    @IBAction func textWeightEditing(sender: UITextField) {
        options = []
        for (var i = 50; i < 151; i++) { options.append("\(i)") }
        pickerView.reloadAllComponents()
    }
    @IBAction func textParEditing(sender: UITextField) {
        options = []
        for (var i = 0; i < 8; i++) { options.append("\(i)") }
        pickerView.reloadAllComponents()
    }
    @IBAction func textStepLengthEditing(sender: UITextField) {
        options = []
        for (var i = 20; i < 181; i++) { options.append("\(i)") }
        pickerView.reloadAllComponents()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (LogRegSegment.selectedSegmentIndex == 0) {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (LogRegSegment.selectedSegmentIndex == 0) {
            if section == 0{
                return 3
            } else{
                return 7
            }
        } else {
            if section == 0{
                return 2
            } else{
                return 0
            }
        }
    }
    
    //Pickerview Functions for Age
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textAge.editing {
            textAge.text = options[row]
            person.age = Int(options[row])
        } else if textWeight.editing {
            textWeight.text = options[row]
            person.weight = Int(options[row])
        } else if textHeight.editing {
            textHeight.text = options[row]
            person.height = Int(options[row])
        } else if textPar.editing {
            textPar.text = options[row]
            person.par = Int(options[row])
        } else {
            textStepLength.text = options[row]
            person.stepLength = Int(options[row])
        }
    }

    @IBAction func btnDoneClicked(sender: UIBarButtonItem) {
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("notifyWatch", object: nil, userInfo: nil)
        
//        connector.sendMessage(person, functionName: "") { (jsonString, error) -> Void in
//            print(jsonString)
//        }

        
        
        if (LogRegSegment.selectedSegmentIndex == 0) {
            //Register
            if textEmail.text != "" && textPassword.text != "" && textPasswordConfirm.text != "" && textName.text != "" && textPar.text != "" && textStepLength.text != "" && textWeight.text != "" && textHeight.text != "" && textAge.text != ""{
                person.name = textName.text
                person.mail = textEmail.text
                person.pw = textPassword.text
                person.gender = switchGender.on
                                
                connector.sendMessage(person.objectToString(), functionName: "register") { (jsonString,error) -> Void in
                    print("Error: \(error)")
                    if jsonString == "3" {
                        print("Server/DB Error")
                    } else if jsonString == "1" {
                        print("Successful")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.appDel.person = self.person
                            self.performSegueWithIdentifier("showMenu", sender: self)
                        }
                    } else if jsonString == "-2" {
                        print("Username already taken")
                    }
                }
            } else {
                print("Mars: Please enter all the data!")
            }
        } else {
            //Login
            if textEmail.text != "" && textPassword.text != "" {
                person.mail = textEmail.text
                person.pw = textPassword.text
                
                connector.sendMessage(person.objectToString(), functionName: "login") { (jsonString,error) -> Void in
                    print(jsonString)
                    print(error)
                    
                    if jsonString == "" {
                        print("User not in our database")
                    } else {
                        //User Data contained in jsonString
                        //Convert JSON String to Person Object
                        //Params of the JSON String: age, email, height, name, password, weight, gender, par, steplength
                        
                        self.person = self.person.jsonToObject(jsonString)
                        self.person.mail = self.textEmail.text
                        self.person.pw = self.textPassword.text

                        dispatch_async(dispatch_get_main_queue()) {
                            self.appDel.person = self.person
                            self.performSegueWithIdentifier("showMenu", sender: self)
                        }
                    }
                }
            } else {
                print("Mars: Please enter all the data!")
            }

        }
        

    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
