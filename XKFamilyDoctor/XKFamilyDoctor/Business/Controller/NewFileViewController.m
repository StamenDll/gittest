//
//  NewFileViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/10/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NewFileViewController.h"
#import "CustomProgressView.h"
#import "SCCaptureCameraController.h"
#import "MyUserViewController.h"
#import "AddArchiveItem.h"

@interface NewFileViewController ()<SCNavigationControllerDelegate>

@end

@implementation NewFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"健康档案"];
    [self addLeftButtonItem];
    [self initData];
    [self creatUI];
    [self sendRequest:@"GetArchiveOption" andPath:queryURL andSqlParameter:nil and:self];
    if (self.userItem) {
        [self sendRequest:GETUSERFILETYPE andPath:[NSString stringWithFormat:@"http://116.52.164.59:7702%@",GETUSERFILEURL] andSqlParameter:@{@"idNum":self.userItem.LIdNum} and:self];
    }
}

- (void)initData{
    mainArray=[NSMutableArray new];
    paymentArray=[NSMutableArray new];
    allergicArray=[NSMutableArray new];
    exposeArray=[NSMutableArray new];
    familyFArray=[NSMutableArray new];
    diseaseArray=[NSMutableArray new];
    diseaseButtonArray=[NSMutableArray new];
    disabilityArray=[NSMutableArray new];
    self.familyFArray=[NSMutableArray new];
    self.familyMArray=[NSMutableArray new];
    self.familyBArray=[NSMutableArray new];
    self.familyDArray=[NSMutableArray new];
    self.diseaseArray=[NSMutableArray new];
    self.opsArray=[NSMutableArray new];
    self.traumaArray=[NSMutableArray new];
    self.bloodArray=[NSMutableArray new];
    self.disabilityArray=[NSMutableArray new];

    self.marital=@"";
    self.maternal=@"";
    self.liveType=@"";
    self.bloodType=@"";
    self.RH=@"";
    self.education=@"";
    self.job=@"";
    self.genetic=@"";
    self.kitchen=@"";
    self.fuel=@"";
    self.drinking=@"";
    self.toilet=@"";
    self.livestock=@"";
    self.personalUUID=[self getUniqueStrByUUID];
//    self.delFielNO=@"";
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic=message;
        if ([type isEqualToString:SETUSERFILETYPE]) {
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"建档已完成！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
        }else{
            self.userFileItem=[RMMapper objectWithClass:[UserFileInfoItem class] fromDictionary:dataDic];
            self.fileNo=self.userFileItem.fileNo;
            [self showUserFileToView];
        }
    }else if ([message isKindOfClass:[NSArray class]]){
        NSArray *dataArray=message;
        if([type isEqualToString:@"SearchIDNumber"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.DistrictNumber=[self changeNullString:[dic objectForKey:@"DistrictNumber"]];
                if (self.DistrictNumber.length==0) {
                    isCheckIDCard=YES;
                    [self showSimplePromptBox:self andMesage:@"该身份证号还未进行建档操作！"];
                }else{
                    if ([self changeNullString:[dic objectForKey:@"FileNo"]].length>0) {
                        isCheckIDCard=NO;
                    }
                    [self showSimplePromptBox:self andMesage:@"该身份证号已有档案信息！"];
                }
            }else{
                isCheckIDCard=YES;
                [self showSimplePromptBox:self andMesage:@"该身份证号还未建档！"];
            }
        }else if ([type isEqualToString:@"GetArchiveOption"]) {
            if (dataArray.count>0) {
                for (NSDictionary *dic in dataArray) {
                    AddArchiveItem *item=[RMMapper objectWithClass:[AddArchiveItem class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
            }
        }else if ([type isEqualToString:@"MemberCode"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.memberID=[self overMemberCod:[[dic objectForKey:@"nid"] stringValue]];
                [self setPostData];
            }
        }
    }else{
        if ([type isEqualToString:GETUSERFILETYPE]) {
            isCheckIDCard=YES;
        }else{
            [self showSimplePromptBox:self andMesage:message];
        }
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showUserFileToView{
    self.memberID=self.userFileItem.memberId;
    UITextField *paperNoField=(UITextField*)[self.view viewWithTag:1003];
    paperNoField.text=self.userFileItem.paperFileNo;
    
    UITextField *nameField=(UITextField*)[self.view viewWithTag:1004];
    nameField.text=self.userFileItem.name;
    
    UILabel *sexLabel=[[((UIButton*)[self.view viewWithTag:1005]) subviews] firstObject];
    sexLabel.text=@"男";
    if ([self.userFileItem.sex isEqualToString:@"2"]) {
        sexLabel.text=@"女";
    }
    sexLabel.textColor=TEXTCOLOR;
    
    UITextField *birLabel=[[((UIButton*)[self.view viewWithTag:1006]) subviews] firstObject];
    birLabel.text=[self getSubTime:self.userFileItem.birthday andFormat:@""];
    
    UITextField *nationLabel=[[((UIButton*)[self.view viewWithTag:1007]) subviews] firstObject];
    nationLabel.text=self.userFileItem.folk;
    
    UITextField *IDCardField=(UITextField*)[self.view viewWithTag:1008];
    IDCardField.text=self.userFileItem.idNum;
    
    UITextField *hjAdrField=(UITextField*)[self.view viewWithTag:1009];
    hjAdrField.text=self.userFileItem.residenceAddress;
    
    UITextField *nowAdrField=(UITextField*)[self.view viewWithTag:1010];
    nowAdrField.text=self.userFileItem.address;
    
    UITextField *mobileField=(UITextField*)[self.view viewWithTag:1011];
    mobileField.text=self.userFileItem.mobile;
    
    UITextField *districtIdField=(UITextField*)[self.view viewWithTag:1012];
    districtIdField.text=self.userFileItem.districtId;
    
    UITextField *townshipField=(UITextField*)[self.view viewWithTag:1013];
    townshipField.text=self.userFileItem.township;
    
    UITextField *villageField=(UITextField*)[self.view viewWithTag:1014];
    villageField.text=self.userFileItem.village;
    
    UITextField *buildUnitField=(UITextField*)[self.view viewWithTag:1015];
    buildUnitField.text=self.userFileItem.buildUnit;
    
    UITextField *buildPersonField=(UITextField*)[self.view viewWithTag:1016];
    buildPersonField.text=self.userFileItem.buildPerson;
    
    UITextField *doctorField=(UITextField*)[self.view viewWithTag:1017];
    doctorField.text=self.userFileItem.doctor;
    
    UILabel *buildDateLabel=[[((UIButton*)[self.view viewWithTag:1018]) subviews] firstObject];
    buildDateLabel.text=[self getSubTime:self.userFileItem.buildDate andFormat:@""];
    
    UITextField *barCodeField=(UITextField*)[self.view viewWithTag:1019];
    barCodeField.text=self.userFileItem.barCode;
    
    UITextField *houseMasterField=(UITextField*)[self.view viewWithTag:1020];
    houseMasterField.text=self.userFileItem.houseMaster;
    
    UITextField *cupBoardNoField=(UITextField*)[self.view viewWithTag:1021];
    cupBoardNoField.text=self.userFileItem.cupBoardNo;
    
    UITextField *boxNoField=(UITextField*)[self.view viewWithTag:1022];
    boxNoField.text=self.userFileItem.boxNo;
    
    if (self.fileNo.length>0&&(![self.userFileItem.inputPersonId isEqualToString:[NSString stringWithFormat:@"%@",EMPKEY]])) {
        uploadButton.backgroundColor=TEXTCOLORDG;
    }
    
    self.familyFArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.fatherHistoryList];
    self.familyMArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.matherHistoryList];
    self.familyDArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.brotherHistoryList];
    self.familyBArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.familyHistoryList];
    
    self.diseaseArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.diseaseHistoryList];
    self.traumaArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.traumaHistoryList];
    self.opsArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.opsHistoryList];
    self.bloodArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.bloodTransList];
    
    self.paymentArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.paymentModeList];
    self.allergicArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.allergiesHistoryList];
    self.exposeArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.exposeHistoryAOList];
    self.disabilityArray=[[NSMutableArray alloc]initWithArray:self.userFileItem.disabilityStatusList];
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}


- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    if (!self.titleString) {
        if (self.isCA) {
            [cProgressView creatUI:@[@"住户信息",@"完成建档"] andCount:1];
        }else{
            [cProgressView creatUI:@[@"选择小区",@"住户信息",@"完成建档"] andCount:2];
        }
    }
    [self.view addSubview:cProgressView];
    
    NSArray *btnArray=@[@"档案封面",@"家族史",@"既往史",@"其他信息"];
    for (int i=0; i<btnArray.count; i++) {
        UIButton *menuButton=[self addSimpleButton:CGRectMake(SCREENWIDTH/4*i, cProgressView.frame.origin.y+cProgressView.frame.size.height, SCREENWIDTH/4, 40) andBColor:CLEARCOLOR andTag:2001+i andSEL:@selector(changeFileView:) andText:[btnArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [self.view addSubview:menuButton];

        if (i>0) {
            [self addLineLabel:CGRectMake(SCREENWIDTH/4*i, cProgressView.frame.origin.y+cProgressView.frame.size.height, 0.5,40) andColor:LINECOLOR andBackView:self.view];
        }else{
            ((UILabel*)[menuButton.subviews firstObject]).textColor=GREENCOLOR;
            lastMenuButton=menuButton;
        }
    }
    moveLine=[[UILabel alloc]initWithFrame:CGRectMake(10,  cProgressView.frame.origin.y+cProgressView.frame.size.height+38, SCREENWIDTH/4-20, 2)];
    moveLine.backgroundColor=GREENCOLOR;
    [self.view addSubview:moveLine];
    
    [self addLineLabel:CGRectMake(0,cProgressView.frame.origin.y+cProgressView.frame.size.height+39.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    faceBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,cProgressView.frame.origin.y+cProgressView.frame.size.height+40, SCREENWIDTH, SCREENHEIGHT-(cProgressView.frame.origin.y+cProgressView.frame.size.height+40)-50)];
    faceBGView.delegate=self;
    [self.view addSubview:faceBGView];
    nowBGView=faceBGView;
    
    UIView *whiteBGView=[[UIView alloc]initWithFrame:CGRectMake(110, 0, SCREENWIDTH-110, 1000)];
    whiteBGView.backgroundColor=[UIColor whiteColor];
    [faceBGView addSubview:whiteBGView];
    
    UILabel *label3=[self addLabel:CGRectMake(10,10,90,20) andText:@"纸质档案编号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label3];
    
    UITextField *textField3N=[self addTextfield:CGRectMake(120, label3.frame.origin.y-5, SCREENWIDTH-240,30) andPlaceholder:@"请输入纸质档案编号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3N.keyboardType=UIKeyboardTypeNumberPad;
    textField3N.tag=1003;
    [faceBGView addSubview:textField3N];
    
    [self addLineLabel:CGRectMake(0, label3.frame.origin.y+label3.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label4=[self addLabel:CGRectMake(10,label3.frame.origin.y+label3.frame.size.height+20,90,20) andText:@"姓名 *" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label4.attributedText=[self setString:@"姓名 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label4];
    
    UITextField *textField4N=[self addTextfield:CGRectMake(120, label4.frame.origin.y-5, SCREENWIDTH-240,30) andPlaceholder:@"请输入姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField4N.text=self.userItem.LName;
    }
    
    textField4N.tag=1004;
    [faceBGView addSubview:textField4N];
    
    UIButton *readIDCardButton=[self addButton:CGRectMake(SCREENWIDTH-90, label4.frame.origin.y-2.5, 80,25) adnColor:GREENCOLOR andTag:0 andSEL:@selector(getIDCardInfo)];
    [readIDCardButton.layer setCornerRadius:12.5];
    [faceBGView addSubview:readIDCardButton];
    
    UILabel *readLabel=[self addLabel:CGRectMake(0,0,80,25) andText:@"身份证识别" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    [readIDCardButton addSubview:readLabel];
    
    [self addLineLabel:CGRectMake(0, label4.frame.origin.y+label4.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label5=[self addLabel:CGRectMake(10,label4.frame.origin.y+label4.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label5.attributedText=[self setString:@"性别 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label5];
    
    UIButton *button5N=[self addSimpleButton:CGRectMake(120, label5.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1005 andSEL:@selector(choiceSex:) andText:@"请选择性别" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *sexLabel=[[button5N subviews]lastObject];
    if (self.userItem) {
        sexLabel.text=self.userItem.LSex;
        sexLabel.textColor=TEXTCOLOR;
    }
    [faceBGView addSubview:button5N];
    
    [self addLineLabel:CGRectMake(0, label5.frame.origin.y+label5.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label6=[self addLabel:CGRectMake(10,label5.frame.origin.y+label5.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label6.attributedText=[self setString:@"出生日期 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label6];
    
    UIButton *button6N=[self addSimpleButton:CGRectMake(120, label6.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1006 andSEL:@selector(addDateChoiceView:) andText:@"请选择出生日期" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *birLabel=[[button6N subviews]lastObject];
    if (self.userItem) {
        birLabel.text=[self getSubTime:self.userItem.LBirthday andFormat:@"yyyy-MM-dd"];
        birLabel.textColor=TEXTCOLOR;
    }
    [faceBGView addSubview:button6N];
    
    [self addLineLabel:CGRectMake(0, label6.frame.origin.y+label6.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label7=[self addLabel:CGRectMake(10,label6.frame.origin.y+label6.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label7.attributedText=[self setString:@"民族" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label7];
    
    UIButton *button7N=[self addSimpleButton:CGRectMake(120, label7.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1007 andSEL:@selector(choiceSex:) andText:@"请选择民族" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *nationLabel=[[button7N subviews]lastObject];
    if (self.userItem) {
        nationLabel.text=self.userItem.LFolk;
        nationLabel.textColor=TEXTCOLOR;
    }

    [faceBGView addSubview:button7N];
    
    [self addLineLabel:CGRectMake(0, label7.frame.origin.y+label7.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label8=[self addLabel:CGRectMake(10,label7.frame.origin.y+label7.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label8.attributedText=[self setString:@"身份证号码 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label8];
    
    UITextField *textField8=[self addTextfield:CGRectMake(120, label8.frame.origin.y+12.5, SCREENWIDTH-130,30) andPlaceholder:@"请输入身份证号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField8.text=self.userItem.LIdNum;
    }
    textField8.adjustsFontSizeToFitWidth=YES;
    textField8.tag=1008;
    textField8.delegate=self;
    [textField8 addTarget:self action:@selector(IDCardTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [faceBGView addSubview:textField8];
    
    UIButton *checkIDCardButton=[self addButton:CGRectMake(10, label8.frame.origin.y+30, 80,25) adnColor:GREENCOLOR andTag:0 andSEL:@selector(checkIDNumber)];
    [checkIDCardButton.layer setCornerRadius:12.5];
    [faceBGView addSubview:checkIDCardButton];
    
    UILabel *checkIDCardLabel=[self addLabel:CGRectMake(0,0,80,25) andText:@"重复检测" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    [checkIDCardButton addSubview:checkIDCardLabel];
    
    [self addLineLabel:CGRectMake(0, checkIDCardButton.frame.origin.y+checkIDCardButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];

    UILabel *label9=[self addLabel:CGRectMake(10, textField8.frame.origin.y+textField8.frame.size.height+32.5,90,20) andText:@"户籍地址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label9];
    
    UITextField *textField9=[self addTextfield:CGRectMake(120, label9.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入户籍地址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField9.text=self.userItem.LIDAddr;
    }

    textField9.adjustsFontSizeToFitWidth=YES;
    textField9.tag=1009;
    [faceBGView addSubview:textField9];
    
    [self addLineLabel:CGRectMake(0, label9.frame.origin.y+label9.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label10=[self addLabel:CGRectMake(10,label9.frame.origin.y+label9.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label10.attributedText=[self setString:@"现住址*" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label10];
    
    UITextField *textField10=[self addTextfield:CGRectMake(120, label10.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入现住址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField10.text=self.userItem.LIDAddr;
    }

    textField10.adjustsFontSizeToFitWidth=YES;
    textField10.tag=1010;
    [faceBGView addSubview:textField10];
    
    [self addLineLabel:CGRectMake(0, label10.frame.origin.y+label10.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label11=[self addLabel:CGRectMake(10,label10.frame.origin.y+label10.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label11.attributedText=[self setString:@"联系电话 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label11];
    
    UITextField *textField11N=[self addTextfield:CGRectMake(120, label11.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系电话" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField11N.text=[[self.userItem.LMobile componentsSeparatedByString:@"_"] firstObject];
    }

    textField11N.tag=1011;
    textField11N.keyboardType=UIKeyboardTypeNumberPad;
    [faceBGView addSubview:textField11N];
    
    [self addLineLabel:CGRectMake(0, label11.frame.origin.y+label11.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label12=[self addLabel:CGRectMake(10,label11.frame.origin.y+label11.frame.size.height+20,90,20) andText:@"行政区划编码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label12];
    
    UILabel *label12N=[self addLabel:CGRectMake(120,label12.frame.origin.y,SCREENWIDTH-130,20) andText:self.NCItem.ID andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label12N.tag=1012;
    [faceBGView addSubview:label12N];
    
    [self addLineLabel:CGRectMake(0, label12.frame.origin.y+label12.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label13=[self addLabel:CGRectMake(10,label12.frame.origin.y+label12.frame.size.height+20,90,20) andText:@"乡镇(街道)名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label13.numberOfLines=0;
    [label13 sizeToFit];
    label13.frame=CGRectMake(10, label12.frame.origin.y+label12.frame.size.height+20, 90, label13.frame.size.height);
    [faceBGView addSubview:label13];
    
    UILabel *label13N=[self addLabel:CGRectMake(120,label12.frame.origin.y+label12.frame.size.height+10+label13.frame.size.height/2,SCREENWIDTH-130,20) andText:self.NCItem.ParentName andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label13N.tag=1013;
    [faceBGView addSubview:label13N];
    
    [self addLineLabel:CGRectMake(0, label13.frame.origin.y+label13.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label14=[self addLabel:CGRectMake(10,label13.frame.origin.y+label13.frame.size.height+20,90,20) andText:@"村(居)委会名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label14.numberOfLines=0;
    [label14 sizeToFit];
    label14.frame=CGRectMake(10, label13.frame.origin.y+label13.frame.size.height+20, 90, label14.frame.size.height);
    [faceBGView addSubview:label14];
    
    UILabel *label14N=[self addLabel:CGRectMake(120,label13.frame.origin.y+label13.frame.size.height+10+label14.frame.size.height/2,SCREENWIDTH-130,20) andText:self.NCItem.Name andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label14N.tag=1014;
    [faceBGView addSubview:label14N];
    
    [self addLineLabel:CGRectMake(0, label14.frame.origin.y+label14.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label15=[self addLabel:CGRectMake(10,label14.frame.origin.y+label14.frame.size.height+20,90,20) andText:@"建档单位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label15];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    UILabel *label15N=[self addLabel:CGRectMake(120,label14.frame.origin.y+label14.frame.size.height+20,SCREENWIDTH-130,20) andText:[usd objectForKey:@"orgname"]  andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label15N.tag=1015;
    [faceBGView addSubview:label15N];
    
    [self addLineLabel:CGRectMake(0, label15.frame.origin.y+label15.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label16=[self addLabel:CGRectMake(10,label15.frame.origin.y+label15.frame.size.height+20,90,20) andText:@"建档人" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label16];
    
    UILabel *label16N=[self addLabel:CGRectMake(120, label16.frame.origin.y, SCREENWIDTH-130,20) andText:[usd objectForKey:@"truename"] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label16N.tag=1016;
    [faceBGView addSubview:label16N];
    
    [self addLineLabel:CGRectMake(0, label16.frame.origin.y+label16.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label17=[self addLabel:CGRectMake(10,label16.frame.origin.y+label16.frame.size.height+20,90,20) andText:@"责任医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label17];
    
    UITextField *textField17=[self addTextfield:CGRectMake(120, label17.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入责任医生" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField17.adjustsFontSizeToFitWidth=YES;
    textField17.tag=1017;
    [faceBGView addSubview:textField17];
    
    [self addLineLabel:CGRectMake(0, label17.frame.origin.y+label17.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label18=[self addLabel:CGRectMake(10,label17.frame.origin.y+label17.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label18.attributedText=[self setString:@"建档日期 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label18];
    
    UIButton *button18N=[self addSimpleButton:CGRectMake(120, label18.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1018 andSEL:@selector(addDateChoiceView:) andText:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"] andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [faceBGView addSubview:button18N];
    
    [self addLineLabel:CGRectMake(0, label18.frame.origin.y+label18.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label19=[self addLabel:CGRectMake(10,label18.frame.origin.y+label18.frame.size.height+20,90,20) andText:@"条形码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label19];
    
    UITextField *textField19=[self addTextfield:CGRectMake(120, label19.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入条形码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField19.adjustsFontSizeToFitWidth=YES;
    textField19.tag=1019;
    [faceBGView addSubview:textField19];
    
    [self addLineLabel:CGRectMake(0, label19.frame.origin.y+label19.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label20=[self addLabel:CGRectMake(10,label19.frame.origin.y+label19.frame.size.height+20,90,20) andText:@"户主" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label20];
    
    UITextField *textField20=[self addTextfield:CGRectMake(120, label20.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入户主" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField20.adjustsFontSizeToFitWidth=YES;
    textField20.tag=1020;
    [faceBGView addSubview:textField20];
    
    [self addLineLabel:CGRectMake(0, label20.frame.origin.y+label20.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label21=[self addLabel:CGRectMake(10,label20.frame.origin.y+label20.frame.size.height+20,90,20) andText:@"柜号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label21];
    
    UITextField *textField21=[self addTextfield:CGRectMake(120, label21.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入柜号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField21.adjustsFontSizeToFitWidth=YES;
    textField21.tag=1021;
    [faceBGView addSubview:textField21];
    
    [self addLineLabel:CGRectMake(0, label21.frame.origin.y+label21.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
    
    UILabel *label22=[self addLabel:CGRectMake(10,label21.frame.origin.y+label21.frame.size.height+20,90,20) andText:@"盒号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [faceBGView addSubview:label22];
    
    UITextField *textField22=[self addTextfield:CGRectMake(120, label22.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入盒号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField22.adjustsFontSizeToFitWidth=YES;
    textField22.tag=1022;
    [faceBGView addSubview:textField22];
    
    [self addLineLabel:CGRectMake(0, label22.frame.origin.y+label22.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];

    
/*
     UILabel *label32=[self addLabel:CGRectMake(10,button18N.frame.origin.y+button18N.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label32.attributedText=[self setString:@"人口类型 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [faceBGView addSubview:label32];
    
    NSArray *farmArray=@[@"1.农业人口",@"2.城镇居民"];
    NSMutableArray *farmBtnArray=[NSMutableArray new];
    for (int i=0; i<farmArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label32.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFarmOrTown:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [faceBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[farmArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (i>0) {
            UIButton *lastBtn=[farmBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [farmBtnArray addObject:addressButton];
        if (i==farmArray.count-1) {
            label32.frame=CGRectMake(10,label32.frame.origin.y-10+(addressButton.frame.origin.y+35-(label32.frame.origin.y-10)-20)/2, 90, 20);
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:faceBGView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
 */
    whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, label22.frame.origin.y+label22.frame.size.height+10);
    
    faceBGView.contentSize=CGSizeMake(0,whiteBGView.frame.origin.y+whiteBGView.frame.size.height+40);
    
    [self addLineLabel:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    uploadButton=[self addCurrencyButton:CGRectMake(20,SCREENHEIGHT-45, SCREENWIDTH-40, 40) andText:@"提交" andSEL:@selector(sureUpload)];
    [self.view addSubview:uploadButton];
    
    [self addOneTapGestureRecognizer:self.view andSel:@selector(cancelkeyboard)];
}

- (void)changeFileView:(UIButton*)button{
        if (button.tag==2001) {
            nowBGView.hidden=YES;
            faceBGView.hidden=NO;
            nowBGView=faceBGView;
        }else if (button.tag==2002){
            [self addFamilyView];
        }else if (button.tag==2003){
            [self addPastView];
        }else if (button.tag==2004){
            [self addOtherInfoView];
        }
    
    UILabel *label=[[button subviews] lastObject];
    label.textColor=GREENCOLOR;
    if (lastMenuButton!=button) {
        lastMenuButton.selected=NO;
        UILabel *lastLabel=[[lastMenuButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }
    button.selected=YES;
    lastMenuButton.selected=NO;
    lastMenuButton=button;
    moveLine.frame=CGRectMake(button.frame.origin.x+10,moveLine.frame.origin.y, moveLine.frame.size.width, 2);
}

- (void)sureUpload{
    if (uploadButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //        姓名
        UITextField *nameTextField=(UITextField*)[self.view viewWithTag:1004];
        NSString *tureName = [nameTextField.text stringByTrimmingCharactersInSet:set];
        //        性别
        UIButton *sexButton=(UIButton*)[self.view viewWithTag:1005];
        UILabel *sexLabel=[[sexButton subviews] firstObject];
        //        生日
        UIButton *birthdayButton=(UIButton*)[self.view viewWithTag:1006];
        UILabel *birthdayLabel=[[birthdayButton subviews] firstObject];
        
        //        身份证号码
        UITextField *IDNumber=(UITextField*)[self.view viewWithTag:1008];
        
        //        现住址
        UITextField *addressNowTextField=(UITextField*)[self.view viewWithTag:1010];
        NSString *addressNow = [addressNowTextField.text stringByTrimmingCharactersInSet:set];
        //        联系电话
        UITextField *selfPhoneTextField=(UITextField*)[self.view viewWithTag:1011];
        NSString *selfPhone = [selfPhoneTextField.text stringByTrimmingCharactersInSet:set];
        //        建档日期
        UIButton *writeTimeButton=(UIButton*)[self.view viewWithTag:1018];
        UILabel *writeTimeLabel=[[writeTimeButton subviews] firstObject];
        if (tureName.length==0) {
            [self showSimplePromptBox:self andMesage:@"姓名不能为空！"];
        }else if ([sexLabel.text isEqualToString:@"请选择性别"]){
            [self showSimplePromptBox:self andMesage:@"性别不能为空！"];
        }else if ([birthdayLabel.text isEqualToString:@"请选择出生日期"]){
            [self showSimplePromptBox:self andMesage:@"生日不能为空！"];
        }else if (![self checkIDcard:IDNumber.text]){
            [self showSimplePromptBox:self andMesage:@"身份证号码输入有误！"];
        }else if (addressNow.length==0) {
            [self showSimplePromptBox:self andMesage:@"现住址不能为空！"];
        }else if (selfPhone.length==0) {
            [self showSimplePromptBox:self andMesage:@"联系电话不能为空！"];
        }else if ([writeTimeLabel.text isEqualToString:@"请选择建档日期"]){
            [self showSimplePromptBox:self andMesage:@"建档日期不能为空！"];
        }else if (isCheckIDCard==NO&&self.fileNo.length==0){
            [self showSimplePromptBox:self andMesage:@"请先确定该身份证号未进行过建档操作（身份证重复检测）"];
        }
        else if (self.fileNo.length>0&&(![self.userFileItem.inputPersonId isEqualToString:[NSString stringWithFormat:@"%@",EMPKEY]])) {
            [self showSimplePromptBox:self andMesage:@"只有建档人可以对档案信息进行修改操作！"];
        }
        else if(self.memberID.length==0){
            [self sendRequest:@"MemberCode" andPath:queryURL andSqlParameter:nil and:self];
        }else{
            [self setPostData];
        }
    }
}

- (void)setPostData{
    if (!self.userFileItem) {
        self.userFileItem=[UserFileInfoItem new];
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    //        姓名
    UITextField *nameTextField=(UITextField*)[self.view viewWithTag:1004];
    NSString *tureName = [nameTextField.text stringByTrimmingCharactersInSet:set];
    //        性别
    UIButton *sexButton=(UIButton*)[self.view viewWithTag:1005];
    UILabel *sexLabel=[[sexButton subviews] firstObject];
    //        生日
    UIButton *birthdayButton=(UIButton*)[self.view viewWithTag:1006];
    UILabel *birthdayLabel=[[birthdayButton subviews] firstObject];
    
    //        身份证号码
    UITextField *IDNumber=(UITextField*)[self.view viewWithTag:1008];
    
    //        现住址
    UITextField *addressNowTextField=(UITextField*)[self.view viewWithTag:1010];
    NSString *addressNow = [addressNowTextField.text stringByTrimmingCharactersInSet:set];
    //        联系电话
    UITextField *selfPhoneTextField=(UITextField*)[self.view viewWithTag:1011];
    NSString *selfPhone = [selfPhoneTextField.text stringByTrimmingCharactersInSet:set];
    //        建档日期
    UIButton *writeTimeButton=(UIButton*)[self.view viewWithTag:1018];
    UILabel *writeTimeLabel=[[writeTimeButton subviews] firstObject];
    
    self.userFileItem.fileNo=self.fileNo;
    self.userFileItem.memberId=self.memberID;
    self.userFileItem.name=tureName;
    self.userFileItem.sex=@"1";
    if ([sexLabel.text isEqualToString:@"女"]) {
        self.userFileItem.sex=@"2";
    }
    self.userFileItem.birthday=[NSString stringWithFormat:@"%@ 00:00:00",birthdayLabel.text];
    UILabel *folkLabel=[[((UIButton*)[self.view viewWithTag:1007]) subviews]lastObject];
    self.userFileItem.folk=folkLabel.text;
    self.userFileItem.idNum=IDNumber.text;
    self.userFileItem.residenceAddress=((UITextField*)[self.view viewWithTag:1009]).text;
    self.userFileItem.address=addressNow;
    self.userFileItem.mobile=selfPhone;
    if (self.NCItem) {
        self.userFileItem.districtId=self.NCItem.ID;
        self.userFileItem.township=self.NCItem.ParentName;
        self.userFileItem.village=self.NCItem.Name;
        self.userFileItem.currentOrgId=[NSString stringWithFormat:@"%ld",(long)self.NCItem.OrgID];
    }
    
    if (self.choiceHouseholdItem) {
        self.userFileItem.cellId=self.choiceHouseholdItem.CellID;
        self.userFileItem.areaId=self.choiceHouseholdItem.AreaID;
        self.userFileItem.unitId=self.choiceHouseholdItem.UnitID;
    }
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    self.userFileItem.buildUnit=[usd objectForKey:@"orgname"];
    self.userFileItem.buildPerson=[usd objectForKey:@"truename"];
    self.userFileItem.aiderCode=EMPKEY;
    self.userFileItem.aiderName=[usd objectForKey:@"truename"];
    self.userFileItem.inputPersonId=EMPKEY;
    
    UITextField *Doctor=(UITextField*)[self.view viewWithTag:1017];
    self.userFileItem.doctor=Doctor.text;
    self.userFileItem.buildDate=[NSString stringWithFormat:@"%@ 00:00:00",writeTimeLabel.text];
    UITextField *BarCode=(UITextField*)[self.view viewWithTag:1019];
    self.userFileItem.barCode=BarCode.text;
    UITextField *HouseMaster=(UITextField*)[self.view viewWithTag:1020];
    self.userFileItem.houseMaster=HouseMaster.text;
    UITextField *CupboardNo=(UITextField*)[self.view viewWithTag:1021];
    self.userFileItem.cupBoardNo=CupboardNo.text;
    UITextField *BoxNo=(UITextField*)[self.view viewWithTag:1022];
    self.userFileItem.boxNo=BoxNo.text;
    self.userFileItem.fatherHistoryList=self.familyFArray;
    self.userFileItem.matherHistoryList=self.familyMArray;
    self.userFileItem.brotherHistoryList=self.familyBArray;
    self.userFileItem.familyHistoryList=self.familyDArray;
    self.userFileItem.diseaseHistoryList=self.diseaseArray;
    self.userFileItem.traumaHistoryList=self.traumaArray;
    self.userFileItem.bloodTransList=self.bloodArray;
    self.userFileItem.opsHistoryList=self.opsArray;
    
    UITextField *workUnit=(UITextField*)[self.view viewWithTag:1023];
    self.userFileItem.workUnit=workUnit.text;
    
    UITextField *linkMan=(UITextField*)[self.view viewWithTag:1024];
    self.userFileItem.linkMan=linkMan.text;
    
    UITextField *linkManTEL=(UITextField*)[self.view viewWithTag:1025];
    self.userFileItem.linkManTEL=linkManTEL.text;
    
    self.userFileItem.resideType=self.liveType;
    self.userFileItem.bloodTypeABO=self.bloodType;
    self.userFileItem.bloodTypeRH=self.RH;
    self.userFileItem.education=self.education;
    self.userFileItem.occupation=self.job;
    self.userFileItem.maritalStatus=self.marital;
    
    if ([self.farmOrTown isEqualToString:@"农业人口"]) {
        self.userFileItem.farmStatus=@"是";
        self.userFileItem.townStatus=@"否";
    }else if([self.farmOrTown isEqualToString:@"城镇居民"]){
        self.userFileItem.farmStatus=@"否";
        self.userFileItem.townStatus=@"是";
    }else{
        self.userFileItem.farmStatus=@"";
        self.userFileItem.townStatus=@"";
    }
    self.userFileItem.bornStatus=self.maternal;
    self.userFileItem.paymentModeList=self.paymentArray;
    self.userFileItem.allergiesHistoryList=self.allergicArray;
    self.userFileItem.exposeHistoryAOList=self.exposeArray;
    self.userFileItem.geneticHistory=self.genetic;
    self.userFileItem.disabilityStatusList=self.disabilityArray;
    
    self.userFileItem.kitchen=self.kitchen;
    self.userFileItem.bunkers=self.fuel;
    self.userFileItem.drinkingWater=self.drinking;
    self.userFileItem.toilet=self.toilet;
    self.userFileItem.poultry=self.livestock;
    
    [self sendRequest:SETUSERFILETYPE andPath:[NSString stringWithFormat:@"http://116.52.164.59:7702%@",SETUSERFILEURL] andSqlParameter:[self getObjectData:self.userFileItem] and:self];
}

- (void)addFamilyView{
    if (!familyBGView) {
    familyBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,nowBGView.frame.origin.y, SCREENWIDTH,nowBGView.frame.size.height)];
    [self.view addSubview:familyBGView];
    
    UILabel *label39=[self addLabel:CGRectMake(10,10,50,20) andText:@"家族史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [familyBGView addSubview:label39];
    
    UIView *dWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [familyBGView addSubview:dWhiteView];
    
    UILabel *label391=[self addLabel:CGRectMake(80,10,40,20) andText:@"父亲" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [familyBGView addSubview:label391];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==148&&item.ID!=148) {
            [familyFArray addObject:item];
        }
    }
    NSMutableArray *fatherBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label391.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyF:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [familyBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name]  andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (((NSArray*)self.userFileItem.fatherHistoryList).count>0) {
            for (NSDictionary *fatherDic in self.userFileItem.fatherHistoryList) {
                if ([[fatherDic objectForKey:@"heredityid"]intValue]==item.ID) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                }
            }
        }else{
            if (i==0) {
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
                [dic setObject:item.Name forKey:@"name"];
                [self.familyFArray addObject:dic];
            }
        }
        if (i>0) {
            UIButton *lastBtn=[fatherBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [fatherBtnArray addObject:addressButton];
        if (i==familyFArray.count-1) {
            label391.frame=CGRectMake(80,label391.frame.origin.y-10+(addressButton.frame.origin.y+35-(label391.frame.origin.y-10)-20)/2,40, 20);
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:familyBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label392=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"母亲" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [familyBGView addSubview:label392];
    
    NSMutableArray *motherBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label392.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyM:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [familyBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (((NSArray*)self.userFileItem.matherHistoryList).count>0) {
            for (NSDictionary *matherDic in self.userFileItem.matherHistoryList) {
                if ([[matherDic objectForKey:@"heredityid"]intValue]==item.ID) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                }
            }
        }else{
            if (i==0) {
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
                [dic setObject:item.Name forKey:@"name"];
                [self.familyMArray addObject:dic];
            }
        }
        
        if (i>0) {
            UIButton *lastBtn=[motherBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [motherBtnArray addObject:addressButton];
        if (i==familyFArray.count-1) {
            label392.frame=CGRectMake(80,label392.frame.origin.y-10+(addressButton.frame.origin.y+35-(label392.frame.origin.y-10)-20)/2,40, 20);
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:familyBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label393=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40, 0) andText:@"兄弟姐妹" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label393.numberOfLines=0;
    [label393 sizeToFit];
    label393.frame=CGRectMake(10, dWhiteView.frame.size.height+10, 40, label393.frame.size.height);
    [familyBGView addSubview:label393];
    
    NSMutableArray *basBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label393.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyB:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [familyBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (((NSArray*)self.userFileItem.brotherHistoryList).count>0) {
            for (NSDictionary *brotherDic in self.userFileItem.brotherHistoryList) {
                if ([[brotherDic objectForKey:@"heredityid"]intValue]==item.ID) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                }
            }
        }else{
            if (i==0) {
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
                [dic setObject:item.Name forKey:@"name"];
                [self.familyBArray addObject:dic];
            }
        }
        if (i>0) {
            UIButton *lastBtn=[basBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [basBtnArray addObject:addressButton];
        if (i==familyFArray.count-1) {
            label393.frame=CGRectMake(80,label393.frame.origin.y-10+(addressButton.frame.origin.y+35-(label393.frame.origin.y-10)-label393.frame.size.height)/2,40, label393.frame.size.height);
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:familyBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    
    UILabel *label394=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"儿女" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [familyBGView addSubview:label394];
    
    NSMutableArray *sadBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label394.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyD:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [familyBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        if (((NSArray*)self.userFileItem.familyHistoryList).count>0) {
            for (NSDictionary *brotherDic in self.userFileItem.familyHistoryList) {
                if ([[brotherDic objectForKey:@"heredityid"]intValue]==item.ID) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                }
            }
        }else{
            if (i==0) {
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
                [dic setObject:item.Name forKey:@"name"];
                [self.familyDArray addObject:dic];
            }
        }
        if (i>0) {
            UIButton *lastBtn=[sadBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [sadBtnArray addObject:addressButton];
        if (i==familyFArray.count-1) {
            label394.frame=CGRectMake(80,label394.frame.origin.y-10+(addressButton.frame.origin.y+35-(label394.frame.origin.y-10)-20)/2,40, 20);
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:familyBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    familyBGView.contentSize=CGSizeMake(0, dWhiteView.frame.origin.y+dWhiteView.frame.size.height+40);
    [self addLineLabel:CGRectMake(80, 0,0.5, dWhiteView.frame.size.height) andColor:LINECOLOR andBackView:familyBGView];
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:familyBGView];
    label39.frame=CGRectMake(10, (familyBGView.contentSize.height-20)/2,label39.frame.size.width, 20);
    }
    
    nowBGView.hidden=YES;
    familyBGView.hidden=NO;
    nowBGView=familyBGView;
}

- (void)addPastView{
    if (!pastBGView) {
        pastBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,nowBGView.frame.origin.y,SCREENWIDTH,nowBGView.frame.size.height)];
        pastBGView.hidden=YES;
        [self.view addSubview:pastBGView];
    
        diseaseBGView=[self addSimpleBackView:CGRectMake(0,0, SCREENWIDTH,40) andColor:CLEARCOLOR];
        [pastBGView addSubview:diseaseBGView];
        
        [self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"疾病" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0 andBGView:diseaseBGView];
        
        NSMutableArray *diseaseViewArray=[NSMutableArray new];
        if (((NSArray*)self.userFileItem.diseaseHistoryList).count>0) {
            for (int i=0; i<((NSArray*)self.userFileItem.diseaseHistoryList).count; i++) {
                NSDictionary *diseaseDic=[self.userFileItem.diseaseHistoryList objectAtIndex:i];
                UIView *diseaseSubView=[self addSimpleBackView:CGRectMake(10,40+60*i, SCREENWIDTH-20,50) andColor:MAINWHITECOLOR];
                diseaseSubView.layer.borderColor=LINECOLOR.CGColor;
                diseaseSubView.layer.borderWidth=0.5;
                [diseaseSubView.layer setCornerRadius:10];
                [diseaseBGView addSubview:diseaseSubView];
                
                UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"名称: %@",[diseaseDic objectForKey:@"name"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [diseaseSubView addSubview:nameLabel];
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[diseaseDic objectForKey:@"confirmdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [diseaseSubView addSubview:dateLabel];
                
                UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(delDiseaseSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
                delButton.layer.borderColor=LINECOLOR.CGColor;
                delButton.layer.borderWidth=0.5;
                [delButton.layer setCornerRadius:12.5];
                [diseaseSubView addSubview:delButton];
                
                UILabel *remarkLabel=[self addLabel:CGRectMake(10,70,SCREENWIDTH-20, 20) andText:[NSString stringWithFormat:@"说明: %@",[diseaseDic objectForKey:@"remark"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                remarkLabel.numberOfLines=3;
                [remarkLabel sizeToFit];
                [diseaseSubView addSubview:remarkLabel];
                
                diseaseSubView.frame=CGRectMake(10, diseaseSubView.frame.origin.y, diseaseSubView.frame.size.width, remarkLabel.frame.origin.y+remarkLabel.frame.size.height+10);
                if (i>0) {
                    UIView *beforeView=[diseaseViewArray objectAtIndex:i-1];
                    diseaseSubView.frame=CGRectMake(10, beforeView.frame.origin.y+beforeView.frame.size.height+10, diseaseSubView.frame.size.width, diseaseSubView.frame.size.height);
                }
                [diseaseViewArray addObject:diseaseSubView];
                diseaseBGView.frame=CGRectMake(0, 0, SCREENWIDTH, diseaseSubView.frame.origin.y+diseaseSubView.frame.size.height);
            }
        }
            addDiseaseButton=[self addSimpleButton:CGRectMake(10,diseaseBGView.frame.size.height+10, SCREENWIDTH-20, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addDisease) andText:@"新增" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
            addDiseaseButton.layer.borderColor=LINECOLOR.CGColor;
            addDiseaseButton.layer.borderWidth=0.5;
            [addDiseaseButton.layer setCornerRadius:10];
            [diseaseBGView addSubview:addDiseaseButton];
        
        diseaseBGView.frame=CGRectMake(0, 0, SCREENWIDTH, addDiseaseButton.frame.origin.y+addDiseaseButton.frame.size.height);

        opsBGView=[self addSimpleBackView:CGRectMake(0,diseaseBGView.frame.size.height+diseaseBGView.frame.origin.y+10, SCREENWIDTH,40) andColor:CLEARCOLOR];
        [pastBGView addSubview:opsBGView];
        
        [self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"手术" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0 andBGView:opsBGView];
        
        if (((NSArray*)self.userFileItem.opsHistoryList).count>0) {
            for (int i=0; i<((NSArray*)self.userFileItem.opsHistoryList).count; i++) {
                NSDictionary *opsDic=[self.userFileItem.opsHistoryList objectAtIndex:i];
                UIView *opsSubView=[self addSimpleBackView:CGRectMake(10,40+80*i, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
                opsSubView.layer.borderColor=LINECOLOR.CGColor;
                opsSubView.layer.borderWidth=0.5;
                [opsSubView.layer setCornerRadius:10];
                [opsBGView addSubview:opsSubView];
                
                UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"名称: %@",[opsDic objectForKey:@"opsname"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [opsSubView addSubview:nameLabel];
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[opsDic objectForKey:@"opsdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [opsSubView addSubview:dateLabel];
                
                UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(delOPSSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
                delButton.layer.borderColor=LINECOLOR.CGColor;
                delButton.layer.borderWidth=0.5;
                [delButton.layer setCornerRadius:12.5];
                [opsSubView addSubview:delButton];
                
                
                opsBGView.frame=CGRectMake(0,opsBGView.frame.origin.y, SCREENWIDTH, opsSubView.frame.origin.y+opsSubView.frame.size.height);
            }
        }
        addOpsButton=[self addSimpleButton:CGRectMake(10,opsBGView.frame.size.height+10, SCREENWIDTH-20, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addOPSView) andText:@"新增" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
        addOpsButton.layer.borderColor=LINECOLOR.CGColor;
        addOpsButton.layer.borderWidth=0.5;
        [addOpsButton.layer setCornerRadius:10];
        [opsBGView addSubview:addOpsButton];
        
        opsBGView.frame=CGRectMake(0, opsBGView.frame.origin.y, SCREENWIDTH, addOpsButton.frame.origin.y+addOpsButton.frame.size.height);
        
        traumaBGView=[self addSimpleBackView:CGRectMake(0,opsBGView.frame.size.height+opsBGView.frame.origin.y+10, SCREENWIDTH,40) andColor:CLEARCOLOR];
        [pastBGView addSubview:traumaBGView];
        
        [self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"外伤" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0 andBGView:traumaBGView];
        
        if (((NSArray*)self.userFileItem.traumaHistoryList).count>0) {
            for (int i=0; i<((NSArray*)self.userFileItem.traumaHistoryList).count; i++) {
                NSDictionary *traumaDic=[self.userFileItem.traumaHistoryList objectAtIndex:i];
                UIView *traumaSubView=[self addSimpleBackView:CGRectMake(10,40+80*i, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
                traumaSubView.layer.borderColor=LINECOLOR.CGColor;
                traumaSubView.layer.borderWidth=0.5;
                [traumaSubView.layer setCornerRadius:10];
                [traumaBGView addSubview:traumaSubView];
                
                UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"名称: %@",[traumaDic objectForKey:@"traumaname"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [traumaSubView addSubview:nameLabel];
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10, 40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[traumaDic objectForKey:@"traumadate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [traumaSubView addSubview:dateLabel];
                
                UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(delTraSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
                delButton.layer.borderColor=LINECOLOR.CGColor;
                delButton.layer.borderWidth=0.5;
                [delButton.layer setCornerRadius:12.5];
                [traumaSubView addSubview:delButton];
                
                traumaBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y, SCREENWIDTH, traumaSubView.frame.origin.y+traumaSubView.frame.size.height);
            }
        }
        addTraumaButton=[self addSimpleButton:CGRectMake(10,traumaBGView.frame.size.height+10, SCREENWIDTH-20, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addTraumaView) andText:@"新增" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
        addTraumaButton.layer.borderColor=LINECOLOR.CGColor;
        addTraumaButton.layer.borderWidth=0.5;
        [addTraumaButton.layer setCornerRadius:10];
        [traumaBGView addSubview:addTraumaButton];
        
        traumaBGView.frame=CGRectMake(0, traumaBGView.frame.origin.y, SCREENWIDTH, addTraumaButton.frame.origin.y+addTraumaButton.frame.size.height+10);
        
        bloodBGView=[self addSimpleBackView:CGRectMake(0,traumaBGView.frame.size.height+traumaBGView.frame.origin.y+10, SCREENWIDTH,40) andColor:CLEARCOLOR];
        [pastBGView addSubview:bloodBGView];
        
        [self addLabel:CGRectMake(10, 10, SCREENWIDTH-20, 20) andText:@"输血" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0 andBGView:bloodBGView];
        
        if (((NSArray*)self.userFileItem.bloodTransList).count>0) {
            for (int i=0; i<((NSArray*)self.userFileItem.bloodTransList).count; i++) {
                NSDictionary *traumaDic=[self.userFileItem.bloodTransList objectAtIndex:i];
                UIView *traumaSubView=[self addSimpleBackView:CGRectMake(10,40+80*i, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
                traumaSubView.layer.borderColor=LINECOLOR.CGColor;
                traumaSubView.layer.borderWidth=0.5;
                [traumaSubView.layer setCornerRadius:10];
                [bloodBGView addSubview:traumaSubView];
                
                UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"原因: %@",[traumaDic objectForKey:@"reason"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [traumaSubView addSubview:nameLabel];
                
                UILabel *dateLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[traumaDic objectForKey:@"transdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
                [traumaSubView addSubview:dateLabel];
                
                UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(delBloodSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
                delButton.layer.borderColor=LINECOLOR.CGColor;
                delButton.layer.borderWidth=0.5;
                [delButton.layer setCornerRadius:12.5];
                [traumaSubView addSubview:delButton];
                
                bloodBGView.frame=CGRectMake(0,bloodBGView.frame.origin.y, SCREENWIDTH, traumaSubView.frame.origin.y+traumaSubView.frame.size.height);
            }
        }
        addBloodButton=[self addSimpleButton:CGRectMake(10,bloodBGView.frame.size.height+10, SCREENWIDTH-20, 50) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(addBloodView) andText:@"新增" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
        addBloodButton.layer.borderColor=LINECOLOR.CGColor;
        addBloodButton.layer.borderWidth=0.5;
        [addBloodButton.layer setCornerRadius:10];
        [bloodBGView addSubview:addBloodButton];
        
        bloodBGView.frame=CGRectMake(0, bloodBGView.frame.origin.y, SCREENWIDTH, addBloodButton.frame.origin.y+addBloodButton.frame.size.height+10);
        
        pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
    }
    nowBGView.hidden=YES;
    pastBGView.hidden=NO;
    nowBGView=pastBGView;
}

- (void)delDiseaseSubView:(UIButton*)button{
    [self.diseaseArray removeObjectAtIndex:button.tag-101];
    
    for (UIView *subView in diseaseBGView.subviews) {
        if (subView.frame.origin.y>button.superview.frame.origin.y) {
            subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height-10, subView.frame.size.width, subView.frame.size.height);
            
            for (UIView *sSubView in subView.subviews) {
                sSubView.tag=sSubView.tag-1;
            }
        }
    }
    diseaseBGView.frame=CGRectMake(0, diseaseBGView.frame.origin.y, SCREENWIDTH, addDiseaseButton.frame.origin.y+addDiseaseButton.frame.size.height+10);
    opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, diseaseBGView.frame.origin.y+diseaseBGView.frame.size.height+10, opsBGView.frame.size.width, opsBGView.frame.size.height);
    traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, opsBGView.frame.origin.y+opsBGView.frame.size.height+10, traumaBGView.frame.size.width, traumaBGView.frame.size.height);
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
    pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
    [button.superview removeFromSuperview];
}

- (void)delOPSSubView:(UIButton*)button{
    [self.opsArray removeObjectAtIndex:button.tag-101];
    for (UIView *subView in opsBGView.subviews) {
        if (subView.frame.origin.y>button.superview.frame.origin.y) {
            subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height-10, subView.frame.size.width, subView.frame.size.height);
            for (UIView *sSubView in subView.subviews) {
                sSubView.tag=sSubView.tag-1;
            }
        }
    }
    opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, diseaseBGView.frame.origin.y+diseaseBGView.frame.size.height+10, opsBGView.frame.size.width,addOpsButton.frame.origin.y+addOpsButton.frame.size.height+10);
    traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, opsBGView.frame.origin.y+opsBGView.frame.size.height+10, traumaBGView.frame.size.width, traumaBGView.frame.size.height);
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
    pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
    [button.superview removeFromSuperview];
}

- (void)delTraSubView:(UIButton*)button{
    [self.traumaArray removeObjectAtIndex:button.tag-101];
    for (UIView *subView in traumaBGView.subviews) {
        if (subView.frame.origin.y>button.superview.frame.origin.y) {
            subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height-10, subView.frame.size.width, subView.frame.size.height);
            for (UIView *sSubView in subView.subviews) {
                sSubView.tag=sSubView.tag-1;
            }
        }
    }
    traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, opsBGView.frame.origin.y+opsBGView.frame.size.height+10, traumaBGView.frame.size.width,addTraumaButton.frame.origin.y+addTraumaButton.frame.size.height+10);
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
    pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
    [button.superview removeFromSuperview];
}

- (void)delBloodSubView:(UIButton*)button{
    [self.bloodArray removeObjectAtIndex:button.tag-101];
    for (UIView *subView in bloodBGView.subviews) {
        if (subView.frame.origin.y>button.superview.frame.origin.y) {
            subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height-10, subView.frame.size.width, subView.frame.size.height);
            for (UIView *sSubView in subView.subviews) {
                sSubView.tag=sSubView.tag-1;
            }
        }
    }
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width,addBloodButton.frame.origin.y+addBloodButton.frame.size.height+10);
    pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
    [button.superview removeFromSuperview];
}

- (void)addOtherInfoView{
    if (!otherBGView) {
        otherBGView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,nowBGView.frame.origin.y, SCREENWIDTH,nowBGView.frame.size.height)];
        [self.view addSubview:otherBGView];

        UIView *whiteBGView=[self addSimpleBackView:CGRectMake(110, 0, SCREENWIDTH-110, 200) andColor:MAINWHITECOLOR];
        [otherBGView addSubview:whiteBGView];
        
        UILabel *label23=[self addLabel:CGRectMake(10,10,90,20) andText:@"工作单位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label23];
        
        UITextField *textField23=[self addTextfield:CGRectMake(120, label23.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入工作单位" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        textField23.adjustsFontSizeToFitWidth=YES;
        textField23.tag=1023;
        [otherBGView addSubview:textField23];
        if(self.userFileItem){
            textField23.text=self.userFileItem.workUnit;
        }
        
        [self addLineLabel:CGRectMake(0, label23.frame.origin.y+label23.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
        
        UILabel *label24=[self addLabel:CGRectMake(10,label23.frame.origin.y+label23.frame.size.height+20,90,20) andText:@"联系人姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label24];
        
        UITextField *textField24=[self addTextfield:CGRectMake(120, label24.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系人姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        textField24.adjustsFontSizeToFitWidth=YES;
        textField24.tag=1024;
        [otherBGView addSubview:textField24];
        if(self.userFileItem){
            textField24.text=self.userFileItem.linkMan;
        }
        
        [self addLineLabel:CGRectMake(0, label24.frame.origin.y+label24.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
        
        UILabel *label25=[self addLabel:CGRectMake(10,label24.frame.origin.y+label24.frame.size.height+20,90,20) andText:@"联系人电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label25];
        
        UITextField *textField25=[self addTextfield:CGRectMake(120, label25.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系人电话" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        textField25.adjustsFontSizeToFitWidth=YES;
        textField25.keyboardType=UIKeyboardTypeNumberPad;
        textField25.tag=1025;
        [otherBGView addSubview:textField25];
        if(self.userFileItem){
            textField25.text=self.userFileItem.linkManTEL;
        }
        
        [self addLineLabel:CGRectMake(0, label25.frame.origin.y+label25.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
        
        UILabel *label26=[self addLabel:CGRectMake(10,label25.frame.origin.y+label25.frame.size.height+20,90,20) andText:@"常住类型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label26];
        
        NSArray *addressArray=@[@"1.户籍",@"2.非户籍"];
        for (int i=0; i<addressArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120+70*i, label26.frame.origin.y-2.5, 60,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceLiveType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
        
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[addressArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressButton addSubview:addressLabel];
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.resideType] isEqualToString:[addressArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastLiveTypeButton=addressButton;

                self.liveType=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.resideType.length==0)){
                if (i==0) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastLiveTypeButton=addressButton;
                    
                    self.liveType=[self getChoiceString:addressLabel.text];
                }
            }
        }
        
        [self addLineLabel:CGRectMake(0, label26.frame.origin.y+label26.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
        
        
        UILabel *label27=[self addLabel:CGRectMake(10,label26.frame.origin.y+label26.frame.size.height+20,90,20) andText:@"血型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label27];
        
        NSArray *bloodArray=@[@"1.A型",@"2.B型",@"3.O型",@"4.AB型",@"5.不详"];
        NSMutableArray *bloodBtnArray=[NSMutableArray new];
        for (int i=0; i<bloodArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label27.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceBloodType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bloodArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.bloodTypeABO] isEqualToString:[bloodArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastBloodTypeButton=addressButton;

                self.bloodType=[self getChoiceString:addressLabel.text];
            }
            if (i>0) {
                UIButton *lastBtn=[bloodBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [bloodBtnArray addObject:addressButton];
            if (i==bloodArray.count-1) {
                label27.frame=CGRectMake(10,label27.frame.origin.y-10+(addressButton.frame.origin.y+35-(label27.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label28=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"RH阴性" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label28];
        
        NSArray *bloodRHArray=@[@"1.否",@"2.是",@"3.不详"];
        NSMutableArray *bloodRHBtnArray=[NSMutableArray new];
        for (int i=0; i<bloodRHArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label28.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceRHType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bloodRHArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.bloodTypeRH] isEqualToString:[bloodRHArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastRHButton=addressButton;

                self.RH=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.bloodTypeRH.length==0)){
                if (i==2) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastRHButton=addressButton;

                    self.RH=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[bloodRHBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [bloodRHBtnArray addObject:addressButton];
            if (i==bloodRHArray.count-1) {
                label28.frame=CGRectMake(10,label28.frame.origin.y-10+(addressButton.frame.origin.y+35-(label28.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label29=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"文化程度" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label29];
        
        NSArray *educationArray=@[@"1.文盲及半文盲",@"2.小学",@"3.初中",@"4.高中/技校/中专",@"5.大学专科及以上",@"6.不祥"];
        NSMutableArray *educationBtnArray=[NSMutableArray new];
        for (int i=0; i<educationArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label29.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceEducationType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[educationArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.education] isEqualToString:[educationArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastEducationTypeButton=addressButton;

                self.education=[self getChoiceString:addressLabel.text];
            }
            if (i>0) {
                UIButton *lastBtn=[educationBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [educationBtnArray addObject:addressButton];
            if (i==educationArray.count-1) {
                label29.frame=CGRectMake(10,label29.frame.origin.y-10+(addressButton.frame.origin.y+35-(label29.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label30=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"职业" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label30];
        
        NSArray *jobArray=@[@"1.国家机关、党群组织、企业、事业单位负责人",@"2.专业技术人员",@"3.办事人员和有关人员",@"4.商业、服务业人员",@"5.农、林、牧、渔、水利业生产人员",@"6.生产、运输设备操作人员及有关人员",@"7.军人",@"8.不便分类的其他从业人员"];
        NSMutableArray *jobBtnArray=[NSMutableArray new];
        for (int i=0; i<jobArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label30.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceJobType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0,SCREENWIDTH-150,0) andText:[jobArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
            addressLabel.numberOfLines=0;
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10,5, addressLabel.frame.size.width,addressLabel.frame.size.height);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, addressLabel.frame.size.height+10);
            [addressButton.layer setCornerRadius:addressButton.frame.size.height/2];
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.occupation] isEqualToString:[jobArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastJobTypeButton=addressButton;

                self.job=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.occupation.length==0)){
                if (i==4) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastJobTypeButton=addressButton;

                    self.job=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[jobBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, addressButton.frame.size.height);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+lastBtn.frame.size.height+10, addressButton.frame.size.width, addressButton.frame.size.height);
                }
            }
            [jobBtnArray addObject:addressButton];
            if (i==jobArray.count-1) {
                label30.frame=CGRectMake(10,label30.frame.origin.y-10+(addressButton.frame.origin.y+ addressButton.frame.size.height+10-(label30.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label31=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"婚姻状况" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label31];
        
        NSArray *maritalArray=@[@"1.未婚",@"2.已婚",@"3.丧偶",@"4.离婚",@"5.未说明的婚姻状况"];
        NSMutableArray *maritalBtnArray=[NSMutableArray new];
        for (int i=0; i<maritalArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label31.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceMaritalType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[maritalArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.maritalStatus] isEqualToString:[maritalArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastMaritalButton=addressButton;

                self.marital=[self getChoiceString:addressLabel.text];
            }
            if (i>0) {
                UIButton *lastBtn=[maritalBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [maritalBtnArray addObject:addressButton];
            if (i==maritalArray.count-1) {
                label31.frame=CGRectMake(10,label31.frame.origin.y-10+(addressButton.frame.origin.y+35-(label31.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        
        UILabel *label32=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        label32.attributedText=[self setString:@"人口类型 *" andSubString:@"*" andDifColor:[UIColor redColor]];
        [otherBGView addSubview:label32];
        
        NSArray *farmArray=@[@"1.农业人口",@"2.城镇居民"];
        NSMutableArray *farmBtnArray=[NSMutableArray new];
        for (int i=0; i<farmArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label32.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFarmOrTown:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[farmArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&((i==0&&[self.userFileItem.farmStatus isEqualToString:@"是"])||(i==1&&[self.userFileItem.townStatus isEqualToString:@"是"]))){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastFarmOrTownButton=addressButton;

                self.farmOrTown=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.farmStatus.length==0&&self.userFileItem.townStatus.length==0)){
                if (i==0) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastFarmOrTownButton=addressButton;
                    
                    self.farmOrTown=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[farmBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [farmBtnArray addObject:addressButton];
            if (i==farmArray.count-1) {
                label32.frame=CGRectMake(10,label32.frame.origin.y-10+(addressButton.frame.origin.y+35-(label32.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        
        UILabel *label34=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"是否孕产妇" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label34];
        
        NSArray *bornArray=@[@"1.是",@"2.否"];
        NSMutableArray *bornBtnArray=[NSMutableArray new];
        for (int i=0; i<bornArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(120, label34.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceMaternal:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bornArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.bornStatus] isEqualToString:[bornArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastMaternalButton=addressButton;
                
                self.maternal=[self getChoiceString:addressLabel.text];
            }
            if (i>0) {
                UIButton *lastBtn=[bornBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [bornBtnArray addObject:addressButton];
            if (i==bornArray.count-1) {
                label34.frame=CGRectMake(10,label34.frame.origin.y-10+(addressButton.frame.origin.y+35-(label34.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label35=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"医疗费用支付方式" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        label35.numberOfLines=0;
        [label35 sizeToFit];
        label35.frame=CGRectMake(10, whiteBGView.frame.size.height+10, 90, label35.frame.size.height);
        [otherBGView addSubview:label35];
        
        for (AddArchiveItem *item in mainArray) {
            if (item.type==123&&item.ID!=123) {
                [paymentArray addObject:item];
            }
        }
        NSMutableArray *paymentBtnArray=[NSMutableArray new];
        for (int i=0; i<paymentArray.count; i++) {
            AddArchiveItem *item=[paymentArray objectAtIndex:i];
            UIButton *addressButton=[self addButton:CGRectMake(120, label35.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choicePayMent:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if (((NSArray*)self.userFileItem.paymentModeList).count>0) {
                for (NSDictionary *paymentModeDic in self.userFileItem.paymentModeList) {
                    if ([[paymentModeDic objectForKey:@"paymentmodeid"]intValue]==item.ID) {
                        addressButton.backgroundColor=GREENCOLOR;
                        addressLabel.textColor=MAINWHITECOLOR;
                        addressButton.selected=YES;
                    }
                }
            }else{
                if (item.ID==520) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"paymentmodeid"];
                    [dic setObject:item.Name forKey:@"name"];
                    [self.paymentArray addObject:dic];

                }
            }
            if (i>0) {
                UIButton *lastBtn=[paymentBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [paymentBtnArray addObject:addressButton];
            if (i==paymentArray.count-1) {
                label35.frame=CGRectMake(10,label35.frame.origin.y-10+(addressButton.frame.origin.y+35-(label35.frame.origin.y-10)-label35.frame.size.height)/2, 90,label35.frame.size.height);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label36=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"药物过敏史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label36];
        
        for (AddArchiveItem *item in mainArray) {
            if (item.type==34&&item.ID!=34) {
                [allergicArray addObject:item];
            }
        }
        NSMutableArray *drugBtnArray=[NSMutableArray new];
        for (int i=0; i<allergicArray.count; i++) {
            AddArchiveItem *item=[allergicArray objectAtIndex:i];
            UIButton *addressButton=[self addButton:CGRectMake(120, label36.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceAllergic:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if (((NSArray*)self.userFileItem.allergiesHistoryList).count>0) {
                for (NSDictionary *paymentModeDic in self.userFileItem.allergiesHistoryList) {
                    if ([[paymentModeDic objectForKey:@"allergiesid"]intValue]==item.ID) {
                        addressButton.backgroundColor=GREENCOLOR;
                        addressLabel.textColor=MAINWHITECOLOR;
                        addressButton.selected=YES;
                    }
                }
            }else{
                if (i==0) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"allergiesid"];
                    [dic setObject:item.Name forKey:@"name"];
                    [self.allergicArray addObject:dic];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[drugBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [drugBtnArray addObject:addressButton];
            if (i==allergicArray.count-1) {
                label36.frame=CGRectMake(10,label36.frame.origin.y-10+(addressButton.frame.origin.y+35-(label36.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label37=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"暴露史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label37];
        
        for (AddArchiveItem *item in mainArray) {
            if (item.type==192&&item.ID!=192) {
                [exposeArray addObject:item];
            }
        }
        NSMutableArray *exposeBtnArray=[NSMutableArray new];
        for (int i=0; i<exposeArray.count; i++) {
            AddArchiveItem *item=[exposeArray objectAtIndex:i];
            UIButton *addressButton=[self addButton:CGRectMake(120, label37.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceExpose:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if (((NSArray*)self.userFileItem.exposeHistoryAOList).count>0) {
                for (NSDictionary *paymentModeDic in self.userFileItem.exposeHistoryAOList) {
                    if ([[paymentModeDic objectForKey:@"exposeid"]intValue]==item.ID) {
                        addressButton.backgroundColor=GREENCOLOR;
                        addressLabel.textColor=MAINWHITECOLOR;
                        addressButton.selected=YES;
                    }
                }
            }else{
                if (i==0) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"exposeid"];
                    [dic setObject:item.Name forKey:@"name"];
                    [self.exposeArray addObject:dic];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[exposeBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(120, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [exposeBtnArray addObject:addressButton];
            if (i==exposeArray.count-1) {
                label37.frame=CGRectMake(10,label37.frame.origin.y-10+(addressButton.frame.origin.y+35-(label37.frame.origin.y-10)-20)/2, 90, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label40=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,60,20) andText:@"遗传病史" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label40];
        
        UIView *dWhiteView1=[self addSimpleBackView:CGRectMake(80,whiteBGView.frame.size.height+0.5, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
        [otherBGView addSubview:dWhiteView1];
        
        NSArray *geneticArray=@[@"1.无",@"2.有"];
        NSMutableArray *geneticBtnArray=[NSMutableArray new];
        for (int i=0; i<geneticArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(90, label40.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceGenetic:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[geneticArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(90, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.geneticHistory] isEqualToString:[geneticArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastGeneticButton=addressButton;
                
                self.genetic=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.geneticHistory.length==0)){
                if(i==0){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastGeneticButton=addressButton;
                    
                    self.genetic=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[geneticBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(90, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [geneticBtnArray addObject:addressButton];
            if (i==geneticArray.count-1) {
                label40.frame=CGRectMake(10,label40.frame.origin.y-10+(addressButton.frame.origin.y+35-(label40.frame.origin.y-10)-20)/2,60, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
                
                dWhiteView1.frame=CGRectMake(dWhiteView1.frame.origin.x, dWhiteView1.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10- dWhiteView1.frame.origin.y);
            }
        }
        
        UILabel *label41=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,60,20) andText:@"残疾情况" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label41];
        
        for (AddArchiveItem *item in mainArray) {
            if (item.type==6&&item.ID!=6) {
                [disabilityArray addObject:item];
            }
        }
        NSMutableArray *deformityBtnArray=[NSMutableArray new];
        for (int i=0; i<disabilityArray.count; i++) {
            AddArchiveItem *item=[disabilityArray objectAtIndex:i];
            UIButton *addressButton=[self addButton:CGRectMake(90, label41.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceDisability:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(90, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if (((NSArray*)self.userFileItem.disabilityStatusList).count>0) {
                for (NSDictionary *paymentModeDic in self.userFileItem.disabilityStatusList) {
                    if ([[paymentModeDic objectForKey:@"disabilitystatusid"]intValue]==item.ID) {
                        addressButton.backgroundColor=GREENCOLOR;
                        addressLabel.textColor=MAINWHITECOLOR;
                        addressButton.selected=YES;
                    }
                }
            }else{
                if (i==0) {
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"disabilitystatusid"];
                    [dic setObject:item.Name forKey:@"name"];
                    [self.disabilityArray addObject:dic];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[deformityBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(90, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [deformityBtnArray addObject:addressButton];
            if (i==disabilityArray.count-1) {
                label41.frame=CGRectMake(10,label41.frame.origin.y-10+(addressButton.frame.origin.y+35-(label41.frame.origin.y-10)-20)/2,60, 20);
                
                [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
                
                dWhiteView1.frame=CGRectMake(dWhiteView1.frame.origin.x, dWhiteView1.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10- dWhiteView1.frame.origin.y);
            }
        }
        
        UILabel *label42=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,50,20) andText:@"生活环境" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
        [otherBGView addSubview:label42];
        
        UIView *dWhiteView2=[self addSimpleBackView:CGRectMake(120,whiteBGView.frame.size.height+0.5, SCREENWIDTH-120,0) andColor:MAINWHITECOLOR];
        [otherBGView addSubview:dWhiteView2];
        
        UILabel *label421=[self addLabel:CGRectMake(80,label42.frame.origin.y,40,0) andText:@"厨房排风设施" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        label421.numberOfLines=0;
        [label421 sizeToFit];
        label421.frame=CGRectMake(80, dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10, 40, label421.frame.size.height);
        [otherBGView addSubview:label421];
        
        NSArray *kitchenArray=@[@"1.无",@"2.油烟机",@"3.换气扇",@"4.烟囱",];
        NSMutableArray *kitchenBtnArray=[NSMutableArray new];
        for (int i=0; i<kitchenArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(130,label421.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceKitchenType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[kitchenArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.kitchen] isEqualToString:[kitchenArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastKitchenButton=addressButton;
                
                self.kitchen=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.kitchen.length==0)){
                if(i==0){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastKitchenButton=addressButton;
                    
                    self.kitchen=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[kitchenBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [kitchenBtnArray addObject:addressButton];
            if (i==kitchenArray.count-1) {
                if (addressButton.frame.origin.y+addressButton.frame.size.height>label421.frame.origin.y+label421.frame.size.height) {
                    label421.frame=CGRectMake(80,label421.frame.origin.y-10+(addressButton.frame.origin.y+35-(label421.frame.origin.y-10)-label421.frame.size.height)/2,40, label421.frame.size.height);
                    
                    [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                    
                    dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y-dWhiteView2.frame.origin.y+addressButton.frame.size.height+10);
                }else{
                    label421.frame=CGRectMake(80,label421.frame.origin.y,40, label421.frame.size.height);
                    [self addLineLabel:CGRectMake(80, label421.frame.origin.y+label421.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                    
                    dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-120, label421.frame.origin.y-dWhiteView2.frame.origin.y+label421.frame.size.height+10);
                }
            }
        }
        
        UILabel *label422=[self addLabel:CGRectMake(80,dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10,40,20) andText:@"燃料类型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        label422.numberOfLines=0;
        [label422 sizeToFit];
        label422.frame=CGRectMake(80, dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10, 40, label422.frame.size.height);
        [otherBGView addSubview:label422];
        
        NSArray *fuelArray=@[@"1.液化气",@"2.煤",@"3.天然气",@"4.沼气",@"5.柴火",@"6.其他"];
        NSMutableArray *fuelBtnArray=[NSMutableArray new];
        for (int i=0; i<fuelArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(130,label422.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFuelType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[fuelArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.bunkers] isEqualToString:[fuelArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastFuelButton=addressButton;
                
                self.fuel=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.bunkers.length==0)){
                if(i==4){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastFuelButton=addressButton;
                    
                    self.fuel=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[fuelBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            
            [fuelBtnArray addObject:addressButton];
            if (i==fuelArray.count-1) {
                if (addressButton.frame.origin.y+addressButton.frame.size.height>label422.frame.origin.y+label422.frame.size.height) {
                    label422.frame=CGRectMake(80,label422.frame.origin.y-10+(addressButton.frame.origin.y+35-(label422.frame.origin.y-10)-label422.frame.size.height)/2,40, label422.frame.size.height);
                    
                    [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                    
                    dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y-dWhiteView2.frame.origin.y+addressButton.frame.size.height+10);
                }else{
                    label422.frame=CGRectMake(80,label422.frame.origin.y,40, label422.frame.size.height);
                    [self addLineLabel:CGRectMake(80, label422.frame.origin.y+label422.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                    
                    dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-120, label422.frame.origin.y-dWhiteView2.frame.origin.y+label422.frame.size.height+10);
                }
            }
        }
        
        UILabel *label423=[self addLabel:CGRectMake(80,dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10,40,20) andText:@"饮水" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [otherBGView addSubview:label423];
        
        NSArray *drinkingArray=@[@"1.自来水",@"2.经净化过滤的水",@"3.井水",@"4.河湖水",@"5.塘水",@"6.其他"];
        NSMutableArray *drinkingBtnArray=[NSMutableArray new];
        for (int i=0; i<drinkingArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(130,label423.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceDrinkeType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[drinkingArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.drinkingWater] isEqualToString:[drinkingArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastDrinkingButton=addressButton;
                
                self.drinking=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.drinkingWater.length==0)){
                if(i==0){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastDrinkingButton=addressButton;
                    
                    self.drinking=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[drinkingBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [drinkingBtnArray addObject:addressButton];
            if (i==drinkingArray.count-1) {
                label423.frame=CGRectMake(80,label423.frame.origin.y-10+(addressButton.frame.origin.y+35-(label423.frame.origin.y-10)-20)/2,40, 20);
                
                [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y-dWhiteView2.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label424=[self addLabel:CGRectMake(80,dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10,40,20) andText:@"厕所" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [otherBGView addSubview:label424];
        
        NSArray *toiletArray=@[@"1.卫生厕所",@"2.一格或二格粪池式",@"3.马桶",@"4.露天粪坑",@"5.简易棚厕"];
        NSMutableArray *toiletBtnArray=[NSMutableArray new];
        for (int i=0; i<toiletArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(130,label424.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceToiletType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[toiletArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.toilet] isEqualToString:[toiletArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastToiletButton=addressButton;
                
                self.toilet=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.toilet.length==0)){
                if(i==4){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastToiletButton=addressButton;
                    
                    self.toilet=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[toiletBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [toiletBtnArray addObject:addressButton];
            if (i==toiletArray.count-1) {
                label424.frame=CGRectMake(80,label424.frame.origin.y-10+(addressButton.frame.origin.y+35-(label424.frame.origin.y-10)-20)/2,40, 20);
                
                [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y-dWhiteView2.frame.origin.y+addressButton.frame.size.height+10);
            }
        }
        
        UILabel *label425=[self addLabel:CGRectMake(80,dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10,40,20) andText:@"禽畜栏" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        label425.numberOfLines=0;
        [label425 sizeToFit];
        label425.frame=CGRectMake(80,  dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+10, 40, label422.frame.size.height);
        [otherBGView addSubview:label425];
        
        NSArray *livestockArray=@[@"1.单设",@"2.室内",@"3.室外"];
        NSMutableArray *livestockBtnArray=[NSMutableArray new];
        for (int i=0; i<livestockArray.count; i++) {
            UIButton *addressButton=[self addButton:CGRectMake(130,label425.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceLivestockType:)];
            addressButton.layer.borderColor=LINECOLOR.CGColor;
            addressButton.layer.borderWidth=0.5;
            [addressButton.layer setCornerRadius:12.5];
            [otherBGView addSubview:addressButton];
            
            UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[livestockArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
            [addressLabel sizeToFit];
            [addressButton addSubview:addressLabel];
            
            addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
            addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
            if(self.userFileItem&&[[NSString stringWithFormat:@"%d.%@",i+1,self.userFileItem.poultry] isEqualToString:[livestockArray objectAtIndex:i]]){
                addressButton.backgroundColor=GREENCOLOR;
                addressLabel.textColor=MAINWHITECOLOR;
                addressButton.selected=YES;
                lastLivestockButton=addressButton;
                
                self.livestock=[self getChoiceString:addressLabel.text];
            }else if(!self.userFileItem||(self.userFileItem&&self.userFileItem.poultry.length==0)){
                if(i==0){
                    addressButton.backgroundColor=GREENCOLOR;
                    addressLabel.textColor=MAINWHITECOLOR;
                    addressButton.selected=YES;
                    lastLivestockButton=addressButton;
                    
                    self.livestock=[self getChoiceString:addressLabel.text];
                }
            }
            if (i>0) {
                UIButton *lastBtn=[livestockBtnArray objectAtIndex:i-1];
                addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
                if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                    addressButton.frame=CGRectMake(130, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
                }
            }
            [livestockBtnArray addObject:addressButton];
            if (i==livestockArray.count-1) {
                label425.frame=CGRectMake(80,label425.frame.origin.y,40, label425.frame.size.height);
                [self addLineLabel:CGRectMake(0, label425.frame.origin.y+label425.frame.size.height+10, SCREENWIDTH-0, 0.5) andColor:LINECOLOR andBackView:otherBGView];
                
                dWhiteView2.frame=CGRectMake(dWhiteView2.frame.origin.x, dWhiteView2.frame.origin.y, SCREENWIDTH-110, label425.frame.origin.y-dWhiteView2.frame.origin.y+label425.frame.size.height+10);
            }
        }
        [self addLineLabel:CGRectMake(80, dWhiteView2.frame.origin.y, 0.5, dWhiteView2.frame.size.height) andColor:LINECOLOR andBackView:otherBGView];
        otherBGView.contentSize=CGSizeMake(0,dWhiteView2.frame.origin.y+dWhiteView2.frame.size.height+40);
        label42.frame=CGRectMake(label42.frame.origin.x,label42.frame.origin.y+(otherBGView.contentSize.height-label42.frame.origin.y-20)/2, label42.frame.size.width, 20);
    }

    nowBGView.hidden=YES;
    otherBGView.hidden=NO;
    nowBGView=otherBGView;
}

#pragma mark 选择血型
- (void)choiceBloodType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.bloodType=[self getChoiceString:label.text];
    }
    if (lastBloodTypeButton!=button) {
        lastBloodTypeButton.selected=NO;
        lastBloodTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastBloodTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.bloodType=[self getChoiceString:label.text];
        }else{
            self.bloodType=@"";
        }
    }
    button.selected=!button.selected;
    lastBloodTypeButton=button;
    NSLog(@"===========%@",self.bloodType);
}


#pragma mark 选择文化程度
- (void)choiceEducationType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.education=[self getChoiceString:label.text];
    }
    if (lastEducationTypeButton!=button) {
        lastEducationTypeButton.selected=NO;
        lastEducationTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastEducationTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.education=[self getChoiceString:label.text];
        }else{
            self.education=@"";
        }
    }
    button.selected=!button.selected;
    lastEducationTypeButton=button;
    NSLog(@"===========%@",self.education);
}
#pragma mark 选择医疗费用支付方式
- (void)choicePayMent:(UIButton*)button{
    if (!self.paymentArray) {
        self.paymentArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[paymentArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.paymentArray) {
            if ([[dic objectForKey:@"paymentmodeid"] intValue]==item.ID) {
                [self.paymentArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"paymentmodeid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.paymentArray addObject:dic];
    }
    NSLog(@"===========%@",self.paymentArray);
}

#pragma mark 选择职业
- (void)choiceJobType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.job=[self getChoiceString:label.text];
    }
    if (lastJobTypeButton!=button) {
        lastJobTypeButton.selected=NO;
        lastJobTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastJobTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.job=[self getChoiceString:label.text];
        }else{
            self.job=@"";
        }
    }
    button.selected=!button.selected;
    lastJobTypeButton=button;
    NSLog(@"===========%@",self.job);
}

#pragma mark 选择RH
- (void)choiceRHType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.RH=[self getChoiceString:label.text];
    }
    if (lastRHButton!=button) {
        lastRHButton.selected=NO;
        lastRHButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastRHButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.RH=[self getChoiceString:label.text];
        }else{
            self.RH=@"";
        }
    }
    button.selected=!button.selected;
    lastRHButton=button;
    NSLog(@"===========%@",self.RH);
}


#pragma mark 选择常住类型
- (void)choiceLiveType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.liveType=[self getChoiceString:label.text];
    }
    if (lastLiveTypeButton!=button) {
        lastLiveTypeButton.selected=NO;
        lastLiveTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastLiveTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.liveType=[self getChoiceString:label.text];
        }else{
            self.liveType=@"";
        }
    }
    button.selected=!button.selected;
    lastLiveTypeButton=button;
    NSLog(@"===========%@",self.liveType);
}


#pragma mark 选择人口类型
- (void)choiceFarmOrTown:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        self.farmOrTown=[self getChoiceString:label.text];
    }
    if (lastFarmOrTownButton!=button) {
        lastFarmOrTownButton.selected=NO;
        lastFarmOrTownButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastFarmOrTownButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.farmOrTown=[self getChoiceString:label.text];
        }else{
            self.farmOrTown=@"";
        }
    }
    button.selected=!button.selected;

    lastFarmOrTownButton=button;
    NSLog(@"===========%@",self.farmOrTown);
}

#pragma mark 选择婚姻状况
- (void)choiceMaritalType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.marital=[self getChoiceString:label.text];
    }
    if (lastMaritalButton!=button) {
        lastMaritalButton.selected=NO;
        lastMaritalButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastMaritalButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.marital=[self getChoiceString:label.text];
        }else{
            self.marital=@"";
        }
    }
    button.selected=!button.selected;
    lastMaritalButton=button;
    NSLog(@"===========%@",self.marital);
}

#pragma mark 选择是否孕产妇
- (void)choiceMaternal:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.maternal=[self getChoiceString:label.text];
    }
    if (lastMaternalButton!=button) {
        lastMaternalButton.selected=NO;
        lastMaternalButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastMaternalButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.maternal=[self getChoiceString:label.text];
        }else{
            self.maternal=@"";
        }
    }
    button.selected=!button.selected;
    lastMaternalButton=button;
    NSLog(@"===========%@",self.maternal);
}

#pragma mark 选择暴露史
- (void)choiceExpose:(UIButton*)button{
    if (!self.exposeArray) {
        self.exposeArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[exposeArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.exposeArray) {
            if ([[dic objectForKey:@"exposeid"] intValue]==item.ID) {
                [self.exposeArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"exposeid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.exposeArray addObject:dic];
    }
    NSLog(@"===========%@",self.exposeArray);
}

#pragma mark 选择是否有遗传病史
- (void)choiceGenetic:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.genetic=[self getChoiceString:label.text];
    }
    if (lastGeneticButton!=button) {
        lastGeneticButton.selected=NO;
        lastGeneticButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastGeneticButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.genetic=[self getChoiceString:label.text];
        }else{
            self.genetic=@"";
        }
    }
    button.selected=!button.selected;
    lastGeneticButton=button;
    NSLog(@"===========%@",self.genetic);
}

#pragma mark 选择药物过敏史
- (void)choiceAllergic:(UIButton*)button{
    if (!self.allergicArray) {
        self.allergicArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[allergicArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.allergicArray) {
            if ([[dic objectForKey:@"allergiesid"] intValue]==item.ID) {
                [self.allergicArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"allergiesid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.allergicArray addObject:dic];
    }
    NSLog(@"===========%@",self.allergicArray);
}

#pragma mark 选择残疾情况
- (void)choiceDisability:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[disabilityArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.disabilityArray) {
            if ([[dic objectForKey:@"disabilitystatusid"] intValue]==item.ID) {
                [self.disabilityArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"disabilitystatusid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.disabilityArray addObject:dic];
    }
    NSLog(@"===========%@",self.disabilityArray);
}

#pragma mark 选择饮水方式类型
- (void)choiceDrinkeType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.drinking=[self getChoiceString:label.text];
    }
    if (lastDrinkingButton!=button) {
        lastDrinkingButton.selected=NO;
        lastDrinkingButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastDrinkingButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.drinking=[self getChoiceString:label.text];
        }else{
            self.drinking=@"";
        }
    }
    button.selected=!button.selected;
    lastDrinkingButton=button;
}

#pragma mark 选择燃料类型
- (void)choiceFuelType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.fuel=[self getChoiceString:label.text];
    }
    if (lastFuelButton!=button) {
        lastFuelButton.selected=NO;
        lastFuelButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastFuelButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.fuel=[self getChoiceString:label.text];
        }else{
            self.fuel=@"";
        }
    }
    button.selected=!button.selected;
    lastFuelButton=button;
    NSLog(@"===========%@",self.fuel);
}

#pragma mark 选择厨房拍风设施
- (void)choiceKitchenType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.kitchen=[self getChoiceString:label.text];
    }
    if (lastKitchenButton!=button) {
        lastKitchenButton.selected=NO;
        lastKitchenButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastKitchenButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.kitchen=[self getChoiceString:label.text];
        }else{
            self.kitchen=@"";
        }
    }
    button.selected=!button.selected;
    lastKitchenButton=button;
    NSLog(@"===========%@",self.kitchen);
}

#pragma mark 选择禽畜栏类型
- (void)choiceLivestockType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.livestock=[self getChoiceString:label.text];
    }
    if (lastLivestockButton!=button) {
        lastLivestockButton.selected=NO;
        lastLivestockButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastLivestockButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.livestock=[self getChoiceString:label.text];
        }else{
            self.livestock=@"";
        }
    }
    button.selected=!button.selected;
    lastLivestockButton=button;
    NSLog(@"===========%@",self.livestock);
}

#pragma mark 选择厕所类型
- (void)choiceToiletType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        
        self.toilet=[self getChoiceString:label.text];
    }
    if (lastToiletButton!=button) {
        lastToiletButton.selected=NO;
        lastToiletButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastToiletButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        if (!button.selected) {
            self.toilet=[self getChoiceString:label.text];
        }else{
            self.toilet=@"";
        }
    }
    button.selected=!button.selected;
    lastToiletButton=button;
    NSLog(@"===========%@",self.toilet);
}

#pragma mark 选择既往史疾病
- (void)choiceDisease:(UIButton*)button{
    lastDiseasButton=nil;
    lastDisDic=nil;
    UIButton *timeButton=(UIButton*)[self.view viewWithTag:1026];
    UILabel *timeLabel=[[timeButton subviews] lastObject];
    timeLabel.text=@"请选择患病时间";
    timeLabel.textColor=TEXTCOLORSDG;
    UITextView *textField=(UITextView*)[self.view viewWithTag:1027];
    textField.text=nil;
    if (diseaseButtonArray.count>0) {
        UIButton *lButton=[diseaseButtonArray objectAtIndex:0];
        if (lButton.tag<1100) {
            lastDiseasButton=lButton;
            if (self.diseaseArray.count>0) {
                lastDisDic=[self.diseaseArray objectAtIndex:0];
            }
        }
        
    }
    UILabel *label=[[button subviews] lastObject];
    NSMutableDictionary *dic=[self.diseaseArray lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        for (AddArchiveItem *item in diseaseArray) {
            if ([label.text rangeOfString:item.Name].location!=NSNotFound) {
                [dic setObject:item.Name forKey:@"name"];
                [dic setObject:[NSString  stringWithFormat:@"%d",item.ID] forKey:@"diseaseid"];
                [dic setObject:@"" forKey:@"confirmdate"];
                [dic setObject:@"" forKey:@"remark"];
                break;
            }
        }
    }
    if (lastDiseasButton!=button) {
        lastDiseasButton.selected=NO;
        lastDiseasButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastDiseasButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }
    lastDiseasButton=button;
    if (button.superview.tag>1100) {
        for (UIButton *lButton in diseaseButtonArray) {
            if (lButton.tag==button.tag) {
                [diseaseButtonArray removeObject:lButton];
                break;
            }
        }
        [diseaseButtonArray addObject:button];
    }else{
        if (diseaseButtonArray.count>0) {
            UIButton *lButton=[diseaseButtonArray objectAtIndex:0];
            if (lButton.tag<1100) {
                [diseaseButtonArray removeObjectAtIndex:0];
            }
            
        }
        [diseaseButtonArray insertObject:button atIndex:0];
    }
    NSLog(@"=========%@=====%@",diseaseButtonArray,self.diseaseArray)
    ;
}


- (void)addDisease{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [self.diseaseArray addObject:dic];
    
    addDisView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, SCREENWIDTH, SCREENHEIGHT-200)];
    addDisView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:addDisView];
    
    [self addLabel:CGRectMake(0, 10, SCREENWIDTH, 20) andText:@"疾病" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1 andBGView:addDisView];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-50, 5, 40, 30) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(cancelDisView:) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
    cancelButton.layer.borderWidth=0.5;
    cancelButton.layer.borderColor=LINECOLOR.CGColor;
    [cancelButton.layer setCornerRadius:5];
    [addDisView addSubview:cancelButton];
    
    if (diseaseArray.count==0) {
        for (AddArchiveItem *item in mainArray) {
            if (item.type==38&&item.ID!=38) {
                [diseaseArray addObject:item];
            }
        }
    }
    NSMutableArray *diseaseBtnArray=[NSMutableArray new];
    for (int i=0; i<diseaseArray.count; i++) {
        AddArchiveItem *item=[diseaseArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(10,40, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceDisease:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [addDisView addSubview:addressButton];

        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(10, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (i>0) {
            UIButton *lastBtn=[diseaseBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(10, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        [diseaseBtnArray addObject:addressButton];
        addDisView.contentSize=CGSizeMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10);
    }
    
        UILabel *label3812=[self addLabel:CGRectMake(10,addDisView.contentSize.height+10,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [addDisView addSubview:label3812];
    
        UIButton *button3812N=[self addSimpleButton:CGRectMake(55, label3812.frame.origin.y-5, SCREENWIDTH-65, 30) andBColor:CLEARCOLOR andTag:1026 andSEL:@selector(addDateChoiceView:) andText:@"请选择患病时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
        [addDisView addSubview:button3812N];
    
        [self addLineLabel:CGRectMake(0,label3812.frame.origin.y+30,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:addDisView];
    
    UILabel *label3813=[self addLabel:CGRectMake(10,label3812.frame.origin.y+40,40,20) andText:@"说明" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [addDisView addSubview:label3813];
    
    UITextView *textField3813N=[[UITextView alloc]initWithFrame:CGRectMake(10, label3813.frame.origin.y+30, SCREENWIDTH-20,70)];
    textField3813N.tag=1027;
    textField3813N.delegate=self;
    textField3813N.layer.borderColor=LINECOLOR.CGColor;
    textField3813N.layer.borderWidth=0.5;
    [textField3813N.layer setCornerRadius:5];
    [addDisView addSubview:textField3813N];
    
    UIButton* sureButton=[self addCurrencyButton:CGRectMake(40,textField3813N.frame.origin.y+textField3813N.frame.size.height+20, SCREENWIDTH-80, 40) andText:@"确定" andSEL:@selector(sureAdd:)];
    [addDisView addSubview:sureButton];
    
    addDisView.contentSize=CGSizeMake(0, sureButton.frame.origin.y+sureButton.frame.size.height+40);
}

- (void)cancelDisView:(UIButton*)button{
    [self.diseaseArray removeLastObject];
    [button.superview removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)sureAdd:(UIButton*)button{
    UIButton *disDateButton=(UIButton*)[self.view viewWithTag:1026];
    UILabel *timeLabel=[[disDateButton subviews] lastObject];
    UITextView *textView=(UITextView*)[self.view viewWithTag:1027];
    if (self.diseaseArray.count==0) {
        [self showSimplePromptBox:self andMesage:@"请选择疾病名称！"];
    }else if ([timeLabel.text isEqualToString:@"请选择患病时间！"]){
        [self showSimplePromptBox:self andMesage:@"请选择患病时间！"];
    }else if (textView.text.length==0){
        [self showSimplePromptBox:self andMesage:@"请输入疾病说明！"];
    }else{
        NSMutableDictionary *diseaseDic=[self.diseaseArray lastObject];
        [diseaseDic setObject:textView.text forKey:@"remark"];
        
        UIView *diseaseSubView=[self addSimpleBackView:CGRectMake(10,addDiseaseButton.frame.origin.y, SCREENWIDTH-20,50) andColor:MAINWHITECOLOR];
        diseaseSubView.layer.borderColor=LINECOLOR.CGColor;
        diseaseSubView.layer.borderWidth=0.5;
        [diseaseSubView.layer setCornerRadius:10];
        [diseaseBGView addSubview:diseaseSubView];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,(SCREENWIDTH-80)/2, 20) andText:[NSString stringWithFormat:@"名称: %@",[diseaseDic objectForKey:@"name"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [diseaseSubView addSubview:nameLabel];
        
        UILabel *dateLabel=[self addLabel:CGRectMake((SCREENWIDTH-80)/2+10, 10,(SCREENWIDTH-80)/2, 20) andText:[NSString stringWithFormat:@"时间: %@",[diseaseDic objectForKey:@"confirmdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [diseaseSubView addSubview:dateLabel];
        
        UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:100+self.diseaseArray.count andSEL:@selector(delDiseaseSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        delButton.layer.borderColor=LINECOLOR.CGColor;
        delButton.layer.borderWidth=0.5;
        [delButton.layer setCornerRadius:12.5];
        [diseaseSubView addSubview:delButton];
        
        UILabel *remarkLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-20, 20) andText:[NSString stringWithFormat:@"说明: %@",[diseaseDic objectForKey:@"remark"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        remarkLabel.numberOfLines=3;
        [remarkLabel sizeToFit];
        [diseaseSubView addSubview:remarkLabel];
        
        diseaseSubView.frame=CGRectMake(10, diseaseSubView.frame.origin.y, diseaseSubView.frame.size.width, remarkLabel.frame.origin.y+remarkLabel.frame.size.height+10);
        
        addDiseaseButton.frame=CGRectMake(addDiseaseButton.frame.origin.x, diseaseSubView.frame.origin.y+diseaseSubView.frame.size.height+10, addDiseaseButton.frame.size.width, addDiseaseButton.frame.size.height);
        
        diseaseBGView.frame=CGRectMake(0, diseaseBGView.frame.origin.y, SCREENWIDTH, addDiseaseButton.frame.origin.y+addDiseaseButton.frame.size.height+10);
        opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, diseaseBGView.frame.origin.y+diseaseBGView.frame.size.height+10, opsBGView.frame.size.width, opsBGView.frame.size.height);
        traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, opsBGView.frame.origin.y+opsBGView.frame.size.height+10, traumaBGView.frame.size.width, traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
        pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
        
        [addDisView removeFromSuperview];
    }
}


- (void)delDiseaseView:(UIButton*)button{
    diseaseCount-=1;
    for (NSMutableDictionary *dic in self.diseaseArray) {
        if ([[dic objectForKey:@"index"]integerValue]==button.tag) {
            [self.diseaseArray removeObject:dic];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in [button.superview.superview subviews]) {
            if (subView.frame.origin.y>=button.superview.frame.origin.y+button.superview.frame.size.height) {
                subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height, subView.frame.size.width,subView.frame.size.height);
            }
        }
        diseaseBGView.frame=CGRectMake(diseaseBGView.frame.origin.x, diseaseBGView.frame.origin.y, diseaseBGView.frame.size.width, diseaseBGView.frame.size.height-button.superview.frame.size.height);
        opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, opsBGView.frame.origin.y-button.superview.frame.size.height, opsBGView.frame.size.width, opsBGView.frame.size.height);
        traumaBGView.frame=CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        
        pastBGView.contentSize=CGSizeMake(0,bloodBGView.frame.size.height+bloodBGView.frame.origin.y+40);
        
        UILabel *pLineLabel=(UILabel*)[pastBGView viewWithTag:2100];
        pLineLabel.frame=CGRectMake(0, pastBGView.contentSize.height-40, SCREENWIDTH, 0.5);
        UILabel *pLineLabel1=(UILabel*)[pastBGView viewWithTag:2101];
        pLineLabel1.frame=CGRectMake(160, 0, 0.5, pastBGView.contentSize.height-40);
        UILabel *pLineLabel2=(UILabel*)[pastBGView viewWithTag:2102];
        pLineLabel2.frame=CGRectMake(120, 0, 0.5, pastBGView.contentSize.height-40);
        UILabel *pLineLabel3=(UILabel*)[pastBGView viewWithTag:2103];
        pLineLabel3.frame=CGRectMake(80, 0, 0.5, pastBGView.contentSize.height-40);
    }];
    [button.superview removeFromSuperview];
}
- (void)addTraumaView{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [self.traumaArray addObject:dic];
    
    UIView *blackBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:CLEARCOLOR];
    [self.view addSubview:blackBGView];
    
    [self addOneTapGestureRecognizer:blackBGView andSel:@selector(cancelOPSBlackView:)];
    
    UIView *subOpsBGView=[self addSimpleBackView:CGRectMake(20,(SCREENHEIGHT-200)/2, SCREENWIDTH-40,200) andColor:MAINWHITECOLOR];
    subOpsBGView.layer.borderColor=GREENCOLOR.CGColor;
    subOpsBGView.layer.borderWidth=0.5;
    [subOpsBGView.layer setCornerRadius:10];
    [blackBGView addSubview:subOpsBGView];
    
    UILabel *label3831=[self addLabel:CGRectMake(10,20,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3831];
    
    UITextField *textField3831N=[self addTextfield:CGRectMake(55, label3831.frame.origin.y-5, SCREENWIDTH-65,30) andPlaceholder:@"外伤名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3831N.tag=1030;
    textField3831N.delegate=self;
    [textField3831N addTarget:self action:@selector(traumaTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subOpsBGView addSubview:textField3831N];
    
    [self addLineLabel:CGRectMake(0,label3831.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UILabel *label3832=[self addLabel:CGRectMake(10,label3831.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3832];
    
    UIButton *button3832N=[self addSimpleButton:CGRectMake(55, label3832.frame.origin.y-5, SCREENWIDTH-105, 30) andBColor:CLEARCOLOR andTag:1031 andSEL:@selector(addDateChoiceView:) andText:@"请选择外伤时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subOpsBGView addSubview:button3832N];
    
    [self addLineLabel:CGRectMake(0,label3832.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UIButton *sureButton=[self addCurrencyButton:CGRectMake(20,button3832N.frame.origin.y+button3832N.frame.size.height+40, (SCREENWIDTH-100)/2, 30) andText:@"确定" andSEL:@selector(sureAddTra:)];
    [subOpsBGView addSubview:sureButton];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(sureButton.frame.origin.x+sureButton.frame.size.width+20, sureButton.frame.origin.y, sureButton.frame.size.width, 30) andBColor:LINECOLOR andTag:0 andSEL:@selector(cancelAddTraView:) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:1];
    [cancelButton.layer setCornerRadius:15];
    [subOpsBGView addSubview:cancelButton];
}

- (void)cancelTraBlackView:(UITapGestureRecognizer*)tap{
    [self.traumaArray removeLastObject];
    [tap.view removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)cancelAddTraView:(UIButton*)button{
    [self.traumaArray removeLastObject];
    [button.superview.superview removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)sureAddTra:(UIButton*)button{
    UITextField *textField=(UITextField*)[self.view viewWithTag:1030];
    UIButton *disDateButton=(UIButton*)[self.view viewWithTag:1031];
    UILabel *timeLabel=[[disDateButton subviews] lastObject];
    if (textField.text.length==0) {
        [self showSimplePromptBox:self andMesage:@"请输入外伤名称！"];
    }else if ([timeLabel.text isEqualToString:@"请选择外伤时间！"]){
        [self showSimplePromptBox:self andMesage:@"请选择外伤时间！"];
    }else{
        NSMutableDictionary *opsDic=[self.traumaArray lastObject];
        UIView *opsSubView=[self addSimpleBackView:CGRectMake(10,addTraumaButton.frame.origin.y, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
        opsSubView.layer.borderColor=LINECOLOR.CGColor;
        opsSubView.layer.borderWidth=0.5;
        [opsSubView.layer setCornerRadius:10];
        [traumaBGView addSubview:opsSubView];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"名称: %@",[opsDic objectForKey:@"traumaname"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [opsSubView addSubview:nameLabel];
        
        UILabel *dateLabel=[self addLabel:CGRectMake(10, 40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[opsDic objectForKey:@"traumadate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [opsSubView addSubview:dateLabel];
        
        UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:100+self.traumaArray.count andSEL:@selector(delTraSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        delButton.layer.borderColor=LINECOLOR.CGColor;
        delButton.layer.borderWidth=0.5;
        [delButton.layer setCornerRadius:12.5];
        [opsSubView addSubview:delButton];
        
        addTraumaButton.frame=CGRectMake(addTraumaButton.frame.origin.x, opsSubView.frame.origin.y+opsSubView.frame.size.height+10, addTraumaButton.frame.size.width, addTraumaButton.frame.size.height);
        traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, traumaBGView.frame.origin.y, traumaBGView.frame.size.width, addTraumaButton.frame.origin.y+addTraumaButton.frame.size.height+10);
        bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
        pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
        
        [button.superview.superview removeFromSuperview];
    }
}


- (void)addOPSView{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [self.opsArray addObject:dic];
    
    UIView *blackBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:CLEARCOLOR];
    [self.view addSubview:blackBGView];
    
    [self addOneTapGestureRecognizer:blackBGView andSel:@selector(cancelOPSBlackView:)];
    
    UIView *subOpsBGView=[self addSimpleBackView:CGRectMake(20,(SCREENHEIGHT-200)/2, SCREENWIDTH-40,200) andColor:MAINWHITECOLOR];
    subOpsBGView.layer.borderColor=GREENCOLOR.CGColor;
    subOpsBGView.layer.borderWidth=0.5;
    [subOpsBGView.layer setCornerRadius:10];
    [blackBGView addSubview:subOpsBGView];
    
    UILabel *label3821=[self addLabel:CGRectMake(10,20,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3821];
    
    UITextField *textField3821N=[self addTextfield:CGRectMake(55, label3821.frame.origin.y-5, SCREENWIDTH-65,30) andPlaceholder:@"手术名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3821N.tag=1028;
    textField3821N.delegate=self;
    [textField3821N addTarget:self action:@selector(opsTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subOpsBGView addSubview:textField3821N];
    
    [self addLineLabel:CGRectMake(0,label3821.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UILabel *label3822=[self addLabel:CGRectMake(10,label3821.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3822];
    
    UIButton *button3822N=[self addSimpleButton:CGRectMake(55, label3822.frame.origin.y-5, SCREENWIDTH-105, 30) andBColor:CLEARCOLOR andTag:1029 andSEL:@selector(addDateChoiceView:) andText:@"请选择手术时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subOpsBGView addSubview:button3822N];
    
    [self addLineLabel:CGRectMake(0,label3822.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];

    UIButton *sureButton=[self addCurrencyButton:CGRectMake(20,button3822N.frame.origin.y+button3822N.frame.size.height+40, (SCREENWIDTH-100)/2, 30) andText:@"确定" andSEL:@selector(sureAddOPS:)];
    [subOpsBGView addSubview:sureButton];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(sureButton.frame.origin.x+sureButton.frame.size.width+20, sureButton.frame.origin.y, sureButton.frame.size.width, 30) andBColor:LINECOLOR andTag:0 andSEL:@selector(cancelAddOPSView:) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:1];
    [cancelButton.layer setCornerRadius:15];
    [subOpsBGView addSubview:cancelButton];
}

- (void)cancelOPSBlackView:(UITapGestureRecognizer*)tap{
    [self.opsArray removeLastObject];
    [tap.view removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)cancelAddOPSView:(UIButton*)button{
    [self.opsArray removeLastObject];
    [button.superview.superview removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)sureAddOPS:(UIButton*)button{
    UITextField *textField=(UITextField*)[self.view viewWithTag:1028];
    UIButton *disDateButton=(UIButton*)[self.view viewWithTag:1029];
    UILabel *timeLabel=[[disDateButton subviews] lastObject];
    if (textField.text.length==0) {
        [self showSimplePromptBox:self andMesage:@"请输入手术名称！"];
    }else if ([timeLabel.text isEqualToString:@"请选择患病时间！"]){
        [self showSimplePromptBox:self andMesage:@"请选择手术时间！"];
    }else{
        NSMutableDictionary *opsDic=[self.opsArray lastObject];
    UIView *opsSubView=[self addSimpleBackView:CGRectMake(10,addOpsButton.frame.origin.y, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
    opsSubView.layer.borderColor=LINECOLOR.CGColor;
    opsSubView.layer.borderWidth=0.5;
    [opsSubView.layer setCornerRadius:10];
    [opsBGView addSubview:opsSubView];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20)andText:[NSString stringWithFormat:@"名称: %@",[opsDic objectForKey:@"opsname"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [opsSubView addSubview:nameLabel];
        
    
    UILabel *dateLabel=[self addLabel:CGRectMake(10, 40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[opsDic objectForKey:@"opsdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [opsSubView addSubview:dateLabel];
        
        UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:100+self.opsArray.count andSEL:@selector(delOPSSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        delButton.layer.borderColor=LINECOLOR.CGColor;
        delButton.layer.borderWidth=0.5;
        [delButton.layer setCornerRadius:12.5];
        [opsSubView addSubview:delButton];
    
        addOpsButton.frame=CGRectMake(addOpsButton.frame.origin.x, opsSubView.frame.origin.y+opsSubView.frame.size.height+10, addOpsButton.frame.size.width, addOpsButton.frame.size.height);
        
        opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, diseaseBGView.frame.origin.y+diseaseBGView.frame.size.height+10, opsBGView.frame.size.width, addOpsButton.frame.size.height+addOpsButton.frame.origin.y+10);
        traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, opsBGView.frame.origin.y+opsBGView.frame.size.height+10, traumaBGView.frame.size.width, traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width, bloodBGView.frame.size.height);
        pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
        
        [button.superview.superview removeFromSuperview];
    }
}

#pragma mark 添加输血记录
- (void)addBloodView{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [self.bloodArray addObject:dic];
    
    UIView *blackBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:CLEARCOLOR];
    [self.view addSubview:blackBGView];
    
    [self addOneTapGestureRecognizer:blackBGView andSel:@selector(cancelBloodBlackView:)];
    
    UIView *subOpsBGView=[self addSimpleBackView:CGRectMake(20,(SCREENHEIGHT-200)/2, SCREENWIDTH-40,200) andColor:MAINWHITECOLOR];
    subOpsBGView.layer.borderColor=GREENCOLOR.CGColor;
    subOpsBGView.layer.borderWidth=0.5;
    [subOpsBGView.layer setCornerRadius:10];
    [blackBGView addSubview:subOpsBGView];
    
    UILabel *label3831=[self addLabel:CGRectMake(10,20,40,20) andText:@"原因" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3831];
    
    UITextField *textField3831N=[self addTextfield:CGRectMake(55, label3831.frame.origin.y-5, SCREENWIDTH-65,30) andPlaceholder:@"请输入输血原因" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3831N.tag=1032;
    textField3831N.delegate=self;
    [textField3831N addTarget:self action:@selector(bloodTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subOpsBGView addSubview:textField3831N];
    
    [self addLineLabel:CGRectMake(0,label3831.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UILabel *label3832=[self addLabel:CGRectMake(10,label3831.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3832];
    
    UIButton *button3832N=[self addSimpleButton:CGRectMake(55, label3832.frame.origin.y-5, SCREENWIDTH-105, 30) andBColor:CLEARCOLOR andTag:1033 andSEL:@selector(addDateChoiceView:) andText:@"请选择输血时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subOpsBGView addSubview:button3832N];
    
    [self addLineLabel:CGRectMake(0,label3832.frame.origin.y+29.5,SCREENWIDTH-40,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UIButton *sureButton=[self addCurrencyButton:CGRectMake(20,button3832N.frame.origin.y+button3832N.frame.size.height+40, (SCREENWIDTH-100)/2, 30) andText:@"确定" andSEL:@selector(sureAddBlood:)];
    [subOpsBGView addSubview:sureButton];
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(sureButton.frame.origin.x+sureButton.frame.size.width+20, sureButton.frame.origin.y, sureButton.frame.size.width, 30) andBColor:LINECOLOR andTag:0 andSEL:@selector(cancelAddBloodView:) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:1];
    [cancelButton.layer setCornerRadius:15];
    [subOpsBGView addSubview:cancelButton];
}

- (void)cancelBloodBlackView:(UITapGestureRecognizer*)tap{
    [self.bloodArray removeLastObject];
    [tap.view removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)cancelAddBloodView:(UIButton*)button{
    [self.bloodArray removeLastObject];
    [button.superview.superview removeFromSuperview];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
}

- (void)sureAddBlood:(UIButton*)button{
    UITextField *textField=(UITextField*)[self.view viewWithTag:1032];
    UIButton *disDateButton=(UIButton*)[self.view viewWithTag:1033];
    UILabel *timeLabel=[[disDateButton subviews] lastObject];
    if (textField.text.length==0) {
        [self showSimplePromptBox:self andMesage:@"请输入输血原因！"];
    }else if ([timeLabel.text isEqualToString:@"请选择输血时间！"]){
        [self showSimplePromptBox:self andMesage:@"请选择输血时间！"];
    }else{
        NSMutableDictionary *opsDic=[self.bloodArray lastObject];
        UIView *opsSubView=[self addSimpleBackView:CGRectMake(10,addBloodButton.frame.origin.y, SCREENWIDTH-20,70) andColor:MAINWHITECOLOR];
        opsSubView.layer.borderColor=LINECOLOR.CGColor;
        opsSubView.layer.borderWidth=0.5;
        [opsSubView.layer setCornerRadius:10];
        [bloodBGView addSubview:opsSubView];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"原因: %@",[opsDic objectForKey:@"reason"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [opsSubView addSubview:nameLabel];
        
        UILabel *dateLabel=[self addLabel:CGRectMake(10,40,SCREENWIDTH-120, 20) andText:[NSString stringWithFormat:@"时间: %@",[opsDic objectForKey:@"transdate"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [opsSubView addSubview:dateLabel];
        
        UIButton *delButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70, 10, 40, 25) andBColor:MAINWHITECOLOR andTag:100+self.bloodArray.count andSEL:@selector(delBloodSubView:) andText:@"删除" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        delButton.layer.borderColor=LINECOLOR.CGColor;
        delButton.layer.borderWidth=0.5;
        [delButton.layer setCornerRadius:12.5];
        [opsSubView addSubview:delButton];
        
        addBloodButton.frame=CGRectMake(addBloodButton.frame.origin.x, opsSubView.frame.origin.y+opsSubView.frame.size.height+10, addBloodButton.frame.size.width, addBloodButton.frame.size.height);
        bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, traumaBGView.frame.origin.y+traumaBGView.frame.size.height+10, bloodBGView.frame.size.width,addBloodButton.frame.origin.y+addBloodButton.frame.size.height+10);
        pastBGView.contentSize=CGSizeMake(0, bloodBGView.frame.origin.y+bloodBGView.frame.size.height+40);
        
        [button.superview.superview removeFromSuperview];
    }
}

- (void)textFieldEditChanged:(UITextField *)textField

{
    if (textField.superview.tag>1100) {
        if (self.diseaseArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.diseaseArray) {
                if([[dic objectForKey:@"index"] integerValue]==textField.tag-2){
                    [dic setObject:textField.text forKey:@"remark"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                textField.text=nil;
                [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
            }
        }else{
            textField.text=nil;
            [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
        }
    }else if (textField.tag==1027){
        if (self.diseaseArray.count>0) {
            NSMutableDictionary *dic=[self.diseaseArray objectAtIndex:0];
            if([[dic objectForKey:@"index"] integerValue]<1100){
                [dic setObject:textField.text forKey:@"remark"];
            }else{
                textField.text=nil;
                [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
            }
        }else{
            textField.text=nil;
            [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
        }
    }
    NSLog(@"============%@",self.diseaseArray);
    
}

- (void)opsTextFieldEditChanged:(UITextField *)textField
{
    NSMutableDictionary *dic=[self.opsArray lastObject];
    [dic setObject:textField.text forKey:@"opsname"];
    NSLog(@"============%@",self.opsArray);
    
}

- (void)traumaTextFieldEditChanged:(UITextField *)textField

{
    NSMutableDictionary *dic=[self.traumaArray lastObject];
    [dic setObject:textField.text forKey:@"traumaname"];
    NSLog(@"============%@",self.traumaArray);
    
}


- (void)bloodTextFieldEditChanged:(UITextField *)textField

{
    NSMutableDictionary *dic=[self.bloodArray lastObject];
    [dic setObject:textField.text forKey:@"reason"];
    NSLog(@"============%@",self.bloodArray);
}


#pragma mark 选择父亲家族史
- (void)choiceFamilyF:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.familyFArray) {
            if ([[dic objectForKey:@"heredityid"] intValue]==item.ID) {
                [self.familyFArray removeObject:dic];
                break;
            }
        }
        
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.familyFArray addObject:dic];
    }
    NSLog(@"===========%@",self.familyFArray);
}

#pragma mark 选择母亲家族史
- (void)choiceFamilyM:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES){
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.familyMArray) {
            if ([[dic objectForKey:@"heredityid"] intValue]==item.ID) {
                [self.familyMArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.familyMArray addObject:dic];
    }
    NSLog(@"===========%@",self.familyMArray);
}

#pragma mark 选择兄弟姐妹家族史
- (void)choiceFamilyB:(UIButton*)button{
    if (!self.familyBArray) {
        self.familyBArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.familyBArray) {
            if ([[dic objectForKey:@"heredityid"] intValue]==item.ID) {
                [self.familyBArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.familyBArray addObject:dic];
    }
    NSLog(@"===========%@",self.familyBArray);
}

#pragma mark 选择儿女家族史
- (void)choiceFamilyD:(UIButton*)button{
    if (!self.familyDArray) {
        self.familyDArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (NSMutableDictionary *dic in self.familyDArray) {
            if ([[dic objectForKey:@"heredityid"] intValue]==item.ID) {
                [self.familyDArray removeObject:dic];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        NSMutableDictionary *dic=[NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%d",item.ID] forKey:@"heredityid"];
        [dic setObject:item.Name forKey:@"name"];
        [self.familyDArray addObject:dic];
    }
    NSLog(@"===========%@",self.familyDArray);
}

#pragma mark 识别身份证
- (void)getIDCardInfo{
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc]init];
    con.scNaigationDelegate=self;
    con.iCardType=TIDCARD2; // 其他证件以此类推
    [self presentViewController:con animated:YES completion:NULL];
}

- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    UILabel *nameLabel=(UILabel*)[self.view viewWithTag:1004];
    nameLabel.text=name;
    UIButton *sexButton=(UIButton*)[self.view viewWithTag:1005];
    UILabel *sexLabel=[[sexButton subviews]lastObject];
    sexLabel.textColor=TEXTCOLOR;
    sexLabel.text=sex;
    UIButton *birthdayButton=(UIButton*)[self.view viewWithTag:1006];
    UILabel *birthdayLabel=[[birthdayButton subviews]lastObject];
    birthdayLabel.textColor=TEXTCOLOR;
    birthdayLabel.text=[[[birthday stringByReplacingOccurrencesOfString:@"年" withString:@"-"] stringByReplacingOccurrencesOfString:@"月" withString:@"-"] stringByReplacingOccurrencesOfString:@"日" withString:@""];
    UIButton *folkButton=(UIButton*)[self.view viewWithTag:1007];
    UILabel *folkLabel=[[folkButton subviews]lastObject];
    folkLabel.textColor=TEXTCOLOR;
    if ([folk rangeOfString:@"汉"].location!=NSNotFound) {
        folkLabel.text=@"汉族";
    }else{
        folkLabel.text=@"少数民族";
    }
    UITextField *IDLabel=(UITextField*)[self.view viewWithTag:1008];
    IDLabel.text=num;
    UITextField *addressLabel=(UITextField*)[self.view viewWithTag:1009];
    addressLabel.text=address;
    
    UITextField *nowAddressLabel=(UITextField*)[self.view viewWithTag:1010];
    nowAddressLabel.text=address;
}


- (void)checkIDNumber{
    UITextField *IDNumber=(UITextField*)[self.view viewWithTag:1008];
    if (![self checkIDcard:IDNumber.text]){
        [self showSimplePromptBox:self andMesage:@"身份证号码输入有误！"];
    }else{
        [self sendRequest:@"SearchIDNumber" andPath:queryURL andSqlParameter:IDNumber.text and:self];
        
//        [self sendRequest:GETUSERFILETYPE andPath:[NSString stringWithFormat:@"http://116.52.164.58:9802%@",GETUSERFILEURL] andSqlParameter:@{@"idNum":IDNumber.text} and:self];
    }
}

#pragma mark 选择性别
- (void)choiceSex:(UIButton*)button{
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
    [self cancelkeyboard];
    lastMenuButton=button;
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    UILabel *sexLabel=[[button subviews]lastObject];
    NSArray *keyArray=nil;
    if (button.tag==1005) {
        keyArray=@[@"男",@"女"];
    }else{
        keyArray=@[@"汉族",@"少数民族"];
    }
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    if ([keyArray containsObject:sexLabel.text]) {
        [menuChoiceView initMenuChoiceView:keyArray andFirst:sexLabel.text];
    }else{
        [menuChoiceView initMenuChoiceView:keyArray andFirst:[keyArray objectAtIndex:0]];
    }
    menuChoiceView.delegate=self;
    [self.view addSubview:menuChoiceView];
    
    
}

- (void)cancelkeyboard{
    [self.view endEditing:YES];
}


- (void)sureChoiceMenu:(NSString *)menuString{
    UILabel *sexLabel=[[lastMenuButton subviews]lastObject];
    sexLabel.textColor=TEXTCOLOR;
    sexLabel.text=menuString;
}


#pragma mark 选择时间
- (void)addDateChoiceView:(UIButton *)button{
    [self cancelkeyboard];
    UILabel *label=[[button subviews] lastObject];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
    }
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    if ([label.text rangeOfString:@"请选择"].location!=NSNotFound) {
        [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
    }else{
        [dateChoiceView initDateChoiceView:label.text];
    }
    dateChoiceView.delegate=self;
    [self.view addSubview:dateChoiceView];
    lastTimeButton=button;
}
/**
 时间选择回调
 */
- (void)sureChoiceDate:(NSDate*)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [df stringFromDate:date];
    UILabel *label=[[lastTimeButton subviews] lastObject];
    label.textColor=TEXTCOLOR;
    label.text=s1;
if (lastTimeButton.tag==1026){
        if (self.diseaseArray.count>0) {
            NSMutableDictionary *dic=[self.diseaseArray lastObject];
            if(dic){
                [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"confirmdate"];
            }else{
                label.text=@"请选择患病时间";
                label.textColor=TEXTCOLORSDG;
                [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
            }
        }else{
            label.text=@"请选择患病时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
        }
        NSLog(@"============%@",self.diseaseArray);
    }else if (lastTimeButton.tag==1029){
        NSMutableDictionary *dic=[self.opsArray lastObject];
        [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"opsdate"];
        NSLog(@"============%@",self.opsArray);
    }else if (lastTimeButton.tag==1031){
        NSMutableDictionary *dic=[self.traumaArray lastObject];
        [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"traumadate"];
        NSLog(@"============%@",self.traumaArray);
    }else if (lastTimeButton.tag==1033){
        NSMutableDictionary *dic=[self.bloodArray lastObject];
        [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"transdate"];
        NSLog(@"============%@",self.bloodArray);
    }
}

- (void)cancelChoiceDate{
    
}

- (void)IDCardTextFieldEditChanged:(UITextField*)textField{
    isCheckIDCard=NO;
}


#pragma mark 获取选择的字段
- (NSString*)getChoiceString:(NSString*)choiceString{
    choiceString=[choiceString substringFromIndex:[choiceString rangeOfString:@"."].location+[choiceString rangeOfString:@"."].length];
    return choiceString;
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    nowBGView.frame=CGRectMake(0,nowBGView.frame.origin.y,SCREENWIDTH,SCREENHEIGHT-size.height-nowBGView.frame.origin.y);
    addDisView.frame=CGRectMake(0, addDisView.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-size.height-nowBGView.frame.origin.y);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    nowBGView.frame=CGRectMake(0,nowBGView.frame.origin.y,SCREENWIDTH,SCREENHEIGHT-nowBGView.frame.origin.y-50);
    addDisView.frame=CGRectMake(0, addDisView.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-nowBGView.frame.origin.y);
}

- (NSDictionary*)getObjectData:(id)obj {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

- (id)getObjectInternal:(id)obj {
    
    if([obj isKindOfClass:[NSString class]]
       ||
       [obj isKindOfClass:[NSNumber class]]
       ||
       [obj isKindOfClass:[NSNull class]]) {
        
        return obj;
        
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
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
