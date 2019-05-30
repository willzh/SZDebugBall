//
//  SZNewEnvironmentVC.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import "SZNewEnvironmentVC.h"
#import "UITextView+Placeholder.h"
#import "SZEnvironmentManager.h"

@interface SZNewEnvironmentVC ()

@property (nonatomic, strong) UITextField *tf_title;  //!< 标题输入框
@property (nonatomic, strong) UITextView *tv_address; //!< 地址输入框

@end


@implementation SZNewEnvironmentVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"New Environment";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tf_title];
    [self.view addSubview:self.tv_address];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    
}

#pragma mark -
- (IBAction)doneAction:(id)sender
{
    NSString *address = _tv_address.text;
    NSString *title = _tf_title.text;
    NSString *errorMsg = [SZEnvironmentManager addEnvWithTitle:title address:address];
    
    // 已存在的情况
    if (errorMsg.length)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"环境配置" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    NSLog(@"保存成功");
    if (_addEnviornmentCompletion) _addEnviornmentCompletion(self);
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - lazy loading
- (UITextField *)tf_title
{
    if (!_tf_title)
    {
        _tf_title = [[UITextField alloc] initWithFrame:CGRectMake(20, 44, CGRectGetWidth(self.view.bounds) - 40, 36)];
        _tf_title.backgroundColor = [UIColor clearColor];
        _tf_title.borderStyle = UITextBorderStyleRoundedRect;
        _tf_title.font = [UIFont systemFontOfSize:15];
        _tf_title.textColor = [UIColor blackColor];
        _tf_title.placeholder = @"Title";
        _tf_title.keyboardType = UIKeyboardTypeDefault;
    }
    return _tf_title;
}

- (UITextView *)tv_address
{
    if (!_tv_address)
    {
        _tv_address = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds) - 40, 120)];
        _tv_address.backgroundColor = [UIColor clearColor];
        _tv_address.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
        _tv_address.layer.borderWidth = 1.0;
        _tv_address.layer.cornerRadius = 3.0;
        _tv_address.layer.masksToBounds = YES;
        _tv_address.font = [UIFont systemFontOfSize:14];
        _tv_address.textColor = [UIColor blackColor];
        _tv_address.keyboardType = UIKeyboardTypeURL;
        _tv_address.ddPlaceholder = @"URL Address";
        
    }
    return _tv_address;
}





@end
