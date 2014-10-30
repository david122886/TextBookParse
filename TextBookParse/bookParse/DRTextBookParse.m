//
//  DRTextBookParse.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//
#import "DRTextBookParse.h"
#import "DDFileReader.h"
#import "NSData+encoding.h"

@interface DRTextBookParse()
///正在解析的书籍，保存书本路径
@property (nonatomic,strong) NSMutableArray *parsingBookInfo;
///从第几章开始加载
@property (nonatomic,assign) int startLoadChapterIndex;

///判断是否加载发现的开始章节
@property (nonatomic,assign) BOOL shouldFirstChapterBlockWork;

@property (nonatomic,strong) void (^tmpFindFirstChapterBlock)(DRParseChapter *findFirstChapter);
@property (nonatomic,strong) void (^tmpFindChapterBlock)(unsigned long long
readLength,unsigned long long totalLength,DRParseChapter *findChapter);
@property (nonatomic,strong) void (^tmpsuccessBlock)(NSArray *chaptersArray);
@property (nonatomic,strong) void (^tmpFailureBlock)(NSError *error);
@end

@implementation DRTextBookParse
+(id)defaultDRTextBookParse{
    static DRTextBookParse *textBookparse = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textBookparse = [[DRTextBookParse alloc] init];
    });
    return textBookparse;
}

///判断这本书是否解析过
+(BOOL)hasBookParsedWithBookFilePath:(NSString*)filePath{
    if (!filePath) {
        return NO;
    }
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *parseBookDic = [self getBookParseDicPathWithBookFilePath:filePath];
    return [fileManager fileExistsAtPath:parseBookDic];
}


///解析后书籍对应的隐藏目录
+(NSString*)getBookParseDicPathWithBookFilePath:(NSString*)filePath{
    if (!filePath) {
        return nil;
    }
    //指向文件目录
    NSString *parseBookDic = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@".david_%@",[[filePath stringByDeletingPathExtension] lastPathComponent]]];
    return parseBookDic;
}


