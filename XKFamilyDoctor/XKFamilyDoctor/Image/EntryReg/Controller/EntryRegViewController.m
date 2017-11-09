//
//  EntryRegViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "EntryRegViewController.h"
#import "SCCaptureCameraController.h"
#import "ChoicePostViewController.h"
#import "ChoicePlatetViewController.h"
@interface EntryRegViewController ()<SCNavigationControllerDelegate,UIScrollViewDelegate>

@end

@implementation EntryRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  addTitleView:@"新员工注册"];
    [self addLeftButtonItem];
    businessDepArray=[NSMutableArray new];
    mechanismArray=[NSMutableArray new];
    departmentArray=[NSMutableArray new];
    [self creatUI];
    
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

- (void)viewDidAppear:(BOOL)animated{
    if (self.bdItem) {
        UILabel *namelabel=[[choiceBusinessDep subviews] objectAtIndex:2];
        namelabel.text=self.bdItem.text;
        self.bdString=[NSString stringWithFormat:@"%d",self.bdItem.key];
    }
    if (self.orgItem) {
        self.mString=[NSString stringWithFormat:@"%d",[self.orgItem.orgkey intValue]];
        UILabel *namelabel=[[choiceMechanism subviews] objectAtIndex:2];
        namelabel.text=self.orgItem.orgname;
    }
    if (self.depItem) {
        UILabel *namelabel=[[choiceDepartment subviews] objectAtIndex:2];
        namelabel.text=self.depItem.text;
        self.depString=[NSString stringWithFormat:@"%d",self.depItem.key];
    }
    if (self.postItem) {
        UILabel *namelabel=[[choicePost subviews] objectAtIndex:2];
        namelabel.text=self.postItem.text;
        self.postString=[NSString stringWithFormat:@"%d",self.postItem.key];
    }
}

