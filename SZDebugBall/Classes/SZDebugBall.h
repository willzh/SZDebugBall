//
//  SZDebugBall.h
//
//  Created by Will on 2018/3/8.
//  Copyright © 2018年. All rights reserved.
/*
联机调试时：使用代码设置的环境生效
独立测试时：动态配置模块生效
*/


#import <UIKit/UIKit.h>

@interface SZDebugBall : UIWindow

/// 仅在 Debug 模式下显示
+ (void)show;

/// 隐藏
+ (void)hidden;






@end
