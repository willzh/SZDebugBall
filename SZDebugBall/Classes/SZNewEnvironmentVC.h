//
//  SZNewEnvironmentVC.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZNewEnvironmentVC : UIViewController

@property (nonatomic, copy) void (^addEnviornmentCompletion)(SZNewEnvironmentVC *vc); //!< 添加完成回调

@end




@interface UITextView (SZExt)

@property (nonatomic, strong) NSString *sz_placeholder;
@property (nonatomic, strong) UILabel *sz_placeholderLabel;

@end

NS_ASSUME_NONNULL_END
