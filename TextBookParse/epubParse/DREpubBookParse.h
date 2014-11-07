//
//  DREpubBookParse.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-10-31.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRBookParse.h"
@interface DREpubBookParse : DRBookParse
///chaptersArray 存放是DRParseChapter 对象
+(void)parseBookWithBookFilePath:(NSString *)filePath
                    withComplete:(void (^)(NSArray *chaptersArray,NSString *bookName,NSString *bookCoverFilePath,NSString *author))success
                     withFailure:(void (^)(NSError *))failure;
@end
