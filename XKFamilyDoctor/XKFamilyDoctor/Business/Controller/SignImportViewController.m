//
//  SignImportViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SignImportViewController.h"
#import "ChoiceDocTeamViewController.h"
#import "MyUserViewController.h"
#import "District.h"
#import "PrintView.h"
#import "SCCaptureCameraController.h"
@interface SignImportViewController ()

@end

@implementation SignImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"签约录入"];
    [self addLeftButtonItem];
    districtArray=[NSMutableArray new];
    self.fileNOString=@"";
    [self creatUI];

}

- (void)viewDidAppear:(BOOL)animated{
    if (self.teamItem) {
        teamNameLabel.text=self.teamItem.LName;
    }
    if (self.userItem) {
        IDCardTextField.text=[self changeNullString:self.userItem.LIdNum];
        phoneNumTextField.text=[[[self changeNullString:self.userItem.LMobile] componentsSeparatedByString:@"_"] firstObject];
        userNameTextField.text=[self changeNullString:self.userItem.LName];
        birDateLabel.text=[self getSubTime:[self changeNullString:self.userItem.LBirthday] andFormat:@"yyyy-MM-dd"];
        sexNumLabel.text=[self changeNullString:self.userItem.LSex];
        nationNumLabel.text=[self changeNullString:self.userItem.LFolk];
        addressTextField.text=[self changeNullString:self.userItem.LIDAddr];
        currentAddressField.text=[self changeNullString:self.userItem.LHomeAddr];
        medicalInsTextField.text=[self changeNullString:self.userItem.LMedicalInsurance];

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
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT-64)];
    BGScrollView.delegate=self;
    [self.view addSubview:BGScrollView];
    
    UIButton *IDcardButton=[self addButton:CGRectMake(0,10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(checkIDCard)];
    [BGScrollView addSubview:IDcardButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardButton];
    
    
    UILabel *IDLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"身份证识别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardButton addSubview:IDLabel];
    
    UILabel *adviceLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-120, 20) andText:@"识别后将自动填写以下身份证信息" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [IDcardButton addSubview:adviceLabel];
    [self addGotoNextImageView:IDcardButton];
    
    UIView *IDcardInfoView=[self addSimpleBackView:CGRectMake(0,IDcardButton.frame.origin.y+IDcardButton.frame.size.height+10, SCREENWIDTH,400) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:IDcardInfoView];
    
    UILabel *IDCardLabel=[self addLabel:CGRectMake(10,15,90, 20) andText:@"身份证号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    IDCardLabel.attributedText=[self setString:@"*身份证号码" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:IDCardLabel];
    
    IDCardTextField=[self addTextfield:CGRectMake(110,10, SCREENWIDTH-120, 30) andPlaceholder:@"请输入居民身份证号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    IDCardTextField.delegate=self;
    IDCardTextField.textAlignment=2;
    [IDcardInfoView addSubview:IDCardTextField];
    
    UILabel *phoneNumLabel=[self addLabel:CGRectMake(10,IDCardTextField.frame.origin.y+55,70, 20) andText:@"手机号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    phoneNumLabel.attributedText=[self setString:@"*手机号" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:phoneNumLabel];
    
    phoneNumTextField=[self addTextfield:CGRectMake(90,IDCardTextField.frame.origin.y+50, SCREENWIDTH-100, 30) andPlaceholder:@"不输入手机号码，将无法进行录入" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    phoneNumTextField.delegate=self;
    phoneNumTextField.textAlignment=2;
    phoneNumTextField.keyboardType=UIKeyboardTypeNumberPad;
    [IDcardInfoView addSubview:phoneNumTextField];
    
    UILabel *userNameLabel=[self addLabel:CGRectMake(10,phoneNumTextField.frame.origin.y+55,70, 20) andText:@"姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    userNameLabel.attributedText=[self setString:@"*姓名" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:userNameLabel];
    
    userNameTextField=[self addTextfield:CGRectMake(90,phoneNumTextField.frame.origin.y+50, SCREENWIDTH-100, 30) andPlaceholder:@"请输入居民姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    userNameTextField.delegate=self;
    userNameTextField.textAlignment=2;
    [IDcardInfoView addSubview:userNameTextField];
    
    UIButton *birDateButton=[self addButton:CGRectMake(0, userNameTextField.frame.origin.y+40, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceDate)];
    [IDcardInfoView addSubview:birDateButton];
    
    UILabel *dateLabel=[self addLabel:CGRectMake(10, 15,90, 20) andText:@"出生日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    dateLabel.attributedText=[self setString:@"*出生日期" andSubString:@"*" andDifColor:[UIColor redColor]];
    [birDateButton addSubview:dateLabel];
    
    birDateLabel=[self  addLabel:CGRectMake(110,15, SCREENWIDTH-140, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [birDateButton addSubview:birDateLabel];
    
    [self addGotoNextImageView:birDateButton];
    
    UIButton *sexButton=[self addButton:CGRectMake(0, birDateButton.frame.origin.y+50, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceSex:)];
    [IDcardInfoView addSubview:sexButton];
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
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
    
    UILabel *addressLabel=[self addLabel:CGRectMake(10, nationButton.frame.origin.y+65,70, 20) andText:@"户籍地址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    addressLabel.attributedText=[self setString:@"*户籍地址" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:addressLabel];
    
    addressTextField=[self addTextfield:CGRectMake(90, nationButton.frame.origin.y+60, SCREENWIDTH-100, 30) andPlaceholder:@"请输入户籍地址信息" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    addressTextField.delegate=self;
    addressTextField.textAlignment=2;
    [IDcardInfoView addSubview:addressTextField];
    
    UILabel *cAddressLabel=[self addLabel:CGRectMake(10, addressTextField.frame.origin.y+55,70, 20) andText:@"现住址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    cAddressLabel.attributedText=[self setString:@"*现住址" andSubString:@"*" andDifColor:[UIColor redColor]];
    [IDcardInfoView addSubview:cAddressLabel];
    
    currentAddressField=[self addTextfield:CGRectMake(90, addressTextField.frame.origin.y+50, SCREENWIDTH-100, 30) andPlaceholder:@"请输入现住址信息" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    currentAddressField.delegate=self;
    currentAddressField.textAlignment=2;
    [IDcardInfoView addSubview:currentAddressField];
    
    UILabel *medicalInsLabel=[self addLabel:CGRectMake(10, currentAddressField.frame.origin.y+55,70, 20) andText:@"医保卡号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:medicalInsLabel];
    
    medicalInsTextField=[self addTextfield:CGRectMake(90, currentAddressField.frame.origin.y+50, SCREENWIDTH-100, 30) andPlaceholder:@"请输入医保卡号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    medicalInsTextField.delegate=self;
    medicalInsTextField.textAlignment=2;
    [IDcardInfoView addSubview:medicalInsTextField];
    
    UIButton *teamButton=[self addButton:CGRectMake(0, medicalInsTextField.frame.origin.y+40, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceTeam:)];
    [IDcardInfoView addSubview:teamButton];
    
    UILabel *teamLabel=[self addLabel:CGRectMake(10, 15, 120, 20) andText:@"签约家庭医生团队" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    teamLabel.attributedText=[self setString:@"*签约家庭医生团队" andSubString:@"*" andDifColor:[UIColor redColor]];
    [teamButton addSubview:teamLabel];
    
    teamNameLabel=[self  addLabel:CGRectMake(130,15, SCREENWIDTH-160, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [teamButton addSubview:teamNameLabel];
    
    [self addGotoNextImageView:teamButton];
    
    IDcardInfoView.frame=CGRectMake(IDcardInfoView.frame.origin.x, IDcardInfoView.frame.origin.y, SCREENWIDTH, teamButton.frame.origin.y+teamButton.frame.size.height);
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    [self addLineLabel:CGRectMake(0,IDcardInfoView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    
    
    for (int i=0; i<9; i++) {
        [self addLineLabel:CGRectMake(10, 50*(i+1),SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    }
    
    marriageButton=[self addButton:CGRectMake(0,IDcardInfoView.frame.origin.y+IDcardInfoView.frame.size.height+10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceMarriage:)];
    [BGScrollView addSubview:marriageButton];
    
    UILabel *marriageLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"婚姻状况" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [marriageButton addSubview:marriageLabel];
    
    marriageCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-120, 20) andText:@"请选择用户婚姻状况" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [marriageButton addSubview:marriageCLabel];
    
    [self addGotoNextImageView:marriageButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:marriageButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:marriageButton];
    
    personnelTypeButton=[self addButton:CGRectMake(0,marriageButton.frame.origin.y+marriageButton.frame.size.height+10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addCheckBox:)];
    [BGScrollView addSubview:personnelTypeButton];
    
    UILabel *personnelTypeLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"人群分类" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [personnelTypeButton addSubview:personnelTypeLabel];
    
    personnelTypeCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-120, 20) andText:@"请选择用户人群分类" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [personnelTypeButton addSubview:personnelTypeCLabel];
    
    [self addGotoNextImageView:personnelTypeButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:personnelTypeButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:personnelTypeButton];
    
    diseaseButton=[self addButton:CGRectMake(0,personnelTypeButton.frame.origin.y+personnelTypeButton.frame.size.height+10,SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addCheckBox:)];
    [BGScrollView addSubview:diseaseButton];
    
    UILabel *diseaseLabel=[self addLabel:CGRectMake(10, 15,70, 20) andText:@"疾病类型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [diseaseButton addSubview:diseaseLabel];
    
    diseaseCLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-120, 20) andText:@"请选择用户疾病类型" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [diseaseButton addSubview:diseaseCLabel];
    
    [self addGotoNextImageView:diseaseButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:diseaseButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:diseaseButton];
    
    uploadButton=[self addSimpleButton:CGRectMake(20,diseaseButton.frame.origin.y+diseaseButton.frame.size.height+20, SCREENWIDTH-40,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureUpload) andText:@"提交" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [uploadButton.layer setCornerRadius:20];
    [BGScrollView addSubview:uploadButton];
    
    BGScrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
}

-(void)sureUpload{
    NSLog(@"=======%@==========%@",getVCode,NEWSIGNAPPLYURL);
    if (uploadButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *name = [userNameTextField.text stringByTrimmingCharactersInSet:set];
        NSString *phoneNum = [phoneNumTextField.text stringByTrimmingCharactersInSet:set];
        NSString *IDCard = [IDCardTextField.text stringByTrimmingCharactersInSet:set];
        NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:set];
        NSString *cAddress = [currentAddressField.text stringByTrimmingCharactersInSet:set];
        NSString *nation = [nationNumLabel.text stringByTrimmingCharactersInSet:set];
        if (![self checkIDcard:IDCard]) {
            [self showSimplePromptBox:self andMesage:@"身份证号码有误，请核对后重新输入！"];
        }else if (![self checkPhoneNumber:phoneNum]){
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码！"];
        }else if (name.length==0){
            [self showSimplePromptBox:self andMesage:@"请输入用户的真实姓名！"];
        }else if (birDateLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的生日信息！"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的性别！"];
        }else if (nation.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的民族信息！"];
        }else if (address.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的户籍地址信息！"];
        }else if (cAddress.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的现住址信息！"];
        }else if(teamNameLabel.text.length==0){
            [self  showSimplePromptBox:self andMesage:@"请选择要签约的家庭医生团队！"];
        }else{
            NSString *mString=@"";
            NSString *dString=@"";
            NSString *pString=@"";
            if ([marriageCLabel.text rangeOfString:@"请选择"].location==NSNotFound) {
                mString=marriageCLabel.text;
            }
            if ([diseaseCLabel.text rangeOfString:@"请选择"].location==NSNotFound) {
                dString=diseaseCLabel.text;
            }
            if ([personnelTypeCLabel.text rangeOfString:@"请选择"].location==NSNotFound) {
                pString=personnelTypeCLabel.text;
            }
            
            NSDictionary *dataDic=@{@"mobile":phoneNumTextField.text,@"name":userNameTextField.text,@"id":IDCardTextField.text,@"sex":sexNumLabel.text,@"folk":nationNumLabel.text,@"birthday":birDateLabel.text,@"address":addressTextField.text,@"currentAddress":currentAddressField.text,@"teamName":self.teamItem.LName,@"teamId":self.teamItem.LID,@"LAiderId":[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"],@"LMedicalInsurance":medicalInsTextField.text,@"LMaritalStatus":mString,@"LPersonKind":pString,@"LDiseaseType":dString};
            
            [self sendRequest:NEWSIGNAPPLYTYPE andPath:NEWSIGNAPPLYURL andSqlParameter:dataDic and:self];
        }
    }
}

- (void)addCheckBox:(UIButton*)button{
    lastChoiceButton=button;
    if (button==diseaseButton) {
        [self sendRequest:@"PersonnalType" andPath:queryURL andSqlParameter:@"疾病分类" and:self];
    }else{
        [self sendRequest:@"PersonnalType" andPath:queryURL andSqlParameter:@"签约人群分类" and:self];
        
    }
}

- (void)cancelCheckboxView{}


- (void)sureBackOption:(NSString *)Option{
    if (lastChoiceButton==diseaseButton) {
        diseaseCLabel.text=Option;
    }else{
        personnelTypeCLabel.text=Option;
    }
}


- (void)requestSuccess:(id)message andType:(NSString *)type{
    [self.view endEditing:YES];
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if ([type isEqualToString:@"CheckIDCFile"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.fileNOString=[dic objectForKey:@"FileNo"];
            }else{
                if (districtArray.count==0) {
                    [self sendRequest:@"GetOrgDistrict" andPath:queryURL andSqlParameter:[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"] and:self];
                }else{
                    [self addDistrictButton];
                }
            }
        }
        else if([type isEqualToString:@"PersonnalType"]){
            if (dataArray.count>0) {
                checkboxView=[[CheckboxView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                checkboxView.delegate=self;
                [self.navigationController.view addSubview:checkboxView];
                NSMutableArray *nameArray=[NSMutableArray new];
                for (NSDictionary *dic in dataArray) {
                    [nameArray addObject:[dic objectForKey:@"LValue"]];
                }
                [checkboxView creatUI:@"选择用户类型" andOption:nameArray andConnect:@","];
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
//        else if ([type isEqualToString:@"IDCardIsHave"]){
//            if (dataArray.count>0) {
//                NSDictionary *dic=[dataArray objectAtIndex:0];
//                self.memberID=[self changeNullString:[dic objectForKey:@"member_id"]];
//                self.lOnlyString=[self changeNullString:[dic objectForKey:@"LOnlyCode"]];
//                if (self.lOnlyString.length>0) {
//                    [self sendRequest:@"CheckUserIsSign" andPath:queryURL andSqlParameter:self.lOnlyString and:self];
//                }
//            }
//        }
//        else if([type isEqualToString:@"CheckUserIsSign"]){
//            isSign=NO;
//            if (dataArray.count>0) {
//                isSign=YES;
//                [self showSimplePromptBox:self andMesage:@"该用户已签约过家庭医生,无法进行录入操作!"];
//            }else{
//                isSign=NO;
//            }
//        }
//        else if ([type isEqualToString:@"MemberCode"]){
//            if (dataArray.count>0) {
//                NSDictionary *dic=[dataArray objectAtIndex:0];
//                self.memberID=[self overMemberCod:[[dic objectForKey:@"nid"] stringValue]];
//                NSString *sexString=@"2";
//                if ([sexNumLabel.text isEqualToString:@"男"]) {
//                    sexString=@"1";
//                }
//                if (self.lOnlyString.length==0){
//                    self.lOnlyString=[self getUniqueStrByUUID];
//                    [self sendRequest:@"AddUser" andPath:queryWithoutURL andSqlParameter:@[phoneNumTextField.text,self.memberID,self.lOnlyString,userNameTextField.text,sexString,birDateLabel.text,IDCardTextField.text,addressTextField.text,@"000000",@"iOS",[NSString stringWithFormat:@"iOS(Version %@)",[[UIDevice currentDevice] systemVersion]],@"",@"",nationTextField.text] and:self];
//                }
//                
//            }
//        }
        else if([type isEqualToString:@"GenerateFileNO"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.fileNOString=[dic objectForKey:@"FileNo"];
                NSString *sexString=@"2";
                if ([sexNumLabel.text isEqualToString:@"男"]) {
                    sexString=@"1";
                }
                NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                [self sendRequest:@"AddNewUser_S" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneNumTextField.text,userNameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,userNameTextField.text,self.memberID],@[self.fileNOString,userNameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],[NSString stringWithFormat:@"%d",[[usd objectForKey:@"empkey"] intValue]],phoneNumTextField.text,currentAddressField.text]] and:self];
            }
        }
        else if ([type rangeOfString:@"AddNewUser"].location!=NSNotFound){
            uploadButton.selected=NO;
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"家庭医生签约成功！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
        }
    }
    else if([message isKindOfClass:[NSDictionary class]]){
        NSDictionary *dataDic=message;
        if ([type isEqualToString:NEWSIGNAPPLYTYPE]) {
            self.memberID=[dataDic objectForKey:@"MemberId"];
            self.lOnlyString=[dataDic objectForKey:@"LOnlyCode"];
            self.bindID=[dataDic objectForKey:@"DoctorBindLID"];
                uploadButton.selected=YES;
                NSString *sexString=@"2";
                if ([sexNumLabel.text isEqualToString:@"男"]) {
                    sexString=@"1";
                }
                NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                [self sendRequest:@"AddNewUser_S" andPath:excuteURL andSqlParameter:@[@[IDCardTextField.text,phoneNumTextField.text,userNameTextField.text,birDateLabel.text,sexString,nationNumLabel.text,addressTextField.text,self.memberID,self.lOnlyString,self.fileNOString],@[self.fileNOString,@"",sexString,nationNumLabel.text,birDateLabel.text,IDCardTextField.text,phoneNumTextField.text,self.memberID],@[self.fileNOString,userNameTextField.text,[usd objectForKey:@"truename"],addressTextField.text,[usd objectForKey:@"truename"],@"",phoneNumTextField.text,currentAddressField.text]] and:self];
            
                [self sendRequest:CHANGESIGNTYPE andPath:CHANGESIGNURL andSqlParameter:@{@"idcard":IDCardTextField.text,@"datetime":[self getNowTime],@"bind_team_id":self.teamItem.LID} and:self];
            
        }
    }
    else{
        NSString *msg=message;
        if(msg.length){
            [self showSimplePromptBox:self andMesage:message];
        }
    }
}

- (void)requestFail:(NSString *)type{
    uploadButton.selected=NO;
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    
    printView=[[PrintView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
    NSArray *nameArray=@[@"打印基本信息",@"打印签约协议(留存)",@"打印签约协议"];
    printView.delegate=self;
    [self.navigationController.view addSubview:printView];
    [printView creatUI:nameArray andPrintID:self.bindID andTitle:@"打印签约信息"];
}

- (void)cancelPrinView{
    if ([self.whoPush isEqualToString:@"MU"]) {
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[MyUserViewController class]]) {
                MyUserViewController *mvc=(MyUserViewController*)nvc;
                mvc.isRefresh=YES;
                [self.navigationController popToViewController:mvc animated:YES];
            }
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)addDistrictButton{
    District *item=[districtArray objectAtIndex:0];
    self.districtString=item.ID;
    if (districtButton) {
        uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, districtButton.frame.origin.y, uploadButton.frame.size.width, 40);
        
        BGScrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
        
        [districtButton removeFromSuperview];
        districtButton=nil;
    }
    districtButton=[self addButton:CGRectMake(0, uploadButton.frame.origin.y, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceDistrict)];
    [BGScrollView addSubview:districtButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:districtButton];
    [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:districtButton];
    
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"行政区划" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [districtButton addSubview:sexLabel];
    
    districtLabel=[self addLabel:CGRectMake(90, 15, SCREENWIDTH-130, 20) andText:item.Name andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [districtButton addSubview:districtLabel];
    
    UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,18,14,14)];
    goImagView.image=[UIImage imageNamed:@"arrow_2"];
    [districtButton addSubview:goImagView];
    
    uploadButton.frame=CGRectMake(uploadButton.frame.origin.x, uploadButton.frame.origin.y+60, uploadButton.frame.size.width, 40);
    
    BGScrollView.contentSize=CGSizeMake(0, uploadButton.frame.origin.y+uploadButton.frame.size.height+40);
    
}

- (void)choiceDistrict{
    lastChoiceButton=districtButton;
    NSMutableArray *nameArry=[NSMutableArray new];
    for (District *item in districtArray) {
        [nameArry addObject:item.Name];
    }
    [self addChoiceView:nameArry];
}

- (void)choiceTeam:(UIButton*)button{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
    [button endEditing:YES];
    ChoiceDocTeamViewController *cvc=[ChoiceDocTeamViewController new];
    cvc.whoPush=@"SI";
    [self.navigationController pushViewController:cvc animated:YES];
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
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}
- (void)sureChoiceDate:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    birDateLabel.text=s1;
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}
- (void)cancelChoiceDate{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)choiceMarriage:(UIButton*)button{
    lastChoiceButton=button;
    NSMutableArray *sexArray=[NSMutableArray arrayWithObjects:@"未婚",@"已婚",@"离婚",@"丧偶", nil];
    [self addChoiceView:sexArray];
}

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
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}

- (void)cancelChoiceMenu{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)sureChoiceMenu:(NSString *)menuString{
    if (lastChoiceButton==districtButton) {
        districtLabel.text=menuString;
        for (District *item in districtArray) {
            if ([item.Name isEqualToString:menuString]) {
                self.districtString=item.ID;
            }
        }
    }else if (lastChoiceButton==marriageButton){
        marriageCLabel.text=menuString;
    }
    else if (lastChoiceButton==nationButton){
        nationNumLabel.text=menuString;
    }else{
        sexNumLabel.text=menuString;
    }
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==IDCardTextField) {
        NSString *regex = @"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]||[string isEqualToString:@"x"]||[string isEqualToString:@"X"]) {
            if (textField.text.length<18||(textField.text.length==18&&[string isEqualToString:@""])) {
                return YES;
            }
        }
        return NO;
    }else if (textField==phoneNumTextField){
        if ([self checkIDcard:IDCardTextField.text]) {
            if (textField.text.length<11||(textField.text.length==11&&[string isEqualToString:@""])) {
                if (textField.text.length==10&&![string isEqualToString:@""]) {
                    if (![self checkPhoneNumber:[NSString stringWithFormat:@"%@%@",phoneNumTextField.text,string]]) {
                        phoneNumTextField.text=[NSString stringWithFormat:@"%@%@",phoneNumTextField.text,string];
                        [self showSimplePromptBox:self andMesage:@"您输入的手机号码有误！"];
                    }
                }
                return YES;
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"身份证号码有误，请先输入正确的身份证号码，再输入手机号！"];
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
//                [self sendRequest:@"IDCardIsHave" andPath:queryURL andSqlParameter:textField.text and:self];
            }else{
                [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
        }
    }
}


- (void)checkIDCard{
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc]init];
    con.scNaigationDelegate=self;
    con.iCardType=TIDCARD2; // 其他证件以此类推
    //con.ScanMode=TIDC_SCAN_MODE;
    con.isDisPlayTxt=YES;
    [self presentViewController:con animated:YES completion:NULL];
}


- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    userNameTextField.text=name;
    sexNumLabel.text=sex;
    nationNumLabel.text=folk;
    birDateLabel.text=[self changeDateString:birthday];
    addressTextField.text=address;
    currentAddressField.text=address;
    IDCardTextField.text=num;
    
    [self performSelector:@selector(upRequest:) withObject:num afterDelay:1.0f];
}

- (void)upRequest:(NSString*)num{
    [self sendRequest:@"IDCardIsHave" andPath:queryURL andSqlParameter:num and:self];
}

- (NSString *)changeDateString:(NSString*)birString{
    NSString *newString=[birString stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return newString;
}


//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}


//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
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
