//
//  ArchiveInputViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ArchiveInputViewController.h"
#import "SCCaptureCameraController.h"
#import "MyUserViewController.h"
#import "AddArchiveItem.h"
#import "CustomProgressView.h"
@interface ArchiveInputViewController ()<SCNavigationControllerDelegate>

@end

@implementation ArchiveInputViewController
/*
 问题 部分多选选项包含非选项字段。如暴露史包含暴露史
 会员姓名和姓名字段是否为同一值
 身份证是否为必填。重复检测放在哪个步骤
 建档单位如何取值
 建档人是登录会员还是自己填写
 基本信息表ID、FileNoSub不能为空 如何取值？
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=MAINWHITECOLOR;
    [self addTitleView:@"建档"];
    [self addLeftButtonItem];
    [self initData];
    [self sendRequest:@"GetArchiveOption" andPath:queryURL andSqlParameter:nil and:self];
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
    self.delFielNO=@"";
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if ([type isEqualToString:@"GetArchiveOption"]) {
            if (dataArray.count>0) {
                for (NSDictionary *dic in dataArray) {
                    AddArchiveItem *item=[RMMapper objectWithClass:[AddArchiveItem class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
                [self creatUI];
            }
        }else if([type isEqualToString:@"SearchIDNumber"]){
            if (dataArray.count>0) {
                NSDictionary *dic=[dataArray objectAtIndex:0];
                self.DistrictNumber=[self changeNullString:[dic objectForKey:@"DistrictNumber"]];
                self.delFielNO=[self changeNullString:[dic objectForKey:@"FileNo"]];
                self.oldIDCardInfo=[RMMapper objectWithClass:[IDCardInfoItem class] fromDictionary:dic];
                if (self.DistrictNumber.length==0) {
                    isCheckIDCard=YES;
                    UITextField *nameTextField=(UITextField*)[self.view viewWithTag:1004];
                    nameTextField.text=self.oldIDCardInfo.Name;
                    
                    UIButton *sexButton=(UIButton*)[self.view viewWithTag:1005];
                    UILabel *sexLabel=[[sexButton subviews] firstObject];
                    sexLabel.text=self.oldIDCardInfo.Sex;
                    sexLabel.textColor=TEXTCOLOR;
                    
                    UIButton *folkButton=(UIButton*)[self.view viewWithTag:1007];
                    UILabel *folkLabel=[[folkButton subviews] firstObject];
                    folkLabel.text=self.oldIDCardInfo.Folk;
                    folkLabel.textColor=TEXTCOLOR;
                    
                    UIButton *birthdayButton=(UIButton*)[self.view viewWithTag:1006];
                    UILabel *birthdayLabel=[[birthdayButton subviews] firstObject];
                    birthdayLabel.text=[self getSubTime:self.oldIDCardInfo.Birthday andFormat:@"yyyy-MM-dd"];
                    birthdayLabel.textColor=TEXTCOLOR;
                    
                    UITextField *addressLabel=(UITextField*)[self.view viewWithTag:1009];
                    addressLabel.text=self.oldIDCardInfo.Address;
                    [self showSimplePromptBox:self andMesage:@"该身份证号可进行建档操作！"];
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
        }else if([type isEqualToString:@"UploadArchive"]){
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"建档已完成！" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
        }else if([type isEqualToString:@"GenerateFileNO"]){
            if (dataArray.count>0) {
                self.UUID=[self getUniqueStrByUUID];
                NSDictionary *dic=[dataArray objectAtIndex:0];
                
                NSMutableArray *cmdArray=[NSMutableArray new];
                //                医疗保险支付方式
                if (self.paymentArray.count>0) {
                    for (AddArchiveItem *item in self.paymentArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"paymentMode" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"PaymentModeID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                药物过敏史
                if (self.allergicArray.count>0) {
                    for (AddArchiveItem *item in self.allergicArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"allergiesHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"AllergiesID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                暴露史
                if (self.exposeArray.count>0) {
                    for (AddArchiveItem *item in self.exposeArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"exposeHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"ExposeID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //               既往史-疾病
                if (self.diseaseArray.count>0) {
                    for (NSMutableDictionary *dic in self.diseaseArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"diseaseHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"DiseaseID":@{@"type":@"int",@"value":[dic objectForKey:@"ID"]},@"ID":@{@"type":@"func",@"value":@"newid()"},@"Remark":@{@"type":@"text",@"value":[dic objectForKey:@"remark"]},@"ConfirmDate":@{@"type":@"text",@"value":[dic objectForKey:@"time"]}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //               既往史-手术
                if (self.opsArray.count>0) {
                    for (NSMutableDictionary *dic in self.opsArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"opshistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"opsname":@{@"type":@"text",@"value":[dic objectForKey:@"name"]},@"ID":@{@"type":@"func",@"value":@"newid()"},@"opsdate":@{@"type":@"text",@"value":[dic objectForKey:@"time"]}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //               既往史-外伤
                if (self.traumaArray.count>0) {
                    for (NSMutableDictionary *dic in self.traumaArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"traumaHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"traumaName":@{@"type":@"text",@"value":[dic objectForKey:@"name"]},@"ID":@{@"type":@"func",@"value":@"newid()"},@"traumaDate":@{@"type":@"text",@"value":[dic objectForKey:@"time"]}} forKey:@"data"];
                        [cmdArray addObject:cmd];                    }
                }
                //               既往史-输血
                if (self.bloodArray.count>0) {
                    for (NSMutableDictionary *dic in self.bloodArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"bloodTrans" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"reason":@{@"type":@"text",@"value":[dic objectForKey:@"name"]},@"ID":@{@"type":@"func",@"value":@"newid()"},@"transDate":@{@"type":@"text",@"value":[dic objectForKey:@"time"]}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                家族史-父亲
                if (self.familyFArray.count>0) {
                    for (AddArchiveItem *item in self.familyFArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"fatherHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"HeredityID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                家族史-母亲
                if (self.familyFArray.count>0) {
                    for (AddArchiveItem *item in self.familyMArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"matherHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"HeredityID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                家族史-兄弟姐妹
                if (self.familyBArray.count>0) {
                    for (AddArchiveItem *item in self.familyBArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"brotherHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"HeredityID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                家族史-儿女
                if (self.familyBArray.count>0) {
                    for (AddArchiveItem *item in self.familyBArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"familyHistory" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"HeredityID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                //                  残疾情况
                if (self.disabilityArray.count>0) {
                    for (AddArchiveItem *item in self.disabilityArray) {
                        NSMutableDictionary *cmd=[NSMutableDictionary new];
                        [cmd setObject:@"insert" forKey:@"action"];
                        [cmd setObject:@"disabilityStatus" forKey:@"function"];
                        [cmd setObject:@{@"PersonalInfoID":@{@"type":@"text",@"value":self.UUID},
                                         @"DisabilityStatusID":@{@"type":@"int",@"value":[NSString stringWithFormat:@"%d",item.ID]},@"ID":@{@"type":@"func",@"value":@"newid()"}} forKey:@"data"];
                        [cmdArray addObject:cmd];
                    }
                }
                
                if (self.DistrictNumber.length==0) {
                   NSMutableDictionary *cmd=[NSMutableDictionary new];
                    [cmd setObject:@"delete" forKey:@"action"];
                    [cmd setObject:@"healthFile" forKey:@"function"];
                    [cmd setObject:@{@"FileNo":@{@"type":@"text",@"value":self.delFielNO}} forKey:@"data"];
                    [cmdArray addObject:cmd];
                    
                    NSMutableDictionary *pCmd=[NSMutableDictionary new];
                    [pCmd setObject:@"delete" forKey:@"action"];
                    [pCmd setObject:@"personalInfo" forKey:@"function"];
                    [pCmd setObject:@{@"FileNo":@{@"type":@"text",@"value":self.delFielNO}} forKey:@"data"];
                    [cmdArray addObject:pCmd];
                }
                NSString *FileNo=[dic objectForKey:@"FileNo"];
                NSString *FileNoSub=[FileNo substringFromIndex:FileNo.length-7];
                [self sendRequest:@"UploadArchive" andPath:excuteURL andSqlParameter:@[archiveArray,basicInfoArray,FileNo,cmdArray,FileNoSub,self.UUID] and:self];
            }else{
                [self showSimplePromptBox:self andMesage:@"生成档案号失败，请重试！"];
            }
        }
        
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
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

- (void)choiceDisease:(UIButton*)button{
    lastDiseasButton=nil;
    lastDisDic=nil;
    if (!self.diseaseArray) {
        self.diseaseArray=[NSMutableArray new];
    }
    
    if (button.superview.tag>1100) {
        UIButton *timeButton=(UIButton*)[self.view viewWithTag:button.tag+1];
        UILabel *timeLabel=[[timeButton subviews] lastObject];
        timeLabel.text=@"请选择患病时间";
        timeLabel.textColor=TEXTCOLORSDG;
        
        UITextField *textField=(UITextField*)[self.view viewWithTag:button.tag+2];
        textField.text=nil;
        if (diseaseButtonArray.count>0) {
            for (UIButton *lButton in diseaseButtonArray) {
                if (lButton.tag==button.tag) {
                    lastDiseasButton=lButton;
                    if (self.diseaseArray.count>[diseaseButtonArray indexOfObject:lButton]) {
                        lastDisDic=[self.diseaseArray objectAtIndex:[diseaseButtonArray indexOfObject:lButton]];
                    }
                    break;
                }
            }
        }
    }else{
        UIButton *timeButton=(UIButton*)[self.view viewWithTag:1026];
        UILabel *timeLabel=[[timeButton subviews] lastObject];
        timeLabel.text=@"请选择患病时间";
        timeLabel.textColor=TEXTCOLORSDG;
        UITextField *textField=(UITextField*)[self.view viewWithTag:1027];
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
    }
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        
        if (self.diseaseArray.count>0) {
            if (button.superview.tag>1100) {
                for (NSMutableDictionary *dic in self.diseaseArray) {
                    if ([[dic objectForKey:@"index"] integerValue]==button.tag) {
                        [self.diseaseArray removeObject:dic];
                        break;
                    }
                }
                
            }else{
                NSMutableDictionary *dic=[self.diseaseArray objectAtIndex:0];
                if ([[dic objectForKey:@"index"] integerValue]<1100) {
                    [self.diseaseArray removeObject:dic];
                }
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        if (self.diseaseArray.count>0) {
            for (NSMutableDictionary *dic in self.diseaseArray) {
                if ([[dic objectForKey:@"ID"] isEqualToString:[lastDisDic objectForKey:@"ID"]]&&[[dic objectForKey:@"index"] isEqualToString:[lastDisDic objectForKey:@"index"]]) {
                    [self.diseaseArray removeObject:dic];
                    break;
                }
            }
            for (AddArchiveItem *item in diseaseArray) {
                if ([label.text rangeOfString:item.Name].location!=NSNotFound) {
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:item.Name forKey:@"name"];
                    [dic setObject:[NSString  stringWithFormat:@"%d",item.ID] forKey:@"ID"];
                    [dic setObject:@"" forKey:@"time"];
                    [dic setObject:@"" forKey:@"remark"];
                    [dic setObject:[NSString  stringWithFormat:@"%ld",(long)button.tag] forKey:@"index"];
                    if (button.superview.tag>1100) {
                        [self.diseaseArray addObject:dic];
                    }else{
                        [self.diseaseArray insertObject:dic atIndex:0];
                    }
                    break;
                }
            }
        }
        else{
            for (AddArchiveItem *item in diseaseArray) {
                if ([label.text rangeOfString:item.Name].location!=NSNotFound) {
                    NSMutableDictionary *dic=[NSMutableDictionary new];
                    [dic setObject:item.Name forKey:@"name"];
                    [dic setObject:[NSString  stringWithFormat:@"%d",item.ID] forKey:@"ID"];
                    [dic setObject:@"" forKey:@"time"];
                    [dic setObject:@"" forKey:@"remark"];
                    [dic setObject:[NSString  stringWithFormat:@"%ld",(long)button.tag] forKey:@"index"];
                    if (button.superview.tag>1100) {
                        [self.diseaseArray addObject:dic];
                    }else{
                        [self.diseaseArray insertObject:dic atIndex:0];
                    }
                    break;
                }
            }
        }
    }
    if (lastDiseasButton!=button) {
        lastDiseasButton.selected=NO;
        lastDiseasButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastDiseasButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
        
        if (diseaseButtonArray.count>0) {
            if (button.superview.tag>1100) {
                for (NSMutableDictionary *dic in self.diseaseArray) {
                    if ([[dic objectForKey:@"index"] integerValue]==lastDiseasButton.tag&&[lastLabel.text rangeOfString:[dic objectForKey:@"name"]].location!=NSNotFound) {
                        [self.diseaseArray removeObject:dic];
                        break;
                    }
                }
                
            }else{
                NSMutableDictionary *dic=[self.diseaseArray objectAtIndex:0];
                if ([[dic objectForKey:@"index"] integerValue]<1100&&[[dic objectForKey:@"index"] integerValue]==lastDiseasButton.tag) {
                    [self.diseaseArray removeObject:dic];
                }
            }
        }
        
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

- (void)cancelkeyboard{
    [self.view endEditing:YES];
}

- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    if (self.isCA) {
        [cProgressView creatUI:@[@"住户信息",@"完成建档"] andCount:1];
    }else{
        [cProgressView creatUI:@[@"选择小区",@"住户信息",@"完成建档"] andCount:2];
    }
    [self.view addSubview:cProgressView];
    
    [self addOneTapGestureRecognizer:self.view andSel:@selector(cancelkeyboard)];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,144, SCREENWIDTH, SCREENHEIGHT-194)];
    BGScrollView.delegate=self;
    [self.view addSubview:BGScrollView];
    
    UIView *whiteBGView=[[UIView alloc]initWithFrame:CGRectMake(110, 0, SCREENWIDTH-110, 1000)];
    whiteBGView.backgroundColor=[UIColor whiteColor];
    [BGScrollView addSubview:whiteBGView];
    
    UILabel *label1=[self addLabel:CGRectMake(10, 10,90,20) andText:@"会员姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label1];
    
    UITextField *textField1=[self addTextfield:CGRectMake(120, 5, SCREENWIDTH-130,30) andPlaceholder:@"请输入会员姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField1.text=self.userItem.LName;
    }
    textField1.tag=1001;
    [BGScrollView addSubview:textField1];
    
    
    [self addLineLabel:CGRectMake(0, 40, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label2=[self addLabel:CGRectMake(10,label1.frame.origin.y+label1.frame.size.height+20,90,20) andText:@"档案编号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label2];
    
    UILabel *label2N=[self addLabel:CGRectMake(120,label1.frame.origin.y+label1.frame.size.height+20,SCREENWIDTH-130,20) andText:self.FileNo andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label2N.tag=1002;
    [BGScrollView addSubview:label2N];
    
    [self addLineLabel:CGRectMake(0, label2.frame.origin.y+label2.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label3=[self addLabel:CGRectMake(10,label2.frame.origin.y+label2.frame.size.height+20,90,20) andText:@"纸质档案编号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label3];
    
    UITextField *textField3N=[self addTextfield:CGRectMake(120, label3.frame.origin.y-5, SCREENWIDTH-240,30) andPlaceholder:@"请输入纸质档案编号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3N.keyboardType=UIKeyboardTypeNumberPad;
    textField3N.tag=1003;
    [BGScrollView addSubview:textField3N];
    
    [self addLineLabel:CGRectMake(0, label3.frame.origin.y+label3.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label4=[self addLabel:CGRectMake(10,label3.frame.origin.y+label3.frame.size.height+20,90,20) andText:@"姓名 *" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label4.attributedText=[self setString:@"姓名 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label4];
    
    UITextField *textField4N=[self addTextfield:CGRectMake(120, label4.frame.origin.y-5, SCREENWIDTH-240,30) andPlaceholder:@"请输入姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField4N.text=self.userItem.LName;
    }
    textField4N.tag=1004;
    [BGScrollView addSubview:textField4N];
    
    UIButton *readIDCardButton=[self addButton:CGRectMake(SCREENWIDTH-90, label4.frame.origin.y-2.5, 80,25) adnColor:GREENCOLOR andTag:0 andSEL:@selector(getIDCardInfo)];
    [readIDCardButton.layer setCornerRadius:12.5];
    [BGScrollView addSubview:readIDCardButton];
    
    UILabel *readLabel=[self addLabel:CGRectMake(0,0,80,25) andText:@"身份证识别" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    [readIDCardButton addSubview:readLabel];
    
    [self addLineLabel:CGRectMake(0, label4.frame.origin.y+label4.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label5=[self addLabel:CGRectMake(10,label4.frame.origin.y+label4.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label5.attributedText=[self setString:@"性别 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label5];
    
    UIButton *button5N=[self addSimpleButton:CGRectMake(120, label5.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1005 andSEL:@selector(choiceSex:) andText:@"请选择性别" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *sexLabel=[[button5N subviews]lastObject];
    if (self.userItem) {
        sexLabel.text=self.userItem.LSex;
        sexLabel.textColor=TEXTCOLOR;
    }
    [BGScrollView addSubview:button5N];
    
    [self addLineLabel:CGRectMake(0, label5.frame.origin.y+label5.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label6=[self addLabel:CGRectMake(10,label5.frame.origin.y+label5.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label6.attributedText=[self setString:@"出生日期 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label6];
    
    UIButton *button6N=[self addSimpleButton:CGRectMake(120, label6.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1006 andSEL:@selector(addDateChoiceView:) andText:@"请选择出生日期" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *birLabel=[[button6N subviews]lastObject];
    if (self.userItem) {
        birLabel.text=[self getSubTime:self.userItem.LBirthday andFormat:@"yyyy-MM-dd"];
        birLabel.textColor=TEXTCOLOR;
    }
    [BGScrollView addSubview:button6N];
    
    [self addLineLabel:CGRectMake(0, label6.frame.origin.y+label6.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label7=[self addLabel:CGRectMake(10,label6.frame.origin.y+label6.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label7.attributedText=[self setString:@"民族" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label7];
    
    UIButton *button7N=[self addSimpleButton:CGRectMake(120, label7.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1007 andSEL:@selector(choiceSex:) andText:@"请选择民族" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    UILabel *nationLabel=[[button7N subviews]lastObject];
    if (self.userItem) {
        nationLabel.text=self.userItem.LFolk;
        nationLabel.textColor=TEXTCOLOR;
    }

    [BGScrollView addSubview:button7N];
    
    [self addLineLabel:CGRectMake(0, label7.frame.origin.y+label7.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label8=[self addLabel:CGRectMake(10,label7.frame.origin.y+label7.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label8.attributedText=[self setString:@"身份证号码 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label8];
    
    UITextField *textField8=[self addTextfield:CGRectMake(120, label8.frame.origin.y+12.5, SCREENWIDTH-130,30) andPlaceholder:@"请输入身份证号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField8.text=self.userItem.LIdNum;
        [self sendRequest:@"SearchIDNumber" andPath:queryURL andSqlParameter:textField8.text and:self];

    }
    textField8.adjustsFontSizeToFitWidth=YES;
    textField8.tag=1008;
    textField8.delegate=self;
    [textField8 addTarget:self action:@selector(IDCardTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [BGScrollView addSubview:textField8];
    
    UIButton *checkIDCardButton=[self addButton:CGRectMake(10, label8.frame.origin.y+30, 80,25) adnColor:GREENCOLOR andTag:0 andSEL:@selector(checkIDNumber)];
    [checkIDCardButton.layer setCornerRadius:12.5];
    [BGScrollView addSubview:checkIDCardButton];
    
    UILabel *checkIDCardLabel=[self addLabel:CGRectMake(0,0,80,25) andText:@"重复检测" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    [checkIDCardButton addSubview:checkIDCardLabel];
    
    [self addLineLabel:CGRectMake(0, checkIDCardButton.frame.origin.y+checkIDCardButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label9=[self addLabel:CGRectMake(10, textField8.frame.origin.y+textField8.frame.size.height+32.5,90,20) andText:@"户籍地址" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label9];
    
    UITextField *textField9=[self addTextfield:CGRectMake(120, label9.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入户籍地址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField9.text=self.userItem.LIDAddr;
    }
    textField9.adjustsFontSizeToFitWidth=YES;
    textField9.tag=1009;
    [BGScrollView addSubview:textField9];
    
    [self addLineLabel:CGRectMake(0, label9.frame.origin.y+label9.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label10=[self addLabel:CGRectMake(10,label9.frame.origin.y+label9.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label10.attributedText=[self setString:@"现住址*" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label10];
    
    UITextField *textField10=[self addTextfield:CGRectMake(120, label10.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入现住址" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField10.text=self.userItem.LIDAddr;
    }
    textField10.adjustsFontSizeToFitWidth=YES;
    textField10.tag=1010;
    [BGScrollView addSubview:textField10];
    
    [self addLineLabel:CGRectMake(0, label10.frame.origin.y+label10.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label11=[self addLabel:CGRectMake(10,label10.frame.origin.y+label10.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label11.attributedText=[self setString:@"联系电话 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label11];
    
    UITextField *textField11N=[self addTextfield:CGRectMake(120, label11.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系电话" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    if (self.userItem) {
        textField11N.text=[[self.userItem.LMobile componentsSeparatedByString:@"_"] firstObject];
    }
    textField11N.tag=1011;
    textField11N.keyboardType=UIKeyboardTypeNumberPad;
    [BGScrollView addSubview:textField11N];
    
    [self addLineLabel:CGRectMake(0, label11.frame.origin.y+label11.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label12=[self addLabel:CGRectMake(10,label11.frame.origin.y+label11.frame.size.height+20,90,20) andText:@"行政区划编码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label12];
    
    UILabel *label12N=[self addLabel:CGRectMake(120,label12.frame.origin.y,SCREENWIDTH-130,20) andText:self.NCItem.ID andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label12N.tag=1012;
    [BGScrollView addSubview:label12N];
    
    [self addLineLabel:CGRectMake(0, label12.frame.origin.y+label12.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label13=[self addLabel:CGRectMake(10,label12.frame.origin.y+label12.frame.size.height+20,90,20) andText:@"乡镇(街道)名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label13.numberOfLines=0;
    [label13 sizeToFit];
    label13.frame=CGRectMake(10, label12.frame.origin.y+label12.frame.size.height+20, 90, label13.frame.size.height);
    [BGScrollView addSubview:label13];
    
    UILabel *label13N=[self addLabel:CGRectMake(120,label12.frame.origin.y+label12.frame.size.height+10+label13.frame.size.height/2,SCREENWIDTH-130,20) andText:self.NCItem.ParentName andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label13N.tag=1013;
    [BGScrollView addSubview:label13N];
    
    [self addLineLabel:CGRectMake(0, label13.frame.origin.y+label13.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label14=[self addLabel:CGRectMake(10,label13.frame.origin.y+label13.frame.size.height+20,90,20) andText:@"村(居)委会名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label14.numberOfLines=0;
    [label14 sizeToFit];
    label14.frame=CGRectMake(10, label13.frame.origin.y+label13.frame.size.height+20, 90, label14.frame.size.height);
    [BGScrollView addSubview:label14];
    
    UILabel *label14N=[self addLabel:CGRectMake(120,label13.frame.origin.y+label13.frame.size.height+10+label14.frame.size.height/2,SCREENWIDTH-130,20) andText:self.NCItem.Name andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label14N.tag=1014;
    [BGScrollView addSubview:label14N];
    
    [self addLineLabel:CGRectMake(0, label14.frame.origin.y+label14.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label15=[self addLabel:CGRectMake(10,label14.frame.origin.y+label14.frame.size.height+20,90,20) andText:@"建档单位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label15];
    
    UILabel *label15N=[self addLabel:CGRectMake(120,label14.frame.origin.y+label14.frame.size.height+20,SCREENWIDTH-130,20) andText:[usd objectForKey:@"orgname"] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label15N.tag=1015;
    [BGScrollView addSubview:label15N];
    
    [self addLineLabel:CGRectMake(0, label15.frame.origin.y+label15.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label16=[self addLabel:CGRectMake(10,label15.frame.origin.y+label15.frame.size.height+20,90,20) andText:@"建档人" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label16];
    
    UILabel *label16N=[self addLabel:CGRectMake(120, label16.frame.origin.y, SCREENWIDTH-130,20) andText:[usd objectForKey:@"truename"] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label16N.tag=1016;
    [BGScrollView addSubview:label16N];
    
    [self addLineLabel:CGRectMake(0, label16.frame.origin.y+label16.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label17=[self addLabel:CGRectMake(10,label16.frame.origin.y+label16.frame.size.height+20,90,20) andText:@"责任医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label17];
    
    UITextField *textField17=[self addTextfield:CGRectMake(120, label17.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入责任医生" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField17.adjustsFontSizeToFitWidth=YES;
    textField17.tag=1017;
    [BGScrollView addSubview:textField17];
    
    [self addLineLabel:CGRectMake(0, label17.frame.origin.y+label17.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label18=[self addLabel:CGRectMake(10,label17.frame.origin.y+label17.frame.size.height+20,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label18.attributedText=[self setString:@"建档日期 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label18];
    
    UIButton *button18N=[self addSimpleButton:CGRectMake(120, label18.frame.origin.y-5, SCREENWIDTH-130, 30) andBColor:CLEARCOLOR andTag:1018 andSEL:@selector(addDateChoiceView:) andText:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"] andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [BGScrollView addSubview:button18N];
    
    [self addLineLabel:CGRectMake(0, label18.frame.origin.y+label18.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label19=[self addLabel:CGRectMake(10,label18.frame.origin.y+label18.frame.size.height+20,90,20) andText:@"条形码" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label19];
    
    UITextField *textField19=[self addTextfield:CGRectMake(120, label19.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入条形码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField19.adjustsFontSizeToFitWidth=YES;
    textField19.tag=1019;
    [BGScrollView addSubview:textField19];
    
    [self addLineLabel:CGRectMake(0, label19.frame.origin.y+label19.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label20=[self addLabel:CGRectMake(10,label19.frame.origin.y+label19.frame.size.height+20,90,20) andText:@"户主" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label20];
    
    UITextField *textField20=[self addTextfield:CGRectMake(120, label20.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入户主" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField20.adjustsFontSizeToFitWidth=YES;
    textField20.tag=1020;
    [BGScrollView addSubview:textField20];
    
    [self addLineLabel:CGRectMake(0, label20.frame.origin.y+label20.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label21=[self addLabel:CGRectMake(10,label20.frame.origin.y+label20.frame.size.height+20,90,20) andText:@"柜号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label21];
    
    UITextField *textField21=[self addTextfield:CGRectMake(120, label21.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入柜号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField21.adjustsFontSizeToFitWidth=YES;
    textField21.tag=1021;
    [BGScrollView addSubview:textField21];
    
    [self addLineLabel:CGRectMake(0, label21.frame.origin.y+label21.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label22=[self addLabel:CGRectMake(10,label21.frame.origin.y+label21.frame.size.height+20,90,20) andText:@"盒号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label22];
    
    UITextField *textField22=[self addTextfield:CGRectMake(120, label22.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入盒号" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField22.adjustsFontSizeToFitWidth=YES;
    textField22.tag=1022;
    [BGScrollView addSubview:textField22];
    
    [self addLineLabel:CGRectMake(0, label22.frame.origin.y+label22.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label23=[self addLabel:CGRectMake(10,label22.frame.origin.y+label22.frame.size.height+20,90,20) andText:@"工作单位" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label23];
    
    UITextField *textField23=[self addTextfield:CGRectMake(120, label23.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入工作单位" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField23.adjustsFontSizeToFitWidth=YES;
    textField23.tag=1023;
    [BGScrollView addSubview:textField23];
    
    [self addLineLabel:CGRectMake(0, label23.frame.origin.y+label23.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label24=[self addLabel:CGRectMake(10,label23.frame.origin.y+label23.frame.size.height+20,90,20) andText:@"联系人姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label24];
    
    UITextField *textField24=[self addTextfield:CGRectMake(120, label24.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系人姓名" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField24.adjustsFontSizeToFitWidth=YES;
    textField24.tag=1024;
    [BGScrollView addSubview:textField24];
    
    [self addLineLabel:CGRectMake(0, label24.frame.origin.y+label24.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label25=[self addLabel:CGRectMake(10,label24.frame.origin.y+label24.frame.size.height+20,90,20) andText:@"联系人电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label25];
    
    UITextField *textField25=[self addTextfield:CGRectMake(120, label25.frame.origin.y-5, SCREENWIDTH-130,30) andPlaceholder:@"请输入联系人电话" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField25.adjustsFontSizeToFitWidth=YES;
    textField25.keyboardType=UIKeyboardTypeNumberPad;
    textField25.tag=1025;
    [BGScrollView addSubview:textField25];
    
    [self addLineLabel:CGRectMake(0, label25.frame.origin.y+label25.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *label26=[self addLabel:CGRectMake(10,label25.frame.origin.y+label25.frame.size.height+20,90,20) andText:@"常住类型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label26];
    
    NSArray *addressArray=@[@"1.户籍",@"2.非户籍"];
    for (int i=0; i<addressArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120+70*i, label26.frame.origin.y-2.5, 60,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceLiveType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[addressArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressButton addSubview:addressLabel];
    }
    
    [self addLineLabel:CGRectMake(0, label26.frame.origin.y+label26.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    
    UILabel *label27=[self addLabel:CGRectMake(10,label26.frame.origin.y+label26.frame.size.height+20,90,20) andText:@"血型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label27];
    
    NSArray *bloodArray=@[@"1.A型",@"2.B型",@"3.O型",@"4.AB型",@"5.不详"];
    NSMutableArray *bloodBtnArray=[NSMutableArray new];
    for (int i=0; i<bloodArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label27.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceBloodType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bloodArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label28=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"RH阴性" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label28];
    
    NSArray *bloodRHArray=@[@"1.否",@"2.是",@"3.不详"];
    NSMutableArray *bloodRHBtnArray=[NSMutableArray new];
    for (int i=0; i<bloodRHArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label28.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceRHType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bloodRHArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label29=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"文化程度" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label29];
    
    NSArray *educationArray=@[@"1.文盲及半文盲",@"2.小学",@"3.初中",@"4.高中/技校/中专",@"5.大学专科及以上",@"6.不祥"];
    NSMutableArray *educationBtnArray=[NSMutableArray new];
    for (int i=0; i<educationArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label29.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceEducationType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[educationArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label30=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"职业" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label30];
    
    NSArray *jobArray=@[@"1.国家机关、党群组织、企业、事业单位负责人",@"2.专业技术人员",@"3.办事人员和有关人员",@"4.商业、服务业人员",@"5.农、林、牧、渔、水利业生产人员",@"6.生产、运输设备操作人员及有关人员",@"7.军人",@"8.不便分类的其他从业人员"];
    NSMutableArray *jobBtnArray=[NSMutableArray new];
    for (int i=0; i<jobArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label30.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceJobType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0,SCREENWIDTH-150,0) andText:[jobArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
        addressLabel.numberOfLines=0;
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10,5, addressLabel.frame.size.width,addressLabel.frame.size.height);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, addressLabel.frame.size.height+10);
        [addressButton.layer setCornerRadius:addressButton.frame.size.height/2];
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label31=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"婚姻状况" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label31];
    
    NSArray *maritalArray=@[@"1.未婚",@"2.已婚",@"3.丧偶",@"4.离婚",@"5.未说明的婚姻状况"];
    NSMutableArray *maritalBtnArray=[NSMutableArray new];
    for (int i=0; i<maritalArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label31.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceMaritalType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[maritalArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    
    UILabel *label32=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    label32.attributedText=[self setString:@"人口类型 *" andSubString:@"*" andDifColor:[UIColor redColor]];
    [BGScrollView addSubview:label32];
    
    NSArray *farmArray=@[@"1.农业人口",@"2.城镇居民"];
    NSMutableArray *farmBtnArray=[NSMutableArray new];
    for (int i=0; i<farmArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label32.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFarmOrTown:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    
    UILabel *label34=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"是否孕产妇" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label34];
    
    NSArray *bornArray=@[@"1.是",@"2.否"];
    NSMutableArray *bornBtnArray=[NSMutableArray new];
    for (int i=0; i<bornArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(120, label34.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceMaternal:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[bornArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label35=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"医疗费用支付方式" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label35.numberOfLines=0;
    [label35 sizeToFit];
    label35.frame=CGRectMake(10, whiteBGView.frame.size.height+10, 90, label35.frame.size.height);
    [BGScrollView addSubview:label35];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==123) {
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
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    
    UILabel *label36=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"药物过敏史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label36];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==34) {
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
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label37=[self addLabel:CGRectMake(10,whiteBGView.frame.size.height+10,90,20) andText:@"暴露史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [BGScrollView addSubview:label37];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==192) {
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
        [BGScrollView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(120, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
            
            whiteBGView.frame=CGRectMake(whiteBGView.frame.origin.x, whiteBGView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    pastBGView=[self addSimpleBackView:CGRectMake(0, whiteBGView.frame.origin.y+whiteBGView.frame.size.height+0.5, SCREENWIDTH,200) andColor:CLEARCOLOR];
    [BGScrollView addSubview:pastBGView];
    
    UILabel *label38=[self addLabel:CGRectMake(10,10,50,20) andText:@"既往史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [pastBGView addSubview:label38];
    
    diseaseBGView=[self addSimpleBackView:CGRectMake(0,0, SCREENWIDTH,200) andColor:CLEARCOLOR];
    [pastBGView addSubview:diseaseBGView];
    
    UILabel *label381=[self addLabel:CGRectMake(80,50,40,20) andText:@"疾病" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [diseaseBGView addSubview:label381];
    
    addDiseaseButton=[self addSimpleButton:CGRectMake(90, 80, 20,20) andBColor:GREENCOLOR andTag:0 andSEL:@selector(addDisease) andText:@"+" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [addDiseaseButton.layer setCornerRadius:10];
    [diseaseBGView addSubview:addDiseaseButton];
    
    UIView *disWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [diseaseBGView addSubview:disWhiteView];
    
    UILabel *label3811=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [diseaseBGView addSubview:label3811];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==38) {
            [diseaseArray addObject:item];
        }
    }
    NSMutableArray *diseaseBtnArray=[NSMutableArray new];
    for (int i=0; i<diseaseArray.count; i++) {
        AddArchiveItem *item=[diseaseArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(170, label3811.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceDisease:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [diseaseBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(170, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (i>0) {
            UIButton *lastBtn=[diseaseBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(170, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [diseaseBtnArray addObject:addressButton];
        if (i==diseaseArray.count-1) {
            label3811.frame=CGRectMake(120,label3811.frame.origin.y-10+(addressButton.frame.origin.y+35-(label3811.frame.origin.y-10)-20)/2,40, 20);
            
            [self addLineLabel:CGRectMake(120,addressButton.frame.origin.y+addressButton.frame.size.height+10,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:diseaseBGView];
            
            disWhiteView.frame=CGRectMake(disWhiteView.frame.origin.x, disWhiteView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    UILabel *label3812=[self addLabel:CGRectMake(120,disWhiteView.frame.size.height+10,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [diseaseBGView addSubview:label3812];
    
    UIButton *button3812N=[self addSimpleButton:CGRectMake(165, label3812.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:1026 andSEL:@selector(addDateChoiceView:) andText:@"请选择患病时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [diseaseBGView addSubview:button3812N];
    
    [self addLineLabel:CGRectMake(120,label3812.frame.origin.y+30,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:diseaseBGView];
    
    UILabel *label3813=[self addLabel:CGRectMake(120,label3812.frame.origin.y+40,40,20) andText:@"说明" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [diseaseBGView addSubview:label3813];
    
    UITextField *textField3813N=[self addTextfield:CGRectMake(165, label3813.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"患病说明" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3813N.tag=1027;
    textField3813N.delegate=self;
    [textField3813N addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [diseaseBGView addSubview:textField3813N];
    
    [self addLineLabel:CGRectMake(80,label3813.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:diseaseBGView];
    
    label381.frame=CGRectMake(label381.frame.origin.x,(label3813.frame.origin.y+10)/2, label381.frame.size.width, label381.frame.size.height);
    addDiseaseButton.frame=CGRectMake(addDiseaseButton.frame.origin.x, label381.frame.origin.y+25,20,20);
    
    disWhiteView.frame=CGRectMake(disWhiteView.frame.origin.x, disWhiteView.frame.origin.y, SCREENWIDTH-110, label3813.frame.origin.y+label3813.frame.size.height+10);
    diseaseBGView.frame=CGRectMake(diseaseBGView.frame.origin.x, diseaseBGView.frame.origin.y, diseaseBGView.frame.size.width, label3813.frame.origin.y+30);
    
    opsBGView=[self addSimpleBackView:CGRectMake(0,diseaseBGView.frame.size.height, SCREENWIDTH,200) andColor:CLEARCOLOR];
    [pastBGView addSubview:opsBGView];
    
    UIView *opsWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [opsBGView addSubview:opsWhiteView];
    
    UILabel *label382=[self addLabel:CGRectMake(80,20,40,20) andText:@"手术" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [opsBGView addSubview:label382];
    
    addOpsButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:0 andSEL:@selector(addOPSView) andText:@"+" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [addOpsButton.layer setCornerRadius:10];
    [opsBGView addSubview:addOpsButton];
    
    UILabel *label3821=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [opsBGView addSubview:label3821];
    
    UITextField *textField3821N=[self addTextfield:CGRectMake(165, label3821.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"手术名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3821N.tag=1028;
    textField3821N.delegate=self;
    [textField3821N addTarget:self action:@selector(opsTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [opsBGView addSubview:textField3821N];
    
    [self addLineLabel:CGRectMake(120,label3821.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:opsBGView];
    
    UILabel *label3822=[self addLabel:CGRectMake(120,label3821.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [opsBGView addSubview:label3822];
    
    UIButton *button3822N=[self addSimpleButton:CGRectMake(165, label3822.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:1029 andSEL:@selector(addDateChoiceView:) andText:@"请选择手术时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [opsBGView addSubview:button3822N];
    
    [self addLineLabel:CGRectMake(80,label3822.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:opsBGView];
    
    opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, opsBGView.frame.origin.y, opsBGView.frame.size.width, label3822.frame.origin.y+30);
    opsWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, opsBGView.frame.size.height);
    
    traumaBGView=[self addSimpleBackView:CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,200) andColor:CLEARCOLOR];
    [pastBGView addSubview:traumaBGView];
    
    UIView *traWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [traumaBGView addSubview:traWhiteView];
    
    UILabel *label383=[self addLabel:CGRectMake(80,20,40,20) andText:@"外伤" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [traumaBGView addSubview:label383];
    
    addTraumaButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:0 andSEL:@selector(addTraumaView) andText:@"+" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [addTraumaButton.layer setCornerRadius:10];
    [traumaBGView addSubview:addTraumaButton];
    
    UILabel *label3831=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [traumaBGView addSubview:label3831];
    
    UITextField *textField3831N=[self addTextfield:CGRectMake(165, label3831.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"外伤名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3831N.tag=1030;
    textField3831N.delegate=self;
    [textField3831N addTarget:self action:@selector(traumaTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [traumaBGView addSubview:textField3831N];
    
    [self addLineLabel:CGRectMake(120,label3831.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:traumaBGView];
    
    UILabel *label3832=[self addLabel:CGRectMake(120,label3831.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [traumaBGView addSubview:label3832];
    
    UIButton *button3832N=[self addSimpleButton:CGRectMake(165, label3832.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:1031 andSEL:@selector(addDateChoiceView:) andText:@"请选择外伤时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [traumaBGView addSubview:button3832N];
    
    [self addLineLabel:CGRectMake(80,label3832.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:traumaBGView];
    
    traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, traumaBGView.frame.origin.y, traumaBGView.frame.size.width, label3832.frame.origin.y+30);
    traWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, traumaBGView.frame.size.height);
    
    bloodBGView=[self addSimpleBackView:CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,200) andColor:CLEARCOLOR];
    [pastBGView addSubview:bloodBGView];
    
    UIView *bloodWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [bloodBGView addSubview:bloodWhiteView];
    
    UILabel *label384=[self addLabel:CGRectMake(80,20,40,20) andText:@"输血" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [bloodBGView addSubview:label384];
    
    addBloodButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:0 andSEL:@selector(addBloodView) andText:@"+" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [addBloodButton.layer setCornerRadius:10];
    [bloodBGView addSubview:addBloodButton];
    
    UILabel *label3841=[self addLabel:CGRectMake(120,10,40,20) andText:@"原因" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [bloodBGView addSubview:label3841];
    
    UITextField *textField3841N=[self addTextfield:CGRectMake(165,label3841.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"输血原因" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3841N.tag=1032;
    textField3841N.delegate=self;
    [textField3841N addTarget:self action:@selector(bloodTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [bloodBGView addSubview:textField3841N];
    
    [self addLineLabel:CGRectMake(120,label3841.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:bloodBGView];
    
    UILabel *label3842=[self addLabel:CGRectMake(120,label3841.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [bloodBGView addSubview:label3842];
    
    UIButton *button3842N=[self addSimpleButton:CGRectMake(165, label3842.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:1033 andSEL:@selector(addDateChoiceView:) andText:@"请选择输血时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [bloodBGView addSubview:button3842N];
    
    
    [self addLineLabel:CGRectMake(0,label3842.frame.origin.y+29.5,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:bloodBGView];
    
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, bloodBGView.frame.origin.y, bloodBGView.frame.size.width, label3842.frame.origin.y+30);
    bloodWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, bloodBGView.frame.size.height);
    
    pastBGView.frame=CGRectMake(pastBGView.frame.origin.x, pastBGView.frame.origin.y,pastBGView.frame.size.width,bloodBGView.frame.origin.y+bloodBGView.frame.size.height);
    label38.frame=CGRectMake(10, (pastBGView.frame.size.height-20)/2,label38.frame.size.width, 20);
    
    [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
    [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
    [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
    
    downBGView=[self addSimpleBackView:CGRectMake(0, pastBGView.frame.origin.y+pastBGView.frame.size.height+0.5, SCREENWIDTH,200) andColor:CLEARCOLOR];
    [BGScrollView addSubview:downBGView];
    
    UILabel *label39=[self addLabel:CGRectMake(10,10,50,20) andText:@"家族史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [downBGView addSubview:label39];
    
    UIView *dWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [downBGView addSubview:dWhiteView];
    
    UILabel *label391=[self addLabel:CGRectMake(80,10,40,20) andText:@"父亲" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [downBGView addSubview:label391];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==148) {
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
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name]  andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label392=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"母亲" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [downBGView addSubview:label392];
    
    NSMutableArray *motherBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label392.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyM:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label393=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40, 0) andText:@"兄弟姐妹" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label393.numberOfLines=0;
    [label393 sizeToFit];
    label393.frame=CGRectMake(10, dWhiteView.frame.size.height+10, 40, label393.frame.size.height);
    [downBGView addSubview:label393];
    
    NSMutableArray *basBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label393.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyB:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    
    UILabel *label394=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"儿女" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [downBGView addSubview:label394];
    
    NSMutableArray *sadBtnArray=[NSMutableArray new];
    for (int i=0; i<familyFArray.count; i++) {
        AddArchiveItem *item=[familyFArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(130,label394.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFamilyD:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    downBGView.frame=CGRectMake(downBGView.frame.origin.x, downBGView.frame.origin.y,downBGView.frame.size.width,dWhiteView.frame.size.height);
    label39.frame=CGRectMake(10, (downBGView.frame.size.height-20)/2,label39.frame.size.width, 20);
    [self addLineLabel:CGRectMake(120,0,0.5, downBGView.frame.size.height) andColor:LINECOLOR andBackView:downBGView];
    
    UILabel *label40=[self addLabel:CGRectMake(10,dWhiteView.frame.size.height+10,60,20) andText:@"遗传病史" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [downBGView addSubview:label40];
    
    UIView *dWhiteView1=[self addSimpleBackView:CGRectMake(80,dWhiteView.frame.size.height+0.5, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [downBGView addSubview:dWhiteView1];
    
    NSArray *geneticArray=@[@"1.无",@"2.有"];
    NSMutableArray *geneticBtnArray=[NSMutableArray new];
    for (int i=0; i<geneticArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(90, label40.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceGenetic:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[geneticArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(90, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            
            dWhiteView1.frame=CGRectMake(dWhiteView1.frame.origin.x, dWhiteView1.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10- dWhiteView1.frame.origin.y);
        }
    }
    
    UILabel *label41=[self addLabel:CGRectMake(10,dWhiteView.frame.size.height+10,60,20) andText:@"残疾情况" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [downBGView addSubview:label41];
    
    for (AddArchiveItem *item in mainArray) {
        if (item.type==6) {
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
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(90, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(0, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            
            dWhiteView1.frame=CGRectMake(dWhiteView1.frame.origin.x, dWhiteView1.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10- dWhiteView1.frame.origin.y);
        }
    }
    
    UILabel *label42=[self addLabel:CGRectMake(10,dWhiteView.frame.size.height+10,50,20) andText:@"生活环境" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [downBGView addSubview:label42];
    
    UILabel *label421=[self addLabel:CGRectMake(80,label42.frame.origin.y,40,0) andText:@"厨房排风设施" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label421.numberOfLines=0;
    [label421 sizeToFit];
    label421.frame=CGRectMake(80, dWhiteView.frame.size.height+10, 40, label421.frame.size.height);
    [downBGView addSubview:label421];
    
    NSArray *kitchenArray=@[@"1.无",@"2.油烟机",@"3.换气扇",@"4.烟囱",];
    NSMutableArray *kitchenBtnArray=[NSMutableArray new];
    for (int i=0; i<kitchenArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(130,label421.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceKitchenType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[kitchenArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
                
                [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
                
                dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }else{
                label421.frame=CGRectMake(80,label421.frame.origin.y,40, label421.frame.size.height);
                [self addLineLabel:CGRectMake(80, label421.frame.origin.y+label421.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
                
                dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, label421.frame.origin.y+label421.frame.size.height+10);
            }
        }
    }
    
    UILabel *label422=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"燃料类型" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label422.numberOfLines=0;
    [label422 sizeToFit];
    label422.frame=CGRectMake(80, dWhiteView.frame.size.height+10, 40, label422.frame.size.height);
    [downBGView addSubview:label422];
    
    NSArray *fuelArray=@[@"1.液化气",@"2.煤",@"3.天然气",@"4.沼气",@"5.柴火",@"6.其他"];
    NSMutableArray *fuelBtnArray=[NSMutableArray new];
    for (int i=0; i<fuelArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(130,label422.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceFuelType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[fuelArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
                
                [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
                
                dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
            }else{
                label422.frame=CGRectMake(80,label422.frame.origin.y,40, label422.frame.size.height);
                [self addLineLabel:CGRectMake(80, label422.frame.origin.y+label422.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
                
                dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, label422.frame.origin.y+label422.frame.size.height+10);
            }
        }
    }
    
    UILabel *label423=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"饮水" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [downBGView addSubview:label423];
    
    NSArray *drinkingArray=@[@"1.自来水",@"2.经净化过滤的水",@"3.井水",@"4.河湖水",@"5.塘水",@"6.其他"];
    NSMutableArray *drinkingBtnArray=[NSMutableArray new];
    for (int i=0; i<drinkingArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(130,label423.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceDrinkeType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[drinkingArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label424=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"厕所" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [downBGView addSubview:label424];
    
    NSArray *toiletArray=@[@"1.卫生厕所",@"2.一格或二格粪池式",@"3.马桶",@"4.露天粪坑",@"5.简易棚厕"];
    NSMutableArray *toiletBtnArray=[NSMutableArray new];
    for (int i=0; i<toiletArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(130,label424.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceToiletType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[toiletArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            
            [self addLineLabel:CGRectMake(80, addressButton.frame.origin.y+addressButton.frame.size.height+10, SCREENWIDTH-80, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    
    UILabel *label425=[self addLabel:CGRectMake(80,dWhiteView.frame.size.height+10,40,20) andText:@"禽畜栏" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    label425.numberOfLines=0;
    [label425 sizeToFit];
    label425.frame=CGRectMake(80, dWhiteView.frame.size.height+10, 40, label422.frame.size.height);
    [downBGView addSubview:label425];
    
    NSArray *livestockArray=@[@"1.单设",@"2.室内",@"3.室外"];
    NSMutableArray *livestockBtnArray=[NSMutableArray new];
    for (int i=0; i<livestockArray.count; i++) {
        UIButton *addressButton=[self addButton:CGRectMake(130,label425.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(choiceLivestockType:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [downBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[livestockArray objectAtIndex:i] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(130, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
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
            [self addLineLabel:CGRectMake(0, label425.frame.origin.y+label425.frame.size.height+10, SCREENWIDTH-0, 0.5) andColor:LINECOLOR andBackView:downBGView];
            
            dWhiteView.frame=CGRectMake(dWhiteView.frame.origin.x, dWhiteView.frame.origin.y, SCREENWIDTH-120, label425.frame.origin.y+label425.frame.size.height+10);
        }
    }
    
    downBGView.frame=CGRectMake(downBGView.frame.origin.x, downBGView.frame.origin.y,downBGView.frame.size.width,dWhiteView.frame.size.height);
    label42.frame=CGRectMake(10, label42.frame.origin.y+(downBGView.frame.size.height-label42.frame.origin.y-30)/2,label42.frame.size.width, 20);
    [self addLineLabel:CGRectMake(80,0,0.5, downBGView.frame.size.height) andColor:LINECOLOR andBackView:downBGView];
    
    BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    
    [self addLineLabel:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    uploadButton=[self addCurrencyButton:CGRectMake(40,SCREENHEIGHT-45, SCREENWIDTH-80, 40) andText:@"提交" andSEL:@selector(sureUpload)];
    [self.view addSubview:uploadButton];
    
}

- (void)addDisease{
    diseaseCount+=1;
    UIView *subDiseaseBGView=[self addSimpleBackView:CGRectMake(0, diseaseBGView.frame.origin.y+diseaseBGView.frame.size.height, SCREENWIDTH, 200) andColor:CLEARCOLOR];
    subDiseaseBGView.tag=1001+diseaseCount*100;
    [diseaseBGView addSubview:subDiseaseBGView];
    
    UILabel *label381=[self addLabel:CGRectMake(80,50,40,20) andText:@"疾病" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subDiseaseBGView addSubview:label381];
    
    UIButton *delDiseaseButton=[self addSimpleButton:CGRectMake(90, 80, 20,20) andBColor:GREENCOLOR andTag:1001+diseaseCount*100 andSEL:@selector(delDiseaseView:) andText:@"-" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [delDiseaseButton.layer setCornerRadius:10];
    [subDiseaseBGView addSubview:delDiseaseButton];
    
    UIView *disWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [subDiseaseBGView addSubview:disWhiteView];
    
    UILabel *label3811=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subDiseaseBGView addSubview:label3811];
    
    NSMutableArray *diseaseBtnArray=[NSMutableArray new];
    for (int i=0; i<diseaseArray.count; i++) {
        AddArchiveItem *item=[diseaseArray objectAtIndex:i];
        UIButton *addressButton=[self addButton:CGRectMake(170, label3811.frame.origin.y-2.5, 0,25) adnColor:CLEARCOLOR andTag:1001+diseaseCount*100 andSEL:@selector(choiceDisease:)];
        addressButton.layer.borderColor=LINECOLOR.CGColor;
        addressButton.layer.borderWidth=0.5;
        [addressButton.layer setCornerRadius:12.5];
        [subDiseaseBGView addSubview:addressButton];
        
        UILabel *addressLabel=[self addLabel:CGRectMake(0,0, 60, 25) andText:[NSString stringWithFormat:@"%d.%@",i+1,item.Name] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [addressLabel sizeToFit];
        [addressButton addSubview:addressLabel];
        
        addressLabel.frame=CGRectMake(10, 0, addressLabel.frame.size.width, 25);
        addressButton.frame=CGRectMake(170, addressButton.frame.origin.y, addressLabel.frame.size.width+20, 25);
        
        if (i>0) {
            UIButton *lastBtn=[diseaseBtnArray objectAtIndex:i-1];
            addressButton.frame=CGRectMake(lastBtn.frame.origin.x+lastBtn.frame.size.width+10, lastBtn.frame.origin.y, addressButton.frame.size.width, 25);
            if (addressButton.frame.origin.x+addressButton.frame.size.width>SCREENWIDTH-5) {
                addressButton.frame=CGRectMake(170, lastBtn.frame.origin.y+35, addressButton.frame.size.width, 25);
            }
        }
        
        [diseaseBtnArray addObject:addressButton];
        if (i==diseaseArray.count-1) {
            label3811.frame=CGRectMake(120,label3811.frame.origin.y-10+(addressButton.frame.origin.y+35-(label3811.frame.origin.y-10)-20)/2,40, 20);
            
            [self addLineLabel:CGRectMake(120,addressButton.frame.origin.y+addressButton.frame.size.height+10,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:subDiseaseBGView];
            
            disWhiteView.frame=CGRectMake(disWhiteView.frame.origin.x, disWhiteView.frame.origin.y, SCREENWIDTH-110, addressButton.frame.origin.y+addressButton.frame.size.height+10);
        }
    }
    UILabel *label3812=[self addLabel:CGRectMake(120,disWhiteView.frame.size.height+10,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subDiseaseBGView addSubview:label3812];
    
    UIButton *button3812N=[self addSimpleButton:CGRectMake(165, label3812.frame.origin.y-5, SCREENWIDTH-165, 30) andBColor:CLEARCOLOR andTag:1002+diseaseCount*100 andSEL:@selector(addDateChoiceView:) andText:@"请选择患病时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subDiseaseBGView addSubview:button3812N];
    
    [self addLineLabel:CGRectMake(120,label3812.frame.origin.y+30,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:subDiseaseBGView];
    
    UILabel *label3813=[self addLabel:CGRectMake(120,label3812.frame.origin.y+40,40,20) andText:@"说明" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subDiseaseBGView addSubview:label3813];
    
    UITextField *textField3813N=[self addTextfield:CGRectMake(165, label3813.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"患病说明" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3813N.tag=1003+diseaseCount*100;
    textField3813N.delegate=self;
    [textField3813N addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subDiseaseBGView addSubview:textField3813N];
    
    [self addLineLabel:CGRectMake(80,label3813.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:subDiseaseBGView];
    
    label381.frame=CGRectMake(label381.frame.origin.x,(label3813.frame.origin.y+10)/2, label381.frame.size.width, label381.frame.size.height);
    delDiseaseButton.frame=CGRectMake(delDiseaseButton.frame.origin.x, label381.frame.origin.y+25,20,20);
    
    disWhiteView.frame=CGRectMake(disWhiteView.frame.origin.x, disWhiteView.frame.origin.y, SCREENWIDTH-110, label3813.frame.origin.y+label3813.frame.size.height+10);
    subDiseaseBGView.frame=CGRectMake(subDiseaseBGView.frame.origin.x, subDiseaseBGView.frame.origin.y, SCREENWIDTH, disWhiteView.frame.size.height);
    diseaseBGView.frame=CGRectMake(diseaseBGView.frame.origin.x, diseaseBGView.frame.origin.y, diseaseBGView.frame.size.width, subDiseaseBGView.frame.origin.y+subDiseaseBGView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, opsBGView.frame.origin.y+subDiseaseBGView.frame.size.height, opsBGView.frame.size.width, opsBGView.frame.size.height);
        traumaBGView.frame=CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
    
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
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
    [button.superview removeFromSuperview];
}

- (void)addOPSView{
    opsCount+=1;
    UIView *subOpsBGView=[self addSimpleBackView:CGRectMake(0,opsBGView.frame.size.height, SCREENWIDTH,200) andColor:CLEARCOLOR];
    subOpsBGView.tag=2000+opsCount;
    [opsBGView addSubview:subOpsBGView];
    
    UIView *opsWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [subOpsBGView addSubview:opsWhiteView];
    
    UILabel *label382=[self addLabel:CGRectMake(80,20,40,20) andText:@"手术" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label382];
    
    UIButton *delOpsButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:2000+opsCount andSEL:@selector(delOPS:) andText:@"-" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [delOpsButton.layer setCornerRadius:10];
    [subOpsBGView addSubview:delOpsButton];
    
    UILabel *label3821=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3821];
    
    UITextField *textField3821N=[self addTextfield:CGRectMake(165, label3821.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"手术名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3821N.tag=2000+opsCount;
    textField3821N.delegate=self;
    [textField3821N addTarget:self action:@selector(opsTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subOpsBGView addSubview:textField3821N];
    
    [self addLineLabel:CGRectMake(120,label3821.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    UILabel *label3822=[self addLabel:CGRectMake(120,label3821.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subOpsBGView addSubview:label3822];
    
    UIButton *button3822N=[self addSimpleButton:CGRectMake(165, label3822.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:2000+opsCount andSEL:@selector(addDateChoiceView:) andText:@"请选择手术时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subOpsBGView addSubview:button3822N];
    
    [self addLineLabel:CGRectMake(80,label3822.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:subOpsBGView];
    
    subOpsBGView.frame=CGRectMake(subOpsBGView.frame.origin.x, subOpsBGView.frame.origin.y, subOpsBGView.frame.size.width, label3822.frame.origin.y+30);
    opsWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, subOpsBGView.frame.size.height);
    opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, opsBGView.frame.origin.y, opsBGView.frame.size.width, opsBGView.frame.size.height+subOpsBGView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        traumaBGView.frame=CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
}

- (void)delOPS:(UIButton*)button{
    opsCount-=1;
    for (NSMutableDictionary *dic in self.opsArray) {
        if ([[dic objectForKey:@"index"]integerValue]==button.tag) {
            [self.opsArray removeObject:dic];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in [button.superview.superview subviews]) {
            if (subView.frame.origin.y>=button.superview.frame.origin.y+button.superview.frame.size.height) {
                subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height, subView.frame.size.width,subView.frame.size.height);
            }
        }
        opsBGView.frame=CGRectMake(opsBGView.frame.origin.x, opsBGView.frame.origin.y, opsBGView.frame.size.width, opsBGView.frame.size.height-button.superview.frame.size.height);
        traumaBGView.frame=CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,traumaBGView.frame.size.height);
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
    [button.superview removeFromSuperview];
}

- (void)addTraumaView{
    traumaCount+=1;
    UIView *subTraumaView=[self addSimpleBackView:CGRectMake(0,traumaBGView.frame.size.height, SCREENWIDTH,200) andColor:CLEARCOLOR];
    subTraumaView.tag=3000+traumaCount;
    [traumaBGView addSubview:subTraumaView];
    
    UIView *traumaWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [subTraumaView addSubview:traumaWhiteView];
    
    UILabel *label383=[self addLabel:CGRectMake(80,20,40,20) andText:@"外伤" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subTraumaView addSubview:label383];
    
    UIButton *delTraumaButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:3000+traumaCount andSEL:@selector(delTraumaView:) andText:@"-" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [delTraumaButton.layer setCornerRadius:10];
    [subTraumaView addSubview:delTraumaButton];
    
    UILabel *label3831=[self addLabel:CGRectMake(120,10,40,20) andText:@"名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subTraumaView addSubview:label3831];
    
    UITextField *textField3831N=[self addTextfield:CGRectMake(165, label3831.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"外伤名称" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3831N.tag=3000+traumaCount;
    textField3831N.delegate=self;
    [textField3831N addTarget:self action:@selector(traumaTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subTraumaView addSubview:textField3831N];
    
    [self addLineLabel:CGRectMake(120,label3831.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:subTraumaView];
    
    UILabel *label3832=[self addLabel:CGRectMake(120,label3831.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subTraumaView addSubview:label3832];
    
    UIButton *button3832N=[self addSimpleButton:CGRectMake(165, label3832.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:3000+traumaCount andSEL:@selector(addDateChoiceView:) andText:@"请选择外伤时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subTraumaView addSubview:button3832N];
    
    [self addLineLabel:CGRectMake(80,label3832.frame.origin.y+29.5,SCREENWIDTH-80,0.5) andColor:LINECOLOR andBackView:subTraumaView];
    
    subTraumaView.frame=CGRectMake(subTraumaView.frame.origin.x, subTraumaView.frame.origin.y, subTraumaView.frame.size.width, label3832.frame.origin.y+30);
    traumaWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, subTraumaView.frame.size.height);
    traumaBGView.frame=CGRectMake(traumaBGView.frame.origin.x, traumaBGView.frame.origin.y, traumaBGView.frame.size.width, traumaBGView.frame.size.height+subTraumaView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
}

- (void)delTraumaView:(UIButton*)button{
    traumaCount-=1;
    for (NSMutableDictionary *dic in self.traumaArray) {
        if ([[dic objectForKey:@"index"]integerValue]==button.tag) {
            [self.traumaArray removeObject:dic];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in [button.superview.superview subviews]) {
            if (subView.frame.origin.y>=button.superview.frame.origin.y+button.superview.frame.size.height) {
                subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height, subView.frame.size.width,subView.frame.size.height);
            }
        }
        traumaBGView.frame=CGRectMake(0,opsBGView.frame.origin.y+opsBGView.frame.size.height,SCREENWIDTH,traumaBGView.frame.size.height-button.superview.frame.size.height);
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height);
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
    [button.superview removeFromSuperview];
}

- (void)addBloodView{
    bloodCount+=1;
    UIView *subBloodView=[self addSimpleBackView:CGRectMake(0,bloodBGView.frame.size.height, SCREENWIDTH,200) andColor:CLEARCOLOR];
    subBloodView.tag=4000+bloodCount;
    [bloodBGView addSubview:subBloodView];
    
    UIView *bloodWhiteView=[self addSimpleBackView:CGRectMake(120, 0, SCREENWIDTH-120, 200) andColor:MAINWHITECOLOR];
    [subBloodView addSubview:bloodWhiteView];
    
    UILabel *label384=[self addLabel:CGRectMake(80,20,40,20) andText:@"输血" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subBloodView addSubview:label384];
    
    UIButton *delBloodButton=[self addSimpleButton:CGRectMake(90,45,20,20) andBColor:GREENCOLOR andTag:4000+bloodCount andSEL:@selector(delBloodView:) andText:@"-" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [delBloodButton.layer setCornerRadius:10];
    [subBloodView addSubview:delBloodButton];
    
    UILabel *label3841=[self addLabel:CGRectMake(120,10,40,20) andText:@"原因" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subBloodView addSubview:label3841];
    
    UITextField *textField3841N=[self addTextfield:CGRectMake(165,label3841.frame.origin.y-5, SCREENWIDTH-175,30) andPlaceholder:@"输血原因" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    textField3841N.tag=4000+bloodCount;
    textField3841N.delegate=self;
    [textField3841N addTarget:self action:@selector(bloodTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [subBloodView addSubview:textField3841N];
    
    [self addLineLabel:CGRectMake(120,label3841.frame.origin.y+29.5,SCREENWIDTH-120,0.5) andColor:LINECOLOR andBackView:subBloodView];
    
    UILabel *label3842=[self addLabel:CGRectMake(120,label3841.frame.origin.y+40,40,20) andText:@"时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [subBloodView addSubview:label3842];
    
    UIButton *button3842N=[self addSimpleButton:CGRectMake(165, label3842.frame.origin.y-5, SCREENWIDTH-175, 30) andBColor:CLEARCOLOR andTag:4000+bloodCount andSEL:@selector(addDateChoiceView:) andText:@"请选择输血时间" andFont:MIDDLEFONT andColor:TEXTCOLORSDG andAlignment:0];
    [subBloodView addSubview:button3842N];
    
    [self addLineLabel:CGRectMake(0,label3842.frame.origin.y+29.5,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:subBloodView];
    
    subBloodView.frame=CGRectMake(subBloodView.frame.origin.x, subBloodView.frame.origin.y, subBloodView.frame.size.width, label3842.frame.origin.y+30);
    bloodWhiteView.frame=CGRectMake(120, 0, SCREENWIDTH-120, subBloodView.frame.size.height);
    bloodBGView.frame=CGRectMake(bloodBGView.frame.origin.x, bloodBGView.frame.origin.y, bloodBGView.frame.size.width, bloodBGView.frame.size.height+subBloodView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
}

- (void)delBloodView:(UIButton*)button{
    bloodCount-=1;
    for (NSMutableDictionary *dic in self.bloodArray) {
        if ([[dic objectForKey:@"index"]integerValue]==button.tag) {
            [self.bloodArray removeObject:dic];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subView in [button.superview.superview subviews]) {
            if (subView.frame.origin.y>=button.superview.frame.origin.y+button.superview.frame.size.height) {
                subView.frame=CGRectMake(subView.frame.origin.x, subView.frame.origin.y-button.superview.frame.size.height, subView.frame.size.width,subView.frame.size.height);
            }
        }
        bloodBGView.frame=CGRectMake(0,traumaBGView.frame.origin.y+traumaBGView.frame.size.height,SCREENWIDTH,bloodBGView.frame.size.height-button.superview.frame.size.height);
        
        pastBGView.frame=CGRectMake(pastBGView.frame.origin.x,pastBGView.frame.origin.y, pastBGView.frame.size.width, bloodBGView.frame.size.height+bloodBGView.frame.origin.y);
        [self addLineLabel:CGRectMake(160, 0, 0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(120,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        [self addLineLabel:CGRectMake(80,0,0.5, pastBGView.frame.size.height) andColor:LINECOLOR andBackView:pastBGView];
        downBGView.frame=CGRectMake(downBGView.frame.origin.x, pastBGView.frame.origin.y+pastBGView.frame.size.height, downBGView.frame.size.width, downBGView.frame.size.height);
        BGScrollView.contentSize=CGSizeMake(0, downBGView.frame.origin.y+downBGView.frame.size.height+40);
    }];
    [button.superview removeFromSuperview];
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
        }else if (!self.farmOrTown) {
            [self showSimplePromptBox:self andMesage:@"请选择人口类型！"];
        }else if (isCheckIDCard==NO){
            [self showSimplePromptBox:self andMesage:@"请先确定该身份证号未进行过建档操作（身份证重复检测）"];
        }else{
            /*Name	会员姓名
             FileNo	编号
             PaperFileNo	纸质档案编号
             ResidenceAddress	户籍住址
             TEL	电话号码
             DistrictNumber	所属行政区划编号
             Township	乡镇（街道）名称
             Village	村（居）委会名称
             BuildUnit	建档单位
             BuildPerson	建档人
             Doctor	责任医生
             BuildDate	建档日期
             BarCode	条行码
             HouseMaster	户主
             CupboardNo	柜号
             BoxNo	盒号
             LId	主键
             LAiderName	责任健教专干
             LAiderCode	责任健教专干Code
             */
            //            健康档案表
            UITextField *memberName=(UITextField*)[self.view viewWithTag:1001];
            UITextField *pageFileNo=(UITextField*)[self.view viewWithTag:1003];
            UITextField *residenceAddress=(UITextField*)[self.view viewWithTag:1009];
            UITextField *Doctor=(UITextField*)[self.view viewWithTag:1017];
            UITextField *BarCode=(UITextField*)[self.view viewWithTag:1019];
            UITextField *HouseMaster=(UITextField*)[self.view viewWithTag:1020];
            UITextField *CupboardNo=(UITextField*)[self.view viewWithTag:1021];
            UITextField *BoxNo=(UITextField*)[self.view viewWithTag:1022];
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            archiveArray=@[tureName,@"",pageFileNo.text,residenceAddress.text,selfPhone,self.NCItem.ID,self.NCItem.ParentName,self.NCItem.Name,[usd objectForKey:@"orgname"],[usd objectForKey:@"truename"],Doctor.text,writeTimeLabel.text,BarCode.text,HouseMaster.text,CupboardNo.text,BoxNo.text,[usd objectForKey:@"truename"],EMPKEY,[NSString stringWithFormat:@"%@",self.choiceHouseholdItem.AreaID],[NSString stringWithFormat:@"%@",self.choiceHouseholdItem.UnitID],self.choiceHouseholdItem.CellID,addressNow,[NSString stringWithFormat:@"%ld",(long)self.NCItem.OrgID],[usd objectForKey:@"gwuser"]];
            
            //            基本信息表
            UITextField *WorkUnit=(UITextField*)[self.view viewWithTag:1023];
            UITextField *Linkman=(UITextField*)[self.view viewWithTag:1024];
            UITextField *LinkmanTEL=(UITextField*)[self.view viewWithTag:1025];
            UIButton *folkButton=(UIButton*)[self.view viewWithTag:1007];
            UILabel *folkLabel=[[folkButton subviews] firstObject];
            NSString *folkString=@"";
            if (![folkLabel.text isEqualToString:@"请选择民族"]) {
                folkString=folkLabel.text;
            }
            NSString *farmStatus=nil;
            NSString *townStatus=nil;
            if ([self.farmOrTown isEqualToString:@"农业人口"]) {
                farmStatus=@"是";
                townStatus=@"否";
            }else{
                farmStatus=@"否";
                townStatus=@"是";
            }
            basicInfoArray=@[@"",sexLabel.text,birthdayLabel.text,IDNumber.text,WorkUnit.text,selfPhone,Linkman.text,LinkmanTEL.text,self.liveType,folkString,self.bloodType,self.RH,self.education,self.job,self.marital,farmStatus,townStatus,self.maternal,self.kitchen,self.fuel,self.drinking,self.toilet,self.livestock,self.genetic];
            
            [self sendRequest:@"GenerateFileNO" andPath:queryURL andSqlParameter:self.NCItem.ID and:self];
        }
        
    }
}

