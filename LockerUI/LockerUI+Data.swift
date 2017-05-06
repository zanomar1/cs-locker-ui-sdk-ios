//
//  LockerUI+Data.swift
//  CoreSDKTestApp
//
//  Created by Vladimír Nevyhoštěný on 16.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import Foundation

//==============================================================================
public class LockerUIOAuth2Info
{
    public var code: String?
    public var completion : UIUnlockCompletion?
    
    required convenience public init( code: String, completion: @escaping UIUnlockCompletion )
    {
        self.init()
        self.code = code
        self.completion = completion
    }
    
    convenience public init( completion: @escaping UIUnlockCompletion )
    {
        self.init()
        self.completion = completion
    }
    
}
