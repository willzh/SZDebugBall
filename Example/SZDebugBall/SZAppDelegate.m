//
//  SZAppDelegate.m
//  SZDebugBall
//
//  Created by willzh on 05/29/2019.
//  Copyright (c) 2019 willzh. All rights reserved.
//


#import "SZAppDelegate.h"
//#import <SZDebugBall/SZDebugBall.h>
#import "SZDebugBall.h"

#define BASE_URL [SZEnvironmentManager currentAddress]

@implementation SZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [SZEnvironmentManager configEnvs:@[@"开发", @"测试", @"生产"] address:@[@"http://www.api.com/develop", @"http://www.api.com/test", @"http://www.api.com/product"]];
    
    [SZEnvironmentManager configCurrentAddress:@"http://www.api.com/develop"];
    
    NSLog(@"BASE_URL:%@", BASE_URL);
    
    /// 环境切换成功后的通知。环境切换成功后，会自动退出 App 一次。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(environmentChanged:) name:SZEnvironmentChangedNotification object:nil];
    
    
    return YES;
}


- (void)environmentChanged:(NSNotification *)notice
{
    // 处理环境切换后逻辑，比如退出登录
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
