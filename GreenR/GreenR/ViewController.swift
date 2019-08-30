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
    var devices = [Device]()
    let maximumDataPoints = 15
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLineChart()
        updateLineChart()
    }
    
    
    
    func setupLineChart() {
        data.removeDataSet(line)
        line.valueColors = [UIColor.white]
        lineChart.drawBordersEnabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.xAxis.drawLabelsEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawLabelsEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
    }
    
    func updateLineChart() {
        data.removeDataSet(line)
        lineChartEntry = []
        
        guard !devices.isEmpty else { return }
    
        //If has data
        for (index, device) in devices.enumerated() {
            let value = ChartDataEntry(x: Double(index), y: Double(device.power/1000))
            lineChartEntry.append(value)
        }
        let latestData = Array(lineChartEntry.suffix(maximumDataPoints))
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
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getDevice), userInfo: nil, repeats: true)
        getDevice()
    }
    
    @objc func getDevice() {
        print("getting device")
        network.getDevice { [weak self] result in
            switch result {
            case .success(let device):
                print("getDevice success")
                DispatchQueue.main.async {
                    self?.devices.append(device)
                    self?.updateLineChart()
                }
            case .failure(let error):
                print("Error getting device at \(Date()): \(error.localizedDescription)")
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

