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
open class RAMPaperSwitch: UISwitch, CAAnimationDelegate {

    struct Constants {
        static let scale = "transform.scale"
        static let up    = "scaleUp"
        static let down  = "scaleDown"
    }

    ///  The total duration of the animations, measured in seconds. Default 0.35
    @IBInspectable open var duration: Double = 0.35

    /// Closuer call when animation start
    open var animationDidStartClosure = {(onAnimation: Bool) -> Void in }

    /// Closuer call when animation finish
    open var animationDidStopClosure  = {(onAnimation: Bool, finished: Bool) -> Void in }

    fileprivate var shape: CAShapeLayer! = CAShapeLayer()
    fileprivate var radius: CGFloat      = 0.0
    fileprivate var oldState             = false

    fileprivate var defaultTintColor: UIColor?
    @IBOutlet open var parentView: UIView? {
        didSet {
            defaultTintColor = parentView?.backgroundColor
        }
    }

    // MARK: - Initialization

    /**
     Returns an initialized switch object.

     - parameter view:  animatable view
     - parameter color: The color which fill view.

     - returns: An initialized UISwitch object.
     */
    public required init(view: UIView?, color: UIColor?) {
        super.init(frame: CGRect.zero)
        onTintColor = color
        self.commonInit(view)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        self.commonInit(parentView ?? superview)
        super.awakeFromNib()
    }

    // MARK: Helpers
    fileprivate func commonInit(_ parentView: UIView?) {
        guard let onTintColor = self.onTintColor else {
            fatalError("set tint color")
        }
        self.parentView = parentView
        defaultTintColor = parentView?.backgroundColor

        layer.borderWidth  = 0.5
        layer.borderColor  = UIColor.white.cgColor
        layer.cornerRadius = frame.size.height / 2

        shape.fillColor     = onTintColor.cgColor
        shape.masksToBounds = true

        parentView?.layer.insertSublayer(shape, at: 0)
        parentView?.layer.masksToBounds = true

        showShapeIfNeed()

        addTarget(self, action: #selector(RAMPaperSwitch.switchChanged), for: UIControlEvents.valueChanged)
    }

    override open func layoutSubviews() {
        let x:CGFloat = max(frame.midX, superview!.frame.size.width - frame.midX);
        let y:CGFloat = max(frame.midY, superview!.frame.size.height - frame.midY);
        radius = sqrt(x*x + y*y);

        shape.frame = CGRect(x: frame.midX - radius, y: frame.midY - radius, width: radius * 2, height: radius * 2)
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        shape.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)).cgPath
    }

    // MARK: - Public
    open override func setOn(_ on: Bool, animated: Bool) {
        let changed:Bool = on != self.isOn

        super.setOn(on, animated: animated)

        if changed {
            switchChangeWithAniation(animated)
        }
    }

    // MARK: - Private
    fileprivate func showShapeIfNeed() {
        shape.transform = isOn ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
    }

    internal func switchChanged() {
        switchChangeWithAniation(true)
    }

    // MARK: - Animations 
    fileprivate func animateKeyPath(_ keyPath: String, fromValue from: CGFloat?, toValue to: CGFloat, timing timingFunction: String) -> CABasicAnimation {

        let animation:CABasicAnimation = CABasicAnimation(keyPath: keyPath)

        animation.fromValue             = from
        animation.toValue               = to
        animation.repeatCount           = 1
        animation.timingFunction        = CAMediaTimingFunction(name: timingFunction)
        animation.isRemovedOnCompletion = false
        animation.fillMode              = kCAFillModeForwards
        animation.duration              = duration
        animation.delegate              = self

        return animation
    }

    fileprivate func switchChangeWithAniation(_ animation: Bool) {
        guard let onTintColor = self.onTintColor else {
            return
        }

        shape.fillColor = onTintColor.cgColor

        if isOn {
            let scaleAnimation:CABasicAnimation  = animateKeyPath(Constants.scale,
                                                                  fromValue: 0.01,
                                                                  toValue: 1.0,
                                                                  timing:kCAMediaTimingFunctionEaseIn);
            if animation == false { scaleAnimation.duration = 0.0001 }

            shape.add(scaleAnimation, forKey: Constants.up)
        } else {
            let scaleAnimation:CABasicAnimation  = animateKeyPath(Constants.scale,
                                                                  fromValue: 1.0,
                                                                  toValue: 0.01,
                                                                  timing:kCAMediaTimingFunctionEaseOut);
            if animation == false { scaleAnimation.duration = 0.0001 }

            shape.add(scaleAnimation, forKey: Constants.down)
        }
    }

    //MARK: - CAAnimation Delegate
    open func animationDidStart(_ anim: CAAnimation) {
        parentView?.backgroundColor = defaultTintColor
        animationDidStartClosure(isOn)
    }

    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            parentView?.backgroundColor = isOn == true ? onTintColor : defaultTintColor
        }

        animationDidStopClosure(isOn, flag)
    }
}
