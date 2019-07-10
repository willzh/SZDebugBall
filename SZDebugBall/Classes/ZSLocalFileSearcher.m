//
//  ZSLocalFileSearcher.m
//  PDFTools
//
//  Created by  on 14-10-29.
//  Copyright (c) 2014年 . All rights reserved.
//


#import "ZSLocalFileSearcher.h"



@implementation ZSLocalFileSearcher




#pragma mark - Public Methods
+ (NSArray *)contentsOfDirectory:(NSString *)dirPath sortBy:(ZSLocalFileSortType)sortType ascending:(BOOL)ascending
{
    if (![ZSFilesManager isDirectoryAtPath:dirPath])
    {
        return nil;
    }
    
    NSMutableArray *filePaths = [NSMutableArray array];
    
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error];
    // NSLog(@"contents:%@", contents);
    
    for (NSString *path in contents)
    {
        if ([path isEqualToString:@".DS_Store"]) {
            continue;
        }
        ZSLocalFile *file = [[ZSLocalFile alloc] initWithPath:[dirPath stringByAppendingPathComponent:path]];
        [filePaths addObject:file];
        
        // NSLog(@"fileName:%@, fileSize:%lld", file.fileName, file.fileSize);
    }
    
    if (sortType == ZSLocalFileSort_Unsort) {
        return filePaths;
    }
    return [self sortFiles:filePaths sortBy:sortType ascending:ascending];
}





+ (NSArray *)sortFiles:(NSMutableArray *)datas sortBy:(ZSLocalFileSortType)sortType ascending:(BOOL)ascending
{
    NSComparator comparator = ^NSComparisonResult(ZSLocalFile *obj1, ZSLocalFile *obj2)
    {
        NSComparisonResult cprRs = NSOrderedAscending;
        switch (sortType)
        {
            case ZSLocalFileSort_CreationDate:
            {
                cprRs = [obj1.createDate compare:obj2.createDate];
            }
                break;
            case ZSLocalFileSort_ModifyDate:
            {
                cprRs = [obj1.modifyDate compare:obj2.modifyDate];
            }
                break;
            case ZSLocalFileSort_FileName:
            {
                cprRs = [[obj1.fileName lowercaseString] compare:[obj2.fileName lowercaseString]]; // 忽略字母大小写
            }
                break;
            case ZSLocalFileSort_FileSize:
            {
                cprRs = [self compareFileSize:obj1 object2:obj2];
            }
                break;
            default:
                break;
        }
        
        if (!ascending) {
            cprRs = -cprRs;  // 如果是降序，需要反向排列
        }
        return cprRs;
    };
    
    return [datas sortedArrayUsingComparator:comparator];
}




+ (void)deleteFileAtPaths:(NSArray *)paths
{
    if (!paths || paths.count == 0) {
        return;
    }
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    for (NSString *path in paths)
    {
        if ([fileMan fileExistsAtPath:path]) {
            [fileMan removeItemAtPath:path error:nil];
        }
    }
}



+ (void)deleteLocalFiles:(NSArray *)localFiles
{
    if (!localFiles || localFiles.count == 0) {
        return;
    }
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    for (ZSLocalFile *file in localFiles)
    {
        if ([fileMan fileExistsAtPath:file.path]) {
            [fileMan removeItemAtPath:file.path error:nil];
        }
    }
}


+ (void)renameFile:(ZSLocalFile *)file withNewName:(NSString *)nameStr
{
    if (!nameStr || nameStr.length == 0) {
        return;
    }
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSString *extStr   = [file.path pathExtension];
    NSString *destPath = [[file.path stringByDeletingLastPathComponent] stringByAppendingFormat:@"/%@.%@", nameStr, extStr];
    //NSLog(@"destPath:%@", destPath);
    if ([fileMan fileExistsAtPath:file.path]) {
        [fileMan moveItemAtPath:file.path toPath:destPath error:nil];
    }
}











#pragma mark - Private Methods
+ (NSComparisonResult)compareFileSize:(ZSLocalFile *)file1 object2:(ZSLocalFile *)file2
{
    if (file1.fileSize < file2.fileSize) {
        return NSOrderedAscending;
    }else if (file1.fileSize > file2.fileSize) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}





@end
