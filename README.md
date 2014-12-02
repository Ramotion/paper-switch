#RAMPaperSwitch

Swift subclass of the UISwitch which paints over the parent view with the `onTintColor` when the switch is turned on. Implemented concept from [this Dribbble](https://dribbble.com/shots/1749645-Contact-Sync) shot by [Ramotion](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch).


#Screenshot
![PaperSwitch](screenshot.gif)


## Requirements

- iOS 8.0+
- Xcode 6.1


#Installation

Just add the `RAMPaperSwitch` folder to your project.


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

## [Ramotion](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch)

[Ramotion](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=paper-switch) is an iPhone app design and development company. We are ready for new interesting iOS app development projects.

Follow us on [Twitter](http://twitter.com/ramotion).
	