- (void)checkIDNumber{
    UITextField *IDNumber=(UITextField*)[self.view viewWithTag:1008];
    if (![self checkIDcard:IDNumber.text]){
        [self showSimplePromptBox:self andMesage:@"身份证号码输入有误！"];
    }else{
        [self sendRequest:@"SearchIDNumber" andPath:queryURL andSqlParameter:IDNumber.text and:self];
    }
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
    if (1100<lastTimeButton.superview.tag&&lastTimeButton.tag<2000) {
        if (self.diseaseArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.diseaseArray) {
                if([[dic objectForKey:@"index"] integerValue]==lastTimeButton.superview.tag){
                    [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                label.text=@"请选择患病时间";
                label.textColor=TEXTCOLORSDG;
                [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
            }
        }else{
            label.text=@"请选择患病时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先选择患病名称！"];
        }
    }else if (lastTimeButton.tag==1026){
        if (self.diseaseArray.count>0) {
            NSMutableDictionary *dic=[self.diseaseArray objectAtIndex:0];
            if(dic&&[[dic objectForKey:@"index"] integerValue]<1100){
                [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
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
    }else if (lastTimeButton.tag>2000&&lastTimeButton.tag<3000){
        if (self.opsArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.opsArray) {
                if([[dic objectForKey:@"index"] integerValue]==lastTimeButton.superview.tag){
                    [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                label.text=@"请选择手术时间";
                label.textColor=TEXTCOLORSDG;
                [self showSimplePromptBox:self andMesage:@"请先填写手术名称！"];
            }
        }else{
            label.text=@"请选择手术时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写手术名称！"];
        }
        NSLog(@"============%@",self.opsArray);
    }else if (lastTimeButton.tag==1029){
        NSMutableDictionary *dic=[self.opsArray objectAtIndex:0];
        if(dic&&[[dic objectForKey:@"index"] integerValue]<2000){
            [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
        }else{
            label.text=@"请选择手术时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写手术名称！"];
        }
        NSLog(@"============%@",self.opsArray);
    }else if (lastTimeButton.tag>3000&&lastTimeButton.tag<4000){
        if (self.traumaArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.traumaArray) {
                if([[dic objectForKey:@"index"] integerValue]==lastTimeButton.superview.tag){
                    [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                label.text=@"请选择外伤时间";
                label.textColor=TEXTCOLORSDG;
                [self showSimplePromptBox:self andMesage:@"请先填写外伤名称！"];
            }
        }else{
            label.text=@"请选择外伤时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写外伤名称！"];
        }
        NSLog(@"============%@",self.traumaArray);
    }else if (lastTimeButton.tag==1031){
        NSMutableDictionary *dic=[self.traumaArray objectAtIndex:0];
        if(dic&&[[dic objectForKey:@"index"] integerValue]<2000){
            [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
        }else{
            label.text=@"请选择外伤时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写外伤名称！"];
        }
        NSLog(@"============%@",self.traumaArray);
    }else if (lastTimeButton.tag>4000){
        if (self.bloodArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.bloodArray) {
                if([[dic objectForKey:@"index"] integerValue]==lastTimeButton.superview.tag){
                    [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                label.text=@"请选择输血时间";
                label.textColor=TEXTCOLORSDG;
                [self showSimplePromptBox:self andMesage:@"请先填写输血原因！"];
            }
        }else{
            label.text=@"请选择输血时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写输血原因！"];
        }
        NSLog(@"============%@",self.bloodArray);
    }else if (lastTimeButton.tag==1033){
        NSMutableDictionary *dic=[self.bloodArray objectAtIndex:0];
        if(dic&&[[dic objectForKey:@"index"] integerValue]<2000){
            [dic setObject:[s1 stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"time"];
        }else{
            label.text=@"请选择输血时间";
            label.textColor=TEXTCOLORSDG;
            [self showSimplePromptBox:self andMesage:@"请先填写输血原因！"];
        }
        NSLog(@"============%@",self.bloodArray);
    }
}

- (void)cancelChoiceDate{
    
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

- (void)sureChoiceMenu:(NSString *)menuString{
    UILabel *sexLabel=[[lastMenuButton subviews]lastObject];
    sexLabel.textColor=TEXTCOLOR;
    sexLabel.text=menuString;
}

- (void)cancelChoiceMenu{
    
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

#pragma mark 选择常住类型
- (void)choiceLiveType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.liveType=[self getChoiceString:label.text];
    }
    if (lastLiveTypeButton!=button) {
        lastLiveTypeButton.selected=NO;
        lastLiveTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastLiveTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.liveType=@"";
    }
    lastLiveTypeButton=button;
    NSLog(@"===========%@",self.liveType);
}

#pragma mark 选择血型
- (void)choiceBloodType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.bloodType=[self getChoiceString:label.text];
    }
    if (lastBloodTypeButton!=button) {
        lastBloodTypeButton.selected=NO;
        lastBloodTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastBloodTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.bloodType=@"";
    }
    lastBloodTypeButton=button;
    NSLog(@"===========%@",self.bloodType);
}

#pragma mark 选择RH
- (void)choiceRHType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.RH=[self getChoiceString:label.text];
    }
    if (lastRHButton!=button) {
        lastRHButton.selected=NO;
        lastRHButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastRHButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.RH=@"";
    }
    lastRHButton=button;
    NSLog(@"===========%@",self.RH);
}

#pragma mark 选择文化程度
- (void)choiceEducationType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.education=[self getChoiceString:label.text];
    }
    if (lastEducationTypeButton!=button) {
        lastEducationTypeButton.selected=NO;
        lastEducationTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastEducationTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.education=@"";
    }
    lastEducationTypeButton=button;
    NSLog(@"===========%@",self.education);
}

