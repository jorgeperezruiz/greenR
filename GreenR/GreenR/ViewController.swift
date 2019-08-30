//
//  ViewController.swift
//  GreenR
//
//  Created by Pete Holdsworth on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    
    
    var lineChartEntry = [ChartDataEntry]()
    let data = LineChartData()
    var counter = 0
    var line = LineChartDataSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in counter...10 {
            let value = ChartDataEntry(x:Double(i), y:Double(i+1))
            lineChartEntry.append(value)
        }
        
        counter = 10
        
        line = LineChartDataSet(entries: lineChartEntry, label: "Kw/h")
        
//        lineChart.backgroundColor = UIColor.blue
        line.valueColors = [UIColor.white]
        lineChart.drawBordersEnabled = false
        lineChart.drawGridBackgroundEnabled = false
        
        line.circleRadius = 2
        data.addDataSet(line)
        lineChart.data = data
    }

    
    
    
    

}

