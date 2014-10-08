//
//  NSString+replaceNumbers.m
//  TextBookParse
//
//  Created by xxsy-ima001 on 14-9-28.
//  Copyright (c) 2014年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "NSString+replaceNumbers.h"

@implementation NSString(replaceNumbers)

///阿拉伯数字替换成中文字符
-(NSString*)replaceNumbersWithChineseChar{
    NSArray *numbers = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    NSArray *unitNumbers = @[@"",@"十",@"百",@"千",@"万",@"亿"];
    NSString *tmpNum = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSRange numRange = [tmpNum rangeOfString:@"[0-9]+" options:NSRegularExpressionSearch];
    if (numRange.location == NSNotFound) {
        return @"";
    }
    if (numRange.length > 12) {
        return self;
    }
    unsigned long long number = [tmpNum substringWithRange:numRange].longLongValue;
    if (number < 10) {
        return numbers[number];
    }
    NSMutableString *result = [NSMutableString string];
    int unitIndex = 4;
    int zeroCount = 0;
    BOOL isInsertZero = YES;
    for (int i = 1; i <= unitNumbers.count; i++) {
        
        
        if (i > 4) {
            if (number%(10*unitIndex) != 0) {
                [result insertString:unitNumbers[unitIndex] atIndex:0];
            }
            unitIndex++;
            i=1;
        }
        
        if (number%10 == 0) {//如果出现多个0，就不显示
            number = number/10;
            zeroCount++;
            if (i > 1 && isInsertZero) {
                [result insertString:[numbers firstObject] atIndex:0];
                isInsertZero = NO;
            }
            continue;
        }else{
            zeroCount = 0;
            isInsertZero = YES;
        }
        
        [result insertString:unitNumbers[i-1] atIndex:0];
        if (number%10 == 1 && i == 2 && number/10 == 0) {
            
        }else{
            [result insertString:numbers[number%10] atIndex:0];
        }
        
        
        if (number < 10) {
            break;
        }
        
        number = number/10;
    }
    if (result.length > 1) {
        NSString *lastChar = [result substringFromIndex:result.length-1];
        if ([lastChar isEqualToString:@"零"]) {
            return [result substringToIndex:result.length-1];
        }
    }
    
    return result;
}

///字符串中所有阿拉伯数字替换成中文字符
-(NSString*)replaceNumberStringWhenAllDiscoverToChineseChar{
    NSString *tmp = [[NSString alloc] initWithFormat:@"%@",self];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"," withString:@""];
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange numRange = [tmp rangeOfString:@"[0-9]+" options:NSRegularExpressionSearch];
    while (numRange.location != NSNotFound) {
        NSString *replaceStr = [[tmp substringWithRange:numRange] replaceNumbersWithChineseChar];
        tmp = [tmp stringByReplacingCharactersInRange:numRange withString:replaceStr];
        numRange = [tmp rangeOfString:@"[0-9]+" options:NSRegularExpressionSearch];
    }
    return tmp;
}
@end
