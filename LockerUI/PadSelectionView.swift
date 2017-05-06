//
//  PadSelectionView.swift
//  CoreSDKTestApp
//
//  Created by František Kratochvíl on 11.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
@IBDesignable class PadSelectionView: UIView {
    
    @IBInspectable var points:    Int     = 4 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var pointSize:      CGFloat = 15
    @IBInspectable var lineWidth:      CGFloat = 1.5
    @IBInspectable var color:          UIColor = UIColor.white
    @IBInspectable var selectedColor:  UIColor = UIColor.white

    //--------------------------------------------------------------------------
    var value: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    //--------------------------------------------------------------------------
    override func draw(_ rect: CGRect) {
        let context       = UIGraphicsGetCurrentContext()
        let color         = self.color.cgColor
        let selectedColor = self.selectedColor.cgColor
        

        for i in 0..<points {
            let pointRect  = rectForDot(rect, index: i)
            let path       = UIBezierPath(ovalIn: pointRect)
            path.lineWidth = self.lineWidth
            
            if i < value {
                context!.setStrokeColor(selectedColor)
                context!.setFillColor(selectedColor)
            }
            else {
                context!.setStrokeColor(color)
                context!.setFillColor(color)
            }
            path.fill()
            path.stroke()
        }
    }
    
    //--------------------------------------------------------------------------
    override var intrinsicContentSize : CGSize {
        return CGSize(width: pointSize * CGFloat(points) * 1.6, height: pointSize + 2 * lineWidth)
    }
    
    //--------------------------------------------------------------------------
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clear
    }
    
    //--------------------------------------------------------------------------
    func rectForDot(_ rect: CGRect, index: Int) -> CGRect {
        let w = (frame.size.width  - pointSize - 2 * lineWidth) / CGFloat(points - 1)
        let h = (frame.size.height - pointSize - 2 * lineWidth) / 2
        
        let rect  = CGRect(x: 0, y: 0, width: pointSize, height: pointSize)
        let x     = w * CGFloat(index) + lineWidth
        let moved = rect.offsetBy(dx: x, dy: h + lineWidth)
        
        return moved
    }

}