///判断当前书籍是否正在解析
+(BOOL)hasBookParsedIsWorkingWithBookFilePath:(NSString *)filePath{
    if (!filePath || [[filePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    if ([[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] containsObject:filePath]) {
        return YES;
    }
    return NO;
}


///根据后缀分离目录下的文件
+(NSArray*)filterFileWithFiles:(NSArray*)files withExtension:(NSString*)extension{
    return [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF matches %@",[NSString stringWithFormat:@".+\\.%@",extension]]];
}

+(NSArray*)sortFiles:(NSArray*)files{
    return [files  sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        obj1 = [obj1 stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
        obj2 = [obj2 stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
        NSArray *component1 = [obj1 componentsSeparatedByString:kbookChapterNameSperateChar];
        NSArray *component2 = [obj2 componentsSeparatedByString:kbookChapterNameSperateChar];
        NSString *value1 = component1[0];
        NSString *value2 = component2[0];
        if (value1.integerValue > value2.integerValue) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}
///遍历整本书所有章节信息
+(void)parseBookWithBookFilePath:(NSString*)filePath findTheChapterBlock:(void(^)(NSString *chapterFilePath))findTheChapter withComplete:(void (^)(BOOL success))success withFailure:(void (^)(NSError *error))failure{
    if (!filePath) {
        if(failure)failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"指定的书籍路径为空"}]);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *parsedBookDic = [self getBookParseDicPathWithBookFilePath:filePath];
        if ([self hasBookParsedWithBookFilePath:filePath]) {
            //书籍已经解析成功
            NSError *errorMsg = nil;
            NSArray *chapters = [fileManager contentsOfDirectoryAtPath:parsedBookDic error:&errorMsg];
            chapters = [self sortFiles:chapters];
//            chapters = [self filterFileWithFiles:chapters withExtension:@"txt"];
            BOOL isExistChapters = NO;
            for (NSInteger index = 0;index < chapters.count;index++) {
                NSString *fileName = chapters[index];
                if ([[[fileName pathExtension] lowercaseString] isEqualToString:@"txt"]) {
                    isExistChapters = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (findTheChapter) {
                            findTheChapter([parsedBookDic stringByAppendingPathComponent:fileName]);
                        }
                    });
                }
            }
            if (!isExistChapters) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"指定的书籍没有章节信息"}]);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        success(YES);
                    }
                });
            }
            return;
        }
        
        //解析书籍
        DDFileReader *reader = [[DDFileReader alloc] initWithFilePath:filePath];
        NSAssert(reader != nil, @"查找文件不存在");
        if (reader.totalFileLength <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"书籍无内容"}]);
                }
            });
            return;
        }
        BOOL isMore = YES;
        long long chapterStartIndex = 0ULL;
        long long chapterEndIndex = 0ULL;
        BOOL isHeader = YES;
        long long chapterFileIndex = 0;
        NSString *chapterName = nil;
        while (isMore) {
            long long lineStartIndex = reader.currentOffset;
            NSString *lineData =  [reader readTrimmedLine];
            NSRange range = [lineData rangeOfString:@"第\\s*[0-9零一二三四五六七八九十百千万]+\\s*[篇书首集卷回章节部]+" options:NSRegularExpressionSearch];
            if (range.length >= 2) {
                long long lineEndIndex = reader.currentOffset;
                if (isHeader) {
                    chapterStartIndex = lineEndIndex;
                    isHeader = NO;
                    chapterName = lineData;
//                    DLog(@"%@",chapterName);
                }else{
                    chapterEndIndex = lineStartIndex;
                    
                    [reader.fileHandle seekToFileOffset:chapterStartIndex];//定位开始截取地方
                    NSData *chapterData = [reader.fileHandle readDataOfLength:(NSInteger)(chapterEndIndex - chapterStartIndex)];
                    NSString *stringData = [[NSString alloc] initWithData:chapterData encoding:reader.stringEncoding];
                    if (stringData.length > 0) {
                        if (![fileManager fileExistsAtPath:parsedBookDic]) {
                            [fileManager createDirectoryAtPath:parsedBookDic withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        NSString *path = [parsedBookDic stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@%@.txt",chapterFileIndex,kbookChapterNameSperateChar,chapterName]];
                        path = [path stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
                        [stringData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        chapterFileIndex++;
//                        NSString *tmpContent = [[NSString alloc] initWithData:chapterData encoding:reader.stringEncoding];
//                        DLog(@"%@",tmpContent);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (findTheChapter) {
                                findTheChapter(path);
                            }
                        });
                    }
                    
                    [reader.fileHandle seekToFileOffset:lineEndIndex];//恢复之前的位置
                    chapterStartIndex = lineEndIndex;
                    chapterName = lineData;
                }
            }
            if (!lineData) {
                isMore = NO;
                if (chapterStartIndex <= 0ULL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failure) {
                            failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"书籍内容格式不正确或者编码格式不支持"}]);
                        }
                    });
                    return;
                }
                [reader.fileHandle seekToFileOffset:chapterStartIndex];//定位开始截取地方
                NSData *chapterData = [reader.fileHandle availableData];
                NSString *stringData = [[NSString alloc] initWithData:chapterData encoding:reader.stringEncoding];
                if (stringData.length > 0) {
                    if (![fileManager fileExistsAtPath:parsedBookDic]) {
                        [fileManager createDirectoryAtPath:parsedBookDic withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    NSString *path = [parsedBookDic stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@%@.txt",chapterFileIndex,kbookChapterNameSperateChar,chapterName]];
                    path = [path stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
                    chapterName = nil;
                    [stringData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    chapterFileIndex++;
//                    NSString *tmpContent = [[NSString alloc] initWithData:chapterData encoding:reader.stringEncoding];
//                    DLog(@"%@",tmpContent);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (findTheChapter) {
                            findTheChapter(path);
                        }
                    });
                }
                chapterStartIndex = reader.totalFileLength;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(YES);
            }
        });
    });
}


