//
//  SZEnvironmentManager.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//


#import "SZEnvironmentManager.h"
#import "UIDevice+Debugging.h"

NSNotificationName const SZEnvironmentChangedNotification = @"SZEnvironmentChangedNotification";

@implementation SZEnvironmentManager



#pragma mark - 配置
/// 配置环境
+ (void)configEnvs:(NSArray <NSString *> *)titles address:(NSArray <NSString *> *)address
{
    NSAssert(titles.count, @"Please config the environment titles.");
    NSAssert(titles.count == address.count, @"Please confirm titles and address is equal to length.");
    
    /// 非联机调试时，不能改变
    if (![UIDevice zs_isBeingDebugged]) {
        return;
    }
    
    // 读取以保存的配置，避免重复配置。
    SZEnvironmentConfig *configs = [SZEnvironmentConfig loadConfig];
    
    // 默认环境数据
    for (NSInteger i=0; i<address.count; i++)
    {
        SZEnvironment *model = [SZEnvironment modelWithID:[NSString stringWithFormat:@"%ld", i+1000] title:titles[i] address:address[i]];
        if (![configs isExist:model]) {
            [configs.defaultEnvs addObject:model];
        }
    }
    
    [configs save]; // 保存一下
}

/// 配置当前环境，仅在联机调试的时候有作用
+ (void)configCurrentAddress:(NSString *)address
{
    /// 非联机调试时，不能改变
    if (![UIDevice zs_isBeingDebugged]) {
        return;
    }
    
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    SZEnvironment *env = [config getEnvWithTitle:@"" address:address];
    if (env) {
        config.currentEnvId = env.mid; // 会自动保存
    }
}


#pragma mark - 新增
/// 添加新的自定义环境配置
+ (NSString *)addEnvWithTitle:(NSString *)title address:(NSString *)address
{
    NSString *errorMsg = nil;
    
    if (title.length == 0) {
        errorMsg = @"请输入标题";
    }
    if (address.length == 0) {
        errorMsg = @"请输入地址";
    }
    
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    if (!errorMsg || errorMsg.length == 0)
    {
        // 检查重复
        SZEnvironment *env = [config getEnvWithTitle:title address:address];
        if (env)
        {
            if ([env.address isEqualToString:address])
            {
                errorMsg = [NSString stringWithFormat:@"已存在相同地址的环境，环境名称是‘%@’", env.title];
            }else if ([env.title isEqualToString:title])
            {
                errorMsg = [NSString stringWithFormat:@"已存在名为‘%@’的环境，环境地址是:%@", title, env.address];
            }
        }
    }
    
    if (!errorMsg || errorMsg.length == 0)
    {
        // 保存
        [config addEnv:[SZEnvironment modelWithTitle:title address:address]];
    }
    
    return errorMsg;
}


#pragma mark - 删除
+ (void)deleteEnv:(SZEnvironment *)env
{
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    [config deleteEnv:env];
}


#pragma mark - 修改
+ (void)updateEnv:(SZEnvironment *)env
{
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    [config updateEnv:env];
}

/// 保存当前环境
+ (void)setCurrentEnv:(SZEnvironment *)env
{
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    [config setCurrentEnvId:env.mid];
}

#pragma mark - 读取
+ (NSArray <SZEnvironment *> *)savedEnvs
{
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObjectsFromArray:config.defaultEnvs];
    [temp addObjectsFromArray:config.customEnvs];
    return temp;;
}

+ (SZEnvironment *)currentEnv {
    return [[SZEnvironmentConfig loadConfig] currentEnv];
}

/// 当前环境地址
+ (NSString *)currentAddress
{
    return [[SZEnvironmentConfig loadConfig] currentEnv].address;
}

@end






#pragma mark -
#pragma mark - SZEnvironment Class
#pragma mark -


@implementation SZEnvironment

#pragma mark -
+ (instancetype)modelWithID:(NSString *)mid title:(NSString *)title address:(NSString *)addr
{
    SZEnvironment *model = [[SZEnvironment alloc] init];
    model.mid = mid;
    model.title = title;
    model.address = addr;
    
    return model;
}

+ (instancetype)modelWithTitle:(NSString *)title address:(NSString *)addr
{
    return [self modelWithID:[self randomId] title:title address:addr];
}

#pragma mark -
- (NSString *)description
{
    NSDictionary *dic = @{@"mid": _mid, @"title": _title, @"address": _address};
    return [NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), dic];
}

+ (NSString *)randomId
{
    return [NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970]];
}


#pragma mark -
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.mid forKey:NSStringFromSelector(@selector(mid))];
    [coder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
    [coder encodeObject:self.address forKey:NSStringFromSelector(@selector(address))];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        _mid = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(mid))];
        _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
        _address = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(address))];
    }
    
    return self;
}


#pragma mark -
- (BOOL)isEqual:(SZEnvironment *)object
{
    if ([_address isEqualToString:object.address] || [_mid isEqualToString:object.mid]) {
        return YES;
    }
    return NO;
}


@end


