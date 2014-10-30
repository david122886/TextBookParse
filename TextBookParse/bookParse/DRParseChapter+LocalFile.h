//
//  DRParseChapter+LocalFile.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-23.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRParseChapter.h"
@interface DRParseChapter (LocalFile)
+(void)writeDRParseChaptersArray:(NSArray*)parseChapterArr ToPlistFileWithPlistFilePath:(NSString*)plistFilePath;

+(NSArray*)parseChapterArrayFromPlistFilePath:(NSString*)plistFilePath;

@end
