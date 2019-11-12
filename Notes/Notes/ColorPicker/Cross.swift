//
//  Cross.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
import UIKit
@IBDesignable

class Cross: UIView {
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2,y: bounds.height / 2), radius: bounds.width * 0.3, startAngle: 0, endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
       
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        
        layer.addSublayer(shapeLayer)
        
        let leftLine = UIBezierPath()
        leftLine.move(to: CGPoint(x: 0, y: bounds.height * 0.5))
        leftLine.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.5))
        UIColor.black.setStroke()
        leftLine.lineWidth = 1
        leftLine.stroke()
        let topLine = UIBezierPath()
        topLine.move(to: CGPoint(x: bounds.width * 0.5, y: 0))
        topLine.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.2))
        UIColor.black.setStroke()
        topLine.lineWidth = 1
        topLine.stroke()
        let rightLine = UIBezierPath()
        rightLine.move(to: CGPoint(x: bounds.width, y: bounds.height * 0.5))
        rightLine.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.5))
        UIColor.black.setStroke()
        rightLine.lineWidth = 1
        rightLine.stroke()
        let bottomLine = UIBezierPath()
        bottomLine.move(to: CGPoint(x: bounds.width * 0.5, y: bounds.height))
        bottomLine.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.8))
        UIColor.black.setStroke()
        bottomLine.lineWidth = 1
        bottomLine.stroke()
    }
    
    
}

