//
//  SZEnvironmentVC.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import "SZEnvironmentVC.h"
#import "SZNewEnvironmentVC.h"
#import "SZEnvironmentManager.h"

@interface SZEnvironmentVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table; //!< tableView
@property (nonatomic, strong) NSMutableArray <SZEnvironment *> *datas; //!< 数据
@property (nonatomic, strong) SZEnvironment *currentEnv; //!< 当前选中的
@property (nonatomic, assign) NSInteger selectedIndex; //!< 当前选中的索引

@end


@implementation SZEnvironmentVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.title = @"环境配置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat navbarH = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGRect topBarFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), navbarH + statusH);
    CGFloat tw = CGRectGetWidth(topBarFrame);
    CGFloat th = CGRectGetHeight(topBarFrame);
    
    self.datas = [NSMutableArray array];
    [self.view addSubview:self.table];
    _table.contentInset = UIEdgeInsetsMake(th, 0, 0, 0);
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    
    [self.view addSubview:self.table];
    _table.contentInset = UIEdgeInsetsMake(th, 0, 0, 0);
    
    UIView *topBar = [[UIView alloc] initWithFrame:topBarFrame];
    topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBar];
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake((tw - 200) / 2.0, th - 44, 200, 44)];
    label_title.textAlignment = NSTextAlignmentCenter;
    label_title.textColor = [UIColor blackColor];
    label_title.text = @"环境配置";
    [topBar addSubview:label_title];
    
    UIButton *btn_left = [[UIButton alloc] initWithFrame:CGRectMake(0, th - 44, 60, 44)];
    [btn_left addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_left];
    
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, th - 32, 20, 20)];
    btnBg.contentMode = UIViewContentModeScaleAspectFit;
    btnBg.image = [self closeImage];
    [topBar addSubview:btnBg];
    
    UIButton *btn_right = [[UIButton alloc] initWithFrame:CGRectMake(tw - 60, th - 44, 60, 44)];
    [btn_right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_right setTitle:@"完成" forState:UIControlStateNormal];
    [btn_right addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_right];
    
    
    //读取数据
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    [self.datas addObjectsFromArray:config.defaultEnvs];
    [self.datas addObjectsFromArray:config.customEnvs];
    self.currentEnv = [config currentEnv];
    self.selectedIndex = [_datas indexOfObject:_currentEnv];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma mark -
