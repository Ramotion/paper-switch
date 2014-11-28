//
//  RAMPaperSwitch.swift
//  RAMPaperSwitch
//
//  Created by Ramotion on 20/11/14.
//  Copyright (c) 2014 Ramotion. All rights reserved.
//

import UIKit

class RAMPaperSwitch: UISwitch {
    
    @IBInspectable var duration: Double = 0.35
    
    var didAnimationStartClosure = {(onAnimation: Bool) -> Void in }
    var didAnimationStopClosure = {(onAnimation: Bool, finished: Bool) -> Void in }
    
    private var shape: CAShapeLayer! = CAShapeLayer()
    private var radius: CGFloat = 0.0
    
    
    override func setOn(on: Bool, animated: Bool) {
        let changed:Bool = on != self.on
        
        super.setOn(on, animated: animated)
        
        if changed {
            if animated {
                switchChanged()
            } else {
                showShapeIfNeed()
            }
        }
    }
    
    
    override func layoutSubviews() {
        let x:CGFloat = max(frame.midX, superview!.frame.size.width - frame.midX);
        let y:CGFloat = max(frame.midY, superview!.frame.size.height - frame.midY);
        radius = sqrt(x*x + y*y);
        
        shape.frame = CGRectMake(frame.midX - radius,  frame.midY - radius, radius * 2, radius * 2)
        shape.anchorPoint = CGPointMake(0.5, 0.5);
        shape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, radius * 2, radius * 2)).CGPath
    }


    override func awakeFromNib() {        
        var shapeColor:UIColor = (onTintColor != nil) ? onTintColor : UIColor.greenColor()
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.whiteColor().CGColor;
        layer.cornerRadius = frame.size.height / 2;
        
        shape.fillColor = shapeColor.CGColor
        shape.masksToBounds = true
        
        superview?.layer.insertSublayer(shape, atIndex: 0)
        superview?.layer.masksToBounds = true
        
        showShapeIfNeed()
        
        addTarget(self, action: "switchChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    private func showShapeIfNeed() {
        shape.transform = on ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
    }


    internal func switchChanged(){
        
        if on {
            CATransaction.begin()
            
            shape.removeAnimationForKey("scaleDown")
            
            var scaleAnimation:CABasicAnimation  = animateKeyPath("transform",
                fromValue: NSValue(CATransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                toValue:NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                timing:kCAMediaTimingFunctionEaseIn);
            
            shape.addAnimation(scaleAnimation, forKey: "scaleUp")
            
            CATransaction.commit();
        }
        else {
            CATransaction.begin()
            shape.removeAnimationForKey("scaleUp")
            
            var scaleAnimation:CABasicAnimation  = animateKeyPath("transform",
                fromValue: NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                toValue:NSValue(CATransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                timing:kCAMediaTimingFunctionEaseOut);
                
            shape.addAnimation(scaleAnimation, forKey: "scaleDown")
            
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
        animation.duration = duration;
        animation.delegate = self
        
        return animation;
    }
    
    
    //CAAnimation delegate
    
    
    override func animationDidStart(anim: CAAnimation!){
        didAnimationStartClosure(on)
    }
    
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool){
        didAnimationStopClosure(on, flag)
    }
}
