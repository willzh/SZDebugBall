//
//  SZDebugBall
//
//
//  Created by Will on 2018/3/8.
//  Copyright © 2018年. All rights reserved.
//

#import "SZDebugBall.h"
#import "SZDebugVC.h"

static NSInteger const kDebugBallWindowLevel = 10000000;
static inline CGFloat zs_screenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}


@interface SZDebugBall ()
{
    // 拖动按钮的起始坐标点
    CGPoint _touchPoint;
    
    // 起始按钮的x, y值
    CGFloat _touchBtnX;
    CGFloat _touchBtnY;
    
    // 直径
    CGFloat ballDiam;
}

@property (nonatomic, strong) UILabel *label_title;

@end



@implementation SZDebugBall

+ (void)load {
    [self showWithDelay];
}

#pragma mark - init Single-Instance
+ (instancetype)sharedInstance
{
    static SZDebugBall *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        ballDiam = 60.0;
        
//        UIViewController *vc = [[UIViewController alloc] init];
//        vc.view.backgroundColor = [UIColor clearColor];
//        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
//        [navCon setNavigationBarHidden:YES animated:NO];
//        navCon.view.backgroundColor = [UIColor clearColor];
        
        self.rootViewController = [[UIViewController alloc] init];
        self.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - ballDiam, 320, ballDiam, ballDiam);
        self.layer.cornerRadius = ballDiam / 2.0;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.label_title];
        [self bringSubviewToFront:_label_title];
        
        self.label_title.text = [[SZEnvironmentManager currentEnv].title substringToIndex:1];
        
    }
    return self;
}

#pragma mark - public Method
+ (void)showWithDelay
{
#ifdef DEBUG
    // 延迟加载，避免 wimdow 还没出现就往上加控件造成的crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self sharedInstance] showInWindow];
    });
#endif
}

+ (void)show
{
#ifdef DEBUG
    [[self sharedInstance] showInWindow];
#endif
}

+ (void)hidden {
    [[self sharedInstance] setHidden:YES];
}


#pragma mark - private Method
- (void)showInWindow
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow; // 先记录下来
    
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.windowLevel = kDebugBallWindowLevel;
    [self makeKeyAndVisible];
    
    [mainWindow makeKeyWindow];
    
    self.label_title.text = [[SZEnvironmentManager currentEnv].title substringToIndex:1];
    
}


#pragma mark - button move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    
    _touchBtnX = self.frame.origin.x;
    _touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    //偏移量(当前坐标 - 起始坐标 = 偏移量)
    CGFloat offsetX = currentPosition.x - _touchPoint.x;
    CGFloat offsetY = currentPosition.y - _touchPoint.y;
    
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
    
    //父试图的宽高
    CGFloat superViewWidth = zs_screenWidth();
    CGFloat superViewHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    
    //x轴左右极限坐标
    if (btnX > superViewWidth){
        //按钮右侧越界
        CGFloat centerX = superViewWidth - btnW/2;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnX < 0){
        //按钮左侧越界
        CGFloat centerX = btnW * 0.5;
        self.center = CGPointMake(centerX, centerY);
    }
    
    //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
    CGFloat defaultNaviHeight = 64;
    CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
    
    //y轴上下极限坐标
    if (btnY <= 0)
    {
        //按钮顶部越界
        centerY = btnH * 0.7;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnY > judgeSuperViewHeight)
    {
        //按钮底部越界
        CGFloat y = superViewHeight - btnH * 0.5;
        self.center = CGPointMake(btnX, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    
    CGFloat minDistance = 2;
    
    // 结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - _touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - _touchBtnY) > minDistance;
    
    if (isOverX || isOverY)
    {
        // 超过移动范围就不响应点击 - 只做移动操作
        NSLog(@"拖动事件");
        [self touchesCancelled:touches withEvent:event];
        
        // 按钮靠边动画
        btnX = 0;
        if (self.center.x >= zs_screenWidth() / 2) {
            btnX = zs_screenWidth() - ballDiam;
        }
        __block CGFloat size = ballDiam;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(btnX, btnY, size, size);
        }];
    }else
    {
        [super touchesEnded:touches withEvent:event];

        [self tapAction];
    }
    
    
}

- (void)tapAction
{
    NSLog(@"点击事件");
    NSLog(@"keyWindow:%@", [UIApplication sharedApplication].keyWindow);
//    [self makeKeyAndVisible];
//    NSLog(@"keyWindow:%@", [UIApplication sharedApplication].keyWindow);
//    self.frame = [UIScreen mainScreen].bounds;
//    self.bounds = UIScreen.mainScreen.bounds;
//    self.backgroundColor = [UIColor redColor];
//    [UIView animateWithDuration:0.3 animations:^{
////        self.layer.cornerRadius = 0.0;
//    } completion:^(BOOL finished) {
//        SZDebugVC *vc = [[SZDebugVC alloc] init];
//        [(UINavigationController *)self.rootViewController pushViewController:vc animated:NO];
//    }];
//    SZDebugVC *vc = [[SZDebugVC alloc] init];
//    [(UINavigationController *)self.rootViewController pushViewController:vc animated:NO];
    
    [SZDebugBall hidden];
    SZDebugVC *vc = [[SZDebugVC alloc] init];
    [[SZDebugBall currentViewController].navigationController pushViewController:vc animated:YES];
}


#pragma mark - lazy loading
- (UILabel *)label_title
{
    if (!_label_title)
    {
        _label_title = [[UILabel alloc] initWithFrame:self.bounds];
        _label_title.font = [UIFont systemFontOfSize:ballDiam / 2.0];
        _label_title.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _label_title.textAlignment = NSTextAlignmentCenter;
    }
    return _label_title;
}





+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController)
    {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }else if ([vc isKindOfClass:[UINavigationController class]])
    {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    }else if ([vc isKindOfClass:[UITabBarController class]])
    {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    }else if ([vc isKindOfClass:[UIAlertController class]])
    {
        // UIAlertController *alert = (UIAlertController *)vc;
        //return [self getCurrentVC];
        return vc;
    }
    return vc;
}

+ (UIViewController *)currentViewController {
    return [self findBestViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}


@end
