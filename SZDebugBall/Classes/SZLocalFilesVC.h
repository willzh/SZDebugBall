//
//  SZLocalFilesVC.h
//  SZDebugBall
//
//  Created by Will on 2019/6/3.
//

#import <UIKit/UIKit.h>
#import "ZSLocalFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZLocalFilesVC : UITableViewController

@end


@interface SZFileCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgv_icon;  //!< 图标
@property (nonatomic, strong) UILabel *label_title;    //!< 标题
@property (nonatomic, strong) UILabel *label_detail;   //!< 详情


- (void)config:(ZSLocalFile *)model;


@end


NS_ASSUME_NONNULL_END
