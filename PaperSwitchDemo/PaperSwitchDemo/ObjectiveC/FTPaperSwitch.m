//
//  FTPaperSwitch.m
//  PaperSwitchDemo
//
//  Created by _Finder丶Tiwk on 16/1/25.
//  Copyright © 2016年 Ramotion. All rights reserved.
//

#import "FTPaperSwitch.h"

static NSString *kShapeLayerName  = @"circleShape";

@interface FTPaperSwitch ()
@property (nonatomic,strong) CAShapeLayer *shapLayer;
@end

@implementation FTPaperSwitch

#pragma mark - Accessor
- (CAShapeLayer *)shapLayer{
    if (!_shapLayer) {
        _shapLayer               = [CAShapeLayer layer];
        _shapLayer.name          = kShapeLayerName;
        _shapLayer.fillColor     = [UIColor greenColor].CGColor;
        _shapLayer.masksToBounds = YES;
    }
    return _shapLayer;
}

- (CFTimeInterval)duration{
    return _duration > 0 ? :0.25;
}

- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    self.shapLayer.fillColor = fillColor.CGColor;
}

#pragma mark  - 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - 重写UISwitch设置状态方法

- (void)setOn:(BOOL)on animated:(BOOL)animated{
    [super setOn:on animated:animated];
    [self switchChanged];
}


- (void)insertIntoSuperLayer{
    BOOL isAdd = NO;
    
    for (CAShapeLayer *layer in self.superview.layer.sublayers) {
        if ([layer.name isEqualToString:kShapeLayerName]) {
            isAdd = YES;
            break;
        }
    }
    
    if (!isAdd) {
        [self.superview.layer insertSublayer:self.shapLayer atIndex:0];
        self.superview.layer.masksToBounds = YES;
    }
}

- (void)layoutSubviews{
    [self insertIntoSuperLayer];
    
    CGFloat midX = self.center.x;
    CGFloat midY = self.center.y;
    
    CGFloat x = MAX(midX, self.superview.frame.size.width  - midX);
    CGFloat y = MAX(midY, self.superview.frame.size.height - midY);
    
    CGFloat radius =  sqrt(pow(x, 2) + pow(y, 2));
    self.shapLayer.frame       = (CGRect){{midX-radius,midY-radius},{radius*2,radius*2}};
    self.shapLayer.anchorPoint = (CGPoint){0.5,0.5};
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:(CGRect){CGPointZero,{radius*2,radius*2}}];
    self.shapLayer.path =  bezierPath.CGPath;
}

- (void)switchChanged{
    
    BOOL status = self.on;
    CGFloat orgin = 0.0001;
    CGFloat final = 1.0;
    
    NSValue *value1     = [NSValue valueWithCATransform3D:CATransform3DMakeScale(orgin,orgin,orgin)];
    NSValue *value2     = [NSValue valueWithCATransform3D:CATransform3DMakeScale(final,final,final)];
    NSValue *from       = status?value1:value2;
    NSValue *to         = status?value2:value1;
    
    NSString *animationKey1  = @"ZoomIn";
    NSString *animationKey2  = @"ZoomOut";
    NSString *removeKey      = status?animationKey2:animationKey1;
    NSString *addKey         = status?animationKey1:animationKey2;
    NSString *timingFunction = status?kCAMediaTimingFunctionEaseIn:kCAMediaTimingFunctionEaseOut;
    
    [CATransaction begin];
    [self.shapLayer removeAnimationForKey:removeKey];
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue           = from;
    animation.toValue             = to;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:timingFunction];
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;
    animation.duration            = self.duration;
    animation.delegate            = self;
    [self.shapLayer addAnimation:animation forKey:addKey];
    [CATransaction commit];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    if (self.animationStartBlock) {
        self.animationStartBlock(anim);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && self.animationStopBlock) {
        self.animationStopBlock(anim,flag);
    }
}


@end
