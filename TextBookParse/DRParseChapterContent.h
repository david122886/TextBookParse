//
//  DRParseChapterContent.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14/11/6.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//
///书籍对应目录
#define kbookTypeTEXT @".david"
#define kbookTypeEPUB @".davidEPUB"
#define kbookTypeUMD @".davidUMD"

#define kBookChapterArrayFileName @"chapter_david.plist"

#define kbookPropertiesDic @".davidkbookPropertiesDic"
#pragma mark -
///epub对应字段
#define kBookName @"kepubBookName"
#define kBookCoverPath @"kepubBookCoverPath"
#define kBookAuthor @"kepubBookAuthor"

#pragma mark -

///解析小说书籍格式
typedef NS_ENUM(NSInteger,BookRootDicType) {
    BookRootDicType_TEXT = 210,
    BookRootDicType_EPUB,
    BookRootDicType_UMD,
    BookRootDicType_OTHER,
};