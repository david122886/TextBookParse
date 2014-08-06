//
//  DDFileReader.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>

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

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end