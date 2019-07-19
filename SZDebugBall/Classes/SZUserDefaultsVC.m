//
//  SZUserDefaultsVC.m
//  SZDebugBall_Example
//
//  Created by Will on 2019/7/10.
//  Copyright © 2019 willzh. All rights reserved.
//

#import "SZUserDefaultsVC.h"

@interface SZUserDefaultsVC ()

@property (nonatomic, strong) NSMutableArray <SZUDModel *> *datas; //!< 数据
@property (nonatomic, strong) SZUDModel *model; //!< 模型

@end


@implementation SZUserDefaultsVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"User Defaults";
    
    self.model = [[SZUDModel alloc] initWithKey:@"NSUserDefaults" value:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] level:0];
    self.datas = [NSMutableArray array];
    [self.datas addObject:_model];
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZUDModel *model = _datas[indexPath.row];
    return MAX(model.titleHeight + 20, 32.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZUDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZUDCell"];
    if (cell == nil) {
        cell = [[SZUDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SZUDCell"];
    }
    
    [cell config:_datas[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SZUDModel *model = _datas[indexPath.row];
    if (model.expanded)
    {
        if (model.numberOfChilds > 0)
        {
            NSMutableArray *idps = [NSMutableArray array];
            NSMutableArray *objs = [NSMutableArray array];
            for (NSInteger i=indexPath.row + 1; i<_datas.count; i++)
            {
                SZUDModel *tm = _datas[i];
                if (tm.level <= model.level) {
                    break;
                }
                tm.expanded = NO;
                [objs addObject:tm];
                [idps addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [_datas removeObjectsInArray:objs];
            [tableView deleteRowsAtIndexPaths:idps withRowAnimation:UITableViewRowAnimationFade];
        }
    }else
    {
        if (model.numberOfChilds > 0)
        {
            NSMutableArray *idps = [NSMutableArray array];
            for (NSInteger i=0; i<model.childs.count; i++)
            {
                [_datas insertObject:model.childs[i] atIndex:indexPath.row + i + 1];
                [idps addObject:[NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:0]];
            }
            [tableView insertRowsAtIndexPaths:idps withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    model.expanded = !model.expanded;
    
}


#pragma mark - Private Methods









@end







@implementation SZUDModel


- (instancetype)initWithKey:(NSString *)key value:(id)value level:(NSInteger)level
{
    self = [super init];
    if (self)
    {
        self.key = key;
        self.object = value;
        self.level = level;
        
        if ([_object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)_object;
            self.numberOfChilds = dict.count;
            self.title = [NSString stringWithFormat:@"%@%@: Object[%ld]", [self blankLength:_level], _key, _numberOfChilds];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSString *tk in dict) {
                [tempArr addObject:[[SZUDModel alloc] initWithKey:tk value:dict[tk] level:level + 1]];
            }
            self.childs = tempArr;
            
        }else if ([_object isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)_object;
            self.numberOfChilds = array.count;
            self.title = [NSString stringWithFormat:@"%@%@: Array[%ld]", [self blankLength:_level], _key, _numberOfChilds];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (id tv in array) {
                [tempArr addObject:[[SZUDModel alloc] initWithValue:tv level:level + 1]];
            }
            self.childs = tempArr;
        }else
        {
            self.numberOfChilds = 0;
            if ([_object isKindOfClass:[NSString class]]) {
                self.title = [NSString stringWithFormat:@"%@%@: %@", [self blankLength:_level], _key, _object];
            }else if ([_object isKindOfClass:[NSNumber class]]) {
                self.title = [NSString stringWithFormat:@"%@%@: %@", [self blankLength:_level], _key, [(NSNumber *)_object stringValue]];
            }
            
        }
        self.titleHeight = [self zs_sizeWithFont:[UIFont systemFontOfSize:14]].height;
        
    }
    return self;
}

- (instancetype)initWithValue:(id)value level:(NSInteger)level
{
    self = [super init];
    if (self)
    {
        self.key = @"";
        self.object = value;
        self.level = level;
        
        if ([_object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)_object;
            self.numberOfChilds = dict.count;
            self.title = [NSString stringWithFormat:@"%@Object[%ld]", [self blankLength:_level], _numberOfChilds];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSString *tk in dict) {
                [tempArr addObject:[[SZUDModel alloc] initWithKey:tk value:dict[tk] level:level + 1]];
            }
            self.childs = tempArr;
            
        }else if ([_object isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)_object;
            self.numberOfChilds = array.count;
            self.title = [NSString stringWithFormat:@"%@Array[%ld]", [self blankLength:_level], _numberOfChilds];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (id tv in array) {
                [tempArr addObject:[[SZUDModel alloc] initWithValue:tv level:level + 1]];
            }
            self.childs = tempArr;
        }else
        {
            self.numberOfChilds = 0;
            if ([_object isKindOfClass:[NSString class]]) {
                self.title = [NSString stringWithFormat:@"%@%@", [self blankLength:_level], _object];
            }else if ([_object isKindOfClass:[NSNumber class]]) {
                self.title = [NSString stringWithFormat:@"%@%@", [self blankLength:_level], [(NSNumber *)_object stringValue]];
            }
            
        }
        
        self.titleHeight = [self zs_sizeWithFont:[UIFont systemFontOfSize:14]].height;
        
        
    }
    return self;
}


- (NSString *)blankLength:(NSInteger)length
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<length; i++) {
        [arr addObject:@""];
    }
    return [arr componentsJoinedByString:@""];
}


/// 根据字符串的字体和 size 计算字符串实际 size
- (CGSize)zs_sizeWithFont:(UIFont *)font
{
    // 段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
    
    return [_title boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 80 - 20 * _level, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}





@end




@implementation SZUDCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sw = CGRectGetWidth(self.contentView.frame);
    CGFloat sh = CGRectGetHeight(self.contentView.frame);
    CGFloat insetX = 20 * _model.level;
    _label_title.frame = CGRectMake(20.0 + insetX, 10.0, sw - 40.0 - insetX, sh - 20.0);
    
}

- (void)config:(SZUDModel *)model
{
    self.model = model;
    
    if (model.numberOfChilds) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    _label_title.text = model.title;
    
    
}

- (UILabel *)label_title
{
    if (!_label_title)
    {
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
        _label_title.font = [UIFont systemFontOfSize:14];
        _label_title.textColor = [UIColor blackColor];
        _label_title.numberOfLines = 0;
    }
    return _label_title;
}


@end

