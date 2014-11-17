//
//  DREpubBookParseTest.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-11-4.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DREpubBookParse.h"
#import "HTMLReader.h"
@interface DREpubBookParseTest : XCTestCase

@end

@implementation DREpubBookParseTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/%@",paths[0],@"魔神紫星.epub"];
    
    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"魔神紫星" withExtension:@"epub"]];
    [data writeToFile:path atomically:YES];
    
    [DREpubBookParse parseBookWithBookFilePath:path withComplete:^(NSArray *chaptersArray,NSString *bookName,NSString *bookCoverFilePath,NSString *author) {
        DRParseChapter *chapter = chaptersArray[10];
        NSString *data = [NSString stringWithContentsOfFile:[[DRBookParse getAppDocumentPath].path stringByAppendingPathComponent:chapter.epubChapterFilePath] encoding:NSUTF8StringEncoding error:nil];
        if (!data) {
            return;
        }
        HTMLDocument *doc = [HTMLDocument documentWithString:data];
        NSArray *nodes= [doc nodesMatchingSelector:@"body"];
        HTMLNode *body = [nodes firstObject];
        NSString *string = [body  textContent];
        NSLog(@"finished");
        
    } withFailure:^(NSError *error) {
        XCTAssert(NO, @"Pass");
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSString *path = NSHomeDirectory();
        [DREpubBookParse parseBookWithBookFilePath:[NSString stringWithFormat:@"%@/%@",path,@"魔神紫星.epub"] withComplete:^(NSArray *chaptersArray,NSString *bookName,NSString *bookCoverFilePath,NSString *author) {
            
        } withFailure:^(NSError *error) {
            
        }];
        // Put the code you want to measure the time of here.
    }];
}

-(void)testSaveFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/%@",paths[0],@"魔神紫星.epub"];
    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"魔神紫星" withExtension:@"epub"]];
    [data writeToFile:path atomically:YES];

    XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:path],@"文件不存在");
}


-(void)testHtmlParse{
    NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002" ofType:@"xhtml"] encoding:NSUTF8StringEncoding error:nil];
    HTMLDocument *doc = [HTMLDocument documentWithString:data];
    HTMLNode *body = [doc firstNodeMatchingSelector:@"body"];
    if (!body) {
        return;
    }
    
    NSString *string = [body  textContent];
    
    NSArray *imgNodes= [doc nodesMatchingSelector:@"img[src]"];
    string = [string  stringByReplacingOccurrencesOfString:@"[\n]+[\\s]*[\n]+" withString:@"\n" options:NSRegularExpressionSearch range:(NSRange){0,string.length}];
    NSLog(@"%@",string);
    NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([result isEqualToString:@"\n"] || !result || [result isEqualToString:@""]) {
        
    }else{
        
    }

}
@end
