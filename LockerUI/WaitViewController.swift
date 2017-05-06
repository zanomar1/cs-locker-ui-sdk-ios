//
//  WaitViewController.swift
//  CoreSDKTestApp
//
//  Created by Vladimír Nevyhoštěný on 10.11.15.
//  Copyright © 2015 Applifting. All rights reserved.
//

import UIKit

//==============================================================================
class WaitViewController: LockerViewController
{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailLabel: UILabel!
    
    
    @IBOutlet weak var spinerBaseView: UIView!
    @IBOutlet weak var spinnerBaseViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinnerBaseViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var spinnerOverlay : UIImageView!
    @IBOutlet weak var spinnerView: LockerImageView!
    @IBOutlet weak var spinnerBackgroundView: LockerImageView!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarLogoImage: UIImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var spinnerVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var spinnerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoTopConstraint: NSLayoutConstraint!
    
    var message: String?
    var messageDetail: String?
    var navBarColor: UIColor?
    
    let animationsValues: [Int]           = [80, 20, 40, 5, 75, -20, 5, -50, 98, 30, -15, 0]
    let portraitToBarViewHeight: CGFloat  = 64.0
    let landscapeToBarViewHeight: CGFloat = 52.0
    
    //--------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.lockerViewOptions = LockerViewOptions.showNoButton.rawValue
        self.infoLabel.text = ( self.message ?? nil )
        self.infoDetailLabel.text = ( self.messageDetail ?? nil )
        self.topBarView.backgroundColor = self.navBarColor

        self.spinnerOverlay.image = self.imageNamed("safelock-overlay")
        self.spinnerView.image = self.imageNamed("safelock-spinner")
        self.spinnerBackgroundView.image = self.imageNamed("safelock-background")
        
        
        if let tint = self.backgroundTint {
            self.spinnerView.tint = tint
            self.spinnerBackgroundView.tint = tint
        }
        
        if ( UIDevice.current.isSmallDevice ) {
            let smallDeviceRatio: CGFloat                  = 0.7
            self.spinnerBaseViewWidthConstraint.constant  *= smallDeviceRatio
            self.spinnerBaseViewHeightConstraint.constant *= smallDeviceRatio
        }
        
        self.startAnimation()
        
        self.defaultAccessibilityView = self.infoLabel
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.updateConstraintsWithScreenSize()
    }
    
    //--------------------------------------------------------------------------
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraintsWithScreenSize()
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //--------------------------------------------------------------------------
    func updateConstraintsWithScreenSize()
    {
        let isLandscape = UIDevice.current.isLandscape
        
        if ( isLandscape && UIDevice.current.isPhone ) {
            self.topBarViewHeightConstraint.constant = self.landscapeToBarViewHeight
            self.logoTopConstraint.constant          = 24.0
            
            if ( self.shouldShowTitleLogo ) {
                self.topBarLogoImage.image = self.imageNamed("logo-csas-landscape")
            }else{
                self.topBarLogoImage.image = nil
            }
            
            if ( UIDevice.current.isSmallDevice ) {
                self.spinnerVerticalCenterConstraint.isActive = true
                //self.spinnerTopConstraint.constant          = 0.0
                self.infoTopConstraint.constant             = MinConstraint
                self.detailTopConstraint.constant           = 2.0
            }
            else {
                self.spinnerTopConstraint.isActive            = false
                self.infoTopConstraint.constant             = 2.0 * MinConstraint
                self.detailTopConstraint.constant           = MinConstraint
            }
            
        }
        else {
            self.topBarViewHeightConstraint.constant    = self.portraitToBarViewHeight
            self.logoTopConstraint.constant             = 26.0
            
            if ( self.shouldShowTitleLogo ) {
                self.topBarLogoImage.image = self.imageNamed("logo-csas")
            }else{
                self.topBarLogoImage.image = nil
            }
            self.spinnerTopConstraint.isActive            = false
            self.spinnerVerticalCenterConstraint.isActive = true
            self.infoTopConstraint.constant             = 2.0 * MinConstraint
            self.detailTopConstraint.constant           = MinConstraint
        }
    }

    
    //MARK: - animation
    func startAnimation() {
        self.spinnerView.layer.add(self.createAnimations(), forKey: nil)
    }
    
    func createAnimations() -> CAAnimationGroup
    {
        var animations: [CAAnimation]  = Array()
        var totalTime: CFTimeInterval = 0
        var fromAngle: CGFloat = 0
        
        for value in self.animationsValues {
            let angle = (CGFloat(value) / 100.0) * 2 * CGFloat(Double.pi)
            let duration = 0.5 + CFTimeInterval(abs(fromAngle - angle) / 4)
            let anim = self.createRotateAnimation(totalTime, duration: duration, fromAngle: fromAngle, toAngle: angle)
            totalTime += duration
            fromAngle = angle
            animations.append(anim)
        }
        
        let group = CAAnimationGroup()
        group.animations  = animations
        group.repeatCount = HUGE
        group.duration = totalTime
        
        return group
    }
    
    func createRotateAnimation(_ start: CFTimeInterval, duration: CFTimeInterval, fromAngle:CGFloat, toAngle:CGFloat) -> CAAnimation
    {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = fromAngle
        rotateAnimation.toValue = toAngle
        rotateAnimation.duration = duration
        rotateAnimation.beginTime = start
        
        rotateAnimation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.25, 0.2, 0.43, 0.95)
        return rotateAnimation
    }
}
