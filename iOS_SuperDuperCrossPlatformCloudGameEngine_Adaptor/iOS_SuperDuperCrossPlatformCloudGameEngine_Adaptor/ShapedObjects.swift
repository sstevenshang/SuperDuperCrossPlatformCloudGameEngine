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
            handleTap()
        }
    }
    
    private func handleTap() {
        print("I'm touched!")
        NotificationCenter.default.post(name: NSNotification.Name("ObjectClicked"), object: self)
    }
    
    public func changeColor(newColor: UIColor) {
        self.color = newColor
        self.setNeedsDisplay()
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
    
    private var radius: CGFloat!
    
    init(objectID: String, color: UIColor, location: (x: CGFloat, y: CGFloat), radius: CGFloat) {
        let size = (radius*2, radius*2)
        super.init(shape: .Circle, objectID: objectID, color: color, location: location, size: size)
        self.radius = radius
    }
    
    func getRadius() -> CGFloat {
        return radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeRadius(radius: CGFloat) {
        self.radius = radius
        let oldFrame = self.frame
        self.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: radius*2, height: radius*2)
        self.setNeedsLayout()
        self.setNeedsDisplay()
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
