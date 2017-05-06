//
//  LockerBackgroundView.swift
//  CSLockerUI
//
//  Created by František Kratochvíl on 01.12.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
class LockerBackgroundView: UIImageView {
    
    var colorLayer: CALayer? = nil
    
    //--------------------------------------------------------------------------
    var opacity: Float = 0.85 {
        didSet {
            makeLayer()
        }
    }
    
    //--------------------------------------------------------------------------
    var tint: UIColor = UIColor.init(hexString: "135091") {
        didSet {
            makeLayer()
        }
    }
    
    //--------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeLayer()
        
        if let background = LockerUI.internalSharedInstance.lockerUIOptions.backgroundImage {
            self.image = background
        }
    }
    
    //--------------------------------------------------------------------------
    override func layoutSubviews() {
        makeLayer()
    }
    
    //--------------------------------------------------------------------------
    func makeLayer() {
        colorLayer?.removeFromSuperlayer()
        
        let layer = CALayer.init()
        layer.backgroundColor = self.tint.cgColor
        layer.opacity         = self.opacity
        layer.frame           = self.bounds
        
        colorLayer = layer
        self.layer.addSublayer(colorLayer!)
    }
}
