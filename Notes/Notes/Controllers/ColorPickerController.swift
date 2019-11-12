//
//  ColorPickerController.swift
//  Notes
//
//  Created by Надежда Морозова on 10/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    
    @IBOutlet weak var selectedColor: UIView!
    var onSelection: ((UIColor) -> ())?
    
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet var sliderAlpha: UISlider!
    @IBOutlet weak var selectedColorHex: UILabel!
    
    @IBOutlet var crossShape: Cross!
    //initWithCode to init view from xib or storyboard
    var colorSelection: UIColor?
    
    func editColor(_ color: UIColor) {
        crossShape.center = gradientView.getPoint(color: color)
        sliderAlpha.value = Float(color.cgColor.components![3])
        colorChanged()
    }
    
    @IBAction func handleTouching(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = crossShape!
        
        let translation = gestureRecognizer.location(in: piece.superview)
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: translation.x, y: translation.y)
            if piece.superview!.bounds.contains(CGRect(x: newCenter.x, y: newCenter.y, width: 0, height: 0)) {
                piece.center = newCenter
            }
            
        }
        gradientView.getColor(x: Double(piece.center.x), y: Double(piece.center.y))
        colorChanged()
    }
    
    @IBAction func brightnessChanged(_ sender: UISlider) {
        colorChanged()
    }
    
    private func colorChanged() {
        selectedColor.backgroundColor = UIColor(red: CGFloat(gradientView.red / 255.0), green: CGFloat(gradientView.green / 255.0), blue: CGFloat(gradientView.blue / 255.0), alpha: CGFloat(sliderAlpha.value))
        selectedColorHex.text = selectedColor.backgroundColor?.toHexString()
        colorSelection = selectedColor.backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    private func setupCross() {
        if let colorSelection = colorSelection {
            editColor(colorSelection)
        } else {
            crossShape.center = CGPoint(x: gradientView.bounds.width / 2, y: gradientView.bounds.height / 2)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupCross()
    }
    
    //common func to init our view
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedColor.backgroundColor = .white
        selectedColor.layer.borderWidth = 1
        selectedColor.layer.borderColor = UIColor.black.cgColor
        selectedColor.layer.cornerRadius = 5
        selectedColor.clipsToBounds = true
        selectedColorHex.layer.borderWidth = 1
        selectedColorHex.layer.borderColor = UIColor.black.cgColor
        gradientView.layer.borderWidth = 1
        gradientView.layer.borderColor = UIColor.black.cgColor
        setupCross()
    }
    @IBAction func donePressed(_ sender: UIButton) {
        onSelection?(selectedColor.backgroundColor ?? .white)
        dismiss(animated: true, completion: nil)
    }
    
}
