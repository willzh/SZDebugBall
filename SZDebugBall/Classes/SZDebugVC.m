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

#import "SZEnvironmentManager.h"
#import "SZDebugBall.h"

@interface SZDebugVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL navBarHidden;
    BOOL isLoaded;
}

@property (nonatomic, strong) UITableView *table; //!< tableView
@property (nonatomic, strong) NSMutableArray <SZEnvironment *> *datas; //!< 数据
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
    
    CGRect topBarFrame = CGRectUnion(self.navigationController.navigationBar.frame, [UIApplication sharedApplication].statusBarFrame);
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
    [btn_left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_left setTitle:@"关闭" forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_left];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    
    
    isLoaded = YES;
    
    
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
    [self.navigationController popViewControllerAnimated:YES];
    [SZDebugBall show];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZDebugCell"];
    
    if (indexPath.item == 0) {
        cell.label_title.text = @"修改环境";
        cell.label_detail.text = _currentEnv.title;
    }else if (indexPath.item == 1) {
        cell.label_title.text = @"本地文件";
        cell.label_detail.text = @"";
    }else if (indexPath.item == 2) {
        cell.label_title.text = @"界面层级";
        cell.label_detail.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        SZEnvironmentVC *vc = [[SZEnvironmentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 1)
    {
        SZLocalFilesVC *vc = [[SZLocalFilesVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 2)
    {
        SZViewHierarchyVC *vc = [[SZViewHierarchyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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




