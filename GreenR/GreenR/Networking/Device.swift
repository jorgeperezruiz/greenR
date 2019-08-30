//
//  Device.swift
//  GreenR
//
//  Created by Nikash Ramsorrun on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import Foundation

class Device: Decodable {
    let name: String
    let power: Float
    let isOn: Bool
}
