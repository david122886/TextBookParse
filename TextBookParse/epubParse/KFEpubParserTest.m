//
//  KFEpubParserTest.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-11-5.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "KFEpubParser.h"
#import "HTMLReader.h"
@interface KFEpubParserTest : XCTestCase

@end

@implementation KFEpubParserTest

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(void)testHtmlParse{
    NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Section0002_0001_0012_0001" ofType:@"xhtml"] encoding:NSUTF8StringEncoding error:nil];
    if (!data) {
        return ;
    }
    HTMLDocument *doc = [HTMLDocument documentWithString:data];
    HTMLElement *body = [doc firstNodeMatchingSelector:@"body"];
    NSArray *imgNodes = [body nodesMatchingSelector:@"img[src]"];
    NSArray *pNodes = [body nodesMatchingSelector:@"*"];
    
    NSMutableArray *ps = [NSMutableArray array];
    NSMutableArray *imgs = [NSMutableArray array];
    for (HTMLElement *node in pNodes) {
        if ([node.tagName isEqualToString:@"img"] && node.attributes[@"src"]) {
            [imgs addObject:node];
        }
        if ([node.tagName isEqualToString:@"p"]) {
            [ps addObject:node];
        }
    }
    NSArray *testNodes = [body nodesMatchingSelector:@"p"];
    NSLog(@"%@",ps);
    XCTAssert(YES,@"ok");
}
@end
