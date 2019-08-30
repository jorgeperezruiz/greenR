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
typealias PowerOnClosure = (NetworkingResult<Bool>) -> Void

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
    func turnDevice(on: Bool, onCompletion: @escaping PowerOnClosure)
}


class Networking: NetworkingContract {
    
    let baseURL = URL(string: "www.google.com")!
    let deviceComponent = "/devices"
    
    
    func getDevice(onCompletion: @escaping DeviceClosure) {
        let pathComponents = deviceComponent + "/fan"
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
    
    
    func turnDevice(on: Bool, onCompletion: @escaping PowerOnClosure) {
        let pathComponents = deviceComponent + "/fan"
        let endpoint = baseURL.appendingPathComponent(pathComponents)
        
//        let headersHelper = HeadersHelper(additionalHeaders: ["Content-Type": "application/json"])

        
        var json = [String: Any]()
        json["isOn"] = on
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        URLSession.shared.dataTask(withUrl: endpoint, method: .put, jsonData: jsonData) { result in
            switch result {
            case .success(_, let data):
                do {
                    let success = try JSONDecoder().decode(Bool.self, from: data) //Data Type to be determined
                    onCompletion(.success(success))
                } catch {
                    onCompletion(.failure(.decodeFail))
                }
            case .failure(let error):
                print(error)
            }
            }.resume()
    }
    
}


class presenter {
    let network = Networking()
    var device: Device?
    
    func dosomething() {
        network.getDevice { result in
            switch result {
            case .success(let device):
                self.device = device
            case .failure(let error):
                print(error)
            }
        }
    }
}
