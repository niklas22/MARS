//
//  StatisticsTableViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 21.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import UIKit
import Charts

class StatisticsTableViewController: UITableViewController {

    let reuseIdentifier:String = "statisticCell"
    var gradient : CAGradientLayer!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1).CGColor, (UIColor.whiteColor().CGColor)]
        //self.view.layer.insertSublayer(gradient, atIndex: 0)
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
      //  self.tableView.backgroundView?.layer.insertSublayer(gradient, atIndex: 0)

      //  self.tableView.backgroundColor = UIColor.clearColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // stepts
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StatisticTableViewCell
            cell.setTitle("Steps")
            cell.loadDataFromServer("getSteps",dataString: "email=\(appDel.person.mail)&pw=\(appDel.person.pw)")
            cell.barChartView.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.EaseOutExpo)
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("heartRateCell", forIndexPath: indexPath) as! GraphTableViewCell
            cell.setTitle("Heartrates")
            cell.loadDataFromServer("getHeartrates", dataString: appDel.person.objectToString())
            cell.lineChart.animate(xAxisDuration: 2.0, easingOption: ChartEasingOption.EaseOutExpo)
            return cell
        }

        // Configure the cell...

       
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

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
