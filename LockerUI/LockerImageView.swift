//
//  LockerBackgroundView.swift
//  CoreSDKTestApp
//
//  Created by Vladimír Nevyhoštěný on 27.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
class LockerImageView: UIImageView
{
    //--------------------------------------------------------------------------
    var tint: UIColor? {
        didSet {
            tintImage()
        }
    }
    
    //--------------------------------------------------------------------------
    override var image: UIImage? {
        didSet {
            self.tintImage()
        }
    }
    
    //--------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder )
        self.tintImage()
    }
    
    //--------------------------------------------------------------------------
    func tintImage() {
        if self.tint != nil {
            super.image = self.image?.imageWithTint(tint!)
        }
    }
}
