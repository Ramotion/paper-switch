//
//  PaperSwitch.h
//  XKSCommonSDK
//
//  Created by _Finder丶Tiwk on 16/1/26.
//  Copyright © 2016年 _Finder丶Tiwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaperSwitch : UISwitch

/*! 动画时间 默认为0.25秒*/
@property (nonatomic,assign) CFTimeInterval duration;
/*! 展开画面填充颜色,如果不设置,为onTintColor 如果onTintColor为空则为绿色*/
@property (nonatomic,strong) UIColor        *fillColor;

/*! 动画开始回调,从block中的animation参数 可以取到动画相关信息*/
@property (nonatomic,copy) void (^animationStartBlock)(CAAnimation *animation);
/*! 动画结束回调,从block中的animation参数 可以取到动画相关信息,complete标识动画是否结束*/
@property (nonatomic,copy) void (^animationStopBlock)(CAAnimation *animation,BOOL complete);

@end
