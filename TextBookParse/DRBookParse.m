//
//  DRBookParse.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-10-31.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRBookParse.h"
@implementation DRBookParse

///判断这本书是否解析过
+(BOOL)hasBookParsedWithBookFilePath:(NSString*)filePath{
    return NO;
}

///解析后书籍对应的隐藏目录
+(NSString*)getBookParseDicPathWithBookFilePath:(NSString*)filePath{
    return nil;
}

///判断当前书籍是否正在解析
+(BOOL)hasBookParsedIsWorkingWithBookFilePath:(NSString *)filePath{
    return NO;
}


///获取书籍格式
+(BookRootDicType)getParsedBookTypeWithBookFilePath:(NSString *)filePath{
    if (!filePath) {
        return BookRootDicType_OTHER;
    }
    NSString *extension = [[filePath pathExtension] lowercaseString];
    if ([extension isEqualToString:@"umd"]) {
        return BookRootDicType_UMD;
    }
    if ([extension isEqualToString:@"epub"]) {
        return BookRootDicType_EPUB;
    }
    if ([extension isEqualToString:@"text"] || [extension isEqualToString:@"txt"]) {
        return BookRootDicType_UMD;
    }
    return BookRootDicType_OTHER;
}

+(NSURL*)getAppDocumentPath{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls firstObject];
}
@end
