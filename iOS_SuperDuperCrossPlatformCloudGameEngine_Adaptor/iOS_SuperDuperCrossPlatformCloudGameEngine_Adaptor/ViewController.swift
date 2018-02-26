//
//  ViewController.swift
//  iOS_SuperDuperCrossPlatformCloudGameEngine_Adaptor
//
//  Created by Steven Shang on 2/24/18.
//  Copyright © 2018 sstevenshang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    var objects: [String:ShapedObjects] = [:]
    
    private var canvasWidth: Int = 200
    private var canvasHeight: Int = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        sendInitialRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setUpObesrver(objectID: String) {
        
        guard let object = objects[objectID] else {
            fatalError("Object is not stored!")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ObjectClicked"), object: object, queue: nil) { (notification) in
            let parameters: [String: Any] = [
                "class" : "COMPONENT",
                "target" : objectID,
                "operation" : "UPDATE",
                "ax_data" : [
                "action" : "click"
                ]
            ]
            NetworkManager.sharedSession.sendTCPRequest(parameters: parameters, responseHandler: { (response) in
                self.parseJsonCommand(json: response)
            })
        }
    }
    
    private func createCircle(objectID: String, relativeX: Double, relativeY: Double, relativeRadius: Double, colorHex: String) {

        let radius = self.view.frame.size.width * CGFloat(relativeRadius / Double(canvasWidth))
        
        var x = (CGFloat(relativeX)/CGFloat(canvasWidth)) * self.view.frame.size.width
        let y = (CGFloat(relativeX)/CGFloat(canvasHeight)) * self.view.frame.size.height
        
        if (x + radius*2) >= self.view.frame.size.width {
            x = x - radius/2
        }
        
        let color = Utility.hexStringToUIColor(hex: colorHex)
        let circleView = CircleObject(objectID: objectID, color: color, location: (x: x, y: y), radius: CGFloat(radius))
        objects[objectID] = circleView
        self.view.addSubview(circleView)
        
        setUpObesrver(objectID: objectID)
    }

    private func changeCircleColor(objectID: String, newColorHex: String) {
        
        let newColor = Utility.hexStringToUIColor(hex: newColorHex)
        guard let object = objects[objectID] else {
            fatalError("ObjectID is not stored!")
        }
        object.changeColor(newColor: newColor)
    }
    
    private func changeCircleRadius(objectID: String, factor: Double) {
        
        // let newRadius = self.view.frame.size.width * CGFloat(newRelativeRadius / Double(canvasWidth))
        guard let object = objects[objectID] else {
            fatalError("ObjectID is not stored!")
        }
        
        let circle = object as! CircleObject
        let newRadius = circle.getRadius() * CGFloat(factor)
        circle.changeRadius(radius: newRadius)
    }
    
    private func sendInitialRequest() {
        NetworkManager.sharedSession.connectTCPSocket { (json) in
            self.parseJsonCommand(json: json)
        }
    }
    
    private func parseJsonCommand(json: JSON) {
        
        for (_, command) in json {
            
            guard let commandClass: String = command["class"].string,
                let commandTarget: String = command["target"].string,
                let commandOperation: String = command["operation"].string,
                let commandAxData:[String:JSON] = command["ax_data"].dictionary else {
                    print("Failed: to parse JSON.")
                    break
            }
            
            switch commandClass {
            case "CANVAS":
                parseCanvasCommand(objectID: commandTarget, operation: commandOperation, axData: commandAxData)
            case "COMPONENT":
                parseComponentCommand(objectID: commandTarget, operation: commandOperation, axData: commandAxData)
            default:
                print("Failed: invalid command.")
            }
        }
    }
    
    private func parseCanvasCommand(objectID: String, operation: String, axData: [String:JSON]) {
        if operation == "CREATE" {
            if let size = axData["size"]?.arrayValue.map({$0.int}), let w = size[0], let h = size[1] {
                canvasWidth = w
                canvasHeight = h
                print("Canvas size is: \(canvasWidth, canvasHeight)")
            } else {
                print("Failed: to get size.")
            }
        } else {
            print("Failed: invalid operation")
        }
    }
    
    private func parseComponentCommand(objectID: String, operation: String, axData: [String:JSON]) {
        switch operation {
        case "INIT":
            if let location = axData["loc"]?.arrayValue.map({$0.double}),
                let shape = axData["shape"]?.string,
                let color = axData["texture"]?.string,
                let radius = axData["size"]?.double {
                
                switch shape {
                case "circle":
                    createCircle(objectID: objectID, relativeX: location[0]!, relativeY: location[1]!, relativeRadius: radius, colorHex: color)
                default:
                    break
                }
            }
        case "UPDATE":
            if let action = axData["action"]?.string {
                switch action {
                case "change_texture":
                    if let newColor = axData["texture"]?.string {
                        self.changeCircleColor(objectID: objectID, newColorHex: newColor)
                    }
                case "change_size":
                    if let factor = axData["factor"]?.double {
                        self.changeCircleRadius(objectID: objectID, factor: factor)
                    }
                default:
                    break
                }
            }
        default:
            print("Failed: invalid operation")
        }
    }
}
