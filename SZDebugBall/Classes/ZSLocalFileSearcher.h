//
//  ZSLocalFileSearcher.h
//  PDFTools
//
//  Created by  on 14-10-29.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSLocalFile.h"
#import "ZSFilesManager.h"


typedef NS_ENUM(NSUInteger, ZSLocalFileSortType)
{
    ZSLocalFileSort_Unsort = 0,   // 不排序，搜索出来是什么样就是什么样
    ZSLocalFileSort_CreationDate,
    ZSLocalFileSort_ModifyDate,
    ZSLocalFileSort_FileName,
    ZSLocalFileSort_FileSize,
};


@interface ZSLocalFileSearcher : NSObject
{
    
}


/**
 *  搜索某个文件夹下的所有文件路径，并排序
 *
 *  @param dirPath  需要搜索的文件夹路径
 *  @param sortType 排序类型 ZSLocalFileSortType
 *  @param ascending 升序 or 降序
 *
 *  @return 数组，内部是 ZSLocalFile
 */
+ (NSArray<ZSLocalFile *> *)contentsOfDirectory:(NSString *)dirPath
                                          sortBy:(ZSLocalFileSortType)sortType
                                       ascending:(BOOL)ascending;

/**
 *  对数组进行排序
 *
 *  @param datas     需要排序的数组，内容必须为 ZSLocalFile
 *  @param sortType  排序的类型 ZSLocalFileSortType
 *  @param ascending 升序 or 降序. 升序 YES， 降序 NO
 *
 *  @return 返回排序后的数组，内容为 ZSLocalFile
 */
+ (NSArray<ZSLocalFile *> *)sortFiles:(NSMutableArray *)datas
                                sortBy:(ZSLocalFileSortType)sortType
                             ascending:(BOOL)ascending;



/**
 *  删除指定路径的文件
 *
 *  @param paths 需要删除的文件路径数组
 */
+ (void)deleteFileAtPaths:(NSArray *)paths;



/**
 *  删除指定的文件
 *
 *  @param localFiles 需要删除的文件类，内容为 ZSLocalFile
 */
+ (void)deleteLocalFiles:(NSArray<ZSLocalFile *> *)localFiles;



/**
 *  重命名文件
 *
 *  @param file    需要重命名的文件类
 *  @param nameStr 新的文件名
 */
+ (void)renameFile:(ZSLocalFile *)file withNewName:(NSString *)nameStr;








@end
