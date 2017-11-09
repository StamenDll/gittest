//
//  ChoiceDepViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoiceDepViewController.h"
#import "FDDoctorItem.h"
#import "OrgDoctorItem.h"
#import "SAMemberInfoViewController.h"
#import "MyUserViewController.h"
#import "CustomProgressView.h"
#import "AppDelegate.h"
@interface ChoiceDepViewController ()

@end

@implementation ChoiceDepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择挂号医生"];
    [self addLeftButtonItem];
    subDataArray=[NSMutableArray new];
    allDataArray=[NSMutableArray new];
    choiceArray=[NSMutableArray new];
    sureArray=[NSMutableArray new];
    newsDicArray=[NSMutableArray new];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSLog(@"=========%@=========%d============%@",appDelegate.MQTT_HOST,appDelegate.MQTT_PORT,appDelegate.MQTT_HOST_ID);
    if ([self.whopush isEqualToString:@"FD"]) {
        [self sendRequest:@"FDDoctor" andPath:queryURL andSqlParameter:self.fdItem.sID and:self];
    }else{
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        [self sendRequest:DEPDOCLISTTYPE andPath:DEPDOCLISTURL andSqlParameter:@{@"orgid":[usd objectForKey:@"workorgkey"]} and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"FDDoctor"]) {
            for (NSDictionary *dic in message) {
                FDDoctorItem *item=[RMMapper objectWithClass:[FDDoctorItem class] fromDictionary:dic];
                [allDataArray addObject:item];
                NSLog(@"=============%@",item.UserID);
            }
            for (int i=0;i<allDataArray.count;i++) {
                FDDoctorItem *item=[allDataArray objectAtIndex:i];
                if (i==0) {
                    [subDataArray addObject:item];
                }else{
                    BOOL isHave=NO;
                    for (FDDoctorItem *newItem in subDataArray) {
                        if (item.DepartmentID==newItem.DepartmentID) {
                            isHave=YES;
                        }
                    }
                    if (isHave==NO) {
                        [subDataArray addObject:item];
                    }
                }
            }
            [self creatUI];
        }
        else if ([type isEqualToString:DEPDOCLISTTYPE]){
            for (NSDictionary *dic in message) {
                OrgDoctorItem *item=[RMMapper objectWithClass:[OrgDoctorItem class] fromDictionary:dic];
                [allDataArray addObject:item];
            }
            for (int i=0;i<allDataArray.count;i++) {
                OrgDoctorItem *item=[allDataArray objectAtIndex:i];
                if (i==0) {
                    [subDataArray addObject:item];
                }else{
                    BOOL isHave=NO;
                    for (OrgDoctorItem *newItem in subDataArray) {
                        if (item.workdepartment==newItem.workdepartment) {
                            isHave=YES;
                        }
                    }
                    if (isHave==NO) {
                        [subDataArray addObject:item];
                    }
                }
            }
            [self creatUI];
        }
        else if ([type isEqualToString:@"AddFDOrderUser"]){
            uploadButton.selected=NO;
            if (!client) {
                NSString *clientId =  [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
                client = [[MQTTClient alloc] initWithClientId:clientId];
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                client.host = appDelegate.MQTT_HOST;
                client.port = appDelegate.MQTT_PORT;
                
                dispatch_semaphore_t subscribed = dispatch_semaphore_create(0);
                [client connectWithCompletionHandler:^(NSUInteger code) {
                    [client subscribe:CHATCODE
                              withQos:AtMostOnce
                    completionHandler:^(NSArray *grantedQos) {
                        for (NSNumber *qos in grantedQos) {
                            NSLog(@"wwww--%@", qos);
                        }
                        dispatch_semaphore_signal(subscribed);
                    }];
                }];
            }
            
            NSDictionary *contentDic=nil;
            if ([self.whopush isEqualToString:@"FD"]) {
                contentDic=@{@"action" :@"yizhen",@"orgid":[NSString stringWithFormat:@"%d",[self.fdDocItem.DepartmentID intValue]],@"data":newsDicArray};

            }else{
                contentDic=@{@"action" :@"daozhen",@"orgid":[NSString stringWithFormat:@"%d",[self.orgDocItem.workdepartment intValue]],@"data":newsDicArray};
            }
            NSData *contentJson = [NSJSONSerialization dataWithJSONObject:contentDic options:0 error:NULL];
            NSString *content =  [[NSString alloc] initWithData:contentJson encoding:NSUTF8StringEncoding];
            
            NSLog(@"=================+%@",content);
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [client publishString:content
                          toTopic:appDelegate.MQTT_HOST_ID
                          withQos:AtMostOnce
                           retain:NO
                completionHandler:^(int mid) {
                    NSLog(@"wwww--%d", mid);
                }];
            
            dispatch_semaphore_t received = dispatch_semaphore_create(0);
            [client setMessageHandler:^(MQTTMessage *message) {
                dispatch_semaphore_signal(received);
            }];
            
            if (self.phoneString.length>0) {
                [self sendRequest:@"SignState" andPath:queryURL andSqlParameter:self.onlycodeString and:self];
            }else{
                [self showSusccessMesage];
            }
        }else if ([type isEqualToString:@"SignState"]){
            NSArray *dataArray=message;
            if (dataArray.count==0) {
                isSign=NO;
            }else{
                NSDictionary *dic=[dataArray objectAtIndex:0];
                NSString *LState=[dic objectForKey:@"LState"];
                if ([LState rangeOfString:@"取消"].location!=NSNotFound) {
                    isSign=NO;
                }else{
                    isSign=YES;
                }
            }
            [self showSusccessMesage];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    uploadButton.selected=NO;
}


- (void)showSusccessMesage{
    NSString *message=@"义诊活动预约成功！";
    if (![self.whopush isEqualToString:@"FD"]) {
        message=@"挂号预约已成功！";
    }
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:av animated:YES completion:nil];
    [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    if (self.phoneString.length==0) {
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
        }    }else{
        if (isSign==NO) {
            [self showMesage];
        }else{
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
    }
}

- (void)showMesage{
    UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"该居民还没有签约任何家庭医生团队，是否现在帮他签约？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        SAMemberInfoViewController *cvc=[SAMemberInfoViewController new];
        cvc.nameString=self.nameString;
        cvc.IDCardString=self.IDCardString;
        cvc.sexString=self.sexString;
        cvc.addressString=self.addressString;
        cvc.birString=self.birString;
        cvc.nationString=self.nationString;
        cvc.onlycodeString=self.onlycodeString;
        cvc.phoneString=self.phoneString;
        cvc.userItem=self.userItem;
        cvc.whoPush=@"FD";
        cvc.isMU=self.isMU;
        [self.navigationController pushViewController:cvc animated:YES];
    }];
    [av addAction:sureAC];
    
    UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
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
    }];
    [av addAction:cancelAC];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)creatUI{
    CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
    if ([self.whopush isEqualToString:@"BD"]||[self.isMU isEqualToString:@"MU"]) {
        [cProgressView creatUI:@[@"身份信息",@"选择挂号医生"] andCount:1];
    }else{
        [cProgressView creatUI:@[@"选择活动",@"身份信息",@"选择挂号医生"] andCount:2];
    }
    [self.view addSubview:cProgressView];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,144, SCREENWIDTH, SCREENHEIGHT-194)];
    [self.view addSubview:BGScrollView];
    
    for (int i=0; i<subDataArray.count; i++) {
        UIButton *depButton=[self addButton:CGRectMake(0, 50*i, SCREENWIDTH,50) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(choiceDoctor:)];
        [depButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [depButton setImage:[UIImage imageNamed:@"select_vaccine"] forState:UIControlStateSelected];
        depButton.imageEdgeInsets=UIEdgeInsetsMake((depButton.frame.size.height-15)/2,10,(depButton.frame.size.height-15)/2,SCREENWIDTH-25);
        [BGScrollView addSubview:depButton];
        
        [self addLineLabel:CGRectMake(0, 49.5, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:depButton];
        
        UILabel *depLabel=[self addLabel:CGRectMake(35, 15,(SCREENWIDTH-55)/2, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [depButton addSubview:depLabel];
        
        if ([self.whopush isEqualToString:@"FD"]) {
            FDDoctorItem *item=[subDataArray objectAtIndex:i];
            depLabel.text=[self changeNullString:item.DepartmentName];
        }else{
            OrgDoctorItem *item=[subDataArray objectAtIndex:i];
            depLabel.text=[self changeNullString:item.departmentname];

        }
        
        UILabel *doctorLabel=[self addLabel:CGRectMake(depLabel.frame.origin.x+(SCREENWIDTH-55)/2, 15,(SCREENWIDTH-55)/2, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:2];
        [depButton addSubview:doctorLabel];
        
        BGScrollView.contentSize=CGSizeMake(0, depButton.frame.origin.y+depButton.frame.size.height+40);
    }
    
    uploadButton=[self addSimpleButton:CGRectMake(20,SCREENHEIGHT-50, SCREENWIDTH-40,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(upload) andText:@"确定" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [uploadButton.layer setCornerRadius:20];
    [self.view addSubview:uploadButton];
}


- (void)upload{
    if (sureArray.count==0) {
        [self showSimplePromptBox:self andMesage:@"请至少选择一个要预约挂号的医生！"];
    }else{
        if (uploadButton.selected==NO) {
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"是否打印条码？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            self.print=@"yes";
            [self sureUpLoad];
        }];
        [av addAction:sureAC];
        
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            self.print=@"no";
            [self sureUpLoad];
        }];
        [av addAction:cancelAC];
        [self presentViewController:av animated:YES completion:nil];
        }
    }
}

- (void)sureUpLoad{
    NSMutableArray *dataArray=[NSMutableArray new];
    if ([self.whopush isEqualToString:@"FD"]){
        for (FDDoctorItem *item in sureArray) {
            NSString *sid=[self getUniqueStrByUUID];
            NSDictionary *dic=@{@"action":@"EXIST_OR_INSERT",@"function":@"hisBespokeUserLst",
                                @"insert":@{
                                        @"sIdCard":[self generateTextDic:self.IDCardString],
                                        @"sName":[self generateTextDic:self.nameString],
                                        @"sRemark":[self generateTextDic:@""],
                                        @"dBirthday":[self generateTextDic:self.birString],
                                        @"sSex":[self generateTextDic:self.sexString],
                                        @"sFolk":[self generateTextDic:self.nationString],
                                        @"sIDAddr":[self generateTextDic:self.addressString],
                                        @"sMemberId":[self generateTextDic:self.memberidString],
                                        @"sIssueUnit":[self generateTextDic:self.unitString],
                                        @"sValidTime":[self generateTextDic:self.validtimeString],
                                        @"sProjId":[self generateTextDic:self.fdItem.sID],
                                        @"sProjType":[self generateTextDic:@"义诊"],
                                        @"sState":[self generateTextDic:@"预约中"],
                                        @"iOrgId":[self generateIntDic:[NSString stringWithFormat:@"%d",self.fdItem.iOrgId]],
                                        @"iDepartmentId":[self generateTextDic:[NSString stringWithFormat:@"%d",[item.DepartmentID intValue]]],
                                        @"sDeptsName":[self generateTextDic:item.DepartmentName],
                                        @"iUserID":[self generateTextDic:@""],
                                        @"iDoctorId":[self generateTextDic:[NSString stringWithFormat:@"%d",[item.UserID intValue]]],
                                        @"sDoctorName":[self generateTextDic:item.UserName],
                                        @"sAiderId":[self generateTextDic:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"] intValue]]],
                                        @"iPlateId":[self generateTextDic:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"workplate"] intValue]]],
                                        @"LOnlyCode":[self generateTextDic:self.onlycodeString],
                                        @"sMobile":[self generateTextDic:self.phoneString],
                                        @"dTime":[self generateFuncDic:@"getdate()"],
                                        @"sID":[self generateTextDic:sid]},
                                @"where":[NSString stringWithFormat:@"sProjId='%@' and sIdCard='%@' and iDoctorId=%@",self.fdItem.sID,self.IDCardString,[NSString stringWithFormat:@"%d",[item.UserID intValue]]]};
            [dataArray addObject:dic];
            NSDictionary *newsDic=@{@"projid":sid,@"department":[NSString stringWithFormat:@"%d",[item.DepartmentID intValue]],@"print":self.print};
            [newsDicArray addObject:newsDic];
        }
    }
    else{
        for (OrgDoctorItem *item in sureArray) {
            NSString *sid=[self getUniqueStrByUUID];
            NSDictionary *dic=@{@"action":@"insert",@"function":@"hisBespokeUserLst",
                                @"data":@{
                                        @"sIdCard":[self generateTextDic:self.IDCardString],
                                        @"sName":[self generateTextDic:self.nameString],
                                        @"sRemark":[self generateTextDic:@""],
                                        @"dBirthday":[self generateTextDic:self.birString],
                                        @"sSex":[self generateTextDic:self.sexString],
                                        @"sFolk":[self generateTextDic:self.nationString],
                                        @"sIDAddr":[self generateTextDic:self.addressString],
                                        @"sMemberId":[self generateTextDic:self.memberidString],
                                        @"sIssueUnit":[self generateTextDic:self.unitString],
                                        @"sValidTime":[self generateTextDic:self.validtimeString],
                                        @"sProjId":[self generateTextDic:sid],
                                        @"sProjType":[self generateTextDic:@"导诊"],
                                        @"sState":[self generateTextDic:@"预约中"],
                                        @"iOrgId":[self generateIntDic:[NSString stringWithFormat:@"%d",[self.orgDocItem.workorgkey intValue]]],
                                        @"iDepartmentId":[self generateTextDic:[NSString stringWithFormat:@"%d",[item.workdepartment intValue]]],
                                        @"sDeptsName":[self generateTextDic:item.departmentname],
                                        @"iUserID":[self generateTextDic:@""],
                                        @"iDoctorId":[self generateTextDic:[NSString stringWithFormat:@"%d",[item.empkey intValue]]],
                                        @"sDoctorName":[self generateTextDic:item.truename],
                                        @"sAiderId":[self generateTextDic:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"empkey"] intValue]]],
                                        @"iPlateId":[self generateTextDic:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"workplate"] intValue]]],
                                        @"LOnlyCode":[self generateTextDic:self.onlycodeString],
                                        @"sMobile":[self generateTextDic:self.phoneString],
                                        @"dTime":[self generateFuncDic:@"getdate()"],
                                        @"sID":[self generateTextDic:sid]}};
            [dataArray addObject:dic];
            NSDictionary *newsDic=@{@"projid":sid,@"department":[NSString stringWithFormat:@"%d",[item.workdepartment intValue]],@"print":self.print};
            [newsDicArray addObject:newsDic];
        }
    }
    uploadButton.selected=YES;
    [self sendRequest:@"AddFDOrderUser" andPath:excuteURL andSqlParameter:dataArray and:self];
}

