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
    // This is an example of a functional test case.
    NSString *path = NSHomeDirectory();
    [DREpubBookParse parseBookWithBookFilePath:[NSString stringWithFormat:@"%@/%@",path,@"魔神紫星.epub"] withComplete:^(NSArray *chaptersArray,NSString *bookName,NSString *bookCoverFilePath,NSString *author) {
        
    } withFailure:^(NSError *error) {
        
    }];
    XCTAssert(YES, @"Pass");
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
     NSString *path =  [NSString stringWithFormat:@"%@/jhh/%@",NSHomeDirectory(),@"123.txt"];
    NSString *text = @"slhfioshgiosgjiosf";
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[path stringByDeletingLastPathComponent]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *tt = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",tt);
}

@end
