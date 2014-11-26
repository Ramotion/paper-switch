//
//  RAContactSyncSwitch.swift
//  ContactSyncSwitchDemo
//
//  Created by Oleg Oleynichenko on 20/11/14.
//  Copyright (c) 2014 Oleg Oleynichenko. All rights reserved.
//

import UIKit

class RAMViralSwitch: UISwitch {
    
    var didAnimationStartClosure = {(onAnimation: Bool) -> Void in }
    var didAnimationStopClosure = {(onAnimation: Bool, finished: Bool) -> Void in }
    
    var duration: CFTimeInterval = 0.35
    
    
    private var shape: CAShapeLayer! = CAShapeLayer()
    private var radius: CGFloat = 0.0
    
    
    override func setOn(on: Bool, animated: Bool) {
        var changed:Bool = on != self.on
        
        super.setOn(on, animated: animated)
        
        if changed {
            if animated {
                self.switchChanged(self)
            } else {
                self.showShape(on)
            }
        }
    }
    
    
    override func layoutSubviews() {
        let x:CGFloat = max(CGRectGetMidX(self.frame), self.superview!.frame.size.width - CGRectGetMidX(self.frame));
        let y:CGFloat = max(CGRectGetMidY(self.frame), self.superview!.frame.size.height - CGRectGetMidY(self.frame));
        self.radius = sqrt(x*x + y*y);
        
        self.shape.frame = CGRectMake(CGRectGetMidX(self.frame) - self.radius,  CGRectGetMidY(self.frame) - self.radius, self.radius * 2, self.radius * 2)
        self.shape.anchorPoint = CGPointMake(0.5, 0.5);
        self.shape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, self.radius * 2, self.radius * 2)).CGPath
    }


    override func awakeFromNib() {        
        var onTintColor:UIColor? = self.onTintColor
        if onTintColor == nil {
            onTintColor = UIColor.greenColor()
        }
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.whiteColor().CGColor;
        self.layer.cornerRadius = self.frame.size.height / 2;
        
        self.shape.fillColor = onTintColor?.CGColor
        self.shape.masksToBounds = true
        
        self.superview?.layer.insertSublayer(self.shape, atIndex: 0)
        self.superview?.layer.masksToBounds = true
        
        self.showShape(self.on)
        
        self.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    private func showShape(show: Bool) {
        self.shape.transform = show ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
    }


    internal func switchChanged(sender: UISwitch){
        
        if sender.on {
            CATransaction.begin()
            
            self.shape.removeAnimationForKey("scaleDown")
            
            var scaleAnimation:CABasicAnimation  = self.animateKeyPath("transform",
                fromValue: NSValue(CATransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                toValue:NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                timing:kCAMediaTimingFunctionEaseIn);
            
            self.shape.addAnimation(scaleAnimation, forKey: "scaleUp")
            
            CATransaction.commit();
        }
        else {
            CATransaction.begin()
            self.shape.removeAnimationForKey("scaleUp")
            
            var scaleAnimation:CABasicAnimation  = self.animateKeyPath("transform",
                fromValue: NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                toValue:NSValue(CATransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                timing:kCAMediaTimingFunctionEaseOut);
                
            self.shape.addAnimation(scaleAnimation, forKey: "scaleDown")
            
            CATransaction.commit();
        }
    }
    
    
    private func animateKeyPath(keyPath: String, fromValue from: AnyObject, toValue to: AnyObject, timing timingFunction: String) -> CABasicAnimation {
    
        let animation:CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        
        animation.fromValue = from
        animation.toValue = to
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = self.duration;
        animation.delegate = self
        
        return animation;
    }
    
    
    //CAAnimation delegate
    
    
    override func animationDidStart(anim: CAAnimation!){
        self.didAnimationStartClosure(self.on)
    }
    
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool){
        self.didAnimationStopClosure(self.on, flag)
    }
}
