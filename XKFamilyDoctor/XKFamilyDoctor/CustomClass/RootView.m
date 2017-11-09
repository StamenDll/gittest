//
//  RootView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
#import <AVFoundation/AVAsset.h>
@implementation RootView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark 设置label字体不同颜色
- (NSMutableAttributedString*)mainString:(NSString*)mainString andSubString:(NSString*)subString andDifColor:(UIColor*)color{
    NSRange range=[mainString rangeOfString:subString];
    NSMutableAttributedString *sQString = [[NSMutableAttributedString alloc] initWithString:mainString];
    [sQString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location,range.length)];
    return sQString;
}

#pragma mark 创建简单文字按钮
- (UIButton*)addSimpleButton:(CGRect)bFrame andBColor:(UIColor*)bColor andTag:(NSInteger)tag andSEL:(SEL)selector andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment{
    UIButton *button=[self addButton:bFrame adnColor:bColor andTag:tag andSEL:selector];
    UILabel *label=[self addLabel:CGRectMake(0, (bFrame.size.height-20)/2, bFrame.size.width, 20) andText:text andFont:font andColor:color andAlignment:alignment];
    [button addSubview:label];
    return button;
}

#pragma mark 创建简单UIlabel
- (UILabel*)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
    label.textAlignment=alignment;
    return label;
}

#pragma mark 创建简单局部UIlabel
- (void)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment andBGView:(UIView*)bgView{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=[UIFont systemFontOfSize:font];
    label.textColor=color;
    label.textAlignment=alignment;
    [bgView addSubview:label];
}


#pragma mark 简单通用按钮
- (UIButton*)addButton:(CGRect)frame adnColor:(UIColor*)color andTag:(NSInteger)tag andSEL:(SEL)selector{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    button.backgroundColor=color;
    button.tag=tag;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark 简单单色线条
- (void)addLineLabel:(CGRect)frame andColor:(UIColor*)color andBackView:(UIView*)backView{
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:frame];
    lineLabel.backgroundColor=color;
    [backView addSubview:lineLabel];
}

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

#pragma mark 空字符串转换
- (NSString *)changeNullString:(id)string{
    NSString *newString=@"";
    if (![string isKindOfClass:[NSNull class]]&&string!=nil) {
        if (![string isKindOfClass:[NSString class]]) {
            newString=[string stringValue];
        }else{
            newString=string;
        }
    }
    return newString;
}

- (CGFloat)yyLength:(NSString*)yyString{
//    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,yyString]] options:nil];
//    CMTime audioDuration = audioAsset.duration;
//    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
//    return audioDurationSeconds;
    return 0.1;
}



- (NSString*)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

#pragma mark 时间戳转换
- (NSString*)setTime:(NSString*)timeSing{
    NSTimeInterval _interval=[timeSing doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

/**
 两个时间的时间差
 
 @param dateString1 已知时间一
 @param dateString2 已知时间二
 @return 时间差
 */
- (NSArray *)intervalFromLastDate:(NSString *)dateStringF toTheDate:(NSString *)dateStringT andFormat:(NSString *)formart
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    if (formart.length>0) {
        [date setDateFormat:formart];
    }else{
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    
    NSDate *d1=[date dateFromString:dateStringF];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateStringT ];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    
    sen=[NSString stringWithFormat:@"%@", sen];
    
    
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    min=[NSString stringWithFormat:@"%@", min];
    
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    
    house=[NSString stringWithFormat:@"%@", house];
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    NSArray *timeArray=@[house,min,sen];
    return timeArray;
}

- (CGFloat) intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    timeString = [NSString stringWithFormat:@"%f", cha/60];
    timeString = [timeString substringToIndex:timeString.length-7];
    
    return fabsf([timeString floatValue]);
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

#pragma mark简单弹出框
- (void)showSimplePromptBox:(id)showVC andMesage:(NSString*)mesage{
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:mesage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    [av addAction:cancelAC];
    [showVC presentViewController:av animated:YES completion:nil];
    
}



#pragma mark 判断手机号码
- (BOOL)checkPhoneNumber:(NSString*)phoneNumber{
    if ([phoneNumber isEqualToString:@"1380001"]|[phoneNumber isEqualToString:@"13300001"]) {
        return YES;
    }
    NSString *Regex =@"(13[0-9]|14[57]|15[012356789]|18[0123456789]|17[678])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *userString = [phoneNumber stringByTrimmingCharactersInSet:set];
    return [mobileTest evaluateWithObject:userString]||[phoneNumber isEqualToString:@"123"];
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

#pragma mark 生成UUID
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}

@end
