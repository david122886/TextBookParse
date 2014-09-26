//
//  ViewController.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "ViewController.h"
#import "bookParse/DRTextBookParse.h"
#import "NSData+encoding.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    return;
    // 创建文件管理器
    NSDate *beginDate = [NSDate date];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指向文件目录
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *books = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSString *bookFile = nil;
    for (NSString *bookName in books) {
        if ([[bookName lastPathComponent] hasSuffix:@"txt"]) {
            bookFile = [documentsDirectory stringByAppendingPathComponent:bookName];
        }
    }
    
    if (!bookFile) {
        NSLog(@"没有找到书籍");
        return;
    }
//    [DRTextBookParse parseBookWithBookFilePath:bookFile findTheChapterBlock:^(NSString *chapterFilePath) {
//        NSLog(@"%@",chapterFilePath);
//    } withComplete:^(BOOL success) {
//        
//        NSLog(@"读取书籍成功%f",[[NSDate date] timeIntervalSinceDate:beginDate]);
//    } withFailure:^(NSError *error) {
//        NSLog(@"%@",error.userInfo[@"msg"]);
//    }];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:bookFile];
    
    [DRTextBookParse parseBookWithBookFilePath:bookFile progressBlock:^(unsigned long long readLength, unsigned long long totalLength, DRParseChapter *findChapter) {
        NSLog(@"%@",findChapter);
        [fileHandle seekToFileOffset:findChapter.chapterStartIndex];
        NSData *content = [fileHandle readDataOfLength:findChapter.chapterEndIndex - findChapter.chapterStartIndex];
        NSLog(@"%@",[[NSString alloc] initWithData:content encoding:[content getCharEncoding]]);
        NSLog(@"---------------------------------------------------------");
    } withComplete:^(NSArray *chaptersArray) {
//        NSLog(@"%@",chaptersArray);
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error.userInfo[@"msg"]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
