//
//  Networking.swift
//  GreenR
//
//  Created by Nikash Ramsorrun on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import Foundation

typealias CompletionClosure = (Result<(URLResponse, Data), Error>) -> Void
typealias DeviceClosure = (NetworkingResult<Device>) -> Void
typealias PowerOnClosure = (NetworkingResult<Device>) -> Void

enum NetworkingError: Error {
    case networkError
    case decodeFail
    case unknown
}

enum NetworkingResult<T> {
    case success(T)
    case failure(NetworkingError)
}

public enum HTTPMethod: String {
    case get
    case put
    
    public var rawValue: String {
        return "\(self)".uppercased()
    }
}


protocol NetworkingContract {
    func getDevice(onCompletion: @escaping DeviceClosure)
    func turnDevice(isOn: Bool, onCompletion: @escaping PowerOnClosure)
}


class Networking: NetworkingContract {
    
    let baseURL = URL(string: "https://jb4lvatqze.execute-api.eu-west-1.amazonaws.com/prod")!
    let deviceComponent = "/devices"
    
    
    func getDevice(onCompletion: @escaping DeviceClosure) {
        let pathComponents = deviceComponent + "/Fan"
        let endpoint = baseURL.appendingPathComponent(pathComponents)
        
        URLSession.shared.dataTask(withUrl: endpoint) { result in
            switch result {
            case .success(_, let data):
                do {
                    let device = try JSONDecoder().decode(Device.self, from: data)
                    onCompletion(.success(device))
                } catch {
                    onCompletion(.failure(.decodeFail))
                }
            case .failure(let error):
                print(error)
            }
            }.resume()
    }
    
    
    func turnDevice(isOn: Bool, onCompletion: @escaping PowerOnClosure) {
        let pathComponents = deviceComponent + "/Fan"
        let endpoint = baseURL.appendingPathComponent(pathComponents)
        
        let headers = ["Content-Type": "application/json"]

        
        var json = [String: Any]()
        json["isOn"] = isOn
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        URLSession.shared.dataTask(withUrl: endpoint, headerFields: headers, method: .put, jsonData: jsonData) { result in
            switch result {
            case .success(_, let data):
                do {
                    let device = try JSONDecoder().decode(Device.self, from: data) //Data Type to be determined
                    onCompletion(.success(device))
                } catch {
                    onCompletion(.failure(.decodeFail))
                }
            case .failure(let error):
                print(error)
            }
            }.resume()
    }
    
}


//class presenter {
//    let network = Networking()
//    var device: Device?
//
//
//    var timer = Timer()
//
//    override func viewDidLoad() {
//        scheduledTimerWithTimeInterval()
//    }
//
//    func scheduledTimerWithTimeInterval(){
//        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
//        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounting"), userInfo: nil, repeats: true)
//    }
//
//    func updateCounting(){
//        NSLog("counting..")
//    }
//
//
//    func dosomething() {
//        network.getDevice { result in
//            switch result {
//            case .success(let device):
//                self.device = device
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}
