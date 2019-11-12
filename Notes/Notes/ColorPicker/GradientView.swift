//
//  GradientView.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    let maxColor = 255.0
    let dotSize = 1.0
    let ranges = 6
    var red = 255.0, green = 0.0, blue = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for i in stride(from: 0.0, to: Double(bounds.width), by: dotSize) {
            for j in stride(from: 0.0, to: Double(bounds.height), by: dotSize) {
                let color = UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
                getColor(x: i, y: j)
                context?.setFillColor(color.cgColor)
                context?.fill(CGRect(x: i, y: j, width: dotSize, height: dotSize))
            }
        }
        
    }
    func getColor(x: Double, y: Double) {
        let step = 6 * maxColor / (Double(bounds.width) / dotSize)
        switch x {
        case 0..<((Double(bounds.width)) / 6):
            green = (x + 1) * step
            red = maxColor
            blue = 0
        case ((Double(bounds.width)) / 6)..<((Double(bounds.width)) / 6 * 2):
            red = maxColor - (x - Double(bounds.width) / 6  + 1) * step
            blue = 0
            green = maxColor
        case ((Double(bounds.width)) / 6 * 2)..<((Double(bounds.width)) / 6 * 3):
            blue = (x - Double(bounds.width) / 6 * 2  + 1) * step
            green = maxColor
            red = 0
        case ((Double(bounds.width)) / 6 * 3)..<((Double(bounds.width)) / 6 * 4):
            green = maxColor - (x - Double(bounds.width) / 6 * 3  + 1) * step
            blue = maxColor
            red = 0
        case ((Double(bounds.width) ) / 6 * 4)..<((Double(bounds.width)) / 6 * 5):
            red = (x - Double(bounds.width) / 6 * 4 + 1) * step
            green = 0
            blue = maxColor
        case ((Double(bounds.width)) / 6 * 5)..<(Double(bounds.width)):
            blue = maxColor - (x - Double(bounds.width) / 6 * 5  + 1) * step
            red = maxColor
            green = 0
        default:
            break
            
        }
        red += red >= maxColor ? 0 : (y + 1) * (maxColor / (Double(bounds.height) / dotSize))
        red = red >= maxColor ? maxColor : red
        green += green >= maxColor ? 0 : (y + 1) * (maxColor / (Double(bounds.height) / dotSize))
        green = green >= maxColor ? maxColor : green
        blue += blue >= maxColor ? 0 : (y + 1) * (maxColor / (Double(bounds.height) / dotSize))
        blue = blue >= maxColor ? maxColor : blue
    }
    
    func getPoint(color: UIColor) -> CGPoint {
        var result = CGPoint.zero
        let step = 6 * maxColor / (Double(bounds.width) / dotSize)
        red = Double(color.cgColor.components![0] * 255)
        green = Double(color.cgColor.components![1] * 255)
        blue = Double(color.cgColor.components![2] * 255)
        if red + green + blue == 3 * maxColor {
            return CGPoint(x: 0, y: bounds.height)
        }
        
        result.y =  CGFloat(min(red, green, blue) / (maxColor / Double(bounds.height)))
        if red == maxColor {
            if green >= blue {
                result.x = CGFloat((green - blue) / step)
            } else {
                result.x = CGFloat((maxColor - (blue - green)) / step + Double(bounds.width) / 6 * 5)
            }
        } else if green == maxColor {
            if red >= blue {
                result.x = CGFloat((maxColor - (red - blue)) / step + Double(bounds.width) / 6)
            } else {
                result.x = CGFloat((blue - red) / step + Double(bounds.width) / 6 * 2)
            }
        } else if blue == maxColor {
            if red >= green {
                result.x = CGFloat((red - green) / step + Double(bounds.width) / 6 * 4 + 1)
            } else {
                result.x = CGFloat((maxColor - (green - red)) / step + Double(bounds.width) / 6 * 3)
            }
        }
        
        result.x = abs(result.x)
        
        return result
    }
}

