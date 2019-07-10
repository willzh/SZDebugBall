//
//  SZAppDelegate.m
//  SZDebugBall
//
//  Created by willzh on 05/29/2019.
//  Copyright (c) 2019 willzh. All rights reserved.
//

/*
 iVBORw0KGgoAAAAEQ2dCSVAAIAIr1bN/AAAADUlIRFIAAAEAAAABAAgGAAAAXHKoZgAAABxpRE9UAAAAAgAAAAAAAACAAAAAKAAAAIAAAACAAAADdV1wGlAAAANBSURBVOzdMYjWdRzH8bdhREIiBA0NwiENOdzi0hIJNzWEkxC4ubm11SK0OLdIW0TRopMubg1F0NAU5ZBEYNCgBBWoRJE6/G+MuueO5+F//9/rBd9Z+PL5fg6fu/tdAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAd3snq3+qL6vXoy+FyrXhILlu54ddPB/+v8UL0sIizVseo7h/6f83N1SlRYok8d+J7mfvWquLAkp6vHjnvP82u1LTYsxVVHvfL8UZ0RHZbgRwe9r3lYvSE+HHaPHPO+589qR4Q4zBzyweav6pwYoQDGnX+q86KEAhh3HlcXxQkFMPZcEikUwNhzWaxQAGPPB6KFAhh7PqyOiBgKYNz5rHpGzFAA486N6qiooQDGnVvVc+LGUgvgMLvQ9MM86y6BL6vnRQ4FMD/nmn6sd90l8HXT60ugAGZmp+kXfNZdAt9WJ0QPBTA/r1cPNlACt/PYKApgls40Pfqx7hL4KY+NogBmabvp+a91l8DdaksMUQDz80p1bwMlcG/33wIFMDNbu1+lPTaKAhiwANr9f/qdDZSAx0ZRADP1YtMn9+sugQdN34kABTAzJ6pv2syPDl+p3jdrn3eqswpAAezVC9VX+d2GJf6th49H/BxGAazuWPW5o1nsvK0AFMD/ebbpN/wczPLm75E+jFUA+3e0uu5gFjnfN8hrTgrg4D5yMIuctxSAAtiLI03v/zmaZc0nCkABrOKKo1nU3FEACmBV7zmcRY0CsKiVXWr6U2EOSAEogEFdUAIKQAGM7XzT95QdkgJQAIN6s808NmoUgAKYqZ3qkWNSAApgXK+1mXcGjQJQADO1Xf3mqBSAAhjX6TbzzqCRawUwU1vVL45LASiAcZ3MazzrHLlWAAxMri0KBSDXFoUCkGuLQgHItUWhAOTaopBrubYo5FoBWBRyrQAsCrlWABaFXCsAi0KuLcqikGuLsijk2qIUAHJtUQoAubYoBYBcW5QCQK4tCuTaokCuLQrk2qJAri0K5NqiQK4tCuTaokCuLQrk2qJAri0K5NqiQK4tCuTaokCuLQrk2qJAri0K5NqiYDG5fgoAAP//iP8NWgAAAfBJREFU7dkhTkNRGITRzyPwCFLDArHoKmQXUMsGsBgUBoHpKmqKbZrW1DR5DtK0veck/wbmTuaJV+e3/6eDS6LXgsIA6LWgMAB6LSgMgF4LCgOg14JCr/VaUOi1ARAUem0ABIVeGwBBodcGQFDotaAEhV4LSlDotaAMAHotKAOAXgvKAKDXgjIA6LWgQK8FBXotKNBrQYFeCwr0WlCg14ICvRYU6LWgQK8FBXotKNBrQYFeCwr0WlCg14ICvRYU6LWgQK8FBXotKNBrQYFeCwoDoNeCwgDotaAwAHotKAyAXgsKA6DXgkKv9VpQ6LUBEBR6bQAEhV4bAEGh1wZAUOi1oASFXgtKUOi1oAwAei0oA4BeC8oAoNeCMgDotaBArwUFei0o0GtBgV4LCvRaUKDXggK9FhTotaBArwUFen29QTl3i2cAnDMABsA5A2AAnDMABsA5A2AAnDMABsA5A2AAnDMABsA5A2AAnDMAl+/XIzs3eZsRBuDHQzs3ed8jDMCrh3Zu8uYjDMBTtfPYzp3ctnpsEEsP7tzJLRrIXbXy6M61r74a0H317vHd4Pd2/CAOa1a9VJ/H3yBK4W751tVH9Vw9BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPzRAbR5TVkAAAAASUVORK5CYII=
 
 */

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
    
    
    //NSLog(@"image data:%@", [[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search close.png" ofType:nil]] base64EncodedStringWithOptions:0]);
    
    
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
