//
//  SZDebugVC.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEnvironmentManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SZDebugFuncType)
{
    SZDebugFunc_Environment,    //!< 环境
    SZDebugFunc_LocalFiles,     //!< 本地文件
    SZDebugFunc_ViewHierarchy,  //!< 界面层级
    SZDebugFunc_UserDefaults,   //!< 查看 UserDefaults
    SZDebugFunc_KeyChain,       //!< 查看 keychain
    
};


@interface SZDebugVC : UIViewController


@end



@interface SZDebugFunc : NSObject

@property (nonatomic, assign) SZDebugFuncType type; //!< 类型
@property (nonatomic, copy) NSString *title; //!< 标题

+ (instancetype)funcWithType:(SZDebugFuncType)type;

@end


@interface SZDebugCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UILabel *label_detail;

- (void)config:(SZDebugFunc *)model environment:(SZEnvironment *)env;

@end


@interface SZDebugInfoHeader : UIView

@property (nonatomic, strong) UILabel *label_title;

@end




NS_ASSUME_NONNULL_END
