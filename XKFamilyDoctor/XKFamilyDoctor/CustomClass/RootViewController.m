//
//  RootViewController.m
//  CSB
//
//  Created by DLL on 15-4-13.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "SQLItem.h"
#import "ArchiveClass.h"
@interface RootViewController ()

@end

@implementation RootViewController
//static float hight=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGGRAYCOLOR;
    self.automaticallyAdjustsScrollViewInsets=NO;
    mainWidth=self.view.bounds.size.width;
    mainHeight=self.view.bounds.size.height;
    self.navigationController.navigationBar.barTintColor=GREENCOLOR;
    [self setChoieURL];
}

- (void)setChoieURL{
    mainURL=@"http://116.52.164.58:9802/home_doctor_main";
    NSDictionary *urlDic=[[ArchiveClass new] getLocalUrl];
    NSArray *host=[urlDic objectForKey:@"host"];
    for (NSDictionary *dic in host) {
        if ([CHOICEURL isEqualToString:[dic objectForKey:@"orgName"]]) {
            mainURL=[dic objectForKey:@"app_host"];
            MAINURL=[dic objectForKey:@"app_hr"];
            PICURL=@"http://116.52.164.59:7700/app/";
            GETWXPAY=@"http://116.52.164.59:7701/api/WxCash/";
            
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.MQTT_HOST=[dic objectForKey:@"mqtt_host"];
            appDelegate.MQTT_HOST_ID=[dic objectForKey:@"mqtt_host_id"];
            appDelegate.MQTT_PORT=[[dic objectForKey:@"mqtt_port"] intValue];
        }
    }
    //检查更新接口
    CHECKUPDATATYPE=@"CheckUpdataType";
    CHECKUPDATAURL=[NSString stringWithFormat:@"http://116.52.164.59:7700/upgrade/XKAssistant.txt?%d",(arc4random() % 100000) + 100000];
    
    //上传文件
    UPLOADFILE=@"http://116.52.164.59:7701/api/FileUpload";
    //插入、更新接口
    insetOrUpdataURL=[NSString stringWithFormat:@"%@/sql/excute",mainURL];
    //查询接口
    queryURL=[NSString stringWithFormat:@"%@/sql/query",mainURL];
    //无返回查询接口
    queryWithoutURL=[NSString stringWithFormat:@"%@/sql/queryWithout",mainURL];
    //编辑接口
    excuteURL=[NSString stringWithFormat:@"%@/sql/excute",mainURL];
    
    //用户登录
    USERLOGINTYPE=@"UserLogin";
    USERLOGIN=[NSString stringWithFormat:@"%@/apps/manager/interface/checkAuth",MAINURL];
    
    //获取短信验证码接口
    GETVCTYPE=@"GetVCode";
    getVCode=[NSString stringWithFormat:@"%@/user/verification",mainURL];
    
    //获取事业部列表
    BDLISTTYPE=@"BDListType";
    BDLISTURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getPlate",MAINURL];
    
    //获取科室列表
    DEPLISTTYPE=@"DepListType";
    DEPLISTURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getDepartment",MAINURL];
    
    //获取科室医生信息
    DEPDOCLISTTYPE=@"DepDocListType";
    DEPDOCLISTURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getEmp",MAINURL];
    
    //获取机构列表
    MECLISTTYPE=@"MecListType";
    MECLISTURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getOrg",MAINURL];
    
    //获取岗位列表
    POSTLISTTYPE=@"PostListType";
    POSTLISTURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getPost",MAINURL];
    
    //获取调岗记录
    CHANGEHISTTYPE=@"ChangeHisType";
    CHANGEHISURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getLog",MAINURL];
    
    //保存数据
    SAVEDATATYPE=@"SaveDataType";
    SAVEDATAURL=[NSString stringWithFormat:@"%@/apps/manager/interface/saveEmp",MAINURL];
    
    //修改密码
    CHANGEPWTYPE=@"ChangePWType";
    CHANGEPWTAURL=[NSString stringWithFormat:@"%@/apps/manager/interface/changePassword",MAINURL];
    
    //获取申请列表
    AUDITLISTTYPE=@"AuditlistType";
    AUDITLISTAURL=[NSString stringWithFormat:@"%@/apps/manager/interface/getCheckEmp",MAINURL];
    
    //修改申请
    //获取申请列表
    CHANGEATYPE=@"ChangeAType";
    CHANGEAURL=[NSString stringWithFormat:@"%@/apps/manager/interface/checkEmp",MAINURL];
    
    //调换岗位
    CHANGEPROTYPE=@"ChangeProType";
    CHANGEPROAURL=[NSString stringWithFormat:@"%@/apps/manager/interface/editProperty",MAINURL];
    
    
    //登录注册接口
    LoginType=@"Login";
    Login=[NSString stringWithFormat:@"%@/home_doctor_main/user/loginCustomer",MAINURL];
    
    //绑定公卫账号
    BINDINGTYPE=@"BindingType";
    BINDINGURL=[NSString stringWithFormat:@"%@/apps/manager/interface/bandGw",MAINURL];
    
    //登录公卫账号
    LOGINGWTYPE=@"LoginGWType";
    LOGINGWGURL=[NSString stringWithFormat:@"%@/apps/manager/interface/checkGw",MAINURL];
    
    //获取体检建档签约信息
    IDCARDINFOTYPE=@"IDCARDINFOTYPE";
    IDCARDINFOURL=[NSString stringWithFormat:@"%@/apps/manager/interface/personSelectState",MAINURL];
    
    //重置密码
    RESETPWTYPE=@"ResetType";
    RESETPWGURL=[NSString stringWithFormat:@"%@/apps/manager/interface/resetPassword",MAINURL];
    
    //新版签约接口
    NEWSIGNAPPLYTYPE=@"NewSignApply";
    NEWSIGNAPPLYURL=[NSString stringWithFormat:@"%@/user/signHomeDoctor",mainURL];
    
    //我的用户
    MYUSERTYPE=@"MYUSERTYPE";
    MYUSERURL=[NSString stringWithFormat:@"%@/customer/myCustomer",mainURL];
    
    //获取用户标签
    GETUSERTAGTYPE=@"GETUSERTAGTYPE";
    GETUSERTAGURL=[NSString stringWithFormat:@"%@/customer/customerTags",mainURL];
    
    //获取楼栋住户
    GETHHTYPE=@"GETHHTYPE";
    GETHHURL=[NSString stringWithFormat:@"%@/net/netCells",mainURL];
}