- (void)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender
{
    SZEnvironment *env = _datas[_selectedIndex];
    if ([env isEqual:_currentEnv])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"App 环境将切换为 '%@'，点击确定后，将会退出 App，之后请手动启动您的 App。您确定切换吗？", env.title];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改环境" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SZEnvironmentManager setCurrentEnv:env];
        [[NSNotificationCenter defaultCenter] postNotificationName:SZEnvironmentChangedNotification object:nil];
        // exit 和 abort 都可以退出 App。exit 是正常退出，表现是直接退出。abort 是异常退出，会有错误日志，表现较平滑。
        //exit(0);
        abort();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:cancel];
    [alertVC addAction:confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.datas.count)
    {
        // 添加新环境
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewEnvCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewEnvCell"];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        cell.textLabel.text = @"New Environment";
        
        return cell;
    }
    
    // 已有环境
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NormalCell"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    
    SZEnvironment *model = self.datas[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.address;
    
    if (_selectedIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.datas.count)
    {
        // 添加新环境
        __weak typeof(self) ws = self;
        SZNewEnvironmentVC *vc = [[SZNewEnvironmentVC alloc] init];
        [vc setAddEnviornmentCompletion:^(SZNewEnvironmentVC * _Nonnull vc) {
            [ws reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.datas.count) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.datas.count) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (_datas.count <= 1)
        {
            NSString *msg = [NSString stringWithFormat:@"不能删除最后一个环境"];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        
        // 不能删除当前环境
        SZEnvironment *model = _datas[indexPath.row];
        if ([model isEqual:_currentEnv])
        {
            NSString *msg = [NSString stringWithFormat:@"不能删除当前环境，请先确认切换到其他环境"];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        
        [SZEnvironmentManager deleteEnv:_datas[indexPath.row]];
        [self reloadData];
        
    }
}



#pragma mark - Private Methods
- (void)reloadData
{
    [self.datas removeAllObjects];
    SZEnvironmentConfig *config = [SZEnvironmentConfig loadConfig];
    [self.datas addObjectsFromArray:config.defaultEnvs];
    [self.datas addObjectsFromArray:config.customEnvs];
    self.currentEnv = [config currentEnv];
    self.selectedIndex = [_datas indexOfObject:_currentEnv];
    [self.table reloadData];
}


#pragma mark - lazy loading
- (UITableView *)table
{
    if (!_table)
    {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.alwaysBounceVertical = YES;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _table;
}


/// 关闭图标
- (UIImage *)closeImage
{
    return [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"iVBORw0KGgoAAAAEQ2dCSVAAIAIr1bN/AAAADUlIRFIAAABsAAAAbAgGAAAAj2ZXzQAAABxpRE9UAAAAAgAAAAAAAAA2AAAAKAAAADYAAAA2AAACr6Legx8AAAJ7SURBVOzcv4vaYBzH8UvibyWaKFasVESkiCdikRByIaKoVZMnGrp169atY+dOHbt163bbLb3p6HDTLV26dOnQoUOHQuHgyvU4Sn/YSbiWFvo8hTw+8nnD8w98Xigufnd2EFOKoqQsy3qRz+dtrLHhybIcdxznJAiCFSHkQtM0A6tsMJZt28dBEKzWjxByDrQNTJKk6O9YV9Gy2WwXK20QlmVZR3/CWj/P886AJgjWVTRVVXexGsdM03z+L1jr57ruaTKZvIHlwv9kKaZpHtJgBUGw6vV6+1iPww/C/8CSMF/IWIZhHABLkG9CFizDMA6AxQGr1+vtM2LJmE8ALNM0D4HFIVYsSZIUrBdy3W73GS2WZVlHwBILK4r1Qq7T6TwF1hZj2bZ9DCyBsGRZjmO9kGu3209osRzHOQGWQFiKoiSxXsi1Wq3HwBKkZrP5iBar3++/BBaHGo3GQ0asNNYTAGswGLwCFofq9foDFqxIJKJiPWChv1Wr1e7TYg2Hw9fAEggrGo1qWE8ArNFo9AZYHKpWq/dYsGKxWAHrccBaLpc/aLDG4/FbYHGoUqncZcGKx+PXsB4frO/A2lKsyWTyDlgcKpfLd1iwEonEdazHB+sbDdZ0On0PLA6VSiXCgpVKpapYjwPWYrH4CiwBKhaLt2mxZrPZB2Dxw/pCi5VOp+tYTwCs+Xz+EVgcKhQKAxasTCZzE+txwPJ9/5L2T+DA4pCu63ssWDizwAmLEHIBrC3FwgETvlifKbE+5XK5W1gv5DRNMwgh5zRYOMIlGBbO3HEom812gSUQlud5Z5RYuPrJI1VVd1mwdF3fw3ocsFzXPaXB8n3/Eli/9hMAAP//xX4BygAAAmRJREFU7dw9iNpgHMfxvPiuJCSKFSsVEamgIoEQYi4oilo1Jhq63datW8duXTt263bbbTcdFG66Lrd06dKlQ4cOHQqFKwfHcZS+XKfO7fMM9++Dvy9kFn4fIi7+JemW0jStGwTBeRzHN//6RFF0bZrmnoRo0jStu16vL1jQwjC8Ahphuq5bPGiGYThYTyy0S6ARo4VheAk0gTIMw+FB03Xdwnq0aFcsaOv1+gJohJmmuceDpmlaF+sRokVRdM2CFgTBOdAIK5VKY6DtCFqhULiP9QjRNpvNNxa01Wr1BWiElcvlBzxo+Xy+ifVo0b6zoC2Xy89AI6xSqYQ8aLlcro71CNG22+0PFrTFYvEJaIRVq9WHQNsRtEwmcxfr0aL9ZEGbz+cfgUZYrVbb50FLp9N3sB4t2i8WtNls9gFohNXr9Uc8aKlUqoT1CNFYwOI4vplOp++BRlij0XgMtB1BSyaTBtYTCG0ymbwDGmHNZvMJD1oikdCwnkBo4/H4LdAIa7VaT3nQVFXNYz2i2u32M1a00Wj0BmiEdTqd50DbHbQs1iOq1+u9YEUbDodnQBMQTVGUNNYjqt/vv2RF833/FGhAQyxZlnXAgybLchLrCYTmed4J0MREU7EeUbZtH7Kiua57DDS6ZF40SZIUzEeE5jjOESua4zhHQKNLAZqAaK7rHnOiyZiP4rtRllUeNNu2D4EmJhqiQvM874QVzbKsA6xH2GAweMX4J/mv2Wz2Hpaje9OSvu+f4uCLSD8dFSX9NzScVBIIDUfL/mO04XB4hrOAAqWqavYPGq6lioOW833/dbFY9G/zc38DcgAs3wAAAABJRU5ErkJggg==" options:0]];
}



@end




@implementation SZEnvironmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.label_title];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label_title.frame = CGRectMake(10, CGRectGetHeight(self.contentView.frame) / 2.0 - 15.0, 200, 30);
    
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

@end

