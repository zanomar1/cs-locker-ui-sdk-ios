//
//  LockerPasswordViewController.swift
//  CoreSDKTestApp
//
//  Created by Vladimír Nevyhoštěný on 10.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
public protocol PasswordDialogable
{
    func refreshPasswordDialog()
}

//==============================================================================
public enum PasswordDialogType: Int
{
    case inputPasswordOnly          = 0
    case inputOldPasswordOnly       = 1
    case inputPasswordAndVerifyThem = 2
}

//==============================================================================
class LockerPasswordViewController: LockerViewController, PasswordDialogable
{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    
    var dialogType: PasswordDialogType = PasswordDialogType.inputPasswordOnly
    var step: Int = 0
    var passwordLength: Int?
    var lastPassword: String?
    var newPassword: String?
    var remainingAttempts: Int?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.dialogType == PasswordDialogType.inputPasswordAndVerifyThem {
            self.backButton?.isHidden  = false
            self.backButton?.isEnabled = true
        }
        
        self.defaultAccessibilityView = self.infoLabel
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func refreshPasswordDialog() {}
    
}
