//
//  NSString+replaceNumbers.h
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-28.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(replaceNumbers)

///阿拉伯数字替换成中文字符
-(NSString*)replaceNumbersWithChineseChar;

///字符串中所有阿拉伯数字替换成中文字符
-(NSString*)replaceNumberStringWhenAllDiscoverToChineseChar;

@end
