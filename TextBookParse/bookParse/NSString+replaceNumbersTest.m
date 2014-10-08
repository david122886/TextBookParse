//
//  NSString+replaceNumbersTest.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-28.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+replaceNumbers.h"
@interface NSString_replaceNumbersTest : XCTestCase

@end

@implementation NSString_replaceNumbersTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReplaceNumbersWithChineseChar
{
    XCTAssertEqualObjects([@"" replaceNumbersWithChineseChar], @"",@"");
    XCTAssertEqualObjects([@"0" replaceNumbersWithChineseChar], @"零",@"");
    
    XCTAssertEqualObjects([@"10" replaceNumbersWithChineseChar], @"十",@"");
    XCTAssertEqualObjects([@"20" replaceNumbersWithChineseChar], @"二十",@"");
    
    XCTAssertEqualObjects([@"22" replaceNumbersWithChineseChar], @"二十二",@"");
    XCTAssertEqualObjects([@"12" replaceNumbersWithChineseChar], @"十二",@"");
    XCTAssertEqualObjects([@"312" replaceNumbersWithChineseChar], @"三百一十二",@"");
    XCTAssertEqualObjects([@"302" replaceNumbersWithChineseChar], @"三百零二",@"");
    
    XCTAssertEqualObjects([@"101" replaceNumbersWithChineseChar], @"一百零一",@"");
    XCTAssertEqualObjects([@"10100" replaceNumbersWithChineseChar], @"一万零一百",@"");
    XCTAssertEqualObjects([@"101001" replaceNumbersWithChineseChar], @"十万一千零一",@"");
    
    XCTAssertEqualObjects([@"303030030" replaceNumbersWithChineseChar], @"三亿零三百零三万零三十",@"");
    XCTAssertEqualObjects([@"3,0303,0030" replaceNumbersWithChineseChar], @"三亿零三百零三万零三十",@"");
    
    XCTAssertEqualObjects([@"3,0000,0000" replaceNumbersWithChineseChar], @"三亿",@"");
    XCTAssertEqualObjects([@"300,0000" replaceNumbersWithChineseChar], @"三百万",@"");
    XCTAssertEqualObjects([@"300000" replaceNumbersWithChineseChar], @"三十万",@"");
    XCTAssertEqualObjects([@"3000" replaceNumbersWithChineseChar], @"三千",@"");

    XCTAssertEqualObjects([@"30300000000" replaceNumbersWithChineseChar], @"三百零三亿",@"");
    XCTAssertEqualObjects([@"303000000000" replaceNumbersWithChineseChar], @"三千零三十亿",@"");
    XCTAssertEqualObjects([@"3030000000000" replaceNumbersWithChineseChar], @"3030000000000",@"");
    
    XCTAssertEqualObjects([@"3030000000000" replaceNumbersWithChineseChar], @"三万零三百亿",@"");
    XCTAssertEqualObjects([@"100" replaceNumbersWithChineseChar], @"一百",@"");
    
    
}


-(void)testReplaceNumberStringWhenAllDiscoverToChineseChar{
    XCTAssertEqualObjects([@"123" replaceNumberStringWhenAllDiscoverToChineseChar], @"一百二十三", @"");
    XCTAssertEqualObjects([@"35号给你356984块钱!" replaceNumberStringWhenAllDiscoverToChineseChar],@"三十五号给你三十五万六千九百八十四块钱!", @"");
}
@end
