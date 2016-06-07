//  RAMPaperSwitch.swift
//
// Copyright (c) 26/11/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/// Swift subclass of the UISwitch which paints over the parent view with the onTintColor when the switch is turned on.
public class RAMPaperSwitch: UISwitch {
  
  struct Constants {
    
    static let scale = "transform.scale"
    static let up    = "scaleUp"
    static let down  = "scaleDown"
  }
  
  ///  The total duration of the animations, measured in seconds. Default 0.35
  @IBInspectable public var duration: Double = 0.35
  
  /// Closuer call when animation start
  public var animationDidStartClosure = {(onAnimation: Bool) -> Void in }
  
  /// Closuer call when animation finish
  public var animationDidStopClosure  = {(onAnimation: Bool, finished: Bool) -> Void in }
  
  private var shape: CAShapeLayer! = CAShapeLayer()
  private var radius: CGFloat      = 0.0
  private var oldState             = false

  private var defaultTintColor: UIColor?
  private var parentView: UIView?
  
  // MARK: - Initialization
  
  /**
   Returns an initialized switch object.
   
   - parameter view:  animatable view
   - parameter color: The color which fill view.
   
   - returns: An initialized UISwitch object.
   */
  public required init(view: UIView?, color: UIColor?) {
    super.init(frame: CGRectZero)
    onTintColor = color
    self.commonInit(view)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func awakeFromNib() {
    self.commonInit(superview)
    super.awakeFromNib()
  }
}

// MARK: public

public extension RAMPaperSwitch {
  
  override public func setOn(on: Bool, animated: Bool) {
    let changed:Bool = on != self.on
    
    super.setOn(on, animated: animated)
    
    if changed {
      switchChangeWithAniatiom(animated)
    }
  }
}

// MARK: Helpers 

extension RAMPaperSwitch {
  
  private func commonInit(parentView: UIView?) {
    guard let onTintColor = self.onTintColor else {
      fatalError("set tint color")
    }
    self.parentView = parentView
    self.defaultTintColor = parentView?.backgroundColor
    
    layer.borderWidth  = 0.5
    layer.borderColor  = UIColor.whiteColor().CGColor;
    layer.cornerRadius = frame.size.height / 2;

    shape.fillColor     = onTintColor.CGColor
    shape.masksToBounds = true

    parentView?.layer.insertSublayer(shape, atIndex: 0)
    parentView?.layer.masksToBounds = true
    
    showShapeIfNeed()
    
    addTarget(self, action: #selector(RAMPaperSwitch.switchChanged), forControlEvents: UIControlEvents.ValueChanged)
  }
  
  
  override public func layoutSubviews() {
    let x:CGFloat = max(frame.midX, superview!.frame.size.width - frame.midX);
    let y:CGFloat = max(frame.midY, superview!.frame.size.height - frame.midY);
    radius = sqrt(x*x + y*y);
    
    shape.frame = CGRectMake(frame.midX - radius,  frame.midY - radius, radius * 2, radius * 2)
    shape.anchorPoint = CGPointMake(0.5, 0.5);
    shape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, radius * 2, radius * 2)).CGPath
  }
  
  // MARK: - Private
  
  private func showShapeIfNeed() {
    shape.transform = on ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
  }
  
  internal func switchChanged() {
    switchChangeWithAniatiom(true)
  }
}

// MARK: animations

extension RAMPaperSwitch {
  
  private func animateKeyPath(keyPath: String, fromValue from: CGFloat?, toValue to: CGFloat, timing timingFunction: String) -> CABasicAnimation {
    
    let animation:CABasicAnimation = CABasicAnimation(keyPath: keyPath)
    
    animation.fromValue           = from
    animation.toValue             = to
    animation.repeatCount         = 1
    animation.timingFunction      = CAMediaTimingFunction(name: timingFunction)
    animation.removedOnCompletion = false
    animation.fillMode            = kCAFillModeForwards
    animation.duration            = duration;
    animation.delegate            = self
    
    return animation;
  }
  
  private func switchChangeWithAniatiom(animation: Bool) {
    guard let onTintColor = self.onTintColor else {
      return
    }
    
    shape.fillColor = onTintColor.CGColor
    
    if on {
      let scaleAnimation:CABasicAnimation  = animateKeyPath(Constants.scale,
                                                            fromValue: 0.01,
                                                            toValue: 1.0,
                                                            timing:kCAMediaTimingFunctionEaseIn);
      if animation == false { scaleAnimation.duration = 0.0001 }
      
      shape.addAnimation(scaleAnimation, forKey: Constants.up)
    }
    else {
      let scaleAnimation:CABasicAnimation  = animateKeyPath(Constants.scale,
                                                            fromValue: 1.0,
                                                            toValue: 0.01,
                                                            timing:kCAMediaTimingFunctionEaseOut);
      if animation == false { scaleAnimation.duration = 0.0001 }
      
      shape.addAnimation(scaleAnimation, forKey: Constants.down)
    }
  }

  //MARK: - CAAnimation Delegate
  
  override public func animationDidStart(anim: CAAnimation){
    parentView?.backgroundColor = defaultTintColor
    
    animationDidStartClosure(on)
  }
  
  override public func animationDidStop(anim: CAAnimation, finished flag: Bool){
    print(flag)
    if flag == true {
      parentView?.backgroundColor = on == true ? onTintColor : defaultTintColor
    }
    animationDidStopClosure(on, flag)
  }
}
