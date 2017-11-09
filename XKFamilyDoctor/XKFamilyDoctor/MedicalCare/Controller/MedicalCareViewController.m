//
//  MedicalCareViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MedicalCareViewController.h"
#import "SDCycleScrollView.h"
#import "ReferralViewController.h"
#import "SignViewController.h"
#import "BillingViewController.h"
#import "CommunityViewController.h"
#import "ApplyListItem.h"
#import "TeamDoctorItem.h"
#import "TeamDetailViewController.h"

@interface MedicalCareViewController ()<SDCycleScrollViewDelegate>

@end

@implementation MedicalCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"医疗保健"];
    [self creatUI];
    applyArray=[NSMutableArray new];
    doctorArray=[NSMutableArray new];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if (![[usd objectForKey:@"LTeamId"] isKindOfClass:[NSNull class]]) {
        [self sendRequest:@"TeamDoctor" andPath:queryURL andSqlParameter:[usd objectForKey:@"LTeamId"] and:self];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self.myTabBarController showTabBar];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    if ([self.applyIsChange isEqualToString:@"Y"]) {
        for (UIView *subView in applyBackView.subviews) {
            if (subView.frame.origin.y>=65) {
                [subView removeFromSuperview];
            }
        }
        mainScrollView.contentSize=CGSizeMake(0, applyBackView.frame.origin.y+65);
        applyBackView.frame=CGRectMake(applyBackView.frame.origin.x, applyBackView.frame.origin.y, applyBackView.frame.size.width, 65);
        UIButton *button=[[applyBackView subviews]firstObject];
        button.selected=NO;
        [applyArray removeObjectAtIndex:lastButton.tag-101];
        
        if ([self.returnOrAgree isEqualToString:@"Y"]) {
            [self showSimplePromptBox:self andMesage:@"签约已成功！"];
        }else{
            [self showSimplePromptBox:self andMesage:@"申请已退回！"];
        }
        self.applyIsChange=nil;
        self.returnOrAgree=nil;
    }
    
}
- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    UIButton *button=[[applyBackView subviews]firstObject];
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"SignAuditing"]) {
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    ApplyListItem *item=[RMMapper objectWithClass:[ApplyListItem class] fromDictionary:dic];
                    [applyArray addObject:item];
                }
                [self addApplyList];
            }else{
                button.selected=NO;
                [self showSimplePromptBox:self andMesage:@"暂无签约申请"];
            }
        }if ([type isEqualToString:@"TeamDoctor"]) {
            NSArray *data=message;
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    TeamDoctorItem *item=[RMMapper objectWithClass:[TeamDoctorItem class] fromDictionary:dic];
                    [doctorArray addObject:item];
                }
            }else{
            }
        }
    }else{
        button.selected=NO;
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    UIButton *button=[[applyBackView subviews]firstObject];
    button.selected=NO;
    [self showSimplePromptBox:self andMesage:@"您的网路不给力，请检查后重试"];
}

- (void)creatUI{
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH, SCREENHEIGHT-114)];
    [self.view addSubview:mainScrollView];
    
    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH,130)];
    fBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:fBackView];
    
    NSArray *btnNameArray=@[@"双向转诊",@"配送开单",@"医生团队",@"我的社区"];
    NSArray *btnImageArray=@[@"referral",@"delivery",@"team",@"community"];
    for (int i=0; i<btnNameArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(SCREENWIDTH/2*(i%2),65*(i/2), SCREENWIDTH/2,65) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(referralClick:)];
        [fBackView addSubview:menuButton];
        
        UIImageView *menuImageView=[[UIImageView alloc]initWithFrame:CGRectMake(24,15,35,35)];
        menuImageView.image=[UIImage imageNamed:[btnImageArray objectAtIndex:i]];
        [menuButton addSubview:menuImageView];
        
        UILabel *towReferralLabel=[self addLabel:CGRectMake(71,22,SCREENWIDTH/2-71,20) andText:[btnNameArray objectAtIndex:i] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [menuButton addSubview:towReferralLabel];
    }
    for (int i=0; i<3; i++) {
        [self addLineLabel:CGRectMake(0, 65*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBackView];
    }
    
    [self addLineLabel:CGRectMake(SCREENWIDTH/2, 10, 0.5,45) andColor:LINECOLOR andBackView:fBackView];
    
    [self addLineLabel:CGRectMake(SCREENWIDTH/2, 75, 0.5,45) andColor:LINECOLOR andBackView:fBackView];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if (![[usd objectForKey:@"LLeader"] isKindOfClass:[NSNull class]] &&[[usd objectForKey:@"LLeader"] isEqualToString:@"是"]) {
        applyBackView=[[UIView alloc]initWithFrame:CGRectMake(0,fBackView.frame.origin.y+fBackView.frame.size.height+8, SCREENWIDTH,65)];
        applyBackView.backgroundColor=MAINWHITECOLOR;
        [mainScrollView addSubview:applyBackView];
        
        
        UIButton *sButton=[self addButton:CGRectMake(0, 0, SCREENWIDTH,65) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(getSData:)];
        [applyBackView addSubview:sButton];
        
        UIImageView *openImageView=[[UIImageView alloc]initWithFrame:CGRectMake(24,15,35,35)];
        openImageView.image=[UIImage imageNamed:@"sign"];
        [sButton addSubview:openImageView];
        
        UILabel *sLabel=[self addLabel:CGRectMake(71,22,100,20) andText:@"签约审核" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [sButton addSubview:sLabel];
        
        UIImageView *countImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,25,15, 15)];
        countImageView.image=[UIImage imageNamed:@"arrow_"];
        [sButton addSubview:countImageView];
        
        for (int i=0; i<2; i++) {
            [self addLineLabel:CGRectMake(0, 64.5*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:applyBackView];
        }
    }
    
}

