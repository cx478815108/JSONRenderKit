//
//  UIColor+FSAdd.m
//  MyWHUT
//
//  Created by 陈雄 on 16/7/1.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import "UIColor+SSRender.h"

@interface NSString(SSRender)
- (NSString *)ss_stringByTrim;
@end

@implementation NSString(SSRender)
- (NSString *)ss_stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}
@end

@implementation UIColor (SSRender)

// the color exchange code is from YYKit
static inline NSUInteger ss_hexStrToInt(NSString *str)
{
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

// the color exchange code is from YYKit
static BOOL ss_hexStrToRGBA(NSString *str,CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    str = [[str ss_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) { str = [str substringFromIndex:1];}
    else if ([str hasPrefix:@"0X"]) { str = [str substringFromIndex:2];}
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) { return NO;}
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = ss_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = ss_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = ss_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = ss_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = ss_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = ss_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = ss_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = ss_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+(instancetype)ss_colorWithString:(NSString *)string
{
    NSString *testObj=[string lowercaseString];
    if ([testObj hasPrefix:@"rgb"]) {
        return [self ss_colorWithRGBString:testObj];
    }
    else return [self ss_colorWithHexString:testObj];
}

+(instancetype)ss_colorWithHexString:(NSString *)hexStr
{
    CGFloat r, g, b, a;
    if (ss_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

+(instancetype)ss_colorWithRGBString:(NSString *)rgbString
{
    NSString *testObj=[rgbString lowercaseString];
    if ([testObj hasPrefix:@"rgb("] && [testObj hasSuffix:@")"]) {
        NSString *newStr= [testObj stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
        newStr  = [newStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgbs=[newStr componentsSeparatedByString:@","];
        if (rgbs && rgbs.count==3) {
            UIColor *color = [UIColor colorWithRed:[rgbs[0] floatValue]/255.0 green:[rgbs[1] floatValue]/255.0 blue:[rgbs[2] floatValue]/255.0 alpha:1];
            return color;
        }
        return nil;
    }
    
    if ([testObj hasPrefix:@"rgba("] && [testObj hasSuffix:@")"]) {
        NSString *newStr= [testObj stringByReplacingOccurrencesOfString:@"rgba(" withString:@""];
        newStr  = [newStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgbas=[newStr componentsSeparatedByString:@","];
        if (rgbas && rgbas.count==4) {
            UIColor *color = [UIColor colorWithRed:[rgbas[0] floatValue]/255.0 green:[rgbas[1] floatValue]/255.0 blue:[rgbas[2] floatValue]/255.0 alpha:[rgbas[3] floatValue]];
            return color;
        }
        return nil;
    }

    return nil;
}

@end