///chaptersArray 存放是DRParseChapter 对象
+(void)parseBookWithBookFilePath:(NSString *)filePath
           withStartChapterIndex:(int)startIndex
                loadFirstChapter:(void (^)(DRParseChapter *findChapter))findFirstChapterBlock
                   progressBlock:(void (^)(unsigned long long
                                           readLength,unsigned long long totalLength,DRParseChapter *findChapter))findChapterBlock
                    withComplete:(void (^)(NSArray *chaptersArray))success
                     withFailure:(void (^)(NSError *))failure{
    
    [[DRTextBookParse defaultDRTextBookParse] setTmpFindFirstChapterBlock:findFirstChapterBlock];
    [[DRTextBookParse defaultDRTextBookParse] setTmpFindChapterBlock:findChapterBlock];
    [[DRTextBookParse defaultDRTextBookParse] setTmpsuccessBlock:success];
    [[DRTextBookParse defaultDRTextBookParse] setTmpFailureBlock:failure];
    
    [[DRTextBookParse defaultDRTextBookParse] setStartLoadChapterIndex:startIndex >=0?startIndex:0];
    [[DRTextBookParse defaultDRTextBookParse] setShouldFirstChapterBlockWork:YES];
    
    if ([[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] containsObject:filePath]) {
        return;
    }
    
    if (!filePath ||![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if(failure)failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"指定的书籍不存在"}]);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *parsedBookDic = [self getBookParseDicPathWithBookFilePath:filePath];
        NSMutableArray *chapterArray = [[DRParseChapter parseChapterArrayFromPlistFilePath:[parsedBookDic stringByAppendingPathComponent:kBookChapterArrayFileName]] mutableCopy];
        if (chapterArray && chapterArray.count > 0) {
            DRParseChapter *chapter = [chapterArray lastObject];
            if (chapter.isEndChapter) {
                int startIndex = [[DRTextBookParse defaultDRTextBookParse] startLoadChapterIndex];
                if ([[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock] && startIndex < chapterArray.count) {
                    [[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock]([chapterArray objectAtIndex:startIndex]);
                }
                if ([[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock]) {
                    [[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock](chapter.chapterEndIndex,chapter.chapterEndIndex,chapter);
                }
                if([[DRTextBookParse defaultDRTextBookParse] tmpsuccessBlock])[[DRTextBookParse defaultDRTextBookParse] tmpsuccessBlock](chapterArray);
                [[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] removeObject:filePath];
                return ;
            }
        }

        //解析书籍
        DDFileReader *reader = [[DDFileReader alloc] initWithFilePath:filePath];
        NSAssert(reader != nil, @"查找文件不存在");
        if (!reader || reader.totalFileLength <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[DRTextBookParse defaultDRTextBookParse] tmpFailureBlock]) {
                    [[DRTextBookParse defaultDRTextBookParse] tmpFailureBlock]([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"书籍无内容"}]);
                }
            });
            return;
        }
        if (![fileManager fileExistsAtPath:parsedBookDic]) {
            [fileManager createDirectoryAtPath:parsedBookDic withIntermediateDirectories:YES attributes:nil error:nil];
        }
        chapterArray = [NSMutableArray array];
        [[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] addObject:filePath];
        DRParseChapter *tmpChapter = nil;
        unsigned long long lastChapterStartIndex = 0;
        NSMutableArray *waittingSetEndIndexChapterArray = [NSMutableArray array];
        while (reader.currentOffset < reader.totalFileLength) {
            unsigned long long lineStartIndex = reader.currentOffset;
            NSString *lineString =  [reader readLine];
            unsigned long long lineEndIndex = reader.currentOffset;
            if ([reader hasChapterTitleLineData:lineString]) {
                DRParseChapter *lastChapter = [chapterArray lastObject];
                tmpChapter = [[DRParseChapter alloc] init];
                tmpChapter.chapterStartIndex = lineEndIndex;
                tmpChapter.chapterName = lineString;
                tmpChapter.index = (int)[chapterArray count];
                
                
                if (lastChapter) {
                    if (![reader valuableDataFromIndex:lastChapterStartIndex toIndex:lineStartIndex]) {
                        [waittingSetEndIndexChapterArray addObject:lastChapter];
                    }else{
                        for (DRParseChapter *chap in waittingSetEndIndexChapterArray) {
                            chap.chapterEndIndex = lineStartIndex;
                        }
                        [waittingSetEndIndexChapterArray removeAllObjects];
                        lastChapter.chapterEndIndex = lineStartIndex;
                        
                        if (chapterArray.count > 1) {
                            int startIndex = [[DRTextBookParse defaultDRTextBookParse] startLoadChapterIndex];
                            if ([[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock] && [[DRTextBookParse defaultDRTextBookParse] shouldFirstChapterBlockWork] && startIndex < chapterArray.count-1) {
                                [[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock]([chapterArray objectAtIndex:startIndex]);
                                [[DRTextBookParse defaultDRTextBookParse] setShouldFirstChapterBlockWork:NO];
                            }
                            
                            DRParseChapter *tmp = [chapterArray objectAtIndex:chapterArray.count - 2];
                            if ([[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock]) {
                                [[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock](lineEndIndex,reader.totalFileLength,tmp);
                            }
                        }
                    }
                }
                if (chapterArray.count <= 0 || ![reader hasTheSameChapterName:tmpChapter.chapterName withAnotherChapterName:lastChapter.chapterName]) {
                    [chapterArray addObject:tmpChapter];
                }
                lastChapterStartIndex = lineEndIndex;
            }
        }
        
        if (chapterArray.count <= 0) {
            if(failure)failure([NSError errorWithDomain:@"" code:0 userInfo:@{@"msg": @"文件格式不支持或者文档无内容"}]);
            [[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] removeObject:filePath];
            return;
        }
        
        for (DRParseChapter *chap in waittingSetEndIndexChapterArray) {
            chap.chapterEndIndex = reader.totalFileLength;
        }
        DRParseChapter *lastChapter = [chapterArray lastObject];
        if (lastChapter) {
            lastChapter.chapterEndIndex = reader.totalFileLength;
            lastChapter.isEndChapter = YES;
        }
        
        if ([[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock]) {
            [[DRTextBookParse defaultDRTextBookParse] tmpFindChapterBlock](reader.totalFileLength,reader.totalFileLength,lastChapter);
        }

        
        int startIndex = [[DRTextBookParse defaultDRTextBookParse] startLoadChapterIndex];
        if ([[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock] && [[DRTextBookParse defaultDRTextBookParse] shouldFirstChapterBlockWork] && startIndex < chapterArray.count) {
            [[DRTextBookParse defaultDRTextBookParse] tmpFindFirstChapterBlock]([chapterArray objectAtIndex:startIndex]);
            [[DRTextBookParse defaultDRTextBookParse] setShouldFirstChapterBlockWork:NO];
        }
        
        
        [DRParseChapter writeDRParseChaptersArray:chapterArray ToPlistFileWithPlistFilePath:[parsedBookDic stringByAppendingPathComponent:kBookChapterArrayFileName]];
        
        if ([[DRTextBookParse defaultDRTextBookParse] tmpsuccessBlock]) {
            [[DRTextBookParse defaultDRTextBookParse] tmpsuccessBlock](chapterArray);
        }

        [[[DRTextBookParse defaultDRTextBookParse] parsingBookInfo] removeObject:filePath];
    });
}



-(NSMutableArray *)parsingBookInfo{
    if (!_parsingBookInfo) {
        _parsingBookInfo = [NSMutableArray array];
    }
    return _parsingBookInfo;
}
@end
