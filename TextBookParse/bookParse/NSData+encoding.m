//
//  NSData+encoding.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-8-6.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "NSData+encoding.h"

@implementation NSData (encoding)
///获取编码格式
-(NSStringEncoding)getCharEncoding{
    if ([[NSString alloc] initWithData:self encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]) {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    if ([[NSString alloc] initWithData:self encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95)]) {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95);
    }
    if ([[NSString alloc] initWithData:self encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80)]) {
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    }
    return NSUTF8StringEncoding;
}
@end