#pragma mark 选择职业
- (void)choiceJobType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.job=[self getChoiceString:label.text];
    }
    if (lastJobTypeButton!=button) {
        lastJobTypeButton.selected=NO;
        lastJobTypeButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastJobTypeButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.job=@"";
    }
    lastJobTypeButton=button;
    NSLog(@"===========%@",self.job);
}

#pragma mark 选择婚姻状况
- (void)choiceMaritalType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.marital=[self getChoiceString:label.text];
    }
    if (lastMaritalButton!=button) {
        lastMaritalButton.selected=NO;
        lastMaritalButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastMaritalButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.marital=@"";
    }
    lastMaritalButton=button;
    NSLog(@"===========%@",self.marital);
}

#pragma mark 选择人口类型
- (void)choiceFarmOrTown:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.farmOrTown=[self getChoiceString:label.text];
    }
    if (lastFarmOrTownButton!=button) {
        lastFarmOrTownButton.selected=NO;
        lastFarmOrTownButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastFarmOrTownButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.farmOrTown=@"";
    }
    lastFarmOrTownButton=button;
    NSLog(@"===========%@",self.farmOrTown);
}

#pragma mark 选择是否孕产妇
- (void)choiceMaternal:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.maternal=[self getChoiceString:label.text];
    }
    if (lastMaternalButton!=button) {
        lastMaternalButton.selected=NO;
        lastMaternalButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastMaternalButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.maternal=@"";
    }
    lastMaternalButton=button;
    NSLog(@"===========%@",self.maternal);
}



