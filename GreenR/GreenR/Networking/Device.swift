//
//  Device.swift
//  GreenR
//
//  Created by Nikash Ramsorrun on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import Foundation

class Device: Decodable {
    init(name: String, power: Float, isOn: Bool, powerUsed: Int) {
        self.name = name
        self.power = power
        self.isOn = isOn
        self.powerUsed = powerUsed
    }
    
    let name: String
    let power: Float
    let isOn: Bool
    let powerUsed: Int
    
    
}