- (void)choiceDoctor:(UIButton*)button{
    lastButton=button;
    [choiceArray removeAllObjects];
    if ([self.whopush isEqualToString:@"FD"]) {
        FDDoctorItem *item=[subDataArray objectAtIndex:button.tag-101];
        for (FDDoctorItem *allItem in allDataArray) {
            if (item.DepartmentID==allItem.DepartmentID) {
                [choiceArray addObject:allItem];
            }
        }
        self.fdDocItem=choiceArray.firstObject;
    }else{
        OrgDoctorItem *item=[subDataArray objectAtIndex:button.tag-101];
        for (OrgDoctorItem *allItem in allDataArray) {
            if (item.workdepartment==allItem.workdepartment) {
                [choiceArray addObject:allItem];
            }
        }
        self.orgDocItem=choiceArray.firstObject;
    }
    [self addChoiceView];
}

- (void)addChoiceView{
    if (choiceView) {
        [choiceView removeFromSuperview];
        choiceView=nil;
    }
    choiceView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200, SCREENWIDTH, 200)];
    choiceView.backgroundColor=MAINWHITECOLOR;
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceView];
    [self.view addSubview:choiceView];
    
    UIButton *overButton=[UIButton buttonWithType:UIButtonTypeCustom];
    overButton.frame=CGRectMake(SCREENWIDTH-50, 10, 40, 20);
    [overButton setExclusiveTouch :YES];
    [overButton setTitle:@"完成" forState:UIControlStateNormal];
    [overButton addTarget:self action:@selector(overOnclik) forControlEvents:UIControlEventTouchUpInside];
    [overButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceView addSubview:overButton];
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(10,10,40,20);
    [cancelButton setExclusiveTouch :YES];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelOnclik) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceView addSubview:cancelButton];
    
    
    UIButton *clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame=CGRectMake(60,10,40,20);
    [clearButton setExclusiveTouch :YES];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearOnclik) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceView addSubview:clearButton];
    
    [self addLineLabel:CGRectMake(0, 40, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:choiceView];
    
    UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0,50,SCREENWIDTH,150)];
    picker.backgroundColor=MAINWHITECOLOR;
    picker.delegate=self;
    picker.dataSource=self;
    [choiceView addSubview:picker];
}

