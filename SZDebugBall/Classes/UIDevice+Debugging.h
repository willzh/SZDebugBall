//
//  UIDevice+Debugging.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/27.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Debugging)

/// 判断是否处于联机调试模式。如果是连接真机或模拟器，并使用XCode安装调试模式，才返回 YES。
+ (BOOL)zs_isBeingDebugged;


@end

NS_ASSUME_NONNULL_END
