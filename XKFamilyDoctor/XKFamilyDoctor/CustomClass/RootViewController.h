//
//  RootViewController.h
//  CSB
//
//  Created by DLL on 15-4-13.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyLoadView.h"
//#import "AFNetworking.h"
#import "SelfRequestClass.h"
#import "NoDataView.h"
@interface RootViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,selfRequestDelegate>
{
    CGFloat mainWidth;
    CGFloat mainHeight;
    UIButton *mainMenuButton;
    id _delegate;
    NoDataView *noDataView;
    SelfRequestClass *selfRequest;
    
    
    NSString *mainURL;
    NSString *MAINURL;
    NSString *PICURL;
    NSString *GETWXPAY;
//    检测更新
    NSString *CHECKUPDATATYPE;
    NSString *CHECKUPDATAURL;
//    上传文件
    NSString *UPLOADFILE;
    
    NSString *insetOrUpdataURL;
    NSString *queryURL;
    NSString *queryWithoutURL;
    NSString *excuteURL;
    NSString *USERLOGINTYPE;
    NSString *USERLOGIN;
    
    NSString *GETVCTYPE;
    NSString *getVCode;
    
    NSString *BDLISTTYPE;
    NSString *BDLISTURL;
    
    NSString *DEPLISTTYPE;
    NSString *DEPLISTURL;
    
    NSString *DEPDOCLISTTYPE;
    NSString *DEPDOCLISTURL;
    
    NSString *MECLISTTYPE;
    NSString *MECLISTURL;
    
    NSString *POSTLISTTYPE;
    NSString *POSTLISTURL;
    
    NSString *CHANGEHISTTYPE;
    NSString *CHANGEHISURL;
    
    NSString *SAVEDATATYPE;
    NSString *SAVEDATAURL;
    
    NSString *CHANGEPWTYPE;
    NSString *CHANGEPWTAURL;
    
    NSString *AUDITLISTTYPE;
    NSString *AUDITLISTAURL;
    
    NSString *CHANGEATYPE;
    NSString *CHANGEAURL;
    
    NSString *CHANGEPROTYPE;
    NSString *CHANGEPROAURL;
    
    NSString *LoginType;
    NSString *Login;
    
    NSString *BINDINGTYPE;
    NSString *BINDINGURL;
    
    NSString *LOGINGWTYPE;
    NSString *LOGINGWGURL;
    
    NSString *RESETPWTYPE;
    NSString *RESETPWGURL;
    
    NSString *NEWSIGNAPPLYTYPE;
    NSString *NEWSIGNAPPLYURL;
    
    NSString *IDCARDINFOTYPE;
    NSString *IDCARDINFOURL;
    
    NSString *MYUSERTYPE;
    NSString *MYUSERURL;
    
    NSString *GETUSERTAGTYPE;
    NSString *GETUSERTAGURL;
    
    NSString *GETHHTYPE;
    NSString *GETHHURL;
}
//通用返回事件
- (void)popViewController;

//选择服务器
- (void)setChoieURL;

/* ====================================UI搭建===================================*/
//标题
- (void)addTitleView:(NSString*)text;
//简单图片
- (UIImageView*)addImageView:(CGRect)frame andName:(NSString*)imageName;
//简单文本框
- (UILabel*)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)ali;

/**
 创建简单局部UILabel

 @param frame 位置信息
 @param text 文本内容
 @param font 文字大小
 @param color 文字颜色
 @param alignment 显示方式
 @param bgView 父视图
 */
- (void)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment andBGView:(UIView*)bgView;
//简单按钮
- (UIButton*)addButton:(CGRect)frame adnColor:(UIColor*)color andTag:(NSInteger)tag andSEL:(SEL)selector;
/**
 通用状态按钮
 */
- (UIButton*)addCurrencyButton:(CGRect)frame andText:(NSString*)text andSEL:(SEL)selector;
//简单纯文字按钮
- (UIButton*)addSimpleButton:(CGRect)bFrame andBColor:(UIColor*)bColor andTag:(NSInteger)tag andSEL:(SEL)selector andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)ali;
/**
 简单文本输入
 */
- (UITextField*)addTextfield:(CGRect)frame andPlaceholder:(NSString*)placeholder andFont:(NSInteger)font andTextColor:(UIColor*)textColor;
//简单单色背景框
- (UIView *)addSimpleBackView:(CGRect)frame andColor:(UIColor*)Color;
//简单线条
- (void)addLineLabel:(CGRect)frame andColor:(UIColor*)color andBackView:(UIView*)backView;
//通用返回按钮
- (void)addLeftButtonItem;

//简单提示框
- (void)showSimplePromptBox:(id)showVC andMesage:(NSString*)mesage;
//带处理事件的提示框
- (void)showPromptBox:(id)showVC andMesage:(NSString*)mesage andSel:(SEL)select;
//添加箭头图标
- (void)addGotoNextImageView:(UIView*)bgView;

/**
 添加无数据视图
 */
- (void)addNoDataView;

/**
 生成UUID
 
 @return UUID
 */
- (NSString *)getUniqueStrByUUID;

- (NSString*)overMemberCod:(NSString*)starMemberCode;

/**
 空字符串转换

 @param string 要转换的字符串
 @return 转换后的字符串
 */
- (NSString *)changeNullString:(NSString*)string;

- (NSString*)changeString:(NSString*)string andType:(NSString*)type;

/**
 身份证号校验
 
 @param idCard 要校验的身份证号
 @return 身份证号是否正确
 */
- (BOOL)checkIDcard:(NSString*)idCard;



/**
 身份证号码获取出生日期

 @param numberStr 身份证号码
 @return 出生日期
 */
- (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;

/* ====================================数据处理===================================*/

//设置labe文字不同颜色
- (NSMutableAttributedString*)setString:(NSString*)mainString andSubString:(NSString*)subString andDifColor:(UIColor*)color;
//去除html标签
- (NSString *)setHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
//颜色转换
- (UIColor *) colorWithHexString: (NSString *)color;
//判断手机号码
- (BOOL)checkPhoneNumber:(NSString*)phoneNumber;
//给视图添加单击手势
- (void)addOneTapGestureRecognizer:(UIView*)tapView andSel:(SEL)selector;

/**
 发送请求
 */
- (void)sendRequest:(NSString*)type andPath:(NSString*)path andSqlParameter:(id)sqlParameter and:(id)deleget;


/*==================================时间处理=================================*/
/**
 获取当前时间
 
 @return 当前时间
 */
- (NSString*)getNowTime;

/**
 获取第二天时间
 
 @return 第二天时间
 */
- (NSString*)getTomorrowTime;

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
 @return 时间差
 */
- (NSArray *)intervalFromLastDate: (NSString *) dateStringF  toTheDate:(NSString *) dateStringT;

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


/**
 生日计算年龄

 @param birth 生日
 @return 年龄
 */
- (NSString*)getAgeByBir:(NSString*)birth;

@end
