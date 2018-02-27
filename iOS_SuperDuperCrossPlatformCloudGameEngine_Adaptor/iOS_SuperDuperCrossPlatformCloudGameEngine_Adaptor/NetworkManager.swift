//
//  NetworkManager.swift
//  iOS_SuperDuperCrossPlatformCloudGameEngine_Adaptor
//
//  Created by Steven Shang on 2/24/18.
//  Copyright © 2018 sstevenshang. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftSocket

class NetworkManager: NSObject {
    
    static let serverIP: String = "35.196.154.247"
    static let sharedSession: NetworkManager = NetworkManager()
    
    var clientConnected: Bool = false
    
    let client = TCPClient(address: NetworkManager.serverIP, port: 8081)
    
    func connectTCPSocket(responseHandler:@escaping (_ json: JSON)->Void) {
        
        if !clientConnected {
            switch client.connect(timeout: 10) {
            case .success:
                clientConnected = true
                guard let data = client.read(1014, timeout: 10) else {
                    print("Failed to read anything!")
                    return
                }
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                    let json = JSON(parseJSON: response)
                    responseHandler(json)
                }
            case .failure(let error):
                print("Failed to connect!")
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func sendTCPRequest(parameters: [String: Any], responseHandler:@escaping (_ json: JSON)->Void) {
        
        let jsonData = serializeJSON(parameters: parameters)
        
        if !clientConnected {
            switch client.connect(timeout: 10) {
            case .success:
                clientConnected = true
                sendDataToClient(jsonData: jsonData, responseHandler: responseHandler)
            case .failure(let error):
                print("Failed to connect!")
                print(error.localizedDescription)
                return
            }
        } else {
            sendDataToClient(jsonData: jsonData, responseHandler: responseHandler)
        }
    }
    
    func sendDataToClient(jsonData: Data, responseHandler:@escaping (_ json: JSON)->Void) {
        switch client.send(data: jsonData) {
        case .success:
            guard let data = client.read(1014, timeout: 10) else {
                print("Failed to read anything!")
                return
            }
            if let response = String(bytes: data, encoding: .utf8) {
                print(response)
                let json = JSON(parseJSON: response)
                responseHandler(json)
            }
        case .failure(let error):
            print("Failed to send!")
            print(error.localizedDescription)
            return
        }
    }
    
    func serializeJSON(parameters: [String: Any]) -> Data {
        guard JSONSerialization.isValidJSONObject(parameters) else {
            print("Failed to create JSON!")
            return Data()
        }
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) as Data
        } catch (_) {
            print("Failed to create JSON!")
            return Data()
        }
    }
    /*
    func sendHTTPRequest(parameters: [String: Any], url: String, responseHandler:@escaping (_ json: JSON)->Void) {
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            guard let result = response.result.value else {
                return
            }
            let json = JSON(result)
            responseHandler(json)
        }
    }
    */
}
