//
//  ColorCell.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
import UIKit

class ColorCell: UICollectionViewCell {
    var fillColor = UIColor.white {
        didSet {
            backgroundColor = fillColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func draw() {
        let center = CGPoint(x: bounds.width - 15 - 5,y: 20)
        let circlePath = UIBezierPath(arcCenter: center, radius: 15, startAngle: 0, endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.black.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        layer.addSublayer(shapeLayer)
        
        let leftLine = UIBezierPath()
        leftLine.move(to: CGPoint(x: center.x - 10, y: center.y))
        leftLine.addLine(to: CGPoint(x: center.x, y: center.y + 10))
        leftLine.addLine(to: CGPoint(x: center.x + 7, y: center.y - 10))
        let shape = CAShapeLayer()
        shape.path = leftLine.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = 3.0
        layer.addSublayer(shape)
    }
    
    func unselect() {
        layer.sublayers?.forEach{ ($0 as? CAShapeLayer)?.removeFromSuperlayer()}
    }
}

