//
//  ShadowButton.swift
//  CSLockerUI
//
//  Created by František Kratochvíl on 03.12.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
class ShadowButton: UIButton {

    var backgroundLayer: CALayer?
    var shadowLayer:     CALayer?
    
    var cornerRadius: CGFloat = 5.0
    var shadowOffset: CGSize  = CGSize(width: 0.0, height: 3.0)
    
    //--------------------------------------------------------------------------
    var buttonColor:     UIColor? = UIColor.white {
        didSet {
            backgroundLayer?.backgroundColor = buttonColor?.cgColor
        }
    }

    //--------------------------------------------------------------------------
    var shadowColor:     UIColor? = UIColor.black {
        didSet {
            shadowLayer?.backgroundColor = shadowColor?.cgColor
        }
    }
    
    //--------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    //--------------------------------------------------------------------------
    func addOrReplaceLayers()
    {
        self.shadowLayer?.removeFromSuperlayer()
        self.backgroundLayer?.removeFromSuperlayer()
        
        let backgroundLayer = self.makeLayer(self.buttonColor!.cgColor, frame: self.bounds)        
        var frame           = self.bounds
        frame.origin.x      = self.shadowOffset.width
        frame.origin.y      = self.shadowOffset.height
        let shadowLayer     = self.makeLayer(self.shadowColor!.cgColor, frame: frame)
        
        self.layer.insertSublayer(backgroundLayer, at: 0)
        self.layer.insertSublayer(shadowLayer, at: 0)

        self.backgroundLayer = backgroundLayer
        self.shadowLayer     = shadowLayer
    }
    
    //--------------------------------------------------------------------------
    func makeLayer(_ color: CGColor, frame: CGRect) -> CALayer {
        let layer               = CALayer()
        layer.frame             = frame
        layer.cornerRadius      = self.cornerRadius
        layer.backgroundColor   = color
        return layer
    }

    //--------------------------------------------------------------------------
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.addOrReplaceLayers()
    }

}
