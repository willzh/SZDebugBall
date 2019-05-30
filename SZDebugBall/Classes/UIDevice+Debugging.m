//
//  UIDevice+Debugging.m
//  MNFloatBtn_Example
//
//  Created by Will on 2019/5/27.
//  Copyright © 2019 miniLV. All rights reserved.
//

#import "UIDevice+Debugging.h"
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

@implementation UIDevice (Debugging)



// 判断是否处于联机调试模式。如果是连接真机或模拟器，并使用XCode安装调试模式，才返回 true。
+ (BOOL)zs_isBeingDebugged
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag =0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) /sizeof(*mib), &info, &size, NULL,0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    return ((info.kp_proc.p_flag &P_TRACED) != 0);
}



@end
