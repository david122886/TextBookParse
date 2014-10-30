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
    [chapterPropertiesArr writeToFile:plistFilePath atomically:YES];
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


-(NSDictionary*)getPropertiesDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    dic[@"index"] = [NSNumber numberWithInt:self.index];
    if(self.chapterName) dic[@"chapterName"] = self.chapterName;
    dic[@"chapterStartIndex"] = [NSNumber numberWithLongLong:self.chapterStartIndex];
    dic[@"chapterEndIndex"] = [NSNumber numberWithLongLong:self.chapterEndIndex];
    dic[@"isEndChapter"] = [NSNumber numberWithBool:self.isEndChapter];
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
    return chapter;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"index:%d,chapterName:%@,startIndex:%lld,endIndex:%lld,,isEnd:%@",self.index,self.chapterName,self.chapterStartIndex,self.chapterEndIndex,self.isEndChapter?@"yes":@"no"];
}
@end