- (void)clearOnclik{
    if ([self.whopush isEqualToString:@"FD"]) {
        FDDoctorItem *item=[subDataArray objectAtIndex:lastButton.tag-101];
        for (FDDoctorItem *sureItem in sureArray) {
            if (sureItem.DepartmentID==item.DepartmentID) {
                [sureArray removeObject:sureItem];
                break;
            }
        }
    }else{
        OrgDoctorItem *item=[subDataArray objectAtIndex:lastButton.tag-101];
        for (OrgDoctorItem *sureItem in sureArray) {
            if (sureItem.workdepartment==item.workdepartment) {
                [sureArray removeObject:sureItem];
                break;
            }
        }
    }
    lastButton.selected=NO;
    UILabel *nameLabel=[[lastButton subviews] lastObject];
    nameLabel.text=@"";
    [choiceView removeFromSuperview];
    choiceView=nil;
}

- (void)overOnclik{
    UILabel *nameLabel=[[lastButton subviews] lastObject];
    if ([self.whopush isEqualToString:@"FD"]) {
        nameLabel.text=self.fdDocItem.UserName;
            [sureArray addObject:self.fdDocItem];
    }else{
        nameLabel.text=self.orgDocItem.truename;
            [sureArray addObject:self.orgDocItem];
    }
    lastButton.selected=YES;
    
    [choiceView removeFromSuperview];
    choiceView=nil;
}

