//
//  SAMemberInfoViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SAMemberInfoViewController.h"
#import "SCCaptureCameraController.h"
#import "ChoiceDocTeamViewController.h"
#import "MyUserViewController.h"
#import "CheckboxView.h"
@interface SAMemberInfoViewController ()

@end

@implementation SAMemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@""];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.teamItem) {
        teamNameLabel.text=self.teamItem.LName;
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

- (void)viewDidDisappear:(BOOL)animated{
    if (checkboxView) {
        [checkboxView cancel];
    }
}

- (void)popViewController{
    if ([self.whoPush isEqualToString:@"FD"]) {
        [self.myTabBarController showTabBar];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    UIView *IDcardInfoView=[self addSimpleBackView:CGRectMake(0, IDcardButton.frame.origin.y+IDcardButton.frame.size.height+10, SCREENWIDTH,400) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:IDcardInfoView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    [self addLineLabel:CGRectMake(0,IDcardInfoView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:IDcardInfoView];
    
    UILabel *nickNameLabel=[self addLabel:CGRectMake(10, 15, 70,20) andText:@"昵称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nickNameLabel];
    
    nickNameTextField=[self addTextfield:CGRectMake(90, 10, SCREENWIDTH-100, 30) andPlaceholder:@"请输入用户昵称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nickNameTextField.delegate=self;
    nickNameTextField.textAlignment=2;
    [IDcardInfoView addSubview:nickNameTextField];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, 65, 70,20) andText:@"姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nameLabel];
    
    nameTextField=[self addTextfield:CGRectMake(90, 60, SCREENWIDTH-100, 30) andPlaceholder:@"请输入用户真实姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nameTextField.delegate=self;
    nameTextField.textAlignment=2;
    [IDcardInfoView addSubview:nameTextField];
    
    UIButton *birDateButton=[self addButton:CGRectMake(0, 100, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceDate)];
    [IDcardInfoView addSubview:birDateButton];
    
    UILabel *dateLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"出生日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [birDateButton addSubview:dateLabel];
    
    birDateLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [birDateButton addSubview:birDateLabel];
    
    [self addGotoNextImageView:birDateButton];
    
    UIButton *sexButton=[self addButton:CGRectMake(0, 150, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceSex:)];
    [IDcardInfoView addSubview:sexButton];
    
    UILabel *sexLabel=[self addLabel:CGRectMake(10, 15, 70, 20) andText:@"性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sexButton addSubview:sexLabel];
    
    sexNumLabel=[self  addLabel:CGRectMake(90,15, SCREENWIDTH-120, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [sexButton addSubview:sexNumLabel];
    
    [self addGotoNextImageView:sexButton];
    
    UILabel *nationLabel=[self addLabel:CGRectMake(10, 215,70, 20) andText:@"民族" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:nationLabel];
    
    nationTextField=[self addTextfield:CGRectMake(90,210, SCREENWIDTH-100, 30) andPlaceholder:@"请输入民族信息" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    nationTextField.delegate=self;
    nationTextField.textAlignment=2;
    [IDcardInfoView addSubview:nationTextField];
    
    UILabel *addressLabel=[self addLabel:CGRectMake(10, 265,70, 20) andText:@"住址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:addressLabel];
    
    addressTextField=[self addTextfield:CGRectMake(90,260, SCREENWIDTH-100, 30) andPlaceholder:@"请输入地址信息" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    addressTextField.delegate=self;
    addressTextField.textAlignment=2;
    [IDcardInfoView addSubview:addressTextField];
    
    UILabel *IDCardLabel=[self addLabel:CGRectMake(10, 315,70, 20) andText:@"身份证号码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [IDcardInfoView addSubview:IDCardLabel];
    
    IDCardTextField=[self addTextfield:CGRectMake(90,310, SCREENWIDTH-100, 30) andPlaceholder:@"请输入身份证号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    IDCardTextField.delegate=self;
    IDCardTextField.textAlignment=2;
    [IDcardInfoView addSubview:IDCardTextField];
    
    UIButton *teamButton=[self addButton:CGRectMake(0,350, SCREENWIDTH, 50) adnColor:CLEARCOLOR andTag:101 andSEL:@selector(choiceTeam:)];
    [IDcardInfoView addSubview:teamButton];
    
    UILabel *teamLabel=[self addLabel:CGRectMake(10, 15, 120, 20) andText:@"签约家庭医生团队" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [teamButton addSubview:teamLabel];
    
    teamNameLabel=[self  addLabel:CGRectMake(130,15, SCREENWIDTH-160, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
    [teamButton addSubview:teamNameLabel];
    
    [self addGotoNextImageView:teamButton];
    
    for (int i=0; i<7; i++) {
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
    
    
    signButton=[self addSimpleButton:CGRectMake(20,diseaseButton.frame.origin.y+diseaseButton.frame.size.height+20, SCREENWIDTH-40,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureSign) andText:@"签约" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [signButton.layer setCornerRadius:20];
    [BGScrollView addSubview:signButton];
    
    BGScrollView.contentSize=CGSizeMake(0, signButton.frame.origin.y+signButton.frame.size.height+20);
    if ([self.whoPush isEqualToString:@"FD"]) {
        nickNameTextField.text=self.nameString;
        nameTextField.text=self.nameString;
        birDateLabel.text=self.birString;
        sexNumLabel.text=self.sexString;
        nationTextField.text=self.nationString;
        addressTextField.text=self.addressString;
        IDCardTextField.text=self.IDCardString;
        if (self.userItem) {
            personnelTypeCLabel.text=self.userItem.LPersonKind;
            diseaseCLabel.text=self.userItem.LDiseaseType;
        }
    }
    [self sendRequest:@"Login" andPath:queryURL andSqlParameter:@[self.taskItem.mobile,@"居民"] and:self];
}

- (void)sureSign{
    if (signButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *name = [nameTextField.text stringByTrimmingCharactersInSet:set];
        NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:set];
        NSString *nation = [nationTextField.text stringByTrimmingCharactersInSet:set];
        NSString *IDCard = [IDCardTextField.text stringByTrimmingCharactersInSet:set];
        if (name.length==0) {
            [self showSimplePromptBox:self andMesage:@"请输入用户的真实姓名！"];
        }else if (birDateLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的生日信息！"];
        }else if (sexNumLabel.text.length==0){
            [self showSimplePromptBox:self andMesage:@"请选择用户的性别！"];
        }else if (nation.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的民族信息！"];
        }else if (address.length==0){
            [self  showSimplePromptBox:self andMesage:@"请输入用户的住址信息！"];
        }else if (IDCard.length!=18){
            [self  showSimplePromptBox:self andMesage:@"请输入正确的的身份证号码！"];
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
            [self sendRequest:@"UpdateUserInfo" andPath:excuteURL andSqlParameter:@[nickNameTextField.text,name,sexNumLabel.text,nation,address,IDCard,birDateLabel.text,self.onlycodeString,mString,pString,dString] and:self];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]){
        NSArray *dataArray=message;
        if ([type isEqualToString:@"Login"]) {
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                nickNameTextField.text=[dic objectForKey:@"LNickname"];
                if (![self.whoPush isEqualToString:@"FD"]) {
                    nameTextField.text=[dic objectForKey:@"LName"];
                    birDateLabel.text=[self getSubTime:[dic objectForKey:@"member_birthday"] andFormat:@"yyyy-MM-dd"];
                    sexNumLabel.text=[dic objectForKey:@"LSex"];
                    nationTextField.text=[dic objectForKey:@"LFolk"];
                    addressTextField.text=[dic objectForKey:@"LIDAddr"];
                    IDCardTextField.text=[dic objectForKey:@"LIdNum"];
                }
            }
        }else if([type isEqualToString:@"UpdateUserInfo"]){
            if (self.bindID.length==0) {
                self.bindID=[self getUniqueStrByUUID];
            }
            if (self.bindID.length==0) {
                self.bindID=[self getUniqueStrByUUID];
            }
            NSArray *sqlParameter=@[self.teamItem.LID,self.teamItem.LName,self.onlycodeString,@"成功",[NSString stringWithFormat:@"%d",[EMPKEY intValue]],@"",self.bindID];
            signButton.selected=YES;
            [self sendRequest:@"SignApply" andPath:insetOrUpdataURL andSqlParameter:sqlParameter and:self];
        }
        else if([type isEqualToString:@"SignApply"]){
            signButton.selected=NO;
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"家庭医生签约成功！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
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
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    if([type isEqualToString:@"SignApply"]){
        signButton.selected=NO;
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    if ([self.isMU isEqualToString:@"MU"]) {
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

- (void)choiceTeam:(UIButton*)button{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64);
    [button endEditing:YES];
    ChoiceDocTeamViewController *cvc=[ChoiceDocTeamViewController new];
    [self.navigationController pushViewController:cvc animated:YES];
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
    birDateLabel.text=[self changeDateString:birthday];
    addressTextField.text=address;
    IDCardTextField.text=num;
}

- (NSString *)changeDateString:(NSString*)birString{
    NSString *newString=[birString stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    newString=[newString stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return newString;
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

- (void)sureChoiceMenu:(NSString *)menuString{
    if (lastChoiceButton==marriageButton) {
        marriageCLabel.text=menuString;
    }else{
        sexNumLabel.text=menuString;
    }
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)cancelChoiceMenu{
    BGScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"=%@=",string);
    if (textField==IDCardTextField) {
        NSString *regex = @"[0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([pred evaluateWithObject:string]||[string isEqualToString:@"x"]||[string isEqualToString:@"X"]) {
            if (textField.text.length<18||(textField.text.length==18&&[string isEqualToString:@""])) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
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
