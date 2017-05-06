//
//  LockerUI+ChangePassword.swift
//  CoreSDKTestApp
//
//  Created by Vladimír Nevyhoštěný on 14.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import Foundation
import CSCoreSDK


extension LockerUI
{
    public func changePasswordWithCompletion( _ completion: @escaping UIUnlockCompletion )
    {
        self.changePassword(animated: true, completion: completion)
    }
    
    public func changePassword(animated: Bool, completion: @escaping UIUnlockCompletion)
    {
        self.remainingAttempts = nil
        self.changePassword( animated: animated, remainingAttempts: nil, internalCompletion: completion )
    }
    
    fileprivate func changePassword( animated: Bool, remainingAttempts: Int?, showCancel:Bool = false, internalCompletion: @escaping UIUnlockCompletion )
    {
        let status = self.locker.status
        let lockType = status.lockType
        
        do {
            try self.checkLockType(lockType)
        }
        catch let error {
            if error is LockerError, (error as! LockerError).kind == .wrongLockType {
                clog(LockerUI.ModuleName, activityName: LockerUIActivities.ChangePassword.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.error, format: "LockType: \(lockType), error: \(error.localizedDescription) User will be unregistered." )
                self.unregisterUserWithCompletion(internalCompletion)
                return
            }
            else {
                assert(false, "An unexpected error \(error.localizedDescription)")
            }
        }
        
        if let passwordController = self.passwordControllerWithLockType( lockType ) {
            
            passwordController.lockerViewOptions = showCancel ? LockerViewOptions.showCancelButton.rawValue : LockerViewOptions.showBackButton.rawValue
            passwordController.dialogType = PasswordDialogType.inputOldPasswordOnly
            passwordController.step = 0
            passwordController.passwordLength = Int( self.passwordLengthWithLockType( lockType))
            passwordController.remainingAttempts = self.remainingAttempts
            passwordController.completion = { passwordInput in
                
                switch passwordInput {
                case .success( let password ):
                    self.showWaitViewWithMessage( "info-moment", detailMessage: "info-unlock-in-progress" )
                    self.locker.unlockUserWithPassword( password as? String, completion: { ( result: CoreResult<Bool>, remainingAttempts: Int?  ) in
                        switch result {
                        case .success:
                            self.remainingAttempts = nil
                            self.chooseNewLockTypeWithOldPassword( password as? String, completion: internalCompletion )
                            
                        case .failure( let error ):
                            if error is CoreSDKError {
                                if (error as! CoreSDKError ).kind == .operationCancelled {
                                    internalCompletion( LockerUIDialogBoolResult.cancel )
                                    return
                                }
                                if (error as! CoreSDKError ).isNetworkError {
                                    self.showAlertWithError( error, completion: {
                                        internalCompletion( LockerUIDialogBoolResult.cancel )
                                    })
                                    return
                                }
                            }
                            
                            let showStatusScreenWithLoginFailureAndUnregistrationInfo = {
                                let statusController = self.viewControllerWithName( LockerUI.StatusSceneName ) as! StatusViewController
                                
                                var options = StatusScreenOptions( iconName: "lock-broken", mainText: LockerUI.localized( "info-user-login-failed" ), actionCaption: LockerUI.localized( "btn-register" ) )
                                options.statusDescriptionText = LockerUI.localized( "info-user-login-failed-description" )
                                statusController.options = options
                                statusController.backgroundTint = self.mainColor
                                statusController.lockerViewOptions = self.authFlowOptions.hideCancelButton ? LockerViewOptions.showNoButton.rawValue : LockerViewOptions.showCancelButton.rawValue
                        
                                statusController.completion = { result in
                                    switch result {
                                    case .success:
                                        self.popToRootLockerUIController( animated: true, dismissCompletion: {
                                            self.registerUserWithCompletion({ (result: CoreResult<Bool>) in
                                                switch result {
                                                case .success(_):
                                                    internalCompletion( LockerUIDialogBoolResult.success(true) )
                                                case .failure( let error ):
                                                    internalCompletion( LockerUIDialogBoolResult.failure(error) )
                                                }
                                            })
                                        })
                                    default:
                                        self.popToRootLockerUIControllerWithCompletion( {
                                            internalCompletion( LockerUIDialogBoolResult.failure( LockerError.errorOfKind( .loginFailed, underlyingError: error ) ) )
                                        })
                                    }
                                }
                                self.pushLockerUIController( statusController )
                            }
                            
                            if let attemptsLeft = remainingAttempts {
                                self.remainingAttempts = attemptsLeft
                                if attemptsLeft > 0 {
                                    DispatchQueue.main.async {
                                        self.dismissWaitViewAnimated(true, dismissWaitCompletion: {
                                            passwordController.remainingAttempts = attemptsLeft
                                            passwordController.refreshPasswordDialog()
                                        })
                                    }
                                }
                                else {
                                    self.locker.unregisterUserWithCompletion( { result in
                                        showStatusScreenWithLoginFailureAndUnregistrationInfo()
                                    })
                                }
                            }
                            else {
                                self.remainingAttempts = nil
                                self.locker.unregisterUserWithCompletion( { result in
                                    showStatusScreenWithLoginFailureAndUnregistrationInfo()
                                })
                            }
                        }
                    })
                    
                case .backward:
                    self.popLockerUIController()
                    internalCompletion( LockerUIDialogBoolResult.backward )
                    
                case .cancel:
                    self.popToRootLockerUIControllerWithCompletion({
                        internalCompletion( LockerUIDialogBoolResult.cancel )
                    })
                case .failure( let nestedError ):
                    self.popToRootLockerUIControllerWithCompletion({
                        internalCompletion( LockerUIDialogBoolResult.failure( LockerError.errorOfKind(.loginFailed, underlyingError: nestedError ) ) )
                    })
                }
            }
            
            passwordController.backgroundTint = self.mainColor
            self.pushLockerUIController( passwordController, animated: animated )
            
        }
        else {
            // In case of LockType.NoAuth ...
            self.showWaitViewWithMessage( "info-moment", detailMessage: "info-unlock-in-progress" )
            self.locker.unlockUserWithPassword( nil, completion: { ( result: CoreResult<Bool>, remainingAttempts: Int?  ) in
                
                switch result {
                case .success:
                    self.chooseNewLockTypeWithOldPassword( nil, completion: internalCompletion )
                    
                case .failure( let error ):
                    if ( error is CoreSDKError ) {
                        if ( (error as! CoreSDKError).kind == .operationCancelled ) {
                            internalCompletion(LockerUIDialogBoolResult.cancel )
                            return
                        }
                        else if (error as! CoreSDKError).isNetworkError {
                            self.showAlertWithError( error, completion: {
                                internalCompletion(LockerUIDialogBoolResult.cancel )
                            })
                            return
                        }
                    }
                    
                    self.locker.unregisterUserWithCompletion({ result in
                        internalCompletion(LockerUIDialogBoolResult.failure( LockerError.errorOfKind(.loginFailed ) ) )
                    })
                    
                }
            })
        }
    }
    
