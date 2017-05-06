//
//  FingerprintViewController.swift
//  CoreSDKTestApp
//
//  Created by František Kratochvíl on 09.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit
import Security
import LocalAuthentication
import CSCoreSDK

//==============================================================================
class FingerprintViewController: LockerPasswordViewController
{
    @IBOutlet weak var statusIcon: LockerImageView!
    
    var forceAskForTouch: Bool!
    var prompt: String?


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.forceAskForTouch = true
        self.prompt = LockerUI.localized( "info-input-unlock-fingerprint" )
        self.statusIcon.image = self.imageNamed("icons-finger-ok")
        if let tint = self.backgroundTint {
            self.statusIcon.tint = tint
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear( animated )
        self.updateConstraintsWithScreenSize(self.view.frame.size, sizeIncludesNavigationBar: true)
        if self.forceAskForTouch! {
            DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + Double(Int64( 0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.askUserForTouchIdWithPrompt( self.prompt! )
            })
        }
    }
    
    //--------------------------------------------------------------------------
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraintsWithScreenSize(self.view.frame.size, sizeIncludesNavigationBar: false)
            }, completion: nil)
    }
    
    //--------------------------------------------------------------------------
    func updateConstraintsWithScreenSize( _ screenSize: CGSize, sizeIncludesNavigationBar: Bool )
    {
        let isLandscape = UIDevice.current.isLandscape
        
        if ( self.shouldShowTitleLogo ) {
            if ( isLandscape && UIDevice.current.isPhone ) {
                self.navigationItem.titleView                = UIImageView(image: self.imageNamed("logo-csas-landscape") )
            }
            else {
                self.navigationItem.titleView                = UIImageView(image: self.imageNamed("logo-csas") )
            }
        }
    }
    
    //MARK: -
    func askUserForTouchIdWithPrompt( _ prompt: String )
    {
        let context = LAContext()
        var error: NSError? = nil
        
        if !context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            let touchIdError = LockerError.errorOfKind( .touchIDNotAvailable, underlyingError: error)
            clog(LockerUI.ModuleName, activityName: LockerUIActivities.TouchID.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.error, format: "Error while asking for TouchID: \(touchIdError)" )
            self.completion!( LockerUIDialogResult.failure(touchIdError) )
            return
        }
        
        context.localizedFallbackTitle = ""
        context.evaluatePolicy( LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                localizedReason:prompt,
                                reply:{( success: Bool, error: Error? ) in
            if success {
                clog(LockerUI.ModuleName, activityName: LockerUIActivities.TouchID.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.debug, format: "TouchID authentication succeded." )
                if #available(iOS 9.0, *) {
                    // TouchID hash is not saved here. It's more safe.
                    if let domainState = context.evaluatedPolicyDomainState {
                        if let unlockHash = String( data: domainState, encoding: String.Encoding.ascii ) {
                            self.completion!( LockerUIDialogResult.success(unlockHash as AnyObject))
                        }
                        else {
                            self.completion!( LockerUIDialogResult.failure(LockerError.errorOfKind( .loginFailed )))
                        }
                    }
                    else {
                        self.completion!( LockerUIDialogResult.failure(LockerError.errorOfKind( .loginFailed )))
                    }
                }
                else {
                    // For iOS 8.x
                    
                    let locker = CoreSDK.sharedInstance.locker as! Locker
                    if let unlockHash = locker.touchIdToken {
                        self.completion!( LockerUIDialogResult.success(unlockHash as AnyObject))
                    }
                    else {
                        let unlockHash      = UUID().uuidString
                        locker.touchIdToken = unlockHash
                        self.completion!( LockerUIDialogResult.success(unlockHash as AnyObject))
                    }
                }
            }
            else {
                if let touchIDError = error {
                    clog(LockerUI.ModuleName, activityName: LockerUIActivities.TouchID.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.error, format: "TouchID failed with error: \(touchIDError.localizedDescription)." )
                }
                else {
                    clog(LockerUI.ModuleName, activityName: LockerUIActivities.TouchID.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.error, format: "TouchID cancelled." )
                }
                self.completion!( LockerUIDialogResult.failure(LockerError.errorOfKind(.loginCanceled )))
            }
            self.forceAskForTouch = false
        })
    }
    
    override func refreshPasswordDialog() {}
}
