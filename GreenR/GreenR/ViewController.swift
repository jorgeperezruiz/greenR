//
//  ViewController.swift
//  GreenR
//
//  Created by Pete Holdsworth on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let network = Networking()
    var devices: [Device]?
    
    var timer = Timer()
    
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

