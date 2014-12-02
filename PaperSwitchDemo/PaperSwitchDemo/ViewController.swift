//  ViewController.swift
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

class ViewController: UIViewController {
    
    @IBOutlet weak private var connectContactsLabel: UILabel!
    @IBOutlet weak private var phone1ImageView: UIImageView!
    @IBOutlet weak private var paperSwitch1: RAMPaperSwitch!
    
    @IBOutlet weak private var allowDiscoveryLabel: UILabel!
    @IBOutlet weak private var phone2ImageView: UIImageView!
    @IBOutlet weak private var paperSwitch2: RAMPaperSwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupPaperSwitch()
        
        self.navigationController?.navigationBarHidden = true
    }
    
    
    private func setupPaperSwitch() {
        
        self.paperSwitch1.animationDidStartClosure = {(onAnimation: Bool) in
            
            self.animateLabel(self.connectContactsLabel, onAnimation: onAnimation, duration: self.paperSwitch1.duration)
            self.animateImageView(self.phone1ImageView, onAnimation: onAnimation, duration: self.paperSwitch1.duration)
        }
        
        
        self.paperSwitch2.animationDidStartClosure = {(onAnimation: Bool) in
            
            self.animateLabel(self.self.allowDiscoveryLabel, onAnimation: onAnimation, duration: self.paperSwitch2.duration)
            self.animateImageView(self.phone2ImageView, onAnimation: onAnimation, duration: self.paperSwitch2.duration)
        }
    }
    
    
    private func animateLabel(label: UILabel, onAnimation: Bool, duration: NSTimeInterval) {
        UIView.transitionWithView(label, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            label.textColor = onAnimation ? UIColor.whiteColor() : UIColor(red: 31/255.0, green: 183/255.0, blue: 252/255.0, alpha: 1)
            }, completion:nil)
    }
    
    
    private func animateImageView(imageView: UIImageView, onAnimation: Bool, duration: NSTimeInterval) {
        UIView.transitionWithView(imageView, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            imageView.image = UIImage(named: onAnimation ? "img_phone_on" : "img_phone_off")
            }, completion:nil)
    }
    
}

