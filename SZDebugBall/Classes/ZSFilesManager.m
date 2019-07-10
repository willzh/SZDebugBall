//
//  ZSFilesManager.m
//  ZSZipFiles
//
//  Created by  on 14-3-23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "ZSFilesManager.h"


@implementation ZSFilesManager



#pragma mark -
+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath override:(BOOL)override
{
	NSFileManager *fileMan = [NSFileManager defaultManager];
    
    // remove existed folder
    if (override) {
        [fileMan removeItemAtPath:directoryPath error:nil];
    }
    
    BOOL isDir = YES;
    if (!([fileMan fileExistsAtPath:directoryPath isDirectory:&isDir]))
    {
        NSError *error = nil;
        BOOL isTure = [fileMan createDirectoryAtPath:directoryPath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:&error];
        NSLog(@"%@ Result:%d, error:%@", NSStringFromSelector(_cmd), isTure, error);
        
        return isTure;
    }
    return YES;
}


+ (NSString *)getNewPathby:(NSString *)path
{
	NSString *pathNoExtension  = [path stringByDeletingPathExtension];
	NSString *pathExtension    = [path pathExtension];
	NSFileManager *fileMan     = [NSFileManager defaultManager];
    
	int i = 2;
	NSString *filePath = path;
	while ([fileMan fileExistsAtPath:filePath])
    {
        if (pathExtension && [pathExtension length])
        {
            filePath = [NSString stringWithFormat:@"%@_%d.%@", pathNoExtension, i, pathExtension];
        }else{
            filePath = [NSString stringWithFormat:@"%@ %d", pathNoExtension, i];
        }
		
		// NSLog(@"getNewPathby --- filePath:%@", filePath);
		i ++;
		if(i > 99999999) {
            break;
        }
	}
    
	return filePath;
}


+ (BOOL)isDirectoryAtPath:(NSString *)path
{
	BOOL result;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&result]) {
		result = NO;
	}
    return result;
}



+ (NSInteger)numberOfFilesInDirectory:(NSString *)directoryPath traverse:(BOOL)traverse
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![self isDirectoryAtPath:directoryPath]) {
        return 1;
    }
    
	NSArray *paths = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    // NSLog(@"%d", paths.count);
    if (!traverse) {
        return paths.count;
    }
    
    NSInteger count = 0;
    for (NSString *path in paths)
    {
        NSString *subPath = [directoryPath stringByAppendingPathComponent:path];
        // NSLog(@"path:%@", path);
        if ([self isDirectoryAtPath:subPath]) {
            count += [self numberOfFilesInDirectory:subPath traverse:traverse];
        }else {
            count ++;
        }
    }
    
    return count;
}




//#define ZS_FileUnit(x) ((x) >= 1024 ? ((x) < 1048576 ? 'M' : 'G') : 'K')   // 返回文件的单位 M，G，K, x为读出的文件大小
//#define ZS_FileSize(x) ((x) >= 1024 ? ((x) < 1048576 ? (x)/1024.0 : (x)/1048576.0) : (x))

+ (NSString *)fileSizeDescriptionWith:(unsigned long long)fileSize
{
    // 1048576 = 1024 * 1024
    unsigned long long G1 = 1048576;
    unsigned long long M1 = 1024;
    
    unsigned long long size = fileSize;
    NSString *unit = @"K";
    if (fileSize >= M1)
    {
        if (fileSize < G1)
        {
            size = fileSize / M1;
            unit = @"M";
        }else
        {
            size = fileSize / G1;
            unit = @"G";
        }
    }
    
    return [NSString stringWithFormat:@"%lld%@", size, unit];
}




@end
