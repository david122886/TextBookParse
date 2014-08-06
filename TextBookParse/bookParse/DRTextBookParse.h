//
//  DRTextBookParse.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
///解析txt格式小说，分离出章节单独保存在Document对应小说名目录下，
@interface DRTextBookParse : NSObject
///判断这本书是否解析过
+(BOOL)hasBookParsedWithBookFilePath:(NSString*)filePath;

///遍历整本书所有章节信息
+(void)parseBookWithBookFilePath:(NSString*)filePath findTheChapterBlock:(void(^)(NSString *chapterFilePath))findTheChapter withComplete:(void (^)(BOOL success))success withFailure:(void (^)(NSError *error))failure;
@end
