//
//  DRParseChapter.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-23.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
///解析出来的章节信息
@interface DRParseChapter : NSObject
@property (assign,nonatomic) int index;
@property (strong,nonatomic) NSString *chapterName;
@property (assign,nonatomic)  unsigned long long chapterStartIndex;
@property (assign,nonatomic)  unsigned long long chapterEndIndex;
@property (assign,nonatomic) BOOL isEndChapter;
@end
