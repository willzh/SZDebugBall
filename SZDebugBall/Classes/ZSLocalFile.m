//
//  ZSLocalFile.m
//  ZSZipFiles
//
//  Created by  on 14-3-23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "ZSLocalFile.h"
#import "ZSFilesManager.h"




@implementation NSDate (XFormated)


- (NSString *)zs_simpleFormatedDate
{
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self];
    
    NSInteger m = t/60;
    NSInteger h = m/60;
    NSInteger d = h/24;
    NSInteger M = d/30;
    NSInteger y = M/12;
    
    // NSLog(@"%@, %f, %d, %d, %d, %d, %d", THIS_METHOD, t, m, h, d, M, y);
    if (y > 0) {
        return [NSString stringWithFormat:@"%zdy", y];
    }else if (M > 0) {
        return [NSString stringWithFormat:@"%zdM", M];
    }else if (d > 0) {
        return [NSString stringWithFormat:@"%zdd", d];
    }else if (h > 0) {
        return [NSString stringWithFormat:@"%zdh", h];
    }else if (m > 0) {
        return [NSString stringWithFormat:@"%zdm", m];
    }else {
        return @"0m";
    }
}


- (NSString *)zs_formatedDate:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    
    return [df stringFromDate:self];
}




@end






@implementation ZSLocalFile



#pragma mark - init
- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        NSLog(@"Class:%@----path:%@", NSStringFromClass([self class]), path);
        
        self.path = path;
        
        NSFileManager *fileMan = [NSFileManager defaultManager];
        
        NSDictionary *fileAtt  = [fileMan attributesOfItemAtPath:path error:nil];
        if (fileAtt)
        {
            self.isDirectory         = [ZSFilesManager isDirectoryAtPath:path];
            if (_isDirectory) {
                self.numberOfFiles   = [ZSFilesManager numberOfFilesInDirectory:path traverse:NO];
            }
            
            self.createDate          = [fileAtt fileCreationDate];
            self.modifyDate          = [fileAtt fileModificationDate];
            self.fileSize            = [fileAtt fileSize] / 1024.0;  // Kb
            
            self.fileSizeDescription = [ZSFilesManager fileSizeDescriptionWith:_fileSize];
            self.formatedCreateDate  = [_createDate zs_simpleFormatedDate];
            self.formatedModifyDate  = [_modifyDate zs_simpleFormatedDate];
            
        }
    }
    return self;
}


#pragma mark - Public Methods
- (NSString *)fileName
{
    return [_path lastPathComponent];
}

- (BOOL)isPDFFile
{
    NSString *fileExt = [self.fileName pathExtension];
    
    NSArray *pdfTypes = @[@"pdf"];
    
    return [pdfTypes containsObject:[fileExt lowercaseString]];
}

- (BOOL)isImageFile
{
    NSString *fileExt = [self.fileName pathExtension];

    NSArray *pictureTypes = @[@"jpg", @"jpeg", @"gif", @"thm", @"bmpf", @"bmp", @"tif", @"tiff", @"png", @"cur", @"xbm", @"ico", @"icns", @"j2k", @"tga"];
    
    return [pictureTypes containsObject:[fileExt lowercaseString]];
}












@end