#pragma mark 选择是否有遗传病史
- (void)choiceGenetic:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.genetic=[self getChoiceString:label.text];
    }
    if (lastGeneticButton!=button) {
        lastGeneticButton.selected=NO;
        lastGeneticButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastGeneticButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.genetic=@"";
    }
    lastGeneticButton=button;
    NSLog(@"===========%@",self.genetic);
}

#pragma mark 选择厨房拍风设施
- (void)choiceKitchenType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.kitchen=[self getChoiceString:label.text];
    }
    if (lastKitchenButton!=button) {
        lastKitchenButton.selected=NO;
        lastKitchenButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastKitchenButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.kitchen=@"";
    }
    lastKitchenButton=button;
    NSLog(@"===========%@",self.kitchen);
}

#pragma mark 选择燃料类型
- (void)choiceFuelType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.fuel=[self getChoiceString:label.text];
    }
    if (lastFuelButton!=button) {
        lastFuelButton.selected=NO;
        lastFuelButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastFuelButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.fuel=@"";
    }
    lastFuelButton=button;
    NSLog(@"===========%@",self.fuel);
}

#pragma mark 选择饮水方式类型
- (void)choiceDrinkeType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.drinking=[self getChoiceString:label.text];
    }
    if (lastDrinkingButton!=button) {
        lastDrinkingButton.selected=NO;
        lastDrinkingButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastDrinkingButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.drinking=@"";
    }
    lastDrinkingButton=button;
    NSLog(@"===========%@",self.drinking);
}

