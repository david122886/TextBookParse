//
//  DREpubBookParse.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-10-31.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DREpubBookParse.h"
#import "SSZipArchive.h"
#import "KFEpubParser.h"
#import "DRParseChapter+LocalFile.h"
@interface DREpubBookParse()<SSZipArchiveDelegate>

@end

@implementation DREpubBookParse

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
    NSString *parseBookDic = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",kbookTypeEPUB,[[filePath stringByDeletingPathExtension] lastPathComponent]]];
    return parseBookDic;
}


///判断当前书籍是否正在解析
+(BOOL)hasBookParsedIsWorkingWithBookFilePath:(NSString *)filePath{
    return NO;
}

+(void)parseBookWithBookFilePath:(NSString *)filePath
                    withComplete:(void (^)(NSArray *chaptersArray,NSString *bookName,NSString *bookCoverFilePath,NSString *author))success
                     withFailure:(void (^)(NSError *))failure{
    if (!filePath || [filePath isEqualToString:@""]) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:1548 userInfo:@{@"msg":@"需要解析的书籍不存在"}]);
        }
        return;
    }
    NSString *parsedBookDic = [self getBookParseDicPathWithBookFilePath:filePath];
    NSDictionary *chapterDic = [DRParseChapter parseChapterDicFromPlistFilePath:[parsedBookDic stringByAppendingPathComponent:kBookChapterArrayFileName]];
    NSArray *chaptersArray = chapterDic[@"chapters"];
    NSDictionary *properties = chapterDic[@"properties"];
    if (chaptersArray && chaptersArray.count > 0) {
        if (success) {
            success(chaptersArray,properties[kBookName],properties[kBookCoverPath],properties[kBookAuthor]);
        }
        return;
    }
    
    //解析
    NSString *destination = [self getBookParseDicPathWithBookFilePath:filePath];
    BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:filePath toDestination:destination];
    if (!unzipSuccess) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:1548 userInfo:@{@"msg":@"需要解析的书籍格式不支持"}]);
        }
        return;
    }
    KFEpubParser *parser = [[KFEpubParser alloc] init];
     NSURL *rootFile = [parser rootFileForBaseURL:[NSURL fileURLWithPath:destination]];
    NSString *content = [NSString stringWithContentsOfURL:rootFile encoding:NSUTF8StringEncoding error:nil];
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithXMLString:content options:kNilOptions error:nil];
    if (!document) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:1548 userInfo:@{@"msg":@"需要解析的书籍格式不支持"}]);
        }
        return;
    }
    
    NSDictionary *manifestDic = [parser manifestFromDocument:document];
    if (!manifestDic || manifestDic.count <= 0) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:1548 userInfo:@{@"msg":@"需要解析的书籍格式不支持"}]);
        }
        return;
    }
    NSDictionary *metaDataDic = [parser metaDataFromDocument:document];
    NSString *author = metaDataDic[@"creator"];
    NSString *bookName = metaDataDic[@"title"];
    NSURL *coverUrl = nil;
    NSURL *catalogUrl = nil;
    NSURL *ncxUrl = nil;
    NSInteger index = 0;
    NSMutableArray *parseChapterArray = [[NSMutableArray alloc] init];
    
    NSArray *spineArray = [parser spineFromDocument:document];
    for (NSString *key in spineArray) {
        NSString *contentFile = manifestDic[key][@"href"];
        NSURL *contentURL = [[rootFile URLByDeletingLastPathComponent] URLByAppendingPathComponent:contentFile];
        if ([key isEqualToString:@"catalog"]) {
            catalogUrl = contentURL;
        }else
        if ([key isEqualToString:@"cover"]) {
            coverUrl = contentURL;
        }else
        if ([key isEqualToString:@"ncx"]) {
            ncxUrl = contentURL;
        }else{
            DRParseChapter *chapter = [[DRParseChapter alloc] init];
            chapter.index = index++;
            chapter.bookFileType = BookRootDicType_EPUB;
            chapter.epubChapterFilePath = contentURL.path;
            chapter.isEndChapter = NO;
            chapter.isEpubCatalog = NO;
            [parseChapterArray addObject:chapter];
        }
    }
    DRParseChapter *lastChapter = [parseChapterArray lastObject];
    lastChapter.isEndChapter = YES;
    
    NSArray *parseCatalogArray = nil;
    if (catalogUrl) {
        parseCatalogArray = [parser catalogFromDocumentForCatalogFileURL:catalogUrl];
        for (DRParseChapter *chapter in parseChapterArray) {
            for (NSDictionary *dic in parseCatalogArray) {
                NSURL *src = [[catalogUrl URLByDeletingLastPathComponent] URLByAppendingPathComponent:dic[@"src"]];
                if ([src.path isEqualToString:chapter.epubChapterFilePath]) {
                    chapter.isEpubCatalog = YES;
                    chapter.chapterName = dic[@"text"];
                    break;
                }
            }
        }
        
    }
    
//    NSArray *parseChapterNameArray = nil;
//    if (ncxUrl) {
//        DDXMLDocument *ncxDoc = [[DDXMLDocument alloc] initWithXMLString:[[NSString alloc] initWithContentsOfURL:ncxUrl encoding:NSUTF8StringEncoding error:nil] options:kNilOptions error:nil];
//        parseChapterNameArray = [parser ncxFromDocument:ncxDoc];
//    }
    [DRParseChapter writeDRParseChaptersArray:parseChapterArray withCoverFilePath:coverUrl.path withBookName:bookName withAuthor:author ToPlistFileWithPlistFilePath:[parsedBookDic stringByAppendingPathComponent:kBookChapterArrayFileName]];
    if (success) {
        success(parseChapterArray,bookName,coverUrl.path,author);
    }
}

@end
