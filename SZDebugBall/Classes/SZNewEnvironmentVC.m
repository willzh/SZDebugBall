//
//  SZNewEnvironmentVC.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/21.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import "SZNewEnvironmentVC.h"
#import "SZEnvironmentManager.h"
#import <objc/message.h>

@interface SZNewEnvironmentVC ()
{
    CGFloat topH;
}

@property (nonatomic, strong) UITextField *tf_title;  //!< 标题输入框
@property (nonatomic, strong) UITextView *tv_address; //!< 地址输入框

@end


@implementation SZNewEnvironmentVC


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"New Environment";
    
    CGFloat navbarH = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGRect topBarFrame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), navbarH + statusH);
    CGFloat tw = CGRectGetWidth(topBarFrame);
    CGFloat th = CGRectGetHeight(topBarFrame);
    
    topH = th;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tf_title];
    [self.view addSubview:self.tv_address];
    
    
    
    UIView *topBar = [[UIView alloc] initWithFrame:topBarFrame];
    topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBar];
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake((tw - 200) / 2.0, th - 44, 200, 44)];
    label_title.textAlignment = NSTextAlignmentCenter;
    label_title.textColor = [UIColor blackColor];
    label_title.text = @"New Environment";
    [topBar addSubview:label_title];
    
    UIButton *btn_left = [[UIButton alloc] initWithFrame:CGRectMake(0, th - 44, 60, 44)];
    [btn_left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_left setTitle:@"<" forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_left];
    
    UIButton *btn_right = [[UIButton alloc] initWithFrame:CGRectMake(tw - 60, th - 44, 60, 44)];
    [btn_right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_right setTitle:@"完成" forState:UIControlStateNormal];
    [btn_right addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:btn_right];
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    
}

#pragma mark -
- (void)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
        _tf_title = [[UITextField alloc] initWithFrame:CGRectMake(20, topH + 44, CGRectGetWidth(self.view.bounds) - 40, 36)];
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
        _tv_address = [[UITextView alloc] initWithFrame:CGRectMake(20, topH + 100, CGRectGetWidth(self.view.bounds) - 40, 120)];
        _tv_address.backgroundColor = [UIColor clearColor];
        _tv_address.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
        _tv_address.layer.borderWidth = 1.0;
        _tv_address.layer.cornerRadius = 3.0;
        _tv_address.layer.masksToBounds = YES;
        _tv_address.font = [UIFont systemFontOfSize:14];
        _tv_address.textColor = [UIColor blackColor];
        _tv_address.keyboardType = UIKeyboardTypeURL;
        _tv_address.sz_placeholder = @"Address";
        
    }
    return _tv_address;
}





@end



const void *sz_placeholderLabelKey = "sz_placeholderLabel";

@implementation UITextView (SZExt)

- (void)setSz_placeholder:(NSString *)sz_placeholder {
    self.sz_placeholderLabel.text = sz_placeholder;
}

- (NSString *)sz_placeholder {
    return self.sz_placeholderLabel.text;
}

- (void)setSz_placeholderLabel:(UILabel *)sz_placeholderLabel {
    objc_setAssociatedObject(self, sz_placeholderLabelKey, sz_placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)sz_placeholderLabel
{
    UILabel *label = objc_getAssociatedObject(self, sz_placeholderLabelKey);
    if (!label)
    {
        if (self.font == nil) {
            self.font = [UIFont systemFontOfSize:14];
        }
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.numberOfLines = 0;
        label.font = self.font;
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        [self setValue:label forKey:@"_placeholderLabel"];
        [self addSubview:label];
        [self sendSubviewToBack:label];
        
        objc_setAssociatedObject(self, sz_placeholderLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}

@end
