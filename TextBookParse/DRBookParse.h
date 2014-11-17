//
//  DRBookParse.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-10-31.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRParseChapter.h"
#import "DRParseChapterContent.h"
@interface DRBookParse : NSObject
///判断这本书是否解析过,需要子类实现具体方法
+(BOOL)hasBookParsedWithBookFilePath:(NSString*)filePath;

///解析后书籍对应的隐藏目录,需要子类实现具体方法
+(NSString*)getBookParseDicPathWithBookFilePath:(NSString*)filePath;

///判断当前书籍是否正在解析,需要子类实现具体方法
+(BOOL)hasBookParsedIsWorkingWithBookFilePath:(NSString *)filePath;

///获取书籍格式
+(BookRootDicType)getParsedBookTypeWithBookFilePath:(NSString *)filePath;

+(NSURL*)getAppDocumentPath;
@end
