//
//  SZEnvironmentVC.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//
//  配置环境
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZEnvironmentVC : UIViewController

@property (nonatomic, copy) void (^didSelectedEnv)(NSDictionary *envDict); //!< 选中回调

@end


@interface SZEnvironmentCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;

@end

NS_ASSUME_NONNULL_END
