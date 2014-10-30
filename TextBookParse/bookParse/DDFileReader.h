//
//  DDFileReader.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kChapterNameRegular @"^\\s*[\\S]{0,10}\\s*第\\s*[0-9零一二三四五六七八九十百千万]+\\s*[篇书首集卷回章节部]{1,2}\\s*[\\S]{0,20}\\s*$"
//#define kChapterNameRegular @"[\\S]{0,10}第\\s*[0-9零一二三四五六七八九十百千万]+\\s*[篇书首集卷回章部]{1}[\\S]{0,30}"
#define kChapterNameIndexRegular @"第\\s*[0-9零一二三四五六七八九十百千万]+\\s*[篇书首集卷回章部]{1}"
@interface DDFileReader : NSObject {
    NSString * filePath;
    
    NSString * lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;
@property (nonatomic,assign) unsigned long long currentOffset;
@property (nonatomic,assign) unsigned long long totalFileLength;
@property (nonatomic,strong) NSFileHandle * fileHandle;
@property (nonatomic,assign) NSStringEncoding stringEncoding;
- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;
///判断截取的章节内容是否有意义
-(BOOL)valuableDataFromIndex:(unsigned long long)fromIndex toIndex:(unsigned long long)toIndex;

///判断字符是否是相同章节名称
-(BOOL)hasTheSameChapterName:(NSString*)oneChapterName withAnotherChapterName:(NSString*)anotherChapterName;
///判断该行是否是章节标题
-(BOOL)hasChapterTitleLineData:(NSString*)lineString;
#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end