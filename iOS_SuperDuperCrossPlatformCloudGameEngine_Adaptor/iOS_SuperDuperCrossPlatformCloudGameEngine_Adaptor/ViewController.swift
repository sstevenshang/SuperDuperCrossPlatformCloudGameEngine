//
//  ViewController.swift
//  iOS_SuperDuperCrossPlatformCloudGameEngine_Adaptor
//
//  Created by Steven Shang on 2/24/18.
//  Copyright © 2018 sstevenshang. All rights reserved.
//

import UIKit

var objects: [Int:UIView] = [:]

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createCircle(objectID: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createCircle(objectID: Int) {
        
        let width: CGFloat = 240.0
        let height: CGFloat = 160.0
        
        let x = self.view.frame.size.width/2 - width/2
        let y = self.view.frame.size.height/2 - height/2
        
        var circleView = CircleObject(objectID: objectID, color: .yellow, location: (x: x, y: y), radius: width/2)
        
        // var rectangleView = RectangleObject(objectID: objectID, color: .yellow, location: (x: x, y: y), size: (width, height))
        
        objects[objectID] = circleView
        self.view.addSubview(circleView)
    }
    
}

