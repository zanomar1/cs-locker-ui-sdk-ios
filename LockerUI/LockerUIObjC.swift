//
//  LockerUIObjC.swift
//  CSLockerUI
//
//  Created by Michal Sverak on 11/6/17.
//  Copyright © 2017 Applifting. All rights reserved.
//
/*
 Here is a short list of Swift features that are not available in objective-c: tuples,
 generics, any global variables, structs, typealiases, or enums defined in swift,
 and the top-level swift functions.
 https://medium.com/ios-os-x-development/swift-and-objective-c-interoperability-2add8e6d6887
 */

import Foundation
import CSCoreSDK

public class LockerUIObjC: NSObject {
    
    public static var sharedInstance = LockerUIObjC()
    
    public func startAuthenticationFlow(SkipStatusScreen: SkipStatusScreen, registrationScreenText: String, lockedScreenText: String, completion: @escaping (LockerStatus) -> Void) {
        
        let options = AuthFlowOptions(skipStatusScreen: SkipStatusScreen,
                                      registrationScreenText: registrationScreenText,
                                      lockedScreenText: lockedScreenText)
        
        LockerUI.sharedInstance.startAuthenticationFlow(options: options) { status in
            
            completion(status)
        }
    }
    
    public func startAuthenticationFlow(_ completion: @escaping (LockerStatus) -> Void) {
        
        LockerUI.sharedInstance.startAuthenticationFlow(options: nil) { status in
            
            completion(status)
        }
    }
    
    public func setAuthFlowOptions(SkipStatusScreen: SkipStatusScreen, registrationScreenText: String, lockedScreenText: String) {
        LockerUI.sharedInstance.authFlowOptions = AuthFlowOptions(skipStatusScreen: SkipStatusScreen,
                                                                  registrationScreenText: registrationScreenText,
                                                                  lockedScreenText: lockedScreenText)
    }
    
    public func lockUser() {
        
        CoreSDK.sharedInstance.locker.lockUser()
    }
    
    public func displayInfo(promptText: String?, _ completion: @escaping () ->Void ) {
        
        var options: DisplayInfoOptions? = nil
        
        if let text = promptText {
            options = DisplayInfoOptions(unregisterPromptText: text)
        }
        
        LockerUI.sharedInstance.displayInfo(options: options) { status in
            
            completion()
        }
    }
    
    public let defaultNavBarTint = UIColor(red: 35.0/255.0, green: 74.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    public let darkNavBarTint = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
    public let whiteNavBar = UIColor.white
    public let defaultNavBar = UIColor(red: 202.0/255, green: 218.0/255, blue: 241.0/255, alpha: 1.0)
    
    public func lockerOptions(appName: String, backgroundImage: UIImage, customTint: UIColor, navBarColor: UIColor, navBarTint: UIColor) {
        
        var options = LockerUIOptions()
        
        options.appName = appName
        options.backgroundImage = backgroundImage
        options.customTint = customTint
        options.navBarColor = .custom(color: navBarColor)
        options.navBarTintColor = .custom(color: navBarTint)
        
        options.allowedLockTypes = [LockInfo(lockType: LockType.pinLock ), LockInfo(lockType: LockType.gestureLock), LockInfo(lockType: LockType.biometricLock), LockInfo(lockType: LockType.noLock)]
        
        _ = LockerUI.sharedInstance.useLockerUIOptions(options)
    }
    
    
}
