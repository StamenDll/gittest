//
//  SignViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SignViewController.h"
#import "MedicalCareViewController.h"
#import "TeamDoctorItem.h"
#import "AppDelegate.h"
@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"签约"];
    [self addLeftButtonItem];
    [self sendRequest:@"MemberInfo" andPath:queryURL andSqlParameter:self.LOnlyCode and:self];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MemberInfo"]) {
            if (data.count>0) {
                memberItem=[RMMapper objectWithClass:[MemberInfoItem class] fromDictionary:[data objectAtIndex:0]];
                [self creatUI];
            }
        }else if ([type isEqualToString:@"SignApply"]||[type isEqualToString:@"CancelSign"]){
            [self cancelReturnView];
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
            
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            NSMutableArray *memberArray=[NSMutableArray new];
            for (TeamDoctorItem *item in self.doctorArray) {
                [memberArray addObject:item.LOnlyCode];
            }
            [memberArray addObject:self.LOnlyCode];
            NSDictionary *msgDic = @{@"groupid":self.lChatID,@"name":self.LDoctorName,@"face":@"",@"owner":CHATCODE,@"members":memberArray,@"type":@"group-create"};
            
            NSData *jsonmsg = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:NULL];
            
            NSString *textmsg =  [[NSString alloc] initWithData:jsonmsg encoding:NSUTF8StringEncoding];
            NSLog(@"测试发送消息＝＝＝＝＝＝＝＝＝%@",textmsg);
            [client publishString:textmsg
                          toTopic:@"com.dav.icdp.message"
                          withQos:AtMostOnce
                           retain:NO
                completionHandler:^(int mid) {}];
            
            dispatch_semaphore_t received = dispatch_semaphore_create(0);
            [client setMessageHandler:^(MQTTMessage *message) {
                dispatch_semaphore_signal(received);
            }];

            [UIView animateWithDuration:1 animations:^{
                for (UINavigationController *nvc in self.navigationController.viewControllers) {
                    if ([nvc isKindOfClass:[MedicalCareViewController class]]) {
                        MedicalCareViewController *mvc=(MedicalCareViewController*)nvc;
                        if ([type isEqualToString:@"SignApply"]) {
                            mvc.returnOrAgree=@"Y";
                        }else{
                            mvc.returnOrAgree=@"N";
                        }
                        mvc.applyIsChange=@"Y";
                        [self.navigationController popToViewController:mvc animated:YES];
                        
                    }
                }
            }];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT-114)];
    [self.view addSubview:mainScrollView];
    
    UIView *fBackView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 178) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:fBackView];
    
    UIImageView *hpImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-63)/2,35,63,63)];
    hpImageView.image=[UIImage imageNamed:@"ell_4"];
    [fBackView addSubview:hpImageView];
    
    if (1) {
        UIImageView *vipImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-63)/2+45,80,18,18)];
        vipImageView.image=[UIImage imageNamed:@"v_2"];
        [fBackView addSubview:vipImageView];
    }
    
    UILabel *levelLabel=[self addLabel:CGRectMake(0, hpImageView.frame.origin.y+hpImageView.frame.size.height+10, SCREENWIDTH, 20) andText:memberItem.member_truename andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
    [fBackView addSubview:levelLabel];
    
    UILabel *numberLabel=[self addLabel:CGRectMake(0,levelLabel.frame.origin.y+levelLabel.frame.size.height, SCREENWIDTH, 20) andText:@"52岁  女" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [fBackView addSubview:numberLabel];
    
    [self addLineLabel:CGRectMake(0,178, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    infoButton=[self addButton:CGRectMake(0, fBackView.frame.origin.y+fBackView.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openInfo:)];
    [mainScrollView addSubview:infoButton];
    
    UIImageView *infoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    infoImageView.image=[UIImage imageNamed:@"General-Information"];
    [infoButton addSubview:infoImageView];
    
    UILabel *infoLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"基本信息" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [infoButton addSubview:infoLabel];
    
    UILabel *iopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [infoButton addSubview:iopenLabel];
    
    UIImageView *igoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    igoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [infoButton addSubview:igoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:infoButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:infoButton];
    
    sHistoryButton=[self addButton:CGRectMake(0,infoButton.frame.origin.y+infoButton.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openSelfHistory:)];
    [mainScrollView addSubview:sHistoryButton];
    
    UIImageView *sHistoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    sHistoryImageView.image=[UIImage imageNamed:@"anamnesis"];
    [sHistoryButton addSubview:sHistoryImageView];
    
    UILabel *sHistoryLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"既往病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sHistoryButton addSubview:sHistoryLabel];
    
    UILabel *sopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [sHistoryButton addSubview:sopenLabel];
    
    UIImageView *sgoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    sgoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [sHistoryButton addSubview:sgoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sHistoryButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sHistoryButton];
    
    fHistoryButton=[self addButton:CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openFamilyHistory:)];
    [mainScrollView addSubview:fHistoryButton];
    
    UIImageView *fHistoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    fHistoryImageView.image=[UIImage imageNamed:@"Family-History"];
    [fHistoryButton addSubview:fHistoryImageView];
    
    UILabel *fHistoryLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"家族病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [fHistoryButton addSubview:fHistoryLabel];
    
    UILabel *fopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [fHistoryButton addSubview:fopenLabel];
    
    UIImageView *fgoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    fgoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [fHistoryButton addSubview:fgoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    
    UIButton *sureHandleButton=[self addSimpleButton:CGRectMake(15, SCREENHEIGHT-45, (SCREENWIDTH-40)/2,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureSign:) andText:@"签约" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:sureHandleButton];
    
    UIButton *backButton=[self addSimpleButton:CGRectMake(25+sureHandleButton.frame.size.width, SCREENHEIGHT-45, (SCREENWIDTH-40)/2,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(returnSignApply) andText:@"打回" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:backButton];
}

- (void)sureSign:(UIButton*)button{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    NSArray *sqlParameter=@[[usd objectForKey:@"LTeamId"],self.LDoctorName,memberItem.LOnlyCode,@"成功"];
    [self sendRequest:@"SignApply" andPath:insetOrUpdataURL andSqlParameter:sqlParameter and:self];
}

- (void)returnSignApply{
    UIView *FBGView=[self addSimpleBackView:self.view.bounds andColor:[UIColor blackColor]];
    FBGView.alpha=0.6;
    FBGView.tag=11;
    [self.navigationController.view addSubview:FBGView];
    
    UIView *SBGView=[self addSimpleBackView:CGRectMake(40,100, SCREENWIDTH-80, 220) andColor:MAINWHITECOLOR];
    SBGView.tag=12;
    [self.navigationController.view addSubview:SBGView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:SBGView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = SBGView.bounds;
    maskLayer.path = maskPath.CGPath;
    SBGView.layer.mask = maskLayer;
    
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(0, 0, SBGView.frame.size.width, 40) andColor:GREENCOLOR];
    [SBGView addSubview:titleBGView];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:titleBGView.bounds byRoundingCorners:UIRectCornerTopLeft  cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = titleBGView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    titleBGView.layer.mask = maskLayer1;
    
    
    UILabel *reasonlabel=[self addLabel:CGRectMake(15, 10, SBGView.frame.size.width-30, 20) andText:@"退回原因:" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:0];
    [SBGView addSubview:reasonlabel];
    
    UIView *reasonBGView=[self addSimpleBackView:CGRectMake(15, 55, SBGView.frame.size.width-30, 100) andColor:MAINWHITECOLOR];
    reasonBGView.layer.borderColor=LINECOLOR.CGColor;
    reasonBGView.layer.borderWidth=0.5;
    [SBGView addSubview:reasonBGView];
    
    reasonTextView=[[UITextView alloc]initWithFrame:CGRectMake(5,5, reasonBGView.frame.size.width-10,90)];
    reasonTextView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    reasonTextView.textColor=TEXTCOLOR;
    [reasonBGView addSubview:reasonTextView];
    
    
    UIButton *cancelButton=[self addSimpleButton:CGRectMake(15, 170, (SBGView.frame.size.width-40)/2, 35) andBColor:BGGRAYCOLOR andTag:0 andSEL:@selector(cancelReturnView) andText:@"取消" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
    [SBGView addSubview:cancelButton];
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(25+(SBGView.frame.size.width-40)/2, 170, (SBGView.frame.size.width-40)/2, 35) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureReturnApply:) andText:@"确定" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    [SBGView addSubview:sureButton];
}

- (void)sureReturnApply:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *remarkString = [reasonTextView.text stringByTrimmingCharactersInSet:set];
        if (remarkString.length==0) {
            [self showSimplePromptBox:self andMesage:@"退回原因不能为空"];
        }else{
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            NSArray *sqlParameter=@[@"打回",remarkString,memberItem.LOnlyCode,[usd objectForKey:@"LTeamId"]];
            [self sendRequest:@"CancelSign" andPath:excuteURL andSqlParameter:sqlParameter and:self];
        }
    }
}


- (void)cancelReturnView{
    UIView *FBGView=[self.navigationController.view viewWithTag:11];
    [FBGView removeFromSuperview];
    UIView *SBGView=[self.navigationController.view viewWithTag:12];
    [SBGView removeFromSuperview];
}

- (void)openInfo:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        infoButton.frame=CGRectMake(0, infoButton.frame.origin.y,SCREENWIDTH, 125);
        [self addLineLabel:CGRectMake(0, infoButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:infoButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        infoButton.frame=CGRectMake(0, infoButton.frame.origin.y,SCREENWIDTH, 45);
        for (UIView *subView in [infoButton subviews]) {
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    sHistoryButton.frame=CGRectMake(0,infoButton.frame.origin.y+infoButton.frame.size.height+8, SCREENWIDTH,sHistoryButton.frame.size.height);
    fHistoryButton.frame=CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,fHistoryButton.frame.size.height);
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
}

- (void)openSelfHistory:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        sHistoryButton.frame=CGRectMake(0, sHistoryButton.frame.origin.y,SCREENWIDTH, 120);
        [self addLineLabel:CGRectMake(0, sHistoryButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:sHistoryButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        sHistoryButton.frame=CGRectMake(0, sHistoryButton.frame.origin.y,SCREENWIDTH,45);
        for (UIView *subView in [sHistoryButton subviews]){
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    fHistoryButton.frame=CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,fHistoryButton.frame.size.height);
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
}

- (void)openFamilyHistory:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        fHistoryButton.frame=CGRectMake(0, fHistoryButton.frame.origin.y,SCREENWIDTH, 120);
        [self addLineLabel:CGRectMake(0, fHistoryButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:fHistoryButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        fHistoryButton.frame=CGRectMake(0, fHistoryButton.frame.origin.y,SCREENWIDTH, 45);
        for (UIView *subView in [fHistoryButton subviews]) {
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
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
