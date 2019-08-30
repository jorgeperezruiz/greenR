//
//  ControlsViewController.swift
//  GreenR
//
//  Created by Nikash Ramsorrun on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController {
    let network = Networking()
    
    @IBOutlet weak var acButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acButton.isUserInteractionEnabled = false
        getDevice()
    }
    
    var deviceIsOn = false
    
    func getDevice() {
        print("getting device")
        network.getDevice { [weak self] result in
            DispatchQueue.main.async {
                self?.acButton.isUserInteractionEnabled = true
                switch result {
                case .success(let device):
                    print("getDevice in ControlsVC success")
                    self?.deviceIsOn = device.isOn
                case .failure(let error):
                    print("Error getting device at \(Date()): \(error.localizedDescription)")
                }
            }
        }
    }
    
    func turnDevice(isOn: Bool) {
        print("toggling device  power")
        network.turnDevice(isOn: isOn) { [weak self] result in
            DispatchQueue.main.async {
                self?.acButton.isUserInteractionEnabled = true
                switch result {
                case .success(let device):
                    print("success device is \(device)")
                    self?.deviceIsOn = device.isOn
                case .failure(_):
                    print("Error toggling power at \(Date())")
                }
            }
        }
    }
    @IBAction func acTapped(_ sender: Any) {
        acButton.isUserInteractionEnabled = false
        turnDevice(isOn: !deviceIsOn)
        
    }
}
