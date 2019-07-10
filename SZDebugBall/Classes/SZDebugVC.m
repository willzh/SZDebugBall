//
//  SZDebugVC.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//
//  DEBUG 模式。包括环境改变，本地文件浏览。
//  接口抓包？界面层级？
//

#import "SZDebugVC.h"
#import "SZEnvironmentVC.h"
#import "SZViewHierarchyVC.h"
#import "SZLocalFilesVC.h"
#import "SZUserDefaultsVC.h"
#import "SZKeyChainVC.h"

#import "SZEnvironmentManager.h"
#import "SZDebugBall.h"

@interface SZDebugVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL navBarHidden;
    BOOL isLoaded;
}

@property (nonatomic, strong) UITableView *table; //!< tableView
@property (nonatomic, strong) NSMutableArray <SZDebugFunc *> *datas; //!< 数据
@property (nonatomic, strong) SZEnvironment *currentEnv; //!< collectionView

@end


@implementation SZDebugVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Main";
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self setUI];
    
    isLoaded = YES;
    
    self.datas = [NSMutableArray array];
    [_datas addObject:[SZDebugFunc funcWithType:SZDebugFunc_Environment]];
    [_datas addObject:[SZDebugFunc funcWithType:SZDebugFunc_LocalFiles]];
    [_datas addObject:[SZDebugFunc funcWithType:SZDebugFunc_ViewHierarchy]];
    [_datas addObject:[SZDebugFunc funcWithType:SZDebugFunc_UserDefaults]];
    [_datas addObject:[SZDebugFunc funcWithType:SZDebugFunc_KeyChain]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded) {
        navBarHidden = self.navigationController.navigationBarHidden; // 记录原来的导航显示
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.currentEnv = [SZEnvironmentManager currentEnv];
    [self.table reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:navBarHidden animated:YES];
    
}

