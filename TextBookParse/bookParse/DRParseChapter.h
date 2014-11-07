//
//  DRParseChapter.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-23.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRParseChapterContent.h"
///解析出来的章节信息
@interface DRParseChapter : NSObject
@property (assign,nonatomic) NSInteger index;
@property (strong,nonatomic) NSString *chapterName;
@property (assign,nonatomic) BookRootDicType bookFileType;
@property (assign,nonatomic) BOOL isEndChapter;
#pragma mark txt书籍特有属性
@property (assign,nonatomic)  unsigned long long chapterStartIndex;
@property (assign,nonatomic)  unsigned long long chapterEndIndex;

#pragma mark epub书籍特有属性
@property (strong,nonatomic) NSString *epubChapterFilePath;
///是否是epub指定目录,因为epub有些章节内容没有在目录中
@property (assign,nonatomic) BOOL isEpubCatalog;
@end
