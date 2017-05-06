//
//  WebSessionTimer.swift
//  CSLockerUI
//
//  Created by Marty on 11/04/16.
//  Copyright © 2016 Applifting. All rights reserved.
//

import Foundation
import CSCoreSDK


class WebSessionTimer
{
    var timer:Timer?
    let timeOutTime = 5*60.0
    
    var completion : RegistrationCompletion?
    
    
    init( completion : @escaping RegistrationCompletion)
    {
        self.completion = completion
        self.timer      = Timer.scheduledTimer(timeInterval: timeOutTime, target: self, selector: #selector(loginTimeOut), userInfo: nil, repeats: false)
    }
    
    deinit
    {
        self.cancel()
    }

    
    func cancel()
    {
        if self.timer != nil && self.timer!.isValid{
            self.timer?.invalidate()
        }
        self.timer = nil
        self.completion = nil
    }
    
    @objc func loginTimeOut()
    {
        if let completion = self.completion {
            completion( .failure(LockerError.errorOfKind( .loginTimeOut)))
        }
        self.cancel()
    }
    
}