- (void)creatUI{
    mainBGVSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT-64)];
    mainBGVSrollView.delegate=self;
    [self.view addSubview:mainBGVSrollView];
    
    UIView *phoneBGView=[self addSimpleBackView:CGRectMake(0, 10, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:phoneBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:phoneBGView];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:phoneBGView];
    
    UILabel *phoneLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"手机号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [phoneBGView addSubview:phoneLabel];
    
    phoneTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-190, 30) andPlaceholder:@"请输入手机号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextField.delegate=self;
    [phoneBGView addSubview:phoneTextField];
    
    getCodeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-90,13,80, 24) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(getCode:) andText:@"获取验证码" andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
    getCodeButton.layer.borderColor=GREENCOLOR.CGColor;
    getCodeButton.layer.borderWidth=0.5;
    [getCodeButton.layer setCornerRadius:12];
    [phoneBGView addSubview:getCodeButton];
    
    UIView *codeBGView=[self addSimpleBackView:CGRectMake(0,phoneBGView.frame.origin.y+phoneBGView.frame.size.height+10, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:codeBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeBGView];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeBGView];
    
    UILabel *codeLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"验证码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [codeBGView addSubview:codeLabel];
    
    vCodeTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-100, 30) andPlaceholder:@"请输入验证码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    vCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    vCodeTextField.delegate=self;
    [codeBGView addSubview:vCodeTextField];
    
    UIButton *IDcardButton=[self addButton:CGRectMake(0, codeBGView.frame.origin.y+codeBGView.frame.size.height+10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(checkIDCard)];
    [mainBGVSrollView addSubview:IDcardButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    
    UILabel *IDLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"身份证识别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardButton addSubview:IDLabel];
    
    UILabel *adviceLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:@"识别后将自动填写以下身份证信息" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [IDcardButton addSubview:adviceLabel];
    
    UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    goImagView.image=[UIImage imageNamed:@"arrow_2"];
    [IDcardButton addSubview:goImagView];
    
    UIView *IDcardInfoView=[self addSimpleBackView:CGRectMake(0, IDcardButton.frame.origin.y+IDcardButton.frame.size.height+10, SCREENWIDTH,300) andColor:MAINWHITECOLOR];
    [mainBGVSrollView addSubview:IDcardInfoView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    [self addLineLabel:CGRectMake(0,300, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, 15, 70,20) andText:@"姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nameLabel];
    
    nameTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nameTextField.delegate=self;
    nameTextField.textAlignment=2;
    nameTextField.userInteractionEnabled=NO;
    [IDcardInfoView addSubview:nameTextField];
    
    UIButton *birDateButton=[self addButton:CGRectMake(0, 50, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:0 andSEL:nil];
    [IDcardInfoView addSubview:birDateButton];
    
    UILabel *dateLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"出生日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [birDateButton addSubview:dateLabel];
    
    birDateLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-100, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [birDateButton addSubview:birDateLabel];
    
    UIButton *sexButton=[self addButton:CGRectMake(0, 100, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:nil];
    [IDcardInfoView addSubview:sexButton];
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sexButton addSubview:sexLabel];
    
    sexNumLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-100, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [sexButton addSubview:sexNumLabel];
    
    UILabel *nationLabel=[self addLabel:CGRectMake(10, 165,70, 20) andText:@"民族" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nationLabel];
    
    nationTextField=[self addTextfield:CGRectMake(90,160, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nationTextField.delegate=self;
    nationTextField.textAlignment=2;
    nationTextField.userInteractionEnabled=NO;
    [IDcardInfoView addSubview:nationTextField];
    
    UILabel *addressLabel=[self addLabel:CGRectMake(10, 215,70, 20) andText:@"住址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:addressLabel];
    
    addressTextField=[self addTextfield:CGRectMake(90,210, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    addressTextField.delegate=self;
    addressTextField.textAlignment=2;
    addressTextField.userInteractionEnabled=NO;
    [IDcardInfoView addSubview:addressTextField];
    
    UILabel *IDCardLabel=[self addLabel:CGRectMake(10, 265,70, 20) andText:@"身份证号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:IDCardLabel];
    
    IDCardTextField=[self addTextfield:CGRectMake(90,260, SCREENWIDTH-100, 30) andPlaceholder:@"" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    IDCardTextField.delegate=self;
    IDCardTextField.textAlignment=2;
    IDCardTextField.userInteractionEnabled=NO;
    [IDcardInfoView addSubview:IDCardTextField];
    
    for (int i=0; i<5; i++) {
        [self addLineLabel:CGRectMake(10, 50*(i+1),SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    }
    
    choiceBusinessDep=[self addButton:CGRectMake(0,IDcardInfoView.frame.origin.y+IDcardInfoView.frame.size.height+10, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choicePost:)];
    [mainBGVSrollView addSubview:choiceBusinessDep];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceBusinessDep];
    
    UILabel *bdLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"事业部" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceBusinessDep addSubview:bdLabel];
    
    UILabel *bdCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:@"请选择所属事业部" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceBusinessDep addSubview:bdCLabel];
    
    UIImageView *bdGoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    bdGoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [choiceBusinessDep addSubview:bdGoImagView];
    
    choiceMechanism=[self addButton:CGRectMake(0,choiceBusinessDep.frame.origin.y+choiceBusinessDep.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choicePost:)];
    [mainBGVSrollView addSubview:choiceMechanism];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choiceMechanism];
    
    UILabel *departmentLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"机构" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceMechanism addSubview:departmentLabel];
    
    UILabel *departmentCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:@"请选择所属机构" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceMechanism addSubview:departmentCLabel];
    
    UIImageView *dGoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    dGoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [choiceMechanism addSubview:dGoImagView];
    
    choiceDepartment=[self addButton:CGRectMake(0,choiceMechanism.frame.origin.y+choiceMechanism.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choicePost:)];
    [mainBGVSrollView addSubview:choiceDepartment];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choiceDepartment];
    
    UILabel *mechanismLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"科室" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choiceDepartment addSubview:mechanismLabel];
    
    UILabel *mechanismCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:@"请选择所属科室" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choiceDepartment addSubview:mechanismCLabel];
    
    UIImageView *mGoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    mGoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [choiceDepartment addSubview:mGoImagView];
    
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceDepartment];
    
    choicePost=[self addButton:CGRectMake(0,choiceDepartment.frame.origin.y+choiceDepartment.frame.size.height, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choicePost:)];
    [mainBGVSrollView addSubview:choicePost];
    
    [self addLineLabel:CGRectMake(10, 0, SCREENWIDTH-10, 0.5) andColor:LINECOLOR andBackView:choicePost];
    
    UILabel *postLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"岗位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [choicePost addSubview:postLabel];
    
    UILabel *postCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:@"请选择岗位" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:2];
    [choicePost addSubview:postCLabel];
    
    UIImageView *pGoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    pGoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [choicePost addSubview:pGoImagView];
    
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choicePost];
    
    uploadButton=[self addSimpleButton:CGRectMake(20, choicePost.frame.origin.y+choicePost.frame.size.height+10, SCREENWIDTH-40, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(upload) andText:@"提交" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
    uploadButton.layer.borderColor=GREENCOLOR.CGColor;
    uploadButton.layer.borderWidth=0.5;
    [uploadButton.layer setCornerRadius:25];
    [mainBGVSrollView addSubview:uploadButton];
    
    mainBGVSrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
}

- (void)upload{
    if (uploadButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *name = [nameTextField.text stringByTrimmingCharactersInSet:set];
        NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:set];
        NSString *IDCard = [IDCardTextField.text stringByTrimmingCharactersInSet:set];
        
        if (![self checkPhoneNumber:phoneTextField.text]) {
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码！"];
        }else if ((![self.phoneString isEqualToString:phoneTextField.text]&&![vCodeTextField.text isEqualToString:@"88689707"])||(![self.codeString isEqualToString:vCodeTextField.text]&&![vCodeTextField.text isEqualToString:@"88689707"])){
            [self showSimplePromptBox:self andMesage:@"验证码错误！"];
        }else if (name.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的真实姓名！"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择您的性别！"];
        }else if (address.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的住址信息！"];
        }else if (IDCard.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入您的身份证号码！"];
        }else if (self.bdString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请选择您所属事业部！"];
        }else if (self.mString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请选择您所属机构！"];
        }else if (self.depString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请选择您所属科室！"];
        }else if (self.postString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请选择您的岗位！"];
        }else{
            [self sendRequest:SAVEDATATYPE andPath:SAVEDATAURL andSqlParameter:@{@"truename":name,@"orgid":self.mString,@"mobile":phoneTextField.text,@"idno":IDCard,@"gender":sexNumLabel.text,@"address":address,@"department":self.depString,@"post":self.postString,@"plate":self.bdString} and:self];
            uploadButton.selected=YES;
        }
    }
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

- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
        if (![self checkPhoneNumber:phoneTextField.text]){
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else{
            self.phoneString=phoneTextField.text;
            int code = (arc4random() % 1000) + 1000;
            self.codeString=[NSString stringWithFormat:@"%d",code];
            NSLog(@"=+%@",self.codeString);
            [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:@[phoneTextField.text,[NSString stringWithFormat:@"您好，您的新康助手验证码为：%@，有效期10分钟。",self.codeString]] and:self];
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

- (void)choicePost:(UIButton*)button{
    if (button==choiceBusinessDep) {
        ChoicePlatetViewController *cvc=[ChoicePlatetViewController new];
        cvc.whoPush=@"R";
        cvc.titleString=@"选择事业部";
        cvc.parentID=@"0";
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (button==choiceMechanism){
        ChoicePlatetViewController *cvc=[ChoicePlatetViewController new];
        cvc.whoPush=@"R";
        cvc.titleString=@"选择机构";
        cvc.parentID=@"0";
        [self.navigationController pushViewController:cvc animated:YES];
    }else{
        ChoicePostViewController *cvc=[ChoicePostViewController new];
        cvc.whoPush=@"R";
        if (button==choicePost){
            cvc.titleString=@"选择岗位";
            
        }else{
            cvc.titleString=@"选择科室";
        }
        [self.navigationController pushViewController:cvc animated:YES];

    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    uploadButton.selected=NO;
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if ([type isEqualToString:@"GetCode"]) {
            UILabel *label=[[getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            label.textColor=[UIColor grayColor];
            maCount=60;
            [self startAutoScroll];
        }else if([type isEqualToString:BDLISTTYPE]){
            NSMutableArray *nameArray=[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                [businessDepArray addObject:item];
                [nameArray addObject:item.text];
            }
            lastChoiceButton=choiceBusinessDep;
            [self addChoiceView:nameArray];
        }else if([type isEqualToString:MECLISTTYPE]){
            NSMutableArray *nameArray=[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                OrgItem *item=[RMMapper objectWithClass:[OrgItem class] fromDictionary:dic];
                [mechanismArray addObject:item];
                [nameArray addObject:item.orgname];
            }
            lastChoiceButton=choiceMechanism;
            [self addChoiceView:nameArray];
        }else if([type isEqualToString:DEPLISTTYPE]){
            NSMutableArray *nameArray=[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                CommenModel *item=[RMMapper objectWithClass:[CommenModel class] fromDictionary:dic];
                [departmentArray addObject:item];
                [nameArray addObject:item.text];
            }
            lastChoiceButton=choiceDepartment;
            [self addChoiceView:nameArray];
        }
    }
    else if([message isKindOfClass:[NSDictionary class]]){
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:[message objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [av addAction:cancelAC];
        [self presentViewController:av animated:YES completion:nil];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
    if ([type isEqualToString:SAVEDATATYPE]) {
        uploadButton.selected=NO;
    }
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
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}

- (void)cancelChoiceMenu{
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)sureChoiceMenu:(NSString *)menuString{
    UILabel *numLabel=[[lastChoiceButton subviews] objectAtIndex:1];
    numLabel.text=menuString;
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    
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
    nationTextField.text=folk;
    birDateLabel.text=birthday;
    addressTextField.text=address;
    IDCardTextField.text=num;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==phoneTextField||textField==vCodeTextField) {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainBGVSrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
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
