//
//  SZUserDefaultsVC.h
//  SZDebugBall_Example
//
//  Created by Will on 2019/7/10.
//  Copyright © 2019 willzh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZUserDefaultsVC : UITableViewController

@end



@interface SZUDModel : NSObject

@property (nonatomic, copy) NSString *key; //!< 当前节点 key
@property (nonatomic, strong) id object;   //!< 当前节点对象

@property (nonatomic, assign) NSInteger numberOfChilds; //!< 子节点数量
@property (nonatomic, copy) NSString *title;   //!< 显示的标题
@property (nonatomic, assign) BOOL expanded;   //!< 是否已展开
@property (nonatomic, assign) NSInteger level; //!< 层级
@property (nonatomic, assign) CGFloat titleHeight; //!< 标题高度

@property (nonatomic, copy) NSArray <SZUDModel *> *childs; //!< 子节点


/// 初始化
- (instancetype)initWithKey:(NSString *)key value:(id)value level:(NSInteger)level;


@end



@interface SZUDCell : UITableViewCell

@property (nonatomic, strong) SZUDModel *model; //!< 模型
@property (nonatomic, strong) UILabel *label_title; //!< 标题

- (void)config:(SZUDModel *)model;

@end

NS_ASSUME_NONNULL_END
