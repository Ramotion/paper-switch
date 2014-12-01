//
//  ViewController.swift
//  PaperSwitchDemo
//
//  Created by Ramotion on 26/11/14.
//  Copyright (c) 2014 Ramotion. All rights reserved.
//

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

