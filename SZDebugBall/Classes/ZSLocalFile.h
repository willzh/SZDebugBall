//
//  ZSLocalFile.h
//  ZSZipFiles
//  
//  Created by  on 14-3-23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NSDate (XFormated)

/// 返回日期格式化后的字符串。ext: 3d, 2h, 1Y, 4M...
- (NSString *)zs_simpleFormatedDate;

/// 根据需要的格式来格式化日期
- (NSString *)zs_formatedDate:(NSString *)format;

@end







@interface ZSLocalFile : NSObject
{
    
}

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, retain) NSString *path;    //!< 文件的路径
@property (nonatomic, assign) BOOL isDirectory;  //!< 是否文件夹
@property (nonatomic, assign) NSUInteger numberOfFiles;  //!< 文件夹中的文件数量

@property (nonatomic, retain) NSDate *createDate; //!< 创建日期
@property (nonatomic, retain) NSDate *modifyDate; //!< 更新日期
@property (nonatomic, assign) unsigned long long fileSize; //!< 文件大小

@property (nonatomic, retain) NSString *formatedCreateDate;  //!< 格式化的创建日期
@property (nonatomic, retain) NSString *formatedModifyDate;  //!< 格式化的更新日期
@property (nonatomic, retain) NSString *fileSizeDescription; //!< 文件的大小描述，ext: 3M, 2G, 20K...




/**
 *  ZSLocalFile 实例化类
 *
 *  @param path 文件的路径
 *
 *  @return 返回 ZSLocalFile 实例
 */
- (id)initWithPath:(NSString *)path;

/**
 *  文件名
 *
 *  @return 返回文件名
 */
- (NSString *)fileName;



/**
 *  判断文件是否pdf
 *
 *  @return 是PDF返回YES，否则返回NO
 */
- (BOOL)isPDFFile;


/**
 *  判断文件是否图片
 *
 *  @return 是图片返回YES，否则返回NO
 */
- (BOOL)isImageFile;


@end