#pragma mark 自定义返回按钮需手动开启滑动返回
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark 添加左边返回按钮
- (void)addLeftButtonItem{
    UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lButton.frame=CGRectMake(0, 0,40,44);
    [lButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    lButton.imageEdgeInsets=UIEdgeInsetsMake(13,0,13,22);
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem=lItem;
}

#pragma mark  返回上一页
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
/* =============UI搭建===========*/
#pragma mark 头部标题
- (void)addTitleView:(NSString*)text{
    UILabel *titleLabel=[self addLabel:CGRectMake(0, 0,200, 20) andText:text andFont:18 andColor:MAINWHITECOLOR andAlignment:1];
    titleLabel.font=[UIFont fontWithName:FONTTYPERE size:18];
    self.navigationItem.titleView=titleLabel;
}

#pragma mark 创建简单UILabel
- (UILabel*)addLabel:(CGRect)frame andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)alignment{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=[UIFont fontWithName:FONTTYPEME size:font];
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

#pragma mark 添加简单UIImageView
- (UIImageView*)addImageView:(CGRect)frame andName:(NSString*)imageName{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    return imageView;
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

#pragma mark 创建简单文字按钮
- (UIButton*)addSimpleButton:(CGRect)bFrame andBColor:(UIColor*)bColor andTag:(NSInteger)tag andSEL:(SEL)selector andText:(NSString*)text andFont:(CGFloat)font andColor:(UIColor*)color andAlignment:(NSInteger)ali{
    UIButton *button=[self addButton:bFrame adnColor:bColor andTag:tag andSEL:selector];
    UILabel *label=[self addLabel:CGRectMake(0, (bFrame.size.height-20)/2, bFrame.size.width, 20) andText:text andFont:font andColor:color andAlignment:ali];
    [button addSubview:label];
    return button;
}

#pragma mark 通用绿色背景白色文字按钮
- (UIButton*)addCurrencyButton:(CGRect)frame andText:(NSString*)text andSEL:(SEL)selector{
    UIButton *button=[self addButton:frame adnColor:GREENCOLOR andTag:0 andSEL:selector];
    UILabel *label=[self addLabel:CGRectMake(0, (frame.size.height-20)/2, frame.size.width, 20) andText:text andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [button.layer setCornerRadius:frame.size.height/2];
    [button addSubview:label];
    return button;
}

#pragma mark 简单文本输入
- (UITextField*)addTextfield:(CGRect)frame andPlaceholder:(NSString*)placeholder andFont:(NSInteger)font andTextColor:(UIColor*)textColor{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.placeholder=placeholder;
    textField.font=[UIFont fontWithName:FONTTYPEME size:font];
    textField.textColor=textColor;
    return textField;
}

#pragma mark 简单单色背景框
- (UIView *)addSimpleBackView:(CGRect)frame andColor:(UIColor*)Color{
    UIView *fBackView=[[UIView alloc]initWithFrame:frame];
    fBackView.backgroundColor=Color;
    return fBackView;
}

/* =============数据处理===========*/
#pragma mark 时间戳转换
- (NSString*)setTime:(NSString*)timeSing{
    NSTimeInterval _interval=[timeSing doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

#pragma mark 设置label字体不同颜色
- (NSMutableAttributedString*)setString:(NSString*)mainString andSubString:(NSString*)subString andDifColor:(UIColor*)color{
    NSRange range=[mainString rangeOfString:subString];
    NSMutableAttributedString *sQString = [[NSMutableAttributedString alloc] initWithString:mainString];
    [sQString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location,range.length)];
    return sQString;
}

#pragma mark 去除Html标签
- (NSString *)setHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    html =  [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html =  [html stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    html =  [html stringByReplacingOccurrencesOfString:@"\\s*" withString:@""];
    html =  [html stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    html =  [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

#pragma mark简单弹出框
- (void)showSimplePromptBox:(id)showVC andMesage:(NSString*)mesage{
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:mesage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    [av addAction:cancelAC];
    [showVC presentViewController:av animated:YES completion:nil];
    
}

#pragma mark带处理事件的提示框
- (void)showPromptBox:(id)showVC andMesage:(NSString*)mesage andSel:(SEL)select{
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:mesage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self performSelector:select withObject:nil afterDelay:0];
    }];
    [av addAction:sureAC];
    
    UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    [av addAction:cancelAC];
    [showVC presentViewController:av animated:YES completion:nil];
}

#pragma mark添加箭头图标
- (void)addGotoNextImageView:(UIView *)bgView{
    UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(bgView.frame.size.width-24,(bgView.frame.size.height-14)/2,14,14)];
    goImagView.image=[UIImage imageNamed:@"arrow_2"];
    [bgView addSubview:goImagView];
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

#pragma mark 判断手机号码
- (BOOL)checkPhoneNumber:(NSString*)phoneNumber{
    if ([phoneNumber isEqualToString:@"1380001"]||[phoneNumber isEqualToString:@"13300001"]||[phoneNumber isEqualToString:@"130"]||[phoneNumber isEqualToString:@"007"]||[phoneNumber isEqualToString:@"008"]) {
        return YES;
    }
    NSString *Regex =@"(13[0-9]|14[57]|15[012356789]|18[0123456789]|17[678])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *userString = [phoneNumber stringByTrimmingCharactersInSet:set];
    return [mobileTest evaluateWithObject:userString]||[phoneNumber isEqualToString:@"123"];
}

#pragma mark 给视图添加单击手势
- (void)addOneTapGestureRecognizer:(UIView*)tapView andSel:(SEL)selector{
    UITapGestureRecognizer *tapOne=[[UITapGestureRecognizer alloc]init];
    tapOne.numberOfTapsRequired=1;
    tapOne.numberOfTouchesRequired=1;
    [tapOne addTarget:self action:selector];
    [tapView addGestureRecognizer:tapOne];
}

#pragma mark 网路请求
- (void)sendRequest:(NSString*)type andPath:(NSString*)path andSqlParameter:(id)sqlParameter and:(id)deleget{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            selfRequest=[[SelfRequestClass alloc]init];
            selfRequest.path=path;
            selfRequest.type=type;
            if ([sqlParameter isKindOfClass:[NSDictionary class]]) {
                selfRequest.dic=sqlParameter;
            }else{
                SQLItem *item=[SQLItem new];
                NSString *sqlString=[item returnSqlString:sqlParameter andType:type];
                selfRequest.dic=@{@"sql":sqlString};
            }
            selfRequest.delegate=deleget;
            if ([type isEqualToString:CHECKUPDATATYPE]||([sqlParameter isKindOfClass:[NSString class]]&&[sqlParameter isEqualToString:@"GET"])) {
                [selfRequest startGetRequestInfo];
            }else{
                [selfRequest startPostRequestInfo];
            }
        });
    });
}

- (NSString*)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (NSString*)getTomorrowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:nextDat];
    return dateString;
}