#pragma mark -
#pragma mark - SZEnvironmentConfig Class
#pragma mark -

@implementation SZEnvironmentConfig

#pragma mark -
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.currentEnvId forKey:@"kCurrentEnvId"];
    [coder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.defaultEnvs] forKey:@"kDefaultEnvs"];
    [coder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.customEnvs] forKey:@"kCustomEnvs"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _currentEnvId = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"kCurrentEnvId"];
        
        NSArray *def = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectOfClass:[NSData class] forKey:@"kDefaultEnvs"]];
        if (def && def.count) {
            [self.defaultEnvs addObjectsFromArray:def];
        }
        NSArray *cust = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectOfClass:[NSData class] forKey:@"kCustomEnvs"]];
        if (cust && cust.count) {
            [self.customEnvs addObjectsFromArray:cust];
        }
    }
    
    return self;
}


#pragma mark -
- (void)save
{
    if (![NSKeyedArchiver archiveRootObject:self toFile:[SZEnvironmentConfig savedPath]]) {
        NSLog(@"save data failed");
    }
}

+ (instancetype)loadConfig
{
    SZEnvironmentConfig *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedPath]];
    if (!model) {
        model = [[SZEnvironmentConfig alloc] init];
    }
//    NSLog(@"model.current:%@, default:%@", model.currentEnvId, model.defaultEnvs);
    return model;
}


+ (NSString *)savedPath
{
    NSString *destPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths && paths.count) {
        destPath = [paths.firstObject stringByAppendingPathComponent:@".AppEnvConfigKey"];
    }else {
        destPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/.AppEnvConfigKey"];
    }
    //NSLog(@"destPath:%@", destPath);
    return destPath;
}


#pragma mark -
- (void)addEnv:(SZEnvironment *)env
{
    [self.customEnvs addObject:env];
    [self save];
}

- (void)deleteEnv:(SZEnvironment *)env
{
    for (SZEnvironment *tm in self.defaultEnvs)
    {
        if ([tm isEqual:env])
        {
            [self.defaultEnvs removeObject:tm];
            break;
        }
    }
    for (SZEnvironment *tm in self.customEnvs)
    {
        if ([tm isEqual:env])
        {
            [self.customEnvs removeObject:tm];
            break;
        }
    }
    [self save];
}

- (void)updateEnv:(SZEnvironment *)env
{
    for (SZEnvironment *tm in self.defaultEnvs)
    {
        if ([tm isEqual:env])
        {
            [self.defaultEnvs replaceObjectAtIndex:[self.defaultEnvs indexOfObject:tm] withObject:env];
            break;
        }
    }
    for (SZEnvironment *tm in self.customEnvs)
    {
        if ([tm isEqual:env])
        {
            [self.customEnvs replaceObjectAtIndex:[self.customEnvs indexOfObject:tm] withObject:env];
            break;
        }
    }
    [self save];
}

- (void)setCurrentEnvId:(NSString *)currentEnvId
{
    _currentEnvId = currentEnvId;
    
    [self save];
}

- (BOOL)isExist:(SZEnvironment *)env
{
    for (SZEnvironment *tm in self.defaultEnvs)
    {
        if ([tm isEqual:env]) {
            return YES;
        }
    }
    for (SZEnvironment *tm in self.customEnvs)
    {
        if ([tm isEqual:env]) {
            return YES;
        }
    }
    return NO;
}

- (SZEnvironment *)getEnvWithTitle:(NSString *)title address:(NSString *)addr
{
    for (SZEnvironment *tm in self.defaultEnvs)
    {
        if ([tm.title isEqualToString:title] || [tm.address isEqualToString:addr]) {
            return tm;
        }
    }
    for (SZEnvironment *tm in self.customEnvs)
    {
        if ([tm.title isEqualToString:title] || [tm.address isEqualToString:addr]) {
            return tm;
        }
    }
    return nil;
}

- (SZEnvironment *)currentEnv
{
    // 当前环境不存在时，设置为环境列表中第一条
    if (!_currentEnvId || _currentEnvId.length == 0)
    {
        self.currentEnvId = _defaultEnvs.firstObject.mid; // 会自动保存
        return _defaultEnvs.firstObject;
    }
    
    for (SZEnvironment *tm in self.defaultEnvs)
    {
        if ([tm.mid isEqualToString:_currentEnvId]) {
            return tm;
        }
    }
    for (SZEnvironment *tm in self.customEnvs)
    {
        if ([tm.mid isEqualToString:_currentEnvId]) {
            return tm;
        }
    }
    
    self.currentEnvId = _defaultEnvs.firstObject.mid; // 会自动保存
    return _defaultEnvs.firstObject;
}

#pragma mark - lazy loading
- (NSMutableArray *)defaultEnvs
{
    if (!_defaultEnvs) {
        _defaultEnvs = [NSMutableArray array];
    }
    return _defaultEnvs;
}


- (NSMutableArray *)customEnvs
{
    if (!_customEnvs) {
        _customEnvs = [NSMutableArray array];
    }
    return _customEnvs;
}


@end