    fileprivate func chooseNewLockTypeWithOldPassword( _ oldPassword: String?, completion: @escaping UIUnlockCompletion )
    {
        let inputTypeController = self.viewControllerWithName( LockerUI.InputTypeSceneName ) as! InputTypeViewController
        inputTypeController.lockerUIOptions = self.lockerUIOptions
        inputTypeController.lockerViewOptions = LockerViewOptions.showCancelButton.rawValue
        
        inputTypeController.completion = { result in
            let buttonAction = result
            
            switch buttonAction {
            case .success( let inputButtonTag as Int):
                let lockType = LockType( rawValue: inputButtonTag )!
                self.proceedWithNewLockType( lockType, oldPassword: oldPassword, completion: completion )
                
            case .backward:
                self.changePasswordWithCompletion( completion )
                
            case .cancel:
                completion(LockerUIDialogResult.cancel )
                
            default:
                self.popToRootLockerUIControllerWithCompletion(nil)
            }
        }
        inputTypeController.backgroundTint = self.mainColor
        
        self.pushLockerUIController( inputTypeController )
    }
    
    fileprivate func proceedWithNewLockType( _ newLockType: LockType, oldPassword: String?, completion: @escaping UIUnlockCompletion )
    {
        // Just sanity checking ...
        do {
            try self.checkLockType(newLockType)
        }
        catch let error {
            if error is LockerError, (error as! LockerError).kind == .wrongLockType {
                clog(LockerUI.ModuleName, activityName: LockerUIActivities.ChangePassword.rawValue, fileName: #file, functionName: #function, lineNumber: #line, logLevel: LogLevel.error, format: "NewLockType: \(newLockType), error: \(error.localizedDescription) User will be unregistered." )
                self.unregisterUserWithCompletion(completion)
                return
            }
            else {
                assert(false, "An unexpected error \(error.localizedDescription)")
            }
        }
        
        if let passwordController = self.passwordControllerWithLockType( newLockType ) {
            passwordController.lockerViewOptions = LockerViewOptions.showBackButton.rawValue
            passwordController.dialogType = PasswordDialogType.inputPasswordAndVerifyThem
            passwordController.passwordLength  = Int(self.passwordLengthWithLockType( newLockType))
            passwordController.step = 0
            
            passwordController.completion = { result in
                let passwordInput = result
                switch passwordInput {
                case .success( let newPassword as String ):
                    self.showWaitViewWithMessage( "info-moment", detailMessage: "info-password-change-in-progress" )
                    self.locker.changePassword( oldPassword: oldPassword, newLockType: newLockType, newPassword: newPassword, completion: { (result, remainingAttempts) -> () in
                        var dialogResult: LockerUIDialogBoolResult?
                        switch result {
                        case .success:
                            dialogResult         = LockerUIDialogBoolResult.success( true )
                            
                        case .failure( let error ):
                            if ( error is CoreSDKError ) {
                                if ( (error as! CoreSDKError).kind == .operationCancelled ) {
                                    completion( LockerUIDialogBoolResult.cancel )
                                    return
                                }
                            }
                            
                            if let attemptsLeft = remainingAttempts {
                                self.changePassword( animated: true, remainingAttempts: attemptsLeft, showCancel: true, internalCompletion: completion )
                            }
                            else {
                                self.remainingAttempts = nil
                                if ( self.handlePossibleUnlockNetworkError( error, completion: completion ) ) {
                                    return
                                }
                                dialogResult = LockerUIDialogBoolResult.failure( error )
                            }
                        }
                        
                        if let passwordDialogResult = dialogResult {
                            self.popToRootLockerUIControllerWithCompletion({
                                completion( passwordDialogResult )
                            })
                        }
                    })
                case .backward:
                    self.popLockerUIController()
                    
                case .cancel:
                    self.popToRootLockerUIControllerWithCompletion({
                        completion( LockerUIDialogBoolResult.cancel )
                    })
                case .failure( let error ):
                    self.showAlertWithError( error, completion: {
                        self.popToRootLockerUIControllerWithCompletion({
                            completion( LockerUIDialogBoolResult.failure( LockerError.errorOfKind( .passwordChangeFailed ) ) )
                        })
                    })
                default:
                    self.popToRootLockerUIControllerWithCompletion(nil)
                }
            }
            passwordController.backgroundTint = self.mainColor
            
            self.pushLockerUIController( passwordController )
            
        }
        else {
            self.showWaitViewWithMessage( "info-moment", detailMessage: "info-password-change-in-progress" )
            self.locker.changePassword( oldPassword: oldPassword, newLockType: newLockType, newPassword: "", completion: { (result, remainingAttempts) -> () in
                var dialogResult: LockerUIDialogBoolResult?
                
                switch result {
                case .success:
                    dialogResult         = LockerUIDialogBoolResult.success( true )
                    
                case .failure( let error ):
                    if ( error is CoreSDKError ) {
                        if ( ( error as! CoreSDKError ).kind == .operationCancelled ) {
                            completion( LockerUIDialogBoolResult.cancel )
                            return
                        }
                    }
                    
                    if let attemptsLeft = remainingAttempts {
                        self.changePassword( animated: true, remainingAttempts: attemptsLeft, showCancel: true, internalCompletion: completion )
                        
                    }
                    else {
                        self.remainingAttempts = nil
                        dialogResult = LockerUIDialogBoolResult.failure( error )
                    }
                }
                
                if let passwordDialogResult = dialogResult {
                    self.popToRootLockerUIControllerWithCompletion({
                        completion( passwordDialogResult )
                    })
                }
            })
        }
    }
    
}
