//
//  RAMPaperUISwitch.m
//
//  Translated by lookaji on 06/02/15.
//  Originally:
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

@import CoreGraphics;
@import QuartzCore;

#import "RAMPaperUISwitch.h"

@interface RAMPaperUISwitch()

@property(nonatomic,assign) double duration;
@property(nonatomic,strong) CAShapeLayer* shape;
@property(nonatomic,assign) CGFloat radius;
@property(nonatomic,assign) BOOL oldState;

@end

@implementation RAMPaperUISwitch
@synthesize on;

-(instancetype)init
{
    if (self)
        return self;
    self = [super init];
    if (self)
    {
        self.animationDidStartClosure = nil;
        self.animationDidStopClosure = nil;
    
        return self;
    }
    return nil;
}

-(void)awakeFromNib
{
    [self setup];

    [super awakeFromNib];
}

-(void)setup
{
    self.shape = [CAShapeLayer layer];
    self.radius = 0.0;
    self.oldState = NO;
    
    //on = NO;
    UIColor *shapeColor = (self.onTintColor != nil) ? self.onTintColor : [UIColor greenColor];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = self.frame.size.height / 2;
    
    self.shape.fillColor = shapeColor.CGColor;
    self.shape.masksToBounds = YES;
    
    [self.superview.layer insertSublayer:self.shape atIndex:0];
    self.superview.layer.masksToBounds = YES;
    
    [self showShapeIfNeed];
    
    [self addTarget:self
             action:@selector(switchChanged)
   forControlEvents:UIControlEventValueChanged];
}

- (void)setOn:(BOOL)newOn
{
    [self setOn:newOn animated:NO];
}


-(void)setOn:(BOOL)newOn animated:(BOOL)animated
{
    BOOL changed = (newOn != self.isOn);
    on = newOn;
    
    if (changed)
    {
        if (animated)
            [self switchChanged];
        else
            [self showShapeIfNeed];
    }
}

#pragma mark Interaction

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setOn:!self.isOn animated:YES];
}

-(void)layoutSubviews
{
    CGFloat midX = CGRectGetMidX(self.frame);
    CGFloat x = MAX(midX, self.superview.frame.size.width - midX);
    CGFloat midY = CGRectGetMidY(self.frame);
    CGFloat y = MAX(midY, self.superview.frame.size.height - midY);
    double radius = sqrt(x*x + y*y);
    
    self.shape.frame = CGRectMake(midX - radius, midY - radius, radius * 2, radius * 2);
    self.shape.anchorPoint = CGPointMake(0.5, 0.5);
    self.shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,radius*2,radius*2)].CGPath;
}



-(void)showShapeIfNeed
{
    self.shape.transform = self.isOn ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, .0001, .0001);
}

-(void)switchChanged
{
    if (self.isOn == self.oldState)
    {
        return;
    }
    self.oldState = self.isOn;
    
    
    if (self.isOn)
    {
        [CATransaction begin];
        [self.shape removeAnimationForKey:@"scaleDown"];
        
        CABasicAnimation*scaleAnimation = [self animateKeyPath:@"transform" fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)] timing:kCAMediaTimingFunctionEaseIn];
        [self.shape addAnimation:scaleAnimation forKey:@"scaleUp"];
        [CATransaction commit];
    }
    else
    {
        [CATransaction begin];
        [self.shape removeAnimationForKey:@"scaleUp"];
        
        CABasicAnimation*scaleAnimation = [self animateKeyPath:@"transform" fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)] timing:kCAMediaTimingFunctionEaseIn];
        [self.shape addAnimation:scaleAnimation forKey:@"scaleDown"];
        [CATransaction commit];
    }
         
}


-(CABasicAnimation*)animateKeyPath:(NSString*)keyPath fromValue:(id)from toValue:(id)to timing:(NSString*)timingFunction
{
    CABasicAnimation*animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = from;
    animation.toValue = to;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = self.duration;
    animation.delegate = self;
    
    return animation;
}

//CAAnimation delegate
-(void)animationDidStart:(CAAnimation *)anim
{
    if (self.animationDidStartClosure)
        self.animationDidStartClosure(self.isOn);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.animationDidStopClosure)
        self.animationDidStopClosure(self.isOn, flag);
}

@end
