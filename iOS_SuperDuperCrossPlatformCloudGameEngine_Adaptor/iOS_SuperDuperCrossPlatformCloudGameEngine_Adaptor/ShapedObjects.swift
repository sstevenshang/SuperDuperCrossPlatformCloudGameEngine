//
//  ShapedObjects.swift
//  iOS_SuperDuperCrossPlatformCloudGameEngine_Adaptor
//
//  Created by Steven Shang on 2/24/18.
//  Copyright © 2018 sstevenshang. All rights reserved.
//

import UIKit

enum ShapeType {
    case Circle
    case Rectangle
}

class ShapedObjects: UIView {
    
    var path: UIBezierPath!
    var shape: ShapeType!
    var objectID: String!
    var color: UIColor!
        
    init(shape: ShapeType, objectID: String, color: UIColor, location: (x: CGFloat, y: CGFloat), size: (width: CGFloat, height: CGFloat)) {
        super.init(frame: CGRect(x: location.x, y: location.y, width: size.width, height: size.height))
        self.shape = shape
        self.objectID = objectID
        self.color = color
        self.backgroundColor = UIColor.clear
        setUpRecognizer()
    }
    
    private func setUpRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(tapRecognizer:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        
        let tapLocation:CGPoint = tapRecognizer.location(in: self)
        if path.contains(tapLocation) {
        }
    }
    
    private func handleTap() {
        print("I'm touched!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RectangleObject: ShapedObjects {
    
    init(objectID: String, color: UIColor, location: (x: CGFloat, y: CGFloat), size: (CGFloat, CGFloat)) {
        super.init(shape: .Rectangle, objectID: objectID, color: color, location: location, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.createRectangle()
        color.setFill()
        path.fill()
        UIColor.black.setStroke()
        path.stroke()
    }
    
    private func createRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()
    }
}

class CircleObject: ShapedObjects {
    
    var radius: CGFloat!
    
    init(objectID: String, color: UIColor, location: (x: CGFloat, y: CGFloat), radius: CGFloat) {
        let size = (radius*2, radius*2)
        super.init(shape: .Circle, objectID: objectID, color: color, location: location, size: size)
        self.radius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.createRectangle()
        color.setFill()
        path.fill()
    }
    
    private func createRectangle() {
        path = UIBezierPath(ovalIn: self.bounds)
    }
}