#pragma mark - Actions
- (void)closeAction:(id)sender
{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (!vc) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [SZDebugBall show];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZDebugCell"];
    [cell config:self.datas[indexPath.row] environment:_currentEnv];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SZDebugFunc *model = self.datas[indexPath.row];
    switch (model.type)
    {
        case SZDebugFunc_Environment:
        {
            SZEnvironmentVC *vc = [[SZEnvironmentVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SZDebugFunc_LocalFiles:
        {
            SZLocalFilesVC *vc = [[SZLocalFilesVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SZDebugFunc_ViewHierarchy:
        {
            SZViewHierarchyVC *vc = [[SZViewHierarchyVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SZDebugFunc_UserDefaults:
        {
            SZUserDefaultsVC *vc = [[SZUserDefaultsVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SZDebugFunc_KeyChain:
        {
            SZKeyChainVC *vc = [[SZKeyChainVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - UI
- (void)setUI
{
    // 顶部
    CGFloat navbarH = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGRect topBarFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), navbarH + statusH);
    CGFloat tw = CGRectGetWidth(topBarFrame);
    CGFloat th = CGRectGetHeight(topBarFrame);
    
    [self.view addSubview:self.table];
    _table.contentInset = UIEdgeInsetsMake(th, 0, 0, 0);
    
    UIView *topBar = [[UIView alloc] initWithFrame:topBarFrame];
    topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBar];
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake((tw - 200) / 2.0, th - 44, 200, 44)];
    label_title.textAlignment = NSTextAlignmentCenter;
    label_title.textColor = [UIColor blackColor];
    label_title.text = @"Main";
    [topBar addSubview:label_title];
    
    UIButton *btn_left = [[UIButton alloc] initWithFrame:CGRectMake(0, th - 44, 60, 44)];
    [btn_left addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_left];
    
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, th - 32, 20, 20)];
    btnBg.contentMode = UIViewContentModeScaleAspectFit;
    btnBg.image = [self closeImage];
    [topBar addSubview:btnBg];
    
    
}

#pragma mark - lazy loading
- (UITableView *)table
{
    if (!_table)
    {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.alwaysBounceVertical = YES;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableHeaderView = [[SZDebugInfoHeader alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
        [_table registerClass:[SZDebugCell class] forCellReuseIdentifier:@"SZDebugCell"];
    }
    return _table;
}

/// 关闭图标
- (UIImage *)closeImage
{
    return [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"iVBORw0KGgoAAAAEQ2dCSVAAIAIr1bN/AAAADUlIRFIAAABsAAAAbAgGAAAAj2ZXzQAAABxpRE9UAAAAAgAAAAAAAAA2AAAAKAAAADYAAAA2AAAC59rZSr0AAAKzSURBVOzbO2/TUBQH8AZhpb6+8iMPJ8pDyqPkMUSUSqiJVBQFLOPHvZGM1AXxCRADM2LjEzHwGdhYu8GQoaiioiEtjGGByIlKQhzH8bXPX7rjOYn+P53Re3sQCGQHEUWxU61WX5bL5Rf7+/sFaCSYJJPJfKlUel6r1V5JknR/5UAmk+lrmnbmOM7U/Xq93geM8T2odDsRBKHW7XbfL/auadpZLpczbh1SVfXp4oD7DYfDX9ls9jHU62/S6fQJpfRmWffFYvF0bojjOMk0za/LhlxoT6BmX7GuV/VuWdY3juPk2WA+n6erhuDSgr8s9ysUCs9mw81m8+3/Dv5B+wlo3pNKpbqU0sk6nbfb7XezBfV6/fU6w3Bp3qMoyvG6WI7jTBuNxpu581x3wV+0dDp9AgzbxXIcZ6qqqu7edaff73/0sohSegNo28UaDAafEonE3bmFCKGKbdvfN0B7BCz/xiKE/PDY7UQQhNqtiyVJOiSEjOHSwnFZlNKJoigPl/4AoPkXWZaPtooFaP5iEUKuto7lF5qiKMeAFRCWT2iTOKLtDAvQGMQCNAaxAG11RFHshAoL0JZj2bZ9GTosv9BkWT4CrICw/EAjhFxFAY0ZLEBjECvOaMxixRENY9xiGitOaBjjlmVZF8xj+YUmimIHsBhCs237MoxokcWKIlrksaKEFhusKKAJgnAQKyy/0DDGrV1gmaZ5HjssP9Asy7oIEi32WCyhARZDaIDFEBpgMYQGWAGhCYJwsOl/QAhVACsgNNM0zzdBQwhVDMMYARYDaIDFEBpgMYQGWAyhAVZI0RBClcWdPM+XACukaIZhjNxoPM+XdF3/AlgMoAFW8GgPvH4XbBjGSNf1zx6xruP8bdvOLg0uK+JohJAxYDGCRggZS5J0CE0zgAZYDKEBFkNoLGL9BgAA///sDeZoAAACKklEQVTt2z1v2kAYB3AwSAGEbRnM6ZAJCJC9IEtZUlUZSkTBEfJxhKVVpgxduiRjq3yJfq7OmbKka7eqeVEadWmnUtSSDOZF95z/f8mb7xnup0fn5yRnMkRj2/aeEOJmNpv9SvIIIW5s297LINuJaZq9OI6/JQWbTCZ3juPsYycJYAGNIBbQCGIBjSAW0AhiAY0gFtDWEMuywlWwpJQPCWe0W8dxXkBgi53FGBu5rnsopXxEpymMNZ1OfzLGRn9qAW0LV07rwgKawveDT2EBjSAW0AhiAY0gFtAIYgGNIBbQCGIBjSAW0AhiAY0gFtAIYgGNIFbq0ShipRaNMlbq0HTASg2aTljao+mIpS2azljaoaUBSxu0NGGRR0sjFlm0NGORQwMWIbRVsKSUjzphKY+2KpbruocZTaMcGrAIoQGLEBqwCKEBixAasAihAWvtaA8bQwPW+lOpVA42glYqlVpCiO9Jf1Ot1WqvwbM81Wr1lZTyR1K0crkc/FvT6Pf7n9FZanbaYDC4zGaz+cViL4GlNhpj7GheqN1uvweW2mhBEFzMiwRBcIEzS+0zLQzDT/MCnPMJOkvtTms2m6d/vzgMYyeKoi/AUhNtPB5/zefz5f+GPGCpieZ53puli+v1+vGyWSyKomvLskJs72ZimmZvOBxeLZnB7lut1rtnFxcKhbrneW993//Q7XbPOedxLpcrYVs3G8MwCpzzuNPpnPm+/7HRaJwUi8XdxXd+A/HRqJkAAAAASUVORK5CYII=" options:0]];
}








@end





@implementation SZDebugFunc

+ (instancetype)funcWithType:(SZDebugFuncType)type
{
    SZDebugFunc *model = [[SZDebugFunc alloc] init];
    model.type = type;
    
    [model commonInit];
    
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    switch (_type)
    {
        case SZDebugFunc_Environment:
            self.title = @"修改环境";
            break;
        case SZDebugFunc_LocalFiles:
            self.title = @"本地文件";
            break;
        case SZDebugFunc_ViewHierarchy:
            self.title = @"界面层级";
            break;
        case SZDebugFunc_UserDefaults:
            self.title = @"User Defaults";
            break;
        case SZDebugFunc_KeyChain:
            self.title = @"Key Chain";
            break;
            
        default:
            break;
    }
}



@end











// 功能类型
@implementation SZDebugCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label_title];
        [self.contentView addSubview:self.label_detail];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sw = CGRectGetWidth(self.contentView.frame);
    CGFloat sh = CGRectGetHeight(self.contentView.frame);
    _label_title.frame = CGRectMake(10, sh / 2.0 - 10.0, sw - 130, 20);
    _label_detail.frame = CGRectMake(sw - 100.0, sh / 2.0 - 10.0, 100, 20);
    
}


- (void)config:(SZDebugFunc *)model environment:(SZEnvironment *)env
{
    _label_title.text = model.title;
    
    if (SZDebugFunc_Environment == model.type) {
        _label_detail.text = env.title;
    }else {
        _label_detail.text = nil;
    }
}


- (UILabel *)label_title
{
    if (!_label_title)
    {
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
        _label_title.font = [UIFont systemFontOfSize:14];
        _label_title.textColor = [UIColor blackColor];
    }
    return _label_title;
}

- (UILabel *)label_detail
{
    if (!_label_detail)
    {
        _label_detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
        _label_detail.font = [UIFont systemFontOfSize:12];
        _label_detail.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _label_detail.textAlignment = NSTextAlignmentRight;
    }
    return _label_detail;
}

@end



// 显示 App 相关信息：名称，版本号，编译版本号
@implementation SZDebugInfoHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [self addSubview:self.label_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label_title.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20.0, CGRectGetHeight(self.frame) - 20.0);
    
}

- (UILabel *)label_title
{
    if (!_label_title)
    {
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 130)];
        _label_title.font = [UIFont systemFontOfSize:14];
        _label_title.textColor = [UIColor blackColor];
        _label_title.textAlignment = NSTextAlignmentLeft;
        _label_title.numberOfLines = 0;
        
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *str = [NSString stringWithFormat:@"%@\nVersion: %@\nBuild: %@", infoDict[@"CFBundleDisplayName"], infoDict[@"CFBundleShortVersionString"], infoDict[@"CFBundleVersion"]];
        
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = 12.0;
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, str.length)];
        
        _label_title.attributedText = attStr;
    }
    return _label_title;
}

@end





