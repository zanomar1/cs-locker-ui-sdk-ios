//
//  NumberPadButtonZero.swift
//  CoreSDKTestApp
//
//  Created by František Kratochvíl on 27.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//
import UIKit
class NumberPadButtonZero: NumberPadButton {

    //--------------------------------------------------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numberLabel.frame = CGRect(x: 0, y: 0,
            width: self.frame.size.width, height: self.frame.size.height)
    }
}
