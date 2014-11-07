//
//  DRParseChapter+LocalFile.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-23.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRParseChapter+LocalFile.h"

@implementation DRParseChapter (LocalFile)
+(void)writeDRParseChaptersArray:(NSArray*)parseChapterArr ToPlistFileWithPlistFilePath:(NSString*)plistFilePath{
    if (!parseChapterArr || parseChapterArr.count <= 0 || !plistFilePath || [plistFilePath isEqualToString:@""]) {
        return;
    }
    NSMutableArray *chapterPropertiesArr = [NSMutableArray array];
    for (DRParseChapter *chapter in parseChapterArr) {
        [chapterPropertiesArr addObject:[chapter getPropertiesDic]];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[plistFilePath stringByDeletingLastPathComponent]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[plistFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [chapterPropertiesArr writeToFile:plistFilePath atomically:YES];
}

+(void)writeDRParseChaptersArray:(NSArray*)parseChapterArr withCoverFilePath:(NSString*)coverPath withBookName:(NSString*)bookName withAuthor:(NSString*)author ToPlistFileWithPlistFilePath:(NSString*)plistFilePath{
    if (!parseChapterArr || parseChapterArr.count <= 0 || !plistFilePath || [plistFilePath isEqualToString:@""]) {
        return;
    }
    
    NSString *bookPropertiesPath = [[[plistFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:kbookPropertiesDic] stringByAppendingPathComponent:@"property.plist"];
    NSMutableDictionary *propertiesDic = [NSMutableDictionary dictionary];
    if(bookName) propertiesDic[kBookName] = bookName;
    if(coverPath) propertiesDic[kBookCoverPath] = coverPath;
    if(author) propertiesDic[kBookAuthor] = author;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[bookPropertiesPath stringByDeletingLastPathComponent]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[bookPropertiesPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [propertiesDic writeToFile:bookPropertiesPath atomically:YES];
    [self writeDRParseChaptersArray:parseChapterArr ToPlistFileWithPlistFilePath:plistFilePath];
}

+(NSArray*)parseChapterArrayFromPlistFilePath:(NSString*)plistFilePath{
    if (!plistFilePath) {
        return nil;
    }
    NSArray *chapterPropertiesArr = [NSArray arrayWithContentsOfFile:plistFilePath];
    if (!chapterPropertiesArr || chapterPropertiesArr.count <= 0) {
        return nil;
    }
    NSMutableArray *chapterArr = [NSMutableArray array];
    for (NSDictionary *dic in chapterPropertiesArr) {
        [chapterArr addObject:[self getParseChapterFromProperties:dic]];
    }
    return chapterArr;
}

+(NSDictionary*)parseChapterDicFromPlistFilePath:(NSString*)plistFilePath{
    if (!plistFilePath) {
        return nil;
    }
    NSString *bookPropertiesPath = [[[plistFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:kbookPropertiesDic] stringByAppendingPathComponent:@"property.plist"];
    NSDictionary *propertiesDic = [NSDictionary dictionaryWithContentsOfFile:bookPropertiesPath];
    NSArray *chapters = [self parseChapterArrayFromPlistFilePath:plistFilePath];
    
    if (chapters) {
        if (propertiesDic) {
            return @{@"chapters":chapters,@"properties":propertiesDic};
        }else{
            return @{@"chapters":chapters};
        }
    }
    return nil;
}

-(NSDictionary*)getPropertiesDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    dic[@"index"] = [NSNumber numberWithInt:self.index];
    if(self.chapterName) dic[@"chapterName"] = self.chapterName;
    dic[@"isEndChapter"] = [NSNumber numberWithBool:self.isEndChapter];
    dic[@"bookFileType"] = [NSNumber numberWithInteger:self.bookFileType];
    //new
    if (self.bookFileType == BookRootDicType_EPUB) {
        dic[@"isEpubCatalog"] = [NSNumber numberWithBool:self.isEpubCatalog];
        if(self.epubChapterFilePath) dic[@"epubChapterFilePath"] = self.epubChapterFilePath;
    }else{
        dic[@"chapterStartIndex"] = [NSNumber numberWithLongLong:self.chapterStartIndex];
        dic[@"chapterEndIndex"] = [NSNumber numberWithLongLong:self.chapterEndIndex];
    }
    return dic;
}

+(DRParseChapter*)getParseChapterFromProperties:(NSDictionary*)dic{
    if (!dic || dic.count <= 0) {
        return nil;
    }
    DRParseChapter *chapter = [[DRParseChapter alloc] init];
    chapter.index = [dic[@"index"] intValue];
    chapter.chapterName = dic[@"chapterName"];
    chapter.chapterStartIndex = [dic[@"chapterStartIndex"] longLongValue];
    chapter.chapterEndIndex = [dic[@"chapterEndIndex"] longLongValue];
    chapter.isEndChapter = [dic[@"isEndChapter"] boolValue];
    
    chapter.bookFileType = [dic[@"bookFileType"] integerValue];
    chapter.isEpubCatalog = [dic[@"isEpubCatalog"] boolValue];
    chapter.epubChapterFilePath = dic[@"epubChapterFilePath"];
    return chapter;
}

-(NSString *)description{
    if (self.bookFileType == BookRootDicType_EPUB) {
        return [NSString stringWithFormat:@"index:%d,chapterName:%@,bookFileType:epub,\n epubChapterFilePath:%@\n",self.index,self.chapterName,self.epubChapterFilePath];
    }
    return [NSString stringWithFormat:@"index:%d,chapterName:%@,startIndex:%lld,endIndex:%lld,,isEnd:%@",self.index,self.chapterName,self.chapterStartIndex,self.chapterEndIndex,self.isEndChapter?@"yes":@"no"];
}
@end