- (void)cancelOnclik{
    if ([self.whopush isEqualToString:@"FD"]) {
        self.fdDocItem=nil;
    }else{
        self.orgDocItem=nil;
    }
    [choiceView removeFromSuperview];
    choiceView=nil;
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [choiceArray count];
}

#pragma mark- Picker View Delegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel=[self addLabel:view.frame andText:[self pickerView:pickerView titleForRow:row forComponent:component] andFont:SUPERFONT andColor:TEXTCOLORG andAlignment:1];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if ([self.whopush isEqualToString:@"FD"]) {
        FDDoctorItem *item=[choiceArray objectAtIndex:row];
        self.fdDocItem=item;

    }else{
        OrgDoctorItem *item=[choiceArray objectAtIndex:row];
        self.orgDocItem=item;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if ([self.whopush isEqualToString:@"FD"]) {
        FDDoctorItem *item=[choiceArray objectAtIndex:row];
        return item.UserName;
    }else{
        OrgDoctorItem *item=[choiceArray objectAtIndex:row];
        return item.truename;
    }
}

- (NSDictionary*)generateTextDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"text",@"value":value};
    return dic;
}

- (NSDictionary*)generateIntDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"int",@"value":value};
    return dic;
}

- (NSDictionary*)generateFuncDic:(NSString *)value{
    NSDictionary *dic=@{@"type":@"func",@"value":value};
    return dic;
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
