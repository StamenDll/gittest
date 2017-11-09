//
//  BusinessViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BusinessViewController.h"
#import "WaitAuditingViewController.h"
#import "ChangeJobViewController.h"
#import "FreeDiagnoseViewController.h"
#import "AddOrderUserViewController.h"
#import "SignApplyViewController.h"
#import "BillingViewController.h"
#import "StatisticsViewController.h"
#import "SignImportViewController.h"
#import "SearchAreaViewController.h"
#import "GWLoginViewController.h"
#import "LoginViewController.h"
#import "CensusViewController.h"
#import "MyUserViewController.h"
#import "ChoiceFamilyViewController.h"
#import "ArchiveClass.h"
#import "UserItem.h"
#import "AppDelegate.h"
#import "PrintView.h"
#import "AFNetworking.h"
@interface BusinessViewController ()<PrintViewDelegate>

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"业务入口"];
    if (!CHOICEURL){
        LoginViewController *lvc=[LoginViewController new];
        UINavigationController *nlvc=[[UINavigationController alloc]initWithRootViewController:lvc];
        [self presentViewController:nlvc animated:YES completion:nil];
    }else{
        [self creatUI];
        [self sendRequest:GETURLLISTTYPE andPath:GETURLLIST andSqlParameter:@"GET" and:self];
        [self sendRequest:DEPDOCLISTTYPE andPath:DEPDOCLISTURL andSqlParameter:@{@"mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]} and:self];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self sendRequest:CHECKUPDATATYPE andPath:CHECKUPDATAURL andSqlParameter:nil and:self];
    
    [self.myTabBarController showTabBar];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    nameLabel.attributedText=[self setString:[NSString stringWithFormat:@"当前用户: %@",[usd objectForKey:@"truename"]] andSubString:[usd objectForKey:@"truename"] andDifColor:TEXTCOLORG];
    [nameLabel sizeToFit];
    
    jobLabel.attributedText=[self setString:[NSString stringWithFormat:@"社区: %@",[usd objectForKey:@"orgname"]] andSubString:@"社区: " andDifColor:TEXTCOLOR];
    [jobLabel adjustsFontSizeToFitWidth];
    jobLabel.frame=CGRectMake(nameLabel.frame.size.width+20,jobLabel.frame.origin.y,SCREENWIDTH-(nameLabel.frame.size.width+20)-10, 20);
    
    [self sendRequest:GETSIGNTYPE andPath:GETSIGNURL andSqlParameter:@{@"empkey":EMPKEY} and:self];

}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}


- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([type isEqualToString:CHECKUPDATATYPE]) {
        NSRange startRange = [message rangeOfString:@"<ios_ver>"];
        NSRange endRange = [message rangeOfString:@"</ios_ver>"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [message substringWithRange:range];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if ([result compare:appCurVersion options:NSNumericSearch]==NSOrderedDescending) {
            UIView *updataBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            updataBGView.backgroundColor=[UIColor blackColor];
            updataBGView.alpha=0.6;
            updataBGView.tag=11;
            [self.myTabBarController.view addSubview:updataBGView];
            
            UIImage *updataImage=[UIImage imageNamed:@"version_bg"];
            UIView *sBGView=[self addSimpleBackView:CGRectMake((SCREENWIDTH-250)/2,0,250,250/updataImage.size.width*updataImage.size.height+100) andColor:MAINWHITECOLOR];
            sBGView.center=self.view.center;
            [sBGView.layer setCornerRadius:10];
            sBGView.tag=12;
            [self.myTabBarController.view addSubview:sBGView];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 250/updataImage.size.width*updataImage.size.height)];
            imageView.image=updataImage;
            [sBGView addSubview:imageView];
            
            UIButton *updataButton=[self addSimpleButton:CGRectMake(75, imageView.frame.size.height+20, 100, 30) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(updataNow) andText:@"立即更新" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
            updataButton.layer.borderColor=GREENCOLOR.CGColor;
            updataButton.layer.borderWidth=0.5;
            [updataButton.layer setCornerRadius:15];
            [sBGView addSubview:updataButton];
            
            UILabel *adviceLabel=[self addLabel:CGRectMake(0, updataButton.frame.origin.y+35, 250, 20) andText:@"更新新版本享受更多功能" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
            [sBGView addSubview:adviceLabel];
            
            
            NSRange startRange1 = [message rangeOfString:@"<ios_min_ver>"];
            NSRange endRange1 = [message rangeOfString:@"</ios_min_ver>"];
            NSRange range1 = NSMakeRange(startRange1.location + startRange1.length, endRange1.location - startRange1.location - startRange1.length);
            NSString *minVersion = [message substringWithRange:range1];
            
            if ([minVersion compare:appCurVersion options:NSNumericSearch] !=NSOrderedDescending)
            {
                UIButton *cancelButton=[self addSimpleButton:CGRectMake(sBGView.frame.origin.x+185,sBGView.frame.origin.y-15, 30,30) andBColor:MAINWHITECOLOR andTag:13 andSEL:@selector(cancelUpload) andText:@"X" andFont:BIGFONT andColor:GREENCOLOR andAlignment:1];
                [cancelButton.layer setCornerRadius:15];
                [self.myTabBarController.view addSubview:cancelButton];
            }
            
            NSRange startRange2 = [message rangeOfString:@"<plist>"];
            NSRange endRange2 = [message rangeOfString:@"</plist>"];
            NSRange range2 = NSMakeRange(startRange2.location + startRange2.length, endRange2.location - startRange2.location - startRange2.length);
            plistUrl = [message substringWithRange:range2];
        }
    }
    else if ([type isEqualToString:GETURLLISTTYPE]){
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        NSDictionary *urldic = [NSJSONSerialization JSONObjectWithData:jsonData
                                
                                                               options:NSJSONReadingMutableContainers
                                
                                                                 error:&err];
        [[ArchiveClass new] saveUrlToLocal:urldic];
    }else if ([type isEqualToString:DEPDOCLISTTYPE]){
        if ([message isKindOfClass:[NSArray class]]) {
            NSArray *data=message;
            for (NSDictionary *dic in data) {
                UserItem *item=[RMMapper objectWithClass:[UserItem class] fromDictionary:dic];
                [self saveItemToUserDeful:item];
            }
        }else{
            [self showSimplePromptBox:self andMesage:message];
        }
    }
    else if ([type isEqualToString:@"Login"]) {
        if ([message isKindOfClass:[NSArray class]]) {
            NSArray *dataArray=message;
            if (dataArray.count>0){
                NSDictionary *dic=[dataArray objectAtIndex:0];
                if ([[self changeNullString:[dic objectForKey:@"LRole"]] isEqualToString:@"健康顾问"]) {
                    
                }else{
                    [self showSimplePromptBox:self andMesage:@"您的账号不是健教专干账号，暂不支持该功能！"];
                }
            }else{
                [self showSimplePromptBox:self andMesage:@"您的账号不是健教专干账号，暂不支持该功能！"];
            }
        }else{
            [self showSimplePromptBox:self andMesage:message];
        }
    }else if ([type isEqualToString:GETSIGNTYPE]){
        NSDictionary *dataDic=message;
        int total=[[dataDic objectForKey:@"total"] intValue];
        if (total>0) {
            signCountLabel.hidden=NO;
            signCountLabel.text=[NSString stringWithFormat:@"%d",total];
        }
    }
}

- (void)updataNow{
    NSString*urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",plistUrl];
    
    NSURL*url  = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)cancelUpload{
    UIView *fBGVIew=(UIView*)[self.myTabBarController.view viewWithTag:11];
    UIView *sBGVIew=(UIView*)[self.myTabBarController.view viewWithTag:12];
    UIView *tBGVIew=(UIView*)[self.myTabBarController.view viewWithTag:13];
    [fBGVIew removeFromSuperview];
    [sBGVIew removeFromSuperview];
    [tBGVIew removeFromSuperview];
}

- (void)creatUI{
    NSLog(@"%f",NAVHEIGHT);
    nameLabel=[self addLabel:CGRectMake(10,NAVHEIGHT+10,0, 20) andText:@"当前用户: " andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    jobLabel=[self addLabel:CGRectMake(nameLabel.frame.size.width+20, NAVHEIGHT+10, (SCREENWIDTH-30)/2, 20) andText:@"社区: " andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [self.view addSubview:jobLabel];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+30, SCREENWIDTH, SCREENHEIGHT-155)];
    BGScrollView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:BGScrollView];
    
    [self addLineLabel:CGRectMake(0, nameLabel.frame.origin.y+30, SCREENHEIGHT, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    NSArray *nameArray=@[@"调换岗位",@"待审核",@"我的用户",@"义诊",@"导诊",@"签约任务",@"签约录入",@"配送开单",@"建档",
                         @"数据统计",@"历史记录"];
    NSArray *imageArray=@[@"switch_job",@"check_list",@"myUser",@"public_good",@"guide",@"business_sign",@"import",@"business_delivery",@"file",
                          @"Statis",@"history"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(SCREENWIDTH/3*(i%3),100*(i/3), SCREENWIDTH/3,108) adnColor:CLEARCOLOR andTag:101+i andSEL:@selector(menuOnclick:)];
        [menuButton setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        menuButton.imageEdgeInsets=UIEdgeInsetsMake(20, (SCREENWIDTH/3-48)/2,40, (SCREENWIDTH/3-48)/2);
        [BGScrollView addSubview:menuButton];
        
        if (i==5) {
            signCountLabel=[self addLabel:CGRectMake((SCREENWIDTH/3-48)/2+35,15, 25,25) andText:@"" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
            signCountLabel.backgroundColor=[UIColor redColor];
            signCountLabel.clipsToBounds=YES;
            [signCountLabel.layer setCornerRadius:12.5];
            signCountLabel.hidden=YES;
            [menuButton addSubview:signCountLabel];
        }
        
        UILabel *menunameLabel=[self addLabel:CGRectMake(0,83, menuButton.frame.size.width, 20) andText:[nameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [menuButton  addSubview:menunameLabel];
    }
    
}

- (void)menuOnclick:(UIButton*)button{
    UILabel *label=[[button subviews]lastObject];
    if ([label.text isEqualToString:@"调换岗位"]) {
        ChangeJobViewController *wvc=[ChangeJobViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([label.text isEqualToString:@"待审核"]){
        WaitAuditingViewController *wvc=[WaitAuditingViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([label.text isEqualToString:@"签约任务"]){
        SignApplyViewController *wvc=[SignApplyViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([label.text isEqualToString:@"配送开单"]){
        //        [self sendRequest:@"Login" andPath:queryURL andSqlParameter:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"],@"医生"] and:self];
        BillingViewController *rvc=[BillingViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if ([label.text isEqualToString:@"历史记录"]){
        StatisticsViewController *wvc=[StatisticsViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([label.text isEqualToString:@"我的用户"]){
        MyUserViewController *wvc=[MyUserViewController new];
        [self.myTabBarController hidesTabBar];
        [self.navigationController pushViewController:wvc animated:YES];
    }else if ([label.text isEqualToString:@"数据统计"]){
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if ([usd objectForKey:@"auth"]) {
            NSArray *auth=[usd objectForKey:@"auth"];
            if (auth.count>0) {
                CensusViewController *wvc=[CensusViewController new];
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:wvc animated:YES];
            }else{
                [self showSimplePromptBox:self andMesage:@"您暂无对应权限，如需该功能权限，请联系相关人员进行开通！"];
            }
        }else{
            [self showSimplePromptBox:self andMesage:@"获取统计权限失败，请重新登录账号获取！"];
        }
    }else if ([label.text isEqualToString:@"签约录入"]||[label.text isEqualToString:@"导诊"]||[label.text isEqualToString:@"义诊"]||[label.text isEqualToString:@"建档"]){
        NSString *gwuser=[[NSUserDefaults standardUserDefaults] objectForKey:@"gwuser"];
        if (gwuser.length==0) {
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"该功能需要绑定公卫账号！是否现在去绑定？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                GWLoginViewController *gvc=[GWLoginViewController new];
                gvc.whoPush=label.text;
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:gvc animated:YES];
            }];
            [av addAction:sureAC];
            UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
            [av addAction:cancelAC];
            [self presentViewController:av animated:YES completion:nil];
        }else{
            if ([label.text isEqualToString:@"义诊"]){
                FreeDiagnoseViewController *wvc=[FreeDiagnoseViewController new];
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:wvc animated:YES];
            }else if ([label.text isEqualToString:@"导诊"]){
                AddOrderUserViewController *wvc=[AddOrderUserViewController new];
                wvc.whopush=@"BD";
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:wvc animated:YES];
            }else if([label.text isEqualToString:@"签约录入"]){
                SignImportViewController *wvc=[SignImportViewController new];
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:wvc animated:YES];
            }else if ([label.text isEqualToString:@"建档"]){
                if (1) {
                    ChoiceFamilyViewController *ovc=[ChoiceFamilyViewController new];
                    [self.myTabBarController hidesTabBar];
                    [self.navigationController pushViewController:ovc animated:YES];
                }else{
                SearchAreaViewController *ovc=[SearchAreaViewController new];
                [self.myTabBarController hidesTabBar];
                [self.navigationController pushViewController:ovc animated:YES];
                }
            }
        }
    }
}


- (void)saveItemToUserDeful:(UserItem*)item{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([UserItem class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    for (NSString *key in propertiesArray) {
        if (![[item valueForKey:key] isKindOfClass:[NSNull class]]) {
            [usd setObject:[item valueForKey:key] forKey:key];
        }
    }
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
