//
//  RootView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIView

/**
 不同颜色文字
 
 @param mainString 整条字符串
 @param subString 要设置不同颜色的字符串
 @param color 不同的颜色
 @return 生成的字符串
 */
- (NSMutableAttributedString*)mainString:(NSString*)mainString andSubString:(NSString*)subString andDifColor:(UIColor*)color;

/**
 简单文字按钮
 
 @param bFrame 按钮位置
 @param bColor 北京颜色
 @param tag tag值
 @param selector 点击事件
 @param text 按钮文字
 @param font 文字大小
 @param color 文字颜色
 @param alignment 文字显示格式
 @return 生成的Button
 */
- (UIButton*)addSimpleButton:(CGRect)bFrame andBColor:(UIColor*)bColor andTag:(NSInteger)tag andSEL:(SEL)selector andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment;

/**
 通用文本
 
 @param frame 文本位置
 @param text 文本内容
 @param font 文本内容字号
 @param color 文字颜色
 @param alignment 显示格式
 @return 生成的Label
 */
- (UILabel*)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment;

- (void)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment andBGView:(UIView*)bgView;
/**
 通用按钮
 
 @param frame 按钮位置
 @param color 背景颜色
 @param tag tag值
 @param selector 点击事件
 @return 生成的Button
 */
- (UIButton*)addButton:(CGRect)frame adnColor:(UIColor*)color andTag:(NSInteger)tag andSEL:(SEL)selector;
//简单线条

/**
 简单线条
 
 @param frame 线条位置
 @param color 线条颜色
 @param backView 添加的视图
 */
- (void)addLineLabel:(CGRect)frame andColor:(UIColor*)color andBackView:(UIView*)backView;

/**
 颜色转换
 
 @param color 颜色字符串
 @return 转换后的颜色
 */
- (UIColor *) colorWithHexString: (NSString *)color;

/**
 带事件弹出框
 
 @param showVC 弹出位置
 @param mesage 消息内容
 @param select 点击事件
 */
- (void)showPromptBox:(id)showVC andMesage:(NSString*)mesage andSel:(SEL)select;


- (void)showSimplePromptBox:(id)showVC andMesage:(NSString*)mesage;

- (BOOL)checkPhoneNumber:(NSString*)phoneNumber;
/**
 空字符串转换
 
 @param string 要转换的字符串
 @return 转换后的字符串
 */
- (NSString *)changeNullString:(id)string;

- (NSString*)changeString:(NSString*)string andType:(NSString*)type;

- (CGFloat)yyLength:(NSString*)yyString;

- (NSString *)getUniqueStrByUUID;
/*==================================时间处理=================================*/

/**
 获取当前时间
 
 @return 当前时间
 */
- (NSString*)getNowTime;

/**
 时间戳转换为时间
 
 @param timeSing 时间戳
 @return 转换后的时间
 */
- (NSString*)setTime:(NSString*)timeSing;
/**
 计算时间差
 
 @param dateStringF 时间一
 @param dateStringT 时间二
 @param formart 时间格式
 @return 时间差
 */
- (NSArray *)intervalFromLastDate: (NSString *) dateStringF  toTheDate:(NSString *) dateStringT andFormat:(NSString*)formart;

/**
 与当前时间的时间差
 
 @param theDate 已知的时间
 @return 时间差
 */
- (CGFloat )intervalSinceNow: (NSString *) theDate;
/**
 截取部分时间
 
 @param timeString 时间字符串
 @param formt 截取目标
 @return 截取结果
 */
- (NSString*)getSubTime:(NSString *)timeString andFormat:(NSString*)formt;
@end
