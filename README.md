#RAMPaperSwitch
[![CocoaPods](https://img.shields.io/cocoapods/p/RAMPaperSwitch.svg)](https://cocoapods.org/pods/RAMPaperSwitch)
[![CocoaPods](https://img.shields.io/cocoapods/v/RAMPaperSwitch.svg)](http://cocoapods.org/pods/RAMPaperSwitch)
[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/paper-switch.svg)](https://travis-ci.org/Ramotion/paper-switch)

Swift subclass of the UISwitch which paints over the parent view with the `onTintColor` when the switch is turned on. Implemented concept from [this Dribbble](https://dribbble.com/shots/1749645-Contact-Sync) shot by [Ramotion](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch).


#Screenshot
![PaperSwitch](screenshot.gif)

The [iPhone mockup](https://store.ramotion.com/product/iphone-6-plus-mockups?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch) available [here](https://store.ramotion.com/product/iphone-6-plus-mockups?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch).


## Requirements

- iOS 8.0+
- Xcode 6.1


#Installation

Just add the `RAMPaperSwitch` folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'RAMPaperSwitch', '~> 0.0.1'
```


#Usage
RAMPaperSwitch is a drop-in replacement of UISwitch. You just need to set the `onTintColor` property of the switch, and it will automatically _paint over_ its superview with the selected color.
You have ability to set duration of animation instead of default value.

1. Create a new UISwitch in your storyboard or nib.

2. Set the class of the UISwitch to RAMPaperSwitch in your Storyboard or nib.

3. Set `onTintColor` for the switch

4. Set `duration` property programmatically if You want to change animation duration.

5. Add animation for other views near the switch if need.


#Animate views
You can animate other views near the switch. For example, you can change color to views or labels that are inside the same superview. Duration of animation can be gotten from the RAMPaperSwitch's property `duration`. You can animate CoreAnimation properties like this:

``` swift
self.paperSwitch.animationDidStartClosure = {(onAnimation: Bool) in
    UIView.transitionWithView(self.label, duration: self.paperSwitch.duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
        self.label.textColor = onAnimation ? UIColor.whiteColor() : UIColor.blueColor()
    }, completion:nil)
}
```

## About
The project maintained by [app development agency](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch) [Ramotion Inc.](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch)
See our other [open-source projects](https://github.com/ramotion) or [hire](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch) us to design, develop, and grow your product.

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/paper-switch)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)


	
