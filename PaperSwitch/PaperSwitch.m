//
//  PaperSwitch.m
//  XKSCommonSDK
//
//  Created by _Finder丶Tiwk on 16/1/26.
//  Copyright © 2016年 _Finder丶Tiwk. All rights reserved.
//

#import "PaperSwitch.h"

@interface PaperSwitch ()
@property (nonatomic,strong) CAShapeLayer *shapLayer;
@end

@implementation PaperSwitch{
    BOOL _status;     /**< Switch开关初始状态*/
    BOOL _codeInit;   /**< 是否是通过代码创建的*/
}

#pragma mark - Accessor
static NSString *kShapeLayerName  = @"circleShape";
- (CAShapeLayer *)shapLayer{
    if (!_shapLayer) {
        _shapLayer               = [CAShapeLayer layer];
        _shapLayer.name          = kShapeLayerName;
        _shapLayer.masksToBounds = YES;
    }
    return _shapLayer;
}

- (CFTimeInterval)duration{
    return _duration > 0 ? :0.25;
}

- (UIColor *)fillColor{
    return _fillColor? : (self.onTintColor?:[UIColor greenColor]);
}

#pragma mark  - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _codeInit = YES;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.superview.layer insertSublayer:self.shapLayer atIndex:0];
    self.superview.layer.masksToBounds = YES;
}


#pragma mark - 重写UISwitch设置状态方法
- (void)setOn:(BOOL)on animated:(BOOL)animated{
    [super setOn:on animated:animated];
    _status = on;
}

- (CATransform3D)scaleTransform:(BOOL)clockwise{
    CGFloat scale = clockwise?0.0001:1.0;
    return CATransform3DMakeScale(scale,scale,scale);
}

- (void)layoutSubviews{
    if (_codeInit) {
        /*
         *  如果是通过代码进行初始化的要等到它加入到SuperView之后，
         *  才能找到SuperView为其添加ShapeLayer。
         */
        BOOL added = NO;
        for (CAShapeLayer *layer in self.superview.layer.sublayers) {
            if ((added = [layer.name isEqualToString:kShapeLayerName])) {
                break;
            }
        }
        if (!added) {
            [self.superview.layer insertSublayer:self.shapLayer atIndex:0];
            self.superview.layer.masksToBounds = YES;
        }
    }
    
    CGFloat midX = self.center.x;
    CGFloat midY = self.center.y;
    
    CGFloat x = MAX(midX, self.superview.frame.size.width  - midX);
    CGFloat y = MAX(midY, self.superview.frame.size.height - midY);
    
    CGFloat radius =  sqrt(pow(x, 2) + pow(y, 2));
    self.shapLayer.transform = [self scaleTransform:!_status];
    self.shapLayer.fillColor   = self.fillColor.CGColor;
    self.shapLayer.frame       = (CGRect){{midX-radius,midY-radius},{radius*2,radius*2}};
    self.shapLayer.anchorPoint = (CGPoint){0.5,0.5};
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:(CGRect){CGPointZero,{radius*2,radius*2}}];
    self.shapLayer.path =  bezierPath.CGPath;
}


- (void)switchChanged:(PaperSwitch *)sender{
    _status       = sender.on;
    NSValue *from = [NSValue valueWithCATransform3D:[self scaleTransform:_status]];
    NSValue *to   = [NSValue valueWithCATransform3D:[self scaleTransform:!_status]];
    
    NSString *animationKey1  = @"ZoomIn";
    NSString *animationKey2  = @"ZoomOut";
    NSString *removeKey      = _status?animationKey2:animationKey1;
    NSString *addKey         = _status?animationKey1:animationKey2;
    NSString *timingFunction = _status?kCAMediaTimingFunctionEaseIn:kCAMediaTimingFunctionEaseOut;
    
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
