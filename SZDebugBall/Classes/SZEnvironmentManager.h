//
//  SZEnvironmentManager.h
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// 环境切换后通知
UIKIT_EXTERN NSNotificationName const SZEnvironmentChangedNotification;

/// 环境模型
@interface SZEnvironment : NSObject <NSCoding>

@property (nonatomic, copy) NSString *mid;     //!< id
@property (nonatomic, copy) NSString *title;   //!< title
@property (nonatomic, copy) NSString *address; //!< 地址

+ (instancetype)modelWithID:(NSString *)mid title:(NSString *)title address:(NSString *)addr;
+ (instancetype)modelWithTitle:(NSString *)title address:(NSString *)addr;

@end



@interface SZEnvironmentManager : NSObject

/// 配置默认环境。titles.count == address.count。默认选中第一个。
+ (void)configEnvs:(NSArray <NSString *> *)titles address:(NSArray <NSString *> *)address;

/// 配置当前环境，仅在联机调试(连接电脑，XCode安装调试)的时候有作用。独立运行时不起作用。这是为了方便在联机调试时，能使用代码修改环境。
+ (void)configCurrentAddress:(NSString *)address;

/// 添加新的自定义环境配置
+ (NSString *)addEnvWithTitle:(NSString *)title address:(NSString *)address;

/// 删除环境
+ (void)deleteEnv:(SZEnvironment *)env;

/// 更新环境
+ (void)updateEnv:(SZEnvironment *)env;

/// 保存当前环境
+ (void)setCurrentEnv:(SZEnvironment *)env;

/// 保存的所有环境列表
+ (NSArray *)savedEnvs;

/// 获取当前环境
+ (SZEnvironment *)currentEnv;

/// 当前环境地址
+ (NSString *)currentAddress;



@end





/// 环境模型
@interface SZEnvironmentConfig : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray <SZEnvironment *> *defaultEnvs;   //!< 默认的环境列表
@property (nonatomic, strong) NSMutableArray <SZEnvironment *> *customEnvs;    //!< 自定义的环境列表
@property (nonatomic, copy) NSString *currentEnvId; //!< 当前环境 id

/// 保存
- (void)save;

/// 读取保存的环境配置
+ (instancetype)loadConfig;


/// 查询环境列表中是否存在相同的环境，用在新增环境时
- (SZEnvironment *)getEnvWithTitle:(NSString *)title address:(NSString *)addr;

/// 查询环境列表中是否存在
- (BOOL)isExist:(SZEnvironment *)env;


/// 获取当前环境。默认为 defaultEnvs 中第一条
- (SZEnvironment *)currentEnv;

/// 添加新环境
- (void)addEnv:(SZEnvironment *)env;

/// 删除环境
- (void)deleteEnv:(SZEnvironment *)env;

/// 更新环境
- (void)updateEnv:(SZEnvironment *)env;

/// 设置当前环境，会自动保存一次
- (void)setCurrentEnvId:(NSString *)currentEnvId;





@end





NS_ASSUME_NONNULL_END
