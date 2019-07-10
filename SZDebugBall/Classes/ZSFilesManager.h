//
//  ZSFilesManager.h
//  ZSZipFiles
//
//  Created by  on 14-3-23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZSFilesManager : NSObject
{
    
}


/**
 *  创建一个文件夹，可以选择是否覆盖已存在的文件夹
 *
 *  @param directoryPath 需要创建的文件夹路径
 *  @param override      是否需要覆盖已存在的文件夹
 *
 *  @return YES or NO，创建是否成功
 */
+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath override:(BOOL)override;


/**
 *  判断 path 是否存在，不存在就返回原路径，存在则返回一个带数字的新路径. ext: 原路径为 /a, 如果已存在，则返回/a 2
 *
 *  @param NSString 需要判断的文件路径
 *
 *  @return 新的文件路径
 */
+ (NSString *)getNewPathby:(NSString *)path;


/**
 *  判断一个路径是否文件夹
 *
 *  @param path 需要判断的文件路径
 *
 *  @return YES or No
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path;


/**
 *  获取文件夹中的所有文件数量
 *
 *  @param directoryPath 需要查询的文件夹路径
 *
 *  @param traverse 是否遍历所有子文件夹
 *
 *  @return 整数。文件数量
 */
+ (NSInteger)numberOfFilesInDirectory:(NSString *)directoryPath traverse:(BOOL)traverse;


/**
 *  返回文件的 size 描述，ext: 1G, 3M, 50K...
 *
 *  @param fileSize 文件的大小, 应该为 KB 单位
 *
 *  @return NSString. 文件的 size 描述
 */
+ (NSString *)fileSizeDescriptionWith:(unsigned long long)fileSize;



@end
