//
//  NumberPadButton.swift
//  CoreSDKTestApp
//
//  Created by František Kratochvíl on 27.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//
import UIKit
class NumberPadButton: PadButton {

    static var NumberOffset:  CGFloat = 6.0
    static var LettersOffset: CGFloat = 28.0

    var numberLabel             = UILabel()
    var lettersLabel            = UILabel()

    //--------------------------------------------------------------------------
    var numberLabelFont:UIFont = UIFont(name: "AvenirNext-Medium", size: 32)! {
        didSet {
            setupView()
        }
    }

    //--------------------------------------------------------------------------
    var lettersLabelFont:UIFont = UIFont(name: "AvenirNext-Regular", size: 14)! {
        didSet {
            setupView()
        }
    }

    //--------------------------------------------------------------------------
    @IBInspectable var number:Int = 1 {
        didSet {
            self.tag              = number
            self.numberLabel.text = "\(number)"
        }
    }
    
    //--------------------------------------------------------------------------
    @IBInspectable var letters:String = "ABC" {
        didSet {
            self.lettersLabel.text = letters
        }
    }
    
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
    convenience init(frame: CGRect, number: Int) {
        self.init(frame: frame)
        self.number = number
        setupView()
    }

    //--------------------------------------------------------------------------
    override func setupView()
    {
        super.setupView()
        
        self.numberLabel.font                   = numberLabelFont
        self.numberLabel.textColor              = self.textColor
        self.numberLabel.highlightedTextColor   = self.selectedTextColor
        self.numberLabel.backgroundColor        = UIColor.clear
        self.numberLabel.textAlignment          = NSTextAlignment.center
        
        self.lettersLabel.font                  = lettersLabelFont
        self.lettersLabel.textColor             = self.textColor
        self.lettersLabel.highlightedTextColor  = self.selectedTextColor
        self.lettersLabel.backgroundColor       = UIColor.clear
        self.lettersLabel.textAlignment         = NSTextAlignment.center
        
        self.setNeedsLayout()
    }
    
    //--------------------------------------------------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numberLabel.frame = CGRect(x: 0, y: -type(of: self).NumberOffset,
            width: self.frame.size.width, height: self.frame.size.height - type(of: self).NumberOffset)
        self.lettersLabel.frame = CGRect(x: 0, y: type(of: self).LettersOffset,
            width: self.frame.size.width, height: self.frame.size.height - type(of: self).LettersOffset)
        self.addSubview(self.numberLabel)
        self.addSubview(self.lettersLabel)
    }

    //--------------------------------------------------------------------------
    override var isHighlighted: Bool {
        didSet {
            self.numberLabel.isHighlighted  = isHighlighted
            self.lettersLabel.isHighlighted = isHighlighted
        }
    }
}
