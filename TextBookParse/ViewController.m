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
#import "NSString+replaceNumbers.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
////    NSString *test = @"第1964章 要战便战 ";
//    NSString *test = @"这些强者放在一些中型城市里，那也都是最顶尖的存在，偏偏在这千城之战的战场中，他们却只能屈居于第二集团。";
//    NSRange range = [test rangeOfString:@"^[\\S]{0,10}第\\s*[0-9零一二三四五六七八九十百千万]+\\s*[篇书首集卷回章部]{1}[\\S]{0,30}$" options:NSRegularExpressionSearch];
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
    
    [DRTextBookParse parseBookWithBookFilePath:bookFile loadFirstChapter:^(DRParseChapter *findChapter) {
        NSLog(@"%@",findChapter);
    } progressBlock:^(unsigned long long readLength, unsigned long long totalLength, DRParseChapter *findChapter) {
        NSLog(@"%@",findChapter);
//        [fileHandle seekToFileOffset:findChapter.chapterStartIndex];
//        NSData *content = [fileHandle readDataOfLength:findChapter.chapterEndIndex - findChapter.chapterStartIndex];
//        NSLog(@"%@",[[NSString alloc] initWithData:content encoding:[content getCharEncoding]]);
//        NSLog(@"---------------------------------------------------------");
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
