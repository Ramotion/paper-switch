<img src="https://github.com/Ramotion/folding-cell/blob/master/header.png">

<a href="https://github.com/Ramotion/folding-cell">
<img align="left" src="https://github.com/Ramotion/paper-switch/blob/master/paper-switch.gif" width="480" height="360" /></a>

<p><h1 align="left">PAPER SWITCH</h1></p>

<h4>A Swift material design UI module which paints over the parent view when the switch is on.</h4>


___



<p><h6>We specialize in the designing and coding of custom UI for Mobile Apps and Websites.</h6>
<a href="https://dev.ramotion.com?utm_source=gthb&utm_medium=repo&utm_campaign=paper-switch">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
</p>
<p><h6>Stay tuned for the latest updates:</h6>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a></p>
<h6><a href="https://store.ramotion.com/product/iphone-x-clay-mockups?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch#demo">Get Free Mockup For your project →</a></h6>

</br>

[![CocoaPods](https://img.shields.io/cocoapods/p/RAMPaperSwitch.svg)](https://cocoapods.org/pods/RAMPaperSwitch)
[![CocoaPods](https://img.shields.io/cocoapods/v/RAMPaperSwitch.svg)](http://cocoapods.org/pods/RAMPaperSwitch)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/RAMPaperSwitch.svg)](https://cdn.rawgit.com/Ramotion/paper-switch/master/docs/index.html)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/paper-switch)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/paper-switch.svg)](https://travis-ci.org/Ramotion/paper-switch)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)

## Requirements

- iOS 8.0+
- Xcode 9.0+

# Installation

Just add the `RAMPaperSwitch` folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'RAMPaperSwitch' 
```
or [Carthage](https://github.com/Carthage/Carthage) users can simply add to their `Cartfile`:
```
github "Ramotion/paper-switch"
```


# Usage
RAMPaperSwitch is a drop-in replacement of UISwitch. You just need to set the `onTintColor` property of the switch, and it will automatically _paint over_ its superview with the selected color.
You have ability to set duration of animation instead of default value.

1. Create a new UISwitch in your storyboard or nib.

2. Set the class of the UISwitch to RAMPaperSwitch in your Storyboard or nib.

3. Set `onTintColor` for the switch

4. Set `duration` property programmatically if You want to change animation duration.

5. Add animation for other views near the switch if need.


# Animate views
You can animate other views near the switch. For example, you can change color to views or labels that are inside the same superview. Duration of animation can be gotten from the RAMPaperSwitch's property `duration`. You can animate CoreAnimation properties like this:

``` swift
self.paperSwitch.animationDidStartClosure = {(onAnimation: Bool) in
    UIView.transitionWithView(self.label, duration: self.paperSwitch.duration, options: UIView.AnimationOptions.TransitionCrossDissolve, animations: {
        self.label.textColor = onAnimation ? UIColor.whiteColor() : UIColor.blueColor()
    }, completion:nil)
}
```

<br>

## 📄 License

Paper Switch is released under the MIT license.
See [LICENSE](./LICENSE) for details.

This library is a part of a <a href="https://github.com/Ramotion/swift-ui-animation-components-and-libraries"><b>selection of our best UI open-source projects.</b></a>

If you use the open-source library in your project, please make sure to credit and backlink to www.ramotion.com

## 📱 Get the Showroom App for iOS to give it a try
Try this UI component and more like this in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=folding-cell&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>

<a href="https://dev.ramotion.com?utm_source=gthb&utm_medium=repo&utm_campaign=folding-cell">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>
<br>