- (void)referralClick:(UIButton*)button{
    if (button.tag==101) {
        ReferralViewController *rvc=[ReferralViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (button.tag==102){
        BillingViewController *rvc=[BillingViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (button.tag==103){
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if ([self changeNullString:[usd objectForKey:@"LTeamId"]].length>0) {
            TeamDetailViewController *rvc=[TeamDetailViewController new];
            [self.myTabBarController hidesTabBar];
            [self.navigationController pushViewController:rvc animated:YES];
        }else{
            [self showSimplePromptBox:self andMesage:@"您暂未加入医生团队！"];
        }
    }else{
        CommunityViewController *rvc=[CommunityViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

- (void)getSData:(UIButton*)button{
    if (button.selected==NO) {
        if (applyArray.count>0) {
            [self addApplyList];
        }else{
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            [self sendRequest:@"SignAuditing" andPath:queryURL andSqlParameter:[usd objectForKey:@"LTeamId"] and:self];
        }
        button.selected=YES;
    }else{
        UIView *cListBackView=[self.view viewWithTag:112];
        [cListBackView removeFromSuperview];
        
        applyBackView.frame=CGRectMake(applyBackView.frame.origin.x,applyBackView.frame.origin.y,applyBackView.frame.size.width,65);
        mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, applyBackView.frame.origin.y+applyBackView.frame.size.height+20);
        button.selected=NO;
    }
}

- (void)addApplyList{
    UIView *cListBackView=[[UIView alloc]initWithFrame:CGRectMake(0,65, SCREENWIDTH,0)];
    cListBackView.tag=112;
    [applyBackView addSubview:cListBackView];
    
    for (int i=0; i<applyArray.count; i++) {
        ApplyListItem *item=[applyArray objectAtIndex:i];
        UIButton *userButton=[self addButton:CGRectMake(0, 67*i, SCREENWIDTH,67) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(gotoSign:)];
        [cListBackView addSubview:userButton];
        
        UIImageView *userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,8,50,50)];
        [userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LHeadPic]] placeholderImage:[UIImage imageNamed:@"ell_1"]];
        [userButton addSubview:userImageView];
        
        UILabel *userLabel=[self addLabel:CGRectMake(80,15, SCREENWIDTH-160,15) andText:item.LName andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [userLabel sizeToFit];
        [userButton addSubview:userLabel];
        
        //            UIImageView *noAuditImageView=[[UIImageView alloc]initWithFrame:CGRectMake(userLabel.frame.origin.x+userLabel.frame.size.width+6, 18, 30, 15)];
        //            noAuditImageView.image=[UIImage imageNamed:@"unreviewed"];
        //            [userButton addSubview:noAuditImageView];
        
        //            UILabel *ageLabel=[self addLabel:CGRectMake(80,38,SCREENWIDTH-140,14) andText:@"28岁  男" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        //            [userButton addSubview:ageLabel];
        
        NSLog(@"========%@=========%@",[self getSubTime:item.LBindTime andFormat:@"MM-dd"],item.LBindTime);
        UILabel *timeLabel=[self addLabel:CGRectMake(80,38,SCREENWIDTH-140,14) andText:[self getSubTime:item.LBindTime andFormat:@"MM-dd"] andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:0];
        [userButton addSubview:timeLabel];
        
        [self addLineLabel:CGRectMake(0,userButton.frame.size.height-0.5,SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:userButton];
        
        cListBackView.frame=CGRectMake(0,65, SCREENWIDTH, userButton.frame.origin.y+userButton.frame.size.height);
    }
    applyBackView.frame=CGRectMake(applyBackView.frame.origin.x,applyBackView.frame.origin.y, applyBackView.frame.size.width, cListBackView.frame.origin.y+cListBackView.frame.size.height);
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, applyBackView.frame.origin.y+applyBackView.frame.size.height+20);
}

- (void)gotoSign:(UIButton*)button{
    lastButton=button;
    ApplyListItem *item=[applyArray objectAtIndex:button.tag-101];
    SignViewController *svc=[SignViewController new];
    svc.LOnlyCode=item.LOnlyCode;
    svc.LDoctorName=item.LDoctorName;
    svc.lChatID=item.Lid;
    if (doctorArray.count>0) {
        svc.doctorArray=doctorArray;
    }
    [self.myTabBarController hidesTabBar];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
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
