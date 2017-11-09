//
//  RootTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


- (NSString*)getSubTime:(NSString *)timeString andFormat:(NSString*)formt{
    NSArray *timeArray=[timeString componentsSeparatedByString:@" "];
    NSArray *date=[[timeArray objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *time=[[timeArray objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *resultString=timeString;
    if ([formt isEqualToString:@"yyyy-MM-dd"]) {
        resultString=[timeArray objectAtIndex:0];
    }else if ([formt isEqualToString:@"HH:mm:ss"]){
        resultString=[timeArray objectAtIndex:2];
    }else if ([formt isEqualToString:@"MM-dd"]){
        resultString=[NSString stringWithFormat:@"%@-%@",[date objectAtIndex:1],[date objectAtIndex:2]];
    }else if ([formt isEqualToString:@"HH:mm"]){
        resultString=[NSString stringWithFormat:@"%@:%@",[time objectAtIndex:0],[time objectAtIndex:1]];
    }else if ([formt isEqualToString:@"MM-dd HH:mm"]){
        resultString=[NSString stringWithFormat:@"%@-%@ %@:%@",[date objectAtIndex:1],[date objectAtIndex:2],[time objectAtIndex:0],[time objectAtIndex:1]];
    }
    return resultString;
}

- (NSString*)changeString:(NSString*)string andType:(NSString*)type{
    NSString *returnString=nil;
    if ([type isEqualToString:@"in"]) {
        returnString=[string stringByReplacingOccurrencesOfString:@"[@HC@]" withString:@"\n"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@HH@]" withString:@"\n"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@YH@]" withString:@"'"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@BH@]" withString:@"%"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@ZJH@]" withString:@"<"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"[@YJH@]" withString:@">"];
    }else{
        returnString=[string stringByReplacingOccurrencesOfString:@"\n" withString:@"[@HH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"'" withString:@"[@YH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"%" withString:@"[@BH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@"<" withString:@"[@ZJH@]"];
        returnString=[returnString stringByReplacingOccurrencesOfString:@">" withString:@"[@YJH@]"];
    }
    return returnString;
}

@end
