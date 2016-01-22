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

    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var statisticDetail: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var statisticTitle: UILabel!
    
    let dateFormatter = NSDateFormatter()
    var descriptionText: [String] = []
    var startTimeText:[String] = []
    var endTimeText:[String] = []
    
   // let dataDescription = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var dataDescription:[String] = []
   // let data = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var data:[Double] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        endTimeLabel.textColor = UIColor.whiteColor()
        startTimeLabel.textColor = UIColor.whiteColor()
        endTimeLabel.text = "Endtime:"
        startTimeLabel.text = "Starttime:"
        statisticDetail.text = "Steps:"
        
        
        
        barChartView.delegate = self
        barChartView.scaleYEnabled = false
        barChartView.descriptionText = "Steps:"
        barChartView.legend.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.descriptionTextColor = UIColor.clearColor()
        barChartView.legend.textColor = UIColor.whiteColor()
        barChartView.backgroundColor = UIColor.clearColor()
        barChartView.xAxis.labelPosition = .Bottom
        
        
        statisticTitle.textColor = UIColor.whiteColor()
        statisticDetail.textColor = UIColor.whiteColor()

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
        statisticDetail.text = descriptionText[entry.xIndex]
        startTimeLabel.text = startTimeText[entry.xIndex]
        endTimeLabel.text = endTimeText[entry.xIndex]
    }
    
    func loadDataFromServer(functionName: String, dataString: String) {
        
        self.data = []
        self.dataDescription = []
        self.startTimeText = []
        self.endTimeText = []
        
        ServerConnector.connector.sendMessage(dataString, functionName: functionName) { (jsonString, error) -> Void in
            
            print("MARS: \(jsonString)")
            var beginDate:String = ""
            var endDate:String = ""
            
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                let ar = json.arrayValue
                
                for ind in 0..<ar.count {
                    
                    let steps = ar[ind]["steps"].intValue

                    if steps != 0{
                        
                        
                        let startTime = ar[ind]["startTime"].intValue
                        let endTime = ar[ind]["endTime"].intValue
                        
                        self.data.append(Double(steps))
                        self.dataDescription.append("")
                        
                        beginDate = self.dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(startTime/1000)))
                        endDate = self.dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(endTime/1000)))
                        
                        self.descriptionText.append("Steps: \(steps)")
                        self.startTimeText.append("Starttime: \(beginDate)")
                        self.endTimeText.append("Endtime: \(endDate)")

                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue()){
                   self.initBarChart() 
                }
                
            }
            
            

            
        }
    }
}