/**
 两个时间的时间差
 
 @param dateString1 已知时间一
 @param dateString2 已知时间二
 @return 时间差
 */
- (NSArray *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    
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
    if (timeString.length>0) {
        NSArray *timeArray=[timeString componentsSeparatedByString:@" "];
        NSArray *date=[[timeArray objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *time=[[timeArray objectAtIndex:1] componentsSeparatedByString:@":"];
        NSString *resultString=timeString;
        if ([formt isEqualToString:@"yyyy-MM-dd"]||[formt isEqualToString:@""]) {
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
    return @"";
}

#pragma mark 生成UUID
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}

#pragma mark 补全会员卡号
- (NSString*)overMemberCod:(NSString*)starMemberCode{
    NSString *newMemberCode=starMemberCode;
    NSInteger length=8-starMemberCode.length;
    for (int i=0; i<length; i++) {
        newMemberCode=[NSString stringWithFormat:@"0%@",newMemberCode];
    }
    newMemberCode=[NSString stringWithFormat:@"APP%@",newMemberCode];
    return newMemberCode;
}

#pragma mark 空字符串转换
- (NSString *)changeNullString:(NSString*)string{
    NSString *newString=@"";
    if (![string isKindOfClass:[NSNull class]]&&string!=nil) {
        newString=string;
    }
    if ([newString isEqualToString:@"null"]) {
        newString=@"";
    }
    return newString;
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

#pragma mark 身份证校验
- (BOOL)checkIDcard:(NSString*)idCard{
    if ([idCard hasPrefix:@"11111111"]) {
        return YES;
    }
    BOOL isTrue=YES;
    //省份区划码数组（固定）
    NSArray *city=@[@"11",@"12",@"13",@"14",@"15",@"21",@"22",@"23",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",@"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",@"65",@"71",@"81",@"82",@"91"];
    //基本正则表达式
    NSString *Regex =@"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *IdCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newIdCard = [idCard stringByTrimmingCharactersInSet:set];
    //是否符合正则表达式
    if (![IdCardTest evaluateWithObject:newIdCard]) {
        isTrue=NO;
        return isTrue;
    }
    //前两位是否包含在省份区划码中
    else if (![city containsObject:[idCard substringToIndex:2]]){
        isTrue=NO;
        return isTrue;
    }
    else if(idCard.length==18){
        //将身份证号码分割成数组
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        [idCard enumerateSubstringsInRange:NSMakeRange(0, idCard.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [array addObject:substring];
        }];
        //加权数组(固定)
        NSArray *factor = @[@"7",@"9",@"10",@"5", @"8", @"4",@"2", @"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2"];
        //最后一位校验位元素数组(固定)
        NSArray *parity = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        int sum=0;
        int ai=0;
        int wi=0;
        for (int i=0; i<array.count-1; i++) {
            ai=[[array objectAtIndex:i] intValue];
            wi=[[factor objectAtIndex:i] intValue];
            sum+=ai*wi;
        }
        NSString *last=[parity objectAtIndex:sum%11];
        NSString *idLast=[array lastObject];
        if ((([idLast isEqualToString:@"x"]||[idLast isEqualToString:@"X"])&&[last isEqualToString:@"10"])) {
            isTrue=YES;
            return isTrue;
        }else if (![last isEqualToString:idLast]) {
            isTrue=NO;
            return isTrue;
        }
    }else if (idCard.length==15){
        isTrue=YES;
        return isTrue;
    }else{
        isTrue=NO;
        return isTrue;
    }
    return isTrue;
}


- (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *year = nil;
    
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    
    NSString *day = nil;
    
    if([numberStr length]<18)
        
        return result;
    
    //**从第6位开始 截取8个数
    
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(6, 8)];
    
    //**检测前12位否全都是数字;
    
    const char *str = [fontNumer UTF8String];
    
    const char *p = str;
    
    while (*p!='\0') {
        
        if(!(*p>='0'&&*p<='9'))
            
            isAllNumber = NO;
        
        p++;
        
    }
    if(!isAllNumber)
        
        return result;
    
    year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(8, 2)]];
    
    //    NSLog(@"year ==%@",year);
    
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    
    //    NSLog(@"month ==%@",month);
    
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    //    NSLog(@"day==%@",day);
    [result appendString:year];
    
    [result appendString:@"-"];
    
    [result appendString:month];
    
    [result appendString:@"-"];
    
    [result appendString:day];
    
    //    NSLog(@"result===%@",result);
    
    return result;
    
}

- (void)addNoDataView{
    if (!noDataView) {
        noDataView=[[NoDataView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 100)];
        [self.view addSubview:noDataView];
    }else{
        noDataView.hidden=NO;
    }
}

#pragma mark 通过生日计算年龄
- (NSString*)getAgeByBir:(NSString*)birth {
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
    if([date year] >0)
    {
        //        return [NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]];
        return [NSString stringWithFormat:(@"%ld岁"),(long)[date year]];
        
    }
    else if([date month] >0)
    {
        //        return [NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]];
        return [NSString stringWithFormat:(@"%ld月"),(long)[date month]];
    }
    else if([date day]>0){
        return [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
    }
    return @"";
}



- (void)viewDidDisappear:(BOOL)animated{
    //    [mainActivity loadViewHiddin];
    selfRequest.delegate=nil;
    [selfRequest cancelRequest];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
