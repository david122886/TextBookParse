//
//  DRParseChapter+LocalFile.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-23.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRParseChapter+LocalFile.h"

@implementation DRParseChapter (LocalFile)
-(void)writeToPlistFileWithPlistFilePath:(NSString*)plistFilePath{
    
}
+(NSArray*)parseChapterArrayFromPlistFilePath:(NSString*)plistFilePath{
    return nil;
}

-(BOOL)judgeIsLastChapterFromBookFilePath:(NSString*)bookFilePath{
    return YES;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"index:%d,chapterName:%@,startIndex:%lld,endIndex:%lld,,isEnd:%@",self.index,self.chapterName,self.chapterStartIndex,self.chapterEndIndex,self.isEndChapter?@"yes":@"no"];
}
@end
