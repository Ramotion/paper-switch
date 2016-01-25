//
//  FTPaperSwitch.h
//  PaperSwitchDemo
//
//  Created by _Finder丶Tiwk on 16/1/25.
//  Copyright © 2016年 Ramotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPaperSwitch : UISwitch

/*! 动画时间 默认为0.25秒*/
@property (nonatomic,assign) CFTimeInterval duration;
/*! 展开画面填充颜色,如果不设置，默认为控制底色 绿色*/
@property (nonatomic,strong) UIColor        *fillColor;

/*! 动画开始回调,从block中的animation参数 可以取到动画相关信息*/
@property (nonatomic,copy) void (^animationStartBlock)(CAAnimation *animation);
/*! 动画结束回调,从block中的animation参数 可以取到动画相关信息,complete标识动画是否结束*/
@property (nonatomic,copy) void (^animationStopBlock)(CAAnimation *animation,BOOL complete);

@end
