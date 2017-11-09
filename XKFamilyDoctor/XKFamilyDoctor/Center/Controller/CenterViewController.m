 //
//  CenterViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CenterViewController.h"
#import "ChangePWViewController.h"
#import "ChangeInfoViewController.h"
#import "LoginViewController.h"
#import "MyOrderViewController.h"
#import "InviteViewController.h"
@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"个人中心"];
    [self creatUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.myTabBarController showTabBar];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    oCLabel.text=[NSString stringWithFormat:@"%@ %@ %@",[usd objectForKey:@"platename"],[usd objectForKey:@"orgname"],[usd objectForKey:@"departmentname"]];
    nameCLabel.text=[usd objectForKey:@"truename"];
    gwAccountCLabel.text=[usd objectForKey:@"gwuser"];
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}

- (void)creatUI{
    BGSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGSrollView];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    
    UIView *fBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH,150) andColor:MAINWHITECOLOR];
    [BGSrollView addSubview:fBGView];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15, 15, 50, 20) andText:@"姓名" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:nameLabel];
    
    nameCLabel=[self addLabel:CGRectMake(60, 15, SCREENWIDTH/2-70, 20) andText:[usd objectForKey:@"truename"] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [fBGView addSubview:nameCLabel];
    
    UILabel *phoneLabel=[self addLabel:CGRectMake(SCREENWIDTH/2,15,50, 20) andText:@"手机号" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:phoneLabel];
    
    UILabel *phoneCLabel=[self addLabel:CGRectMake(SCREENWIDTH/2+60, 15, SCREENWIDTH/2-70, 20) andText:[usd objectForKey:@"mobile"] andFont:BIGFONT andColor:TEXTCOLORG andAlignment:0];
    [fBGView addSubview:phoneCLabel];
    
    UILabel *gwAccountLabel=[self addLabel:CGRectMake(15, 65,70, 20) andText:@"公卫账号" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:gwAccountLabel];
    
    gwAccountCLabel=[self addLabel:CGRectMake(90, 65, SCREENWIDTH-80, 20) andText:[usd objectForKey:@"truename"] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [fBGView addSubview:gwAccountCLabel];
    
    UILabel *oLabel=[self addLabel:CGRectMake(15,115,70, 20) andText:@"组织机构" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [fBGView addSubview:oLabel];
    
    oCLabel=[self addLabel:CGRectMake(90,115, SCREENWIDTH-100, 20) andText:[NSString stringWithFormat:@"%@ %@ %@",[usd objectForKey:@"platename"],[usd objectForKey:@"orgname"],[usd objectForKey:@"departmentname"]] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [fBGView addSubview:oCLabel];
    
    [self addLineLabel:CGRectMake(15, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBGView];
    [self addLineLabel:CGRectMake(15, 100, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBGView];
    [self addLineLabel:CGRectMake(0, 150, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBGView];
    
    
    UIButton *orderButton=[self addButton:CGRectMake(0, fBGView.frame.origin.y+fBGView.frame.size.height+8, SCREENWIDTH,55) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(myOrderOnclick)];
    [BGSrollView addSubview:orderButton];
    
    UILabel *orderLabel=[self addLabel:CGRectMake(15,16, SCREENWIDTH-130, 20) andText:@"我的订单" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [orderButton addSubview:orderLabel];
    
    [self addGotoNextImageView:orderButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:orderButton];
    [self addLineLabel:CGRectMake(0, 55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:orderButton];
    
    UIButton *codeButton=[self addButton:CGRectMake(0, orderButton.frame.origin.y+orderButton.frame.size.height+8, SCREENWIDTH,55) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(lockCode)];
    [BGSrollView addSubview:codeButton];
    
    UILabel *codeLabel=[self addLabel:CGRectMake(15,16, SCREENWIDTH-130, 20) andText:@"APP二维码" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [codeButton addSubview:codeLabel];
    
    [self addGotoNextImageView:codeButton];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeButton];
    [self addLineLabel:CGRectMake(0, 55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:codeButton];


    UIButton *changePWButton=[self addButton:CGRectMake(0, codeButton.frame.origin.y+codeButton.frame.size.height+8, SCREENWIDTH,55) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(changePWOnclick)];
    [BGSrollView addSubview:changePWButton];
    
    UILabel *changePWLabel=[self addLabel:CGRectMake(15,16, SCREENWIDTH-130, 20) andText:@"修改密码" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [changePWButton addSubview:changePWLabel];
    
    UIImageView *cpwgoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,20,14,14)];
    cpwgoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [changePWButton addSubview:cpwgoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:changePWButton];
    [self addLineLabel:CGRectMake(0,55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:changePWButton];

//
//    UIButton *changeInfoButton=[self addButton:CGRectMake(0, changePWButton.frame.origin.y+changePWButton.frame.size.height, SCREENWIDTH,55) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(changeInfoOnclick)];
//    [BGSrollView addSubview:changeInfoButton];
//    
//    UILabel *changeInfoLabel=[self addLabel:CGRectMake(15,16, SCREENWIDTH-130, 20) andText:@"修改资料" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
//    [changeInfoButton addSubview:changeInfoLabel];
//    
//    UIImageView *cigoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,20,14,14)];
//    cigoImagView.image=[UIImage imageNamed:@"arrow_2"];
//    [changeInfoButton addSubview:cigoImagView];
//    
//    [self addLineLabel:CGRectMake(15, 0, SCREENWIDTH-15, 0.5) andColor:LINECOLOR andBackView:changeInfoButton];
//    [self addLineLabel:CGRectMake(0, 55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:changeInfoButton];
    
    UIButton *logoutButton=[self addSimpleButton:CGRectMake(20,changePWButton.frame.origin.y+80,SCREENWIDTH-40,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(logoutOnclick) andText:@"退出登录" andFont:SUPERFONT andColor:GREENCOLOR andAlignment:1];
    logoutButton.layer.borderColor=GREENCOLOR.CGColor;
    logoutButton.layer.borderWidth=0.5;
    [logoutButton.layer setCornerRadius:20];
    [BGSrollView addSubview:logoutButton];

    BGSrollView.contentSize=CGSizeMake(0, logoutButton.frame.origin.y+logoutButton.frame.size.height+40);
}

- (void)lockCode{
    InviteViewController *fvc=[[InviteViewController alloc]init];
    [self.myTabBarController hidesTabBar];
    [self.navigationController pushViewController:fvc animated:YES];
}



- (void)myOrderOnclick{
    MyOrderViewController *fvc=[[MyOrderViewController alloc]init];
    [self.myTabBarController hidesTabBar];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)changePWOnclick{
    ChangePWViewController *cvc=[ChangePWViewController new];
    [self.myTabBarController hidesTabBar];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)changeInfoOnclick{
    ChangeInfoViewController *cvc=[ChangeInfoViewController new];
    [self.myTabBarController hidesTabBar];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)logoutOnclick{
    [self showPromptBox:self andMesage:@"确定要退出当前账号吗？" andSel:@selector(sureLogout)];
}

- (void)sureLogout{
    NSString *mainurl=[[NSUserDefaults standardUserDefaults] objectForKey:URLSAVENAME];
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [[NSUserDefaults standardUserDefaults] setObject:mainurl forKey:URLSAVENAME];
    
    LoginViewController *lvc=[LoginViewController new];
    UINavigationController *nlvc=[[UINavigationController alloc]initWithRootViewController:lvc];
    [self presentViewController:nlvc animated:YES completion:nil];
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
