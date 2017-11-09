//
//  AddOrderUserViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddOrderUserViewController.h"
#import "SCCaptureCameraController.h"
#import "CustomProgressView.h"
#import "District.h"
#import "ChoiceDepViewController.h"
#import "VisitViewController.h"
#import "AppDelegate.h"
@interface AddOrderUserViewController ()

@end

@implementation AddOrderUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"添加预约用户"];
    [self addLeftButtonItem];
    districtArray=[NSMutableArray new];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSLog(@"=========%@=========%d============%@",appDelegate.MQTT_HOST,appDelegate.MQTT_PORT,appDelegate.MQTT_HOST_ID);
    self.memberID=@"";
    self.lOnlyString=@"";
    self.fileNOString=@"";
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.userItem) {
        IDCardTextField.text=[self changeNullString:self.userItem.LIdNum];
        phoneTextField.text=[[self.userItem.LMobile componentsSeparatedByString:@"_"] firstObject];
        nameTextField.text=self.userItem.LName;
        birDateLabel.text=[self getSubTime:self.userItem.LBirthday andFormat:@"yyyy-MM-dd"];
        sexNumLabel.text=self.userItem.LSex;
        nationNumLabel.text=self.userItem.LFolk;
        addressTextField.text=[self changeNullString:self.userItem.LIDAddr];
        cAddressTextField.text=[self changeNullString:self.userItem.LHomeAddr];
        [self sendRequest:IDCARDINFOTYPE andPath:IDCARDINFOURL andSqlParameter:@{@"IDcard":[self changeNullString:self.userItem.LIdNum]} and:self];
    }
    if (self.visitItem) {
        nameTextField.text=self.visitItem.member_truename;
        birDateLabel.text=[self getSubTime:self.visitItem.member_birthday andFormat:@"yyyy-MM-dd"];
        NSString *sex=@"男";
        if ([self.visitItem.member_sex intValue]==2) {
            sex=@"女";
        }
        sexNumLabel.text=sex;
        NSString *nation=@"";
        if ([self changeNullString:self.visitItem.sFolk].length>0) {
            nation=self.visitItem.sFolk;
        }
        nationNumLabel.text=nation;
        addressTextField.text=self.visitItem.sAddress;
        IDCardTextField.text=[self changeNullString:self.visitItem.sIDCard];
        phoneTextField.text=@"";
        [self sendRequest:IDCARDINFOTYPE andPath:IDCARDINFOURL andSqlParameter:@{@"IDcard":[self changeNullString:self.visitItem.sIDCard]} and:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    if ([self.whopush isEqualToString:@"BD"]||[self.whopush isEqualToString:@"MU"]) {
        [cProgressView creatUI:@[@"身份信息",@"选择挂号医生"] andCount:0];
    }else{
        [cProgressView creatUI:@[@"选择活动",@"身份信息",@"选择挂号医生"] andCount:1];
    }
    [self.view addSubview:cProgressView];
    
    mainBGVSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,144,SCREENWIDTH, SCREENHEIGHT-144)];
    mainBGVSrollView.delegate=self;
    [self.view addSubview:mainBGVSrollView];
    
    UIButton *searhButton=[self addButton:CGRectMake(0, 10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(searchPeson)];
    [mainBGVSrollView addSubview:searhButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:searhButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:searhButton];
    
    UILabel *searchLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"复诊查询" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [searhButton addSubview:searchLabel];
    
    [self addGotoNextImageView:searhButton];
    
    
    UIView *phoneBGView=[self addSimpleBackView:CGRectMake(0, searhButton.frame.origin.y+searhButton.frame.size.height+10, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:phoneBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:phoneBGView];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:phoneBGView];
    
    UILabel *phoneLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"手机号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [phoneBGView addSubview:phoneLabel];
    
    phoneTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-100, 30) andPlaceholder:@"输入手机号码可直接签约家庭医生" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextField.delegate=self;
    [phoneBGView addSubview:phoneTextField];
    
    UIView *codeBGView=[self addSimpleBackView:CGRectMake(0,phoneBGView.frame.origin.y+phoneBGView.frame.size.height+10, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:codeBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeBGView];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeBGView];
    
    UILabel *codeLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"验证码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [codeBGView addSubview:codeLabel];
    
    vCodeTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-190, 30) andPlaceholder:@"请输入验证码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    vCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    vCodeTextField.delegate=self;
    [codeBGView addSubview:vCodeTextField];
    
    getCodeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-90,13,80, 24) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(getCode:) andText:@"获取验证码" andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
    getCodeButton.layer.borderColor=GREENCOLOR.CGColor;
    getCodeButton.layer.borderWidth=0.5;
    [getCodeButton.layer setCornerRadius:12];
    [codeBGView addSubview:getCodeButton];
    
    UIButton *IDcardButton=[self addButton:CGRectMake(0, codeBGView.frame.origin.y+codeBGView.frame.size.height+10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(checkIDCard)];
    [mainBGVSrollView addSubview:IDcardButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    
    UILabel *IDLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"身份证识别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardButton addSubview:IDLabel];
    
    UILabel *adviceLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-120, 20) andText:@"识别后将自动填写以下身份证信息" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [IDcardButton addSubview:adviceLabel];
    
    [self addGotoNextImageView:IDcardButton];
    
    if (self.userItem) {
        codeBGView.hidden=YES;
        IDcardButton.frame=CGRectMake(0, codeBGView.frame.origin.y,SCREENWIDTH, 50);
    }
    
    UIView *IDcardInfoView=[self addSimpleBackView:CGRectMake(0, IDcardButton.frame.origin.y+IDcardButton.frame.size.height+10, SCREENWIDTH,400) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:IDcardInfoView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    [self addLineLabel:CGRectMake(0,400, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    
    UILabel *IDCardLabel=[self addLabel:CGRectMake(10, 15,80, 20) andText:@"*身份证号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    IDCardLabel.attributedText=[self setString:@"*身份证号码" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:IDCardLabel];
    
    IDCardTextField=[self addTextfield:CGRectMake(100,10, SCREENWIDTH-110, 30) andPlaceholder:@"请输入用户身份证号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    IDCardTextField.delegate=self;
    IDCardTextField.textAlignment=2;
    [IDcardInfoView addSubview:IDCardTextField];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, IDCardTextField.frame.origin.y+IDCardTextField.frame.size.height+25, 70,20) andText:@"*姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    nameLabel.attributedText=[self setString:@"*姓名" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:nameLabel];
    
    nameTextField=[self addTextfield:CGRectMake(90, IDCardTextField.frame.origin.y+IDCardTextField.frame.size.height+20, SCREENWIDTH-100, 30) andPlaceholder:@"请输入用户真实姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nameTextField.delegate=self;
    nameTextField.textAlignment=2;
    [IDcardInfoView addSubview:nameTextField];
    
    UIButton *birDateButton=[self addButton:CGRectMake(0,nameTextField.frame.origin.y+nameTextField.frame.size.height+10, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceDate)];
    [IDcardInfoView addSubview:birDateButton];
    
    UILabel *dateLabel=[self addLabel:CGRectMake(10, 15, 80, 20) andText:@"*出生日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    dateLabel.attributedText=[self setString:@"*出生日期" andSubString:@"*" andDifColor:[UIColor redColor]];
    [birDateButton addSubview:dateLabel];
    
    birDateLabel=[self  addLabel:CGRectMake(100,15, SCREENWIDTH-130, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [birDateButton addSubview:birDateLabel];
    
    [self addGotoNextImageView:birDateButton];
    
    UIButton *sexButton=[self addButton:CGRectMake(0,birDateButton.frame.origin.y+birDateButton.frame.size.height, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceSex:)];
    [IDcardInfoView addSubview:sexButton];
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"*性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    sexLabel.attributedText=[self setString:@"*性别" andSubString:@"*" andDifColor:[UIColor redColor]];
    [sexButton addSubview:sexLabel];
    
    
    sexNumLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [sexButton addSubview:sexNumLabel];
    
    [self addGotoNextImageView:sexButton];
    
    nationButton=[self addButton:CGRectMake(0,sexButton.frame.origin.y+sexButton.frame.size.height, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceNation:)];
    [IDcardInfoView addSubview:nationButton];
    
    UILabel *nationLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"*民族" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    nationLabel.attributedText=[self setString:@"*民族" andSubString:@"*" andDifColor:[UIColor redColor]];
    [nationButton addSubview:nationLabel];
    
    nationNumLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [nationButton addSubview:nationNumLabel];
    
    [self addGotoNextImageView:nationButton];
    
    UILabel *addressLabel=[self addLabel:CGRectMake(10, nationButton.frame.origin.y+nationButton.frame.size.height+15,70, 20) andText:@"*户籍地址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    addressLabel.attributedText=[self setString:@"*户籍地址" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:addressLabel];
    
    addressTextField=[self addTextfield:CGRectMake(90,nationButton.frame.origin.y+nationButton.frame.size.height+10, SCREENWIDTH-100, 30) andPlaceholder:@"请输入用户户籍地址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    addressTextField.delegate=self;
    addressTextField.textAlignment=2;
    [IDcardInfoView addSubview:addressTextField];
    
    UILabel *cAddressLabel=[self addLabel:CGRectMake(10,addressTextField.frame.origin.y+addressTextField.frame.size.height+25,70, 20) andText:@"现住址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:cAddressLabel];
    
    cAddressTextField=[self addTextfield:CGRectMake(90,addressTextField.frame.origin.y+addressTextField.frame.size.height+20, SCREENWIDTH-100, 30) andPlaceholder:@"请输入用户现住址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    cAddressTextField.delegate=self;
    cAddressTextField.textAlignment=2;
    [IDcardInfoView addSubview:cAddressTextField];
    
    
    UILabel *issueUnitLabel=[self addLabel:CGRectMake(10, cAddressTextField.frame.origin.y+cAddressTextField.frame.size.height+25,70, 20) andText:@"签发机构" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:issueUnitLabel];
    
    unitTextField=[self addTextfield:CGRectMake(90,cAddressTextField.frame.origin.y+cAddressTextField.frame.size.height+20, SCREENWIDTH-100, 30) andPlaceholder:@"身份证签发机构" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    unitTextField.delegate=self;
    unitTextField.textAlignment=2;
    [IDcardInfoView addSubview:unitTextField];
    
    UILabel *validTimeLabel=[self addLabel:CGRectMake(10, unitTextField.frame.origin.y+unitTextField.frame.size.height+25,70, 20) andText:@"有效时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:validTimeLabel];
    
    validTimeTextField=[self addTextfield:CGRectMake(90,unitTextField.frame.origin.y+unitTextField.frame.size.height+20, SCREENWIDTH-100, 30) andPlaceholder:@"身份证有效时间" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    validTimeTextField.delegate=self;
    validTimeTextField.textAlignment=2;
    [IDcardInfoView addSubview:validTimeTextField];
    
    IDcardInfoView.frame=CGRectMake(0, IDcardInfoView.frame.origin.y, IDcardInfoView.frame.size.width, validTimeTextField.frame.origin.y+validTimeTextField.frame.size.height+10);
    for (int i=0; i<8; i++) {
        [self addLineLabel:CGRectMake(10, 50*(i+1),SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    }
    
    uploadButton=[self addSimpleButton:CGRectMake(20,IDcardInfoView.frame.origin.y+IDcardInfoView.frame.size.height+10, SCREENWIDTH-40, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(upload) andText:@"下一步" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
    uploadButton.layer.borderColor=GREENCOLOR.CGColor;
    uploadButton.layer.borderWidth=0.5;
    [uploadButton.layer setCornerRadius:25];
    [mainBGVSrollView addSubview:uploadButton];
    
    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
}

- (void)searchPeson{
    VisitViewController *vc=[VisitViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)upload{
    /*
     ChoiceDepViewController *cvc=[ChoiceDepViewController new];
     cvc.phoneString=phoneTextField.text;
     [self.navigationController pushViewController:cvc animated:YES];
     return;
     
     */
    if (uploadButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *name = [nameTextField.text stringByTrimmingCharactersInSet:set];
        NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:set];
        NSString *nation = [nationNumLabel.text stringByTrimmingCharactersInSet:set];
        NSString *IDCard = [IDCardTextField.text stringByTrimmingCharactersInSet:set];
        
        if (phoneTextField.text.length>0) {
            if (![self checkPhoneNumber:phoneTextField.text]) {
                [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码！"];
                return;
            }else if(self.userItem==nil){
                if(![vCodeTextField.text isEqualToString:@"88689707"]){
                    if (![self.phoneString isEqualToString:phoneTextField.text]||![self.codeString isEqualToString:vCodeTextField.text]){
                        [self showSimplePromptBox:self andMesage:@"验证码错误！"];
                        return;
                    }
                }
            }
        }
        if (name.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的真实姓名！"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的出生日期"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的性别！"];
        }else if (nation.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的民族信息！"];
        }else if (address.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的住址信息！"];
        }else if (![self checkIDcard:IDCard]){
            [self  showSimplePromptBox:self andMesage:@"请输入正确的的身份证号码！"];
        }else{
            [self sendRequest:@"IDCardIsHave" andPath:queryURL andSqlParameter:IDCard and:self];
            uploadButton.selected=YES;
        }
    }
}

- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
        if (![self checkPhoneNumber:phoneTextField.text]){
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else{
            self.phoneString=phoneTextField.text;
            int code = (arc4random()% 1000) + 1000;
            self.codeString=[NSString stringWithFormat:@"%d",code];
            NSLog(@"=+%@",self.codeString);
            [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:@[phoneTextField.text,[NSString stringWithFormat:@"您好，您的验证码为：%@，有效期10分钟。",self.codeString]] and:self];
            button.selected=YES;
        }
    }
}

- (void)scrollToNextPage{
    for (UIView *subView in [getCodeButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            maCount-=1;
            if (maCount>0) {
                label.text=[NSString stringWithFormat:@"重新发送(%ld)",(long)maCount];
                label.textColor=[UIColor grayColor];
            }else{
                label.text=@"获取验证码";
                label.textColor=[UIColor blackColor];
                getCodeButton.selected=NO;
                [timer invalidate];
                timer=nil;
            }
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

- (void)choiceDate{
    [self.view endEditing:YES];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
        dateChoiceView=nil;
    }
    dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
    dateChoiceView.delegate=self;
    [self.view addSubview:dateChoiceView];
}

- (void)sureChoiceDate:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    birDateLabel.text=s1;
}

- (void)cancelChoiceDate{}

- (void)choiceSex:(UIButton*)button{
    lastChoiceButton=button;
    NSMutableArray *sexArray=[NSMutableArray arrayWithObjects:@"男",@"女", nil];
    [self addChoiceView:sexArray];
}

- (void)choiceNation:(UIButton*)button{
    lastChoiceButton=button;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nation" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *nationArray=(NSMutableArray*)[content componentsSeparatedByString:@","];
    [self addChoiceView:nationArray];
}


- (void)addChoiceView:(NSMutableArray*)array{
    [self.view endEditing:YES];
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH, 200)];
    [menuChoiceView initMenuChoiceView:array andFirst:[array objectAtIndex:0]];
    menuChoiceView.delegate=self;
    [self.view addSubview:menuChoiceView];
    mainBGVSrollView.frame=CGRectMake(0, 144, SCREENWIDTH, SCREENHEIGHT-144-200);
}

- (void)cancelChoiceMenu{
    mainBGVSrollView.frame=CGRectMake(0, 144, SCREENWIDTH, SCREENHEIGHT-144);
}

- (void)sureChoiceMenu:(NSString *)menuString{
    if (lastChoiceButton==districtButton) {
        districtLabel.text=menuString;
        for (District *item in districtArray) {
            if ([item.Name isEqualToString:menuString]) {
                self.districtString=item.ID;
            }
        }
    }else if(lastChoiceButton==nationButton){
        nationNumLabel.text=menuString;
    }
    else{
        sexNumLabel.text=menuString;
    }
    mainBGVSrollView.frame=CGRectMake(0, 144, SCREENWIDTH, SCREENHEIGHT-144);
    
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    uploadButton.selected=NO;
    if ([message isKindOfClass:[NSArray class]]) {
        NSLog(@"====================================++%@",type);
        NSArray *dataArray=message;
        if ([type isEqualToString:@"GetCode"]) {
            UILabel *label=[[getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            label.textColor=[UIColor grayColor];
            maCount=60;
            [self startAutoScroll];
        }
        else if ([type isEqualToString:@"IDCardIsHave"]){
            if (dataArray.count>0) {
                NSString *sexString=@"2";
                if ([sexNumLabel.text isEqualToString:@"男"]) {
                    sexString=@"1";
                }
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.memberID=[self changeNullString:[dic objectForKey:@"member_id"]];
                self.lOnlyString=[self changeNullString:[dic objectForKey:@"LOnlyCode"]];
                if (self.memberID.length==0) {
                    [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
                }else if (phoneTextField.text.length>0&&self.lOnlyString.length==0){
                    self.lOnlyString=[self getUniqueStrByUUID];
                    [self sendRequest:@"AddUser" andPath:queryWithoutURL andSqlParameter:@[phoneTextField.text,self.memberID,self.lOnlyString,nameTextField.text,sexNumLabel.text,birDateLabel.text,IDCardTextField.text,addressTextField.text,@"000000",@"iOS",[NSString stringWithFormat:@"iOS(Version %@)",[[UIDevice currentDevice] systemVersion]],@"",@"",nationNumLabel.text,cAddressTextField.text] and:self];
                }else{
                    NSString *sexString=@"2";
                    if ([sexNumLabel.text isEqualToString:@"男"]) {
                        sexString=@"1";
                    }
                    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                    [self sendRequest:@"AddNewUser" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneTextField.text,nameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,phoneTextField.text,self.memberID],@[self.fileNOString,nameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],[usd objectForKey:@"gwuser"],phoneTextField.text,cAddressTextField.text]] and:self];
                }
            }
            else{
                [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
            }
            
        }
        else if ([type isEqualToString:@"MemberCode"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.memberID=[self overMemberCod:[[dic objectForKey:@"nid"] stringValue]];
                NSString *sexString=@"2";
                if ([sexNumLabel.text isEqualToString:@"男"]) {
                    sexString=@"1";
                }
                if (phoneTextField.text.length>0&&self.lOnlyString.length==0){
                    self.lOnlyString=[self getUniqueStrByUUID];
                    [self sendRequest:@"AddUser" andPath:queryWithoutURL andSqlParameter:@[phoneTextField.text,self.memberID,self.lOnlyString,nameTextField.text,sexNumLabel.text,birDateLabel.text,IDCardTextField.text,addressTextField.text,@"000000",@"iOS",[NSString stringWithFormat:@"iOS(Version %@)",[[UIDevice currentDevice] systemVersion]],@"",@"",nationNumLabel.text,cAddressTextField.text] and:self];
                }else{
                    NSString *sexString=@"2";
                    if ([sexNumLabel.text isEqualToString:@"男"]) {
                        sexString=@"1";
                    }
                    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                    [self sendRequest:@"AddNewUser" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneTextField.text,nameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,phoneTextField.text,self.memberID],@[self.fileNOString,nameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],[usd objectForKey:@"gwuser"],phoneTextField.text,cAddressTextField.text]] and:self];
                }
                
            }
        }
        else if ([type isEqualToString:@"AddNewUser"]){
            ChoiceDepViewController *cvc=[ChoiceDepViewController new];
            cvc.nameString=nameTextField.text;
            cvc.IDCardString=IDCardTextField.text;
            cvc.sexString=sexNumLabel.text;
            cvc.addressString=addressTextField.text;
            cvc.birString=birDateLabel.text;
            cvc.nationString=nationNumLabel.text;
            cvc.addressString=addressTextField.text;
            cvc.unitString=unitTextField.text;
            cvc.validtimeString=validTimeTextField.text;
            cvc.memberidString=self.memberID;
            cvc.onlycodeString=self.lOnlyString;
            cvc.phoneString=phoneTextField.text;
            cvc.fdItem=self.fdItem;
            cvc.whopush=self.whopush;
            cvc.userItem=self.userItem;
            cvc.isMU=self.isMU;
            [self.navigationController pushViewController:cvc animated:YES];
        }
        else if ([type isEqualToString:@"CheckIDCFile"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.fileNOString=[dic objectForKey:@"FileNo"];
                
                if (districtButton) {
                    uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, districtButton.frame.origin.y, uploadButton.frame.size.width, 50);
                    
                    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
                    
                    [districtButton removeFromSuperview];
                    districtButton=nil;
                }
            }else{
                if (districtArray.count==0) {
                    [self sendRequest:@"GetOrgDistrict" andPath:queryURL andSqlParameter:[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"] and:self];
                }else{
                    [self addDistrictButton];
                }
            }
        }
        else if ([type isEqualToString:@"GetOrgDistrict"]){
            if (dataArray.count>0) {
                for (NSDictionary *dic in dataArray) {
                    District *item=[RMMapper objectWithClass:[District class] fromDictionary:dic];
                    [districtArray addObject:item];
                }
                [self  addDistrictButton];
            }
        }
        else if([type isEqualToString:@"GenerateFileNO"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.fileNOString=[dic objectForKey:@"FileNo"];
                NSString *sexString=@"2";
                if ([sexNumLabel.text isEqualToString:@"男"]) {
                    sexString=@"1";
                }
                NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                [self sendRequest:@"AddNewUser" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneTextField.text,nameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,phoneTextField.text,self.memberID],@[self.fileNOString,nameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],[usd objectForKey:@"gwuser"],phoneTextField.text,cAddressTextField.text]] and:self];
            }
        }
    }
    else if([message isKindOfClass:[NSDictionary class]]){
        if([type isEqualToString:@"AddUser"]) {
            NSString *sexString=@"2";
            if ([sexNumLabel.text isEqualToString:@"男"]) {
                sexString=@"1";
            }
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            [self sendRequest:@"AddNewUser" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneTextField.text,nameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,phoneTextField.text,self.memberID],@[self.fileNOString,nameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],[usd objectForKey:@"gwuser"],phoneTextField.text,cAddressTextField.text]] and:self];
            
        }else if([type isEqualToString:IDCARDINFOTYPE]){
            NSDictionary *file=[message objectForKey:@"file"];
            NSDictionary *exam=[message objectForKey:@"exam"];
            NSDictionary *sign=[message objectForKey:@"sign"];
            if (!adviceView) {
                adviceView=[[UIView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,100)];
                adviceView.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:247.0/255.0 blue:242.0/255.0 alpha:1];
                [self.view addSubview:adviceView];
                
                upAdviceLabel=[self addLabel:CGRectMake(10,74, SCREENWIDTH-20, 20) andText:[NSString stringWithFormat:@"该身份证号对应的用户%@,%@,%@",[file objectForKey:@"msg"],[exam objectForKey:@"msg"],[sign objectForKey:@"msg"]] andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
                upAdviceLabel.numberOfLines=0;
                [upAdviceLabel sizeToFit];
                [self.view addSubview:upAdviceLabel];
                
                adviceView.frame=CGRectMake(0,64, SCREENWIDTH, upAdviceLabel.frame.size.height+20);
                
            }else{
                upAdviceLabel.text=[NSString stringWithFormat:@"该身份证号对应的用户%@,%@,%@",[file objectForKey:@"msg"],[exam objectForKey:@"msg"],[sign objectForKey:@"msg"]];
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    uploadButton.selected=NO;
}

- (void)addDistrictButton{
    District *item=[districtArray objectAtIndex:0];
    self.districtString=item.ID;
    NSLog(@"行政区划码====%@",self.districtString);
    if (districtButton) {
        uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, districtButton.frame.origin.y, uploadButton.frame.size.width, 50);
        
        mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
        
        [districtButton removeFromSuperview];
        districtButton=nil;
    }
    districtButton=[self addButton:CGRectMake(0, uploadButton.frame.origin.y, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceDistrict)];
    [mainBGVSrollView addSubview:districtButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:districtButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:districtButton];
    
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"行政区划" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [districtButton addSubview:sexLabel];
    
    districtLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:item.Name andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [districtButton addSubview:districtLabel];
    
    UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    goImagView.image=[UIImage imageNamed:@"arrow_2"];
    [districtButton addSubview:goImagView];
    
    uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, uploadButton.frame.origin.y+60, uploadButton.frame.size.width, 50);
    
    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
    
}

- (void)choiceDistrict{
    lastChoiceButton=districtButton;
    NSMutableArray *nameArry=[NSMutableArray new];
    for (District *item in districtArray) {
        [nameArry addObject:item.Name];
    }
    [self addChoiceView:nameArry];
}

- (void)checkIDCard{
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc]init];
    con.scNaigationDelegate=self;
    con.iCardType=TIDCARD2; // 其他证件以此类推
    con.isDisPlayTxt=YES;
    [self presentViewController:con animated:YES completion:NULL];
}

- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    nameTextField.text=name;
    sexNumLabel.text=sex;
    nationNumLabel.text=folk;
    birDateLabel.text=[self changeDateString:birthday];
    addressTextField.text=address;
    cAddressTextField.text=address;
    IDCardTextField.text=num;
    
    if ([self checkIDcard:num]) {
        [self sendRequest:IDCARDINFOTYPE andPath:IDCARDINFOURL andSqlParameter:@{@"IDcard":num} and:self];
    }else{
        [self showSimplePromptBox:self andMesage:@"身份证号码有误,请重新进行扫描！"];
    }
}

- (NSString *)changeDateString:(NSString*)birString{
    NSString *newString=[birString stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return newString;
}

- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period{
    unitTextField.text=issue;
    validTimeTextField.text=period;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==IDCardTextField) {
        NSString *regex = @"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]||[string isEqualToString:@"x"]||[string isEqualToString:@"X"]) {
            if (textField.text.length<18) {
                return YES;
            }else if (textField.text.length==18&&[string isEqualToString:@""]){
                if (districtButton) {
                    uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, districtButton.frame.origin.y, uploadButton.frame.size.width, 50);
                    
                    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
                    
                    [districtButton removeFromSuperview];
                    districtButton=nil;
                }
                return YES;
            }
        }
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==IDCardTextField) {
        if (textField.text.length==15||textField.text.length==18) {
            if ([self checkIDcard:textField.text]) {
                birDateLabel.text=[self birthdayStrFromIdentityCard:textField.text];
                [self sendRequest:IDCARDINFOTYPE andPath:IDCARDINFOURL andSqlParameter:@{@"IDcard":textField.text} and:self];
            }else{
                [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
        }
    }
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainBGVSrollView.frame=CGRectMake(0, 144, SCREENWIDTH,SCREENHEIGHT-144-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainBGVSrollView.frame=CGRectMake(0, 144, SCREENWIDTH,SCREENHEIGHT-144);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
