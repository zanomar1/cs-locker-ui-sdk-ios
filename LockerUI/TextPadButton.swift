//
//  TextPadButton.swift
//  CoreSDKTestApp
//
//  Created by František Kratochvíl on 27.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//
import UIKit
class TextPadButton: PadButton {

    var labelFont = UIFont(name: "AvenirNext-Bold", size: 12)! {
        didSet {
            self.label.font = self.labelFont    
        }
    }
    var label     = UILabel()
    
    //--------------------------------------------------------------------------
    @IBInspectable var textColor:UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }
    
    //--------------------------------------------------------------------------
    @IBInspectable var selectedTextColor:UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }

    //--------------------------------------------------------------------------
    @IBInspectable var text:String = "BUTTON" {
        didSet {
            self.label.text = text
        }
    }
    
    //--------------------------------------------------------------------------
    override func setupView() {
        super.setupView()
        
        self.label.font                  = self.labelFont
        self.label.textColor             = self.textColor
        self.label.highlightedTextColor  = self.selectedTextColor
        self.label.backgroundColor       = UIColor.clear
        self.label.textAlignment         = NSTextAlignment.center
    }
    
    //--------------------------------------------------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = CGRect(x: 0, y: 0,
            width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(self.label)
    }

}