#pragma mark 选择厕所类型
- (void)choiceToiletType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.toilet=[self getChoiceString:label.text];
    }
    if (lastToiletButton!=button) {
        lastToiletButton.selected=NO;
        lastToiletButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastToiletButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.toilet=@"";
    }
    lastToiletButton=button;
    NSLog(@"===========%@",self.toilet);
}

#pragma mark 选择禽畜栏类型
- (void)choiceLivestockType:(UIButton*)button{
    UILabel *label=[[button subviews] lastObject];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        
        self.livestock=[self getChoiceString:label.text];
    }
    if (lastLivestockButton!=button) {
        lastLivestockButton.selected=NO;
        lastLivestockButton.backgroundColor=CLEARCOLOR;
        UILabel *lastLabel=[[lastLivestockButton subviews] lastObject];
        lastLabel.textColor=TEXTCOLOR;
    }else{
        self.livestock=@"";
    }
    lastLivestockButton=button;
    NSLog(@"===========%@",self.livestock);
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
        for (AddArchiveItem *sItem in self.paymentArray) {
            if (sItem.ID==item.ID) {
                [self.paymentArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.paymentArray addObject:item];
    }
    NSLog(@"===========%@",self.paymentArray);
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
        for (AddArchiveItem *sItem in self.allergicArray) {
            if (sItem.ID==item.ID) {
                [self.allergicArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.allergicArray addObject:item];
    }
    NSLog(@"===========%@",self.allergicArray);
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
        for (AddArchiveItem *sItem in self.exposeArray) {
            if (sItem.ID==item.ID) {
                [self.exposeArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.exposeArray addObject:item];
    }
    NSLog(@"===========%@",self.exposeArray);
}

#pragma mark 选择父亲家族史
- (void)choiceFamilyF:(UIButton*)button{
    if (!self.familyFArray) {
        self.familyFArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (AddArchiveItem *sItem in self.familyFArray) {
            if (sItem.ID==item.ID) {
                [self.familyFArray removeObject:sItem];
                break;
            }
        }
        
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.familyFArray addObject:item];
    }
    NSLog(@"===========%@",self.familyFArray);
}

#pragma mark 选择母亲家族史
- (void)choiceFamilyM:(UIButton*)button{
    if (!self.familyMArray) {
        self.familyMArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[familyFArray objectAtIndex:button.tag-101];
    if (button.selected==YES){
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (AddArchiveItem *sItem in self.familyMArray) {
            if (sItem.ID==item.ID) {
                [self.familyMArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.familyMArray addObject:item];
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
        [self.familyBArray removeObject:[self getChoiceString:label.text]];
        for (AddArchiveItem *sItem in self.familyBArray) {
            if (sItem.ID==item.ID) {
                [self.familyBArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.familyBArray addObject:item];
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
        for (AddArchiveItem *sItem in self.familyDArray) {
            if (sItem.ID==item.ID) {
                [self.familyDArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.familyDArray addObject:item];
    }
    NSLog(@"===========%@",self.familyDArray);
}

#pragma mark 选择残疾情况
- (void)choiceDisability:(UIButton*)button{
    if (!self.disabilityArray) {
        self.disabilityArray=[NSMutableArray new];
    }
    UILabel *label=[[button subviews] lastObject];
    AddArchiveItem *item=[disabilityArray objectAtIndex:button.tag-101];
    if (button.selected==YES) {
        button.backgroundColor=CLEARCOLOR;
        label.textColor=TEXTCOLOR;
        button.selected=NO;
        for (AddArchiveItem *sItem in self.disabilityArray) {
            if (sItem.ID==item.ID) {
                [self.disabilityArray removeObject:sItem];
                break;
            }
        }
    }else{
        button.backgroundColor=GREENCOLOR;
        label.textColor=MAINWHITECOLOR;
        button.selected=YES;
        [self.disabilityArray addObject:item];
    }
    NSLog(@"===========%@",self.disabilityArray);
}

#pragma mark 获取选择的字段
- (NSString*)getChoiceString:(NSString*)choiceString{
    choiceString=[choiceString substringFromIndex:[choiceString rangeOfString:@"."].location+[choiceString rangeOfString:@"."].length];
    return choiceString;
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
    if(!self.opsArray){
        self.opsArray=[NSMutableArray new];
    }
    if (textField.superview.tag>2000) {
        if (self.opsArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.opsArray) {
                if([[dic objectForKey:@"index"] integerValue]==textField.tag){
                    [dic setObject:textField.text forKey:@"name"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.opsArray addObject:dic];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.opsArray addObject:dic];
        }
    }else{
        if (self.opsArray.count>0) {
            NSMutableDictionary *dic=[self.opsArray objectAtIndex:0];
            if(dic&&[[dic objectForKey:@"index"] integerValue]<2000){
                [dic setObject:textField.text forKey:@"name"];
            }else{
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.opsArray insertObject:dic atIndex:0];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.opsArray insertObject:dic atIndex:0];
        }
    }
    NSLog(@"============%@",self.opsArray);
    
}


- (void)traumaTextFieldEditChanged:(UITextField *)textField

{
    if(!self.traumaArray){
        self.traumaArray=[NSMutableArray new];
    }
    if (textField.superview.tag>3000) {
        if (self.traumaArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.traumaArray) {
                if([[dic objectForKey:@"index"] integerValue]==textField.tag){
                    [dic setObject:textField.text forKey:@"name"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.traumaArray addObject:dic];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.traumaArray addObject:dic];
        }
    }else{
        if (self.traumaArray.count>0) {
            NSMutableDictionary *dic=[self.traumaArray objectAtIndex:0];
            if(dic&&[[dic objectForKey:@"index"] integerValue]<3000){
                [dic setObject:textField.text forKey:@"name"];
            }else{
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.traumaArray insertObject:dic atIndex:0];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.traumaArray insertObject:dic atIndex:0];
        }
    }
    NSLog(@"============%@",self.traumaArray);
    
}

- (void)bloodTextFieldEditChanged:(UITextField *)textField

{
    if(!self.bloodArray){
        self.bloodArray=[NSMutableArray new];
    }
    if (textField.superview.tag>4000) {
        if (self.bloodArray.count>0) {
            BOOL isHave=NO;
            for (NSMutableDictionary *dic in self.bloodArray) {
                if([[dic objectForKey:@"index"] integerValue]==textField.tag){
                    [dic setObject:textField.text forKey:@"name"];
                    isHave=YES;
                }
            }
            if (isHave==NO) {
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.bloodArray addObject:dic];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.bloodArray addObject:dic];
        }
    }else{
        if (self.bloodArray.count>0) {
            NSMutableDictionary *dic=[self.bloodArray objectAtIndex:0];
            if(dic&&[[dic objectForKey:@"index"] integerValue]<4000){
                [dic setObject:textField.text forKey:@"name"];
            }else{
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:textField.text forKey:@"name"];
                [dic setObject:@"" forKey:@"time"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
                [self.bloodArray insertObject:dic atIndex:0];
            }
        }else{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:textField.text forKey:@"name"];
            [dic setObject:@"" forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)textField.tag] forKey:@"index"];
            [self.bloodArray insertObject:dic atIndex:0];
        }
    }
    NSLog(@"============%@",self.bloodArray);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1008) {
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1008) {
        if (textField.text.length==15||textField.text.length==18) {
            if ([self checkIDcard:textField.text]) {
                UIButton *birthdayButton=(UIButton*)[self.view viewWithTag:1006];
                UILabel *birthdayLabel=[[birthdayButton subviews]lastObject];
                birthdayLabel.textColor=TEXTCOLOR;
                birthdayLabel.text=[self birthdayStrFromIdentityCard:textField.text];
                [self sendRequest:@"SearchIDNumber" andPath:queryURL andSqlParameter:textField.text and:self];
            }else{
                [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"身份证号码有误！"];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITextField *textField=(UITextField*)[self.view viewWithTag:1025];
    if (scrollView.contentOffset.y>textField.frame.origin.y) {
        [self.view endEditing:YES];
    }
}

- (void)IDCardTextFieldEditChanged:(UITextField*)textField{
    isCheckIDCard=NO;
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    BGScrollView.frame=CGRectMake(0,144,SCREENWIDTH,SCREENHEIGHT-size.height-144);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    BGScrollView.frame=CGRectMake(0,144,SCREENWIDTH,SCREENHEIGHT-194);
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
