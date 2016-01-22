//
//  GraphTableViewCell.swift
//  MOS5
//
//  Created by Niklas Mayr on 22.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import UIKit
import Charts

class GraphTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var graphTitleLabel: UILabel!
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    var dataDescription:[String] = []
    var data:[Double] = []
    var descriptionText:[String] = []
    var timeText:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm"
        
        graphTitleLabel.textColor = UIColor.whiteColor()
        
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.text = "Time:"
        
        valueLabel.textColor = UIColor.whiteColor()
        valueLabel.text = "Heartrate:"
        
        
        
        lineChart.delegate = self
        lineChart.scaleYEnabled = false
        lineChart.descriptionText = ""
        lineChart.legend.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.rightAxis.enabled = true
        lineChart.descriptionTextColor = UIColor.clearColor()
        lineChart.legend.textColor = UIColor.whiteColor()
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xAxis.labelPosition = .Bottom


        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initLineChart(){
        setChart(dataDescription, values: data)
    }
    
    
    func setTitle(title: String){
        graphTitleLabel.text = title
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "HeartRates")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.circleColors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1)]
        chartDataSet.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1)]
        let chartData = LineChartData(xVals: dataDescription, dataSet: chartDataSet)
        
        
        lineChart.data = chartData
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        valueLabel.text = descriptionText[entry.xIndex]
        timeLabel.text = timeText[entry.xIndex]
    }
    
    func loadDataFromServer(functionName: String, dataString: String) {
        
        self.data = []
        self.dataDescription = []
        self.timeText = []
        
        ServerConnector.connector.sendMessage(dataString, functionName: functionName) { (jsonString, error) -> Void in
            
            print("MARS: \(jsonString)")
            var beginDate:String = ""
            var begin:Int = 0
            
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                let ar = json.arrayValue
                
                if ar.count <= 50 {
                    begin = 0
                } else {
                    begin = ar.count - 50
                }
                
                for ind in begin..<ar.count {
                    
                    let hr = ar[ind]["heartRate"].intValue
                    
                    if hr != 0{
                        
                        
                        let startTime = ar[ind]["date"].intValue
                        
                        self.data.append(Double(hr))
                        self.dataDescription.append("")
                        
                        beginDate = self.dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(startTime/1000)))
                        
                        self.descriptionText.append("Heartrate: \(hr)")
                        self.timeText.append("Time: \(beginDate)")
                        
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.initLineChart()
                }
                
            }
            
            
            
            
        }
    }


}
