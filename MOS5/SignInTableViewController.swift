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
        
        if appDel.personMail != nil && appDel.personMail != "" {
            person = Person()
        
            person.mail = appDel.personMail
            person.pw = appDel.personPW
            
            // global person init
            appDel.person = Person()
            appDel.person.mail = person.mail
            appDel.person.pw = person.pw
            
            loginRequest()
        }
    }
    
    func maleTapped() {
        switchGender.setOn(true, animated: true)
    }
    
    func femaleTapped() {
        switchGender.setOn(false, animated: true)
    }
    
    func infoTapped() {
        showAlert("Info", text: "Use the number (0 – 7) that best describes your physical activity level for the previous month: \n 0-1: Do not participate regularly in programmed recreation sport or heavy physical activity \n 2-3: Participate regularly in recreation or work requiring modest physical activity, such as golf, horseback riding, calisthenics, gymnastics, table tennis, bowling, weightlifting, yard work \n 4-7: Participate regularly in heavy physical exercise such as running or jogging, swimming, cycling, rowing, skipping rope, running in place or engaging in vigorous activity exercise such as tennis, basketball, or handball work")
    }
    
    func showAlert(title: String, text: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController()
            
            alert.title = title
            alert.message = text
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            )
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
        
        if (LogRegSegment.selectedSegmentIndex == 0) {
            //Register
            if textEmail.text != "" && textPassword.text != "" && textPasswordConfirm.text != "" && textName.text != "" && textPar.text != "" && textStepLength.text != "" && textWeight.text != "" && textHeight.text != "" && textAge.text != ""{
                person.name = textName.text
                person.mail = textEmail.text
                person.pw = textPassword.text
                person.gender = switchGender.on
                person.stepLength = Int(textStepLength.text!)
                person.height = Int(textHeight.text!)
                person.weight = Int(textWeight.text!)
                person.par = Int(textPar.text!)
                person.age = Int(textAge.text!)
                                
                connector.sendMessage(person.objectToString(), functionName: "register") { (jsonString,error) -> Void in
                    print("Error: \(error)")
                    
                    self.appDel.personMail = self.textEmail.text
                    self.appDel.personPW = self.textPassword.text
                    self.appDel.saveUserDefaults()
                    
                    if jsonString == "3" {
                        self.showAlert("Server Error", text: "Server currently unable to resolve your request.")
                    } else if jsonString == "1" {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.appDel.person = self.person

                            self.performSegueWithIdentifier("showMenu", sender: self)
                        }
                    } else if jsonString == "-2" {
                        self.showAlert("Email already in use.", text: "Please choose another email address.")
                    }
                }
            } else {
                showAlert("Missing data!", text: "Please enter all the data.")
            }
        } else {
            //Login
            if textEmail.text != "" && textPassword.text != "" {
                person.mail = textEmail.text
                person.pw = textPassword.text
                
                loginRequest()
            } else {
                showAlert("Missing data!", text: "Please enter all the data.")
            }
        }
    }
    
    func loginRequest() {
        connector.sendMessage(person.objectToString(), functionName: "login") { (jsonString,error) -> Void in
            print(jsonString)
            if jsonString == "denial" {
                self.showAlert("Wrong User Data", text: "Email and password don't seem to match. Try again.")
            } else {
                //User Data contained in jsonString
                //Convert JSON String to Person Object
                //Params of the JSON String: age, email, height, name, password, weight, gender, par, steplength
                
                self.person = self.person.jsonToObject(jsonString)
                
                if self.textEmail.text! == "" || self.textPassword.text! == "" {
                    self.person.mail = self.appDel.person.mail
                    self.person.pw = self.appDel.person.pw
                } else {
                    self.person.mail = self.textEmail.text
                    self.person.pw = self.textPassword.text
                    self.appDel.personMail = self.textEmail.text
                    self.appDel.personPW = self.textPassword.text
                }
                
                self.appDel.saveUserDefaults()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.appDel.person = self.person
                    self.performSegueWithIdentifier("showMenu", sender: self)
                }
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
