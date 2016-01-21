//
//  StatisticTableViewCell.swift
//  MOS5
//
//  Created by Niklas Mayr on 21.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import UIKit
import Charts

class StatisticTableViewCell: UITableViewCell, ChartViewDelegate {

    
    @IBOutlet weak var statisticDetail: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var statisticTitle: UILabel!
    let dateFormatter = NSDateFormatter()
    var dict = Dictionary<Int, AnyObject>()
    
   // let dataDescription = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var dataDescription:[String] = []
   // let data = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var data:[Double] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        barChartView.delegate = self
        
        barChartView.scaleYEnabled = false
        barChartView.descriptionText = ""
        
        barChartView.legend.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.descriptionTextColor = UIColor.whiteColor()
        barChartView.descriptionTextColor = UIColor.clearColor()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initBarChart(){
        setChart(dataDescription, values: data)
    }
    
    
    func setTitle(title: String){
        statisticTitle.text = title
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1)]
        let chartData = BarChartData(xVals: dataDescription, dataSet: chartDataSet)
        
        
        barChartView.data = chartData
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("selected")
    }
    
    func loadDataFromServer(dataString: String) {
        
        ServerConnector.connector.sendMessage(dataString, functionName: "getSteps") { (jsonString, error) -> Void in
            
            print("MARS: \(jsonString)")
            var beginDate:String = ""
            var endDate:String = ""
            
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                let ar = json.arrayValue
                
                for ind in 0..<ar.count {
                    let steps = ar[ind]["steps"].intValue
                    let startTime = ar[ind]["startTime"].intValue
                    let endTime = ar[ind]["endTime"].intValue
                    
                    beginDate = self.dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(startTime)))
                    endDate = self.dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(endTime)))
                    
                    

                }

            }

            
        }
    }
}
