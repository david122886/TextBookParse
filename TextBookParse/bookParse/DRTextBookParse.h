//
//  DRTextBookParse.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRBookParse.h"
#import "DRParseChapter.h"
#import "DRParseChapter+LocalFile.h"

#define kbookChapterNameSperateChar @"#"


///解析txt格式小说，分离出章节单独保存在Document对应小说名目录下，
@interface DRTextBookParse : DRBookParse

///遍历整本书所有章节信息
//+(void)parseBookWithBookFilePath:(NSString*)filePath findTheChapterBlock:(void(^)(NSString *chapterFilePath))findTheChapter withComplete:(void (^)(BOOL success))success withFailure:(void (^)(NSError *error))failure;


///chaptersArray 存放是DRParseChapter 对象
+(void)parseBookWithBookFilePath:(NSString *)filePath
           withStartChapterIndex:(int)startIndex
                loadFirstChapter:(void (^)(DRParseChapter *findChapter))findFirstChapterBlock
                   progressBlock:(void (^)(unsigned long long
                                           readLength,unsigned long long totalLength,DRParseChapter *findChapter))findChapterBlock
                    withComplete:(void (^)(NSArray *chaptersArray))success
                     withFailure:(void (^)(NSError *))failure;

@end
