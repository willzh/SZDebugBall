//
//  SZDebugVC.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZDebugVC : UIViewController

@end


@interface SZDebugCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UILabel *label_detail;

@end


@interface SZDebugInfoHeader : UIView

@property (nonatomic, strong) UILabel *label_title;

@end

NS_ASSUME_NONNULL_END
