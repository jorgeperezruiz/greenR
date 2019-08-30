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
    var line = LineChartDataSet()
    let network = Networking()
    var devices: [Device]?
    let maximumDataPoints = 15
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        for i in counter...10 {
        //            let value = ChartDataEntry(x:Double(i), y:Double(i+1))
        //            lineChartEntry.append(value)
        //        }
        
//        let dummyDevices = [ Device(name: "fan", power: Float(6.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(6.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(5.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(11.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(20.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(23.0), isOn: true, powerUsed: 9),
//                             Device(name: "fan", power: Float(4.0), isOn: true, powerUsed: 9)]
//
//        for (index, device) in dummyDevices.enumerated() {
//            let value = ChartDataEntry(x: Double(index + 1), y: Double(device.power))
//            lineChartEntry.append(value)
//        }
//
//        line = LineChartDataSet(entries: lineChartEntry, label: "Kw/h")
        
        //        lineChart.backgroundColor = UIColor.blue
//        line.circleRadius = 2
//        data.addDataSet(line)
//        lineChart.data = data
        
        setupLineChart()
        updateLineChart()
    }
    
    
    
    func setupLineChart() {
        data.removeDataSet(line)
        line.valueColors = [UIColor.white]
        lineChart.drawBordersEnabled = false
        lineChart.drawGridBackgroundEnabled = false
    }
    
    func updateLineChart() {
        data.removeDataSet(line)
        
        guard let devices = devices else { //If no data, dummy data is shown
            let dummyDevices = [ Device(name: "fan", power: Float(6.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(6.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(5.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(11.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(20.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(23.0), isOn: true, powerUsed: 9),
                                 Device(name: "fan", power: Float(4.0), isOn: true, powerUsed: 9)]
            for (index, device) in dummyDevices.enumerated() {
                let value = ChartDataEntry(x: Double(index + 1), y: Double(device.power))
                lineChartEntry.append(value)
            }
            line = LineChartDataSet(entries: lineChartEntry, label: "Kw/h")
            line.circleRadius = 2
            data.addDataSet(line)
            lineChart.data = data
            return
        }
        
        
        //If has data
        for (index, device) in devices.enumerated() {
            let value = ChartDataEntry(x: Double(index + 1), y: Double(device.power))
            lineChartEntry.append(value)
        }
        let latestData = Array(lineChartEntry.suffix(15))
        line = LineChartDataSet(entries: latestData, label: "Kw/h")
        line.circleRadius = 2
        data.addDataSet(line)
        lineChart.data = data
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startReadingPower()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopReadingPower()
    }
    
    func stopReadingPower() {
        timer.invalidate()
    }
    
    func startReadingPower() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getDevice), userInfo: nil, repeats: true)
    }
    
    @objc func getDevice() {
        print("getting device")
        network.getDevice { result in
            switch result {
            case .success(let device):
                self.devices?.append(device)
            case .failure(_):
                print("Error getting device at \(Date())")
            }
        }
    }
    
    func turnDevice(isOn: Bool) {
        print("toggling device  power")
        network.turnDevice(isOn: isOn) { result in
            switch result {
            case .success(let device):
                print(device)
            case .failure(_):
                print("Error toggling power at \(Date())")
            }
        }
    }
    
}

