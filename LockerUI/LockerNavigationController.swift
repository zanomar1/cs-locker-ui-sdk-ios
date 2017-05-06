//
//  LockerNavigationController.swift
//  CSLockerUI
//
//  Created by Marty on 26/02/16.
//  Copyright © 2016 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
class LockerNavigationController: UINavigationController
{
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.all
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupNavBar(CSNavBarColor.default)
    }
    
    override var shouldAutorotate : Bool
    {
        return true
    }

    func setupNavBar(_ navBarColor:CSNavBarColor)
    {
        self.navigationBar.barTintColor = navBarColor.color
        self.navigationBar.isTranslucent = false
    }

}
