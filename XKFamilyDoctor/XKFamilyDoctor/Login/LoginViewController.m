//
//  LoginViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LoginViewController.h"
#import "BusinessViewController.h"
#import "CenterViewController.h"
#import "FoundPWViewController.h"
#import "UserItem.h"
#import <objc/runtime.h>
#import "VPKCClientManager.h"
#import "AppDelegate+SetNews.h"
#import "EntryRegViewController.h"
#import "ArchiveClass.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=MAINWHITECOLOR;
    [self creatUI];
    [self sendRequest:CHECKUPDATATYPE andPath:CHECKUPDATAURL andSqlParameter:nil and:self];
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    if ([self.isChangeSuccess isEqualToString:@"Y"]) {
        [self showSimplePromptBox:self andMesage:@"密码修改成功，您可以重新登录了！"];
        self.isChangeSuccess=nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:BGScrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [BGScrollView addGestureRecognizer:tap];
    
    UIImageView *logImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-118)/2,SCREENHEIGHT/7,118,118)];
    logImageView.image=[UIImage imageNamed:@"logo"];
    [BGScrollView addSubview:logImageView];
    
    
    UIImageView *aImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,logImageView.frame.origin.y+logImageView.frame.size.height+80, 24, 24)];
    aImageView.image=[UIImage imageNamed:@"user"];
    [BGScrollView addSubview:aImageView];
    
    accountsTextField=[[UITextField alloc]initWithFrame:CGRectMake(79, aImageView.frame.origin.y+2, SCREENWIDTH-80, 20)];
    accountsTextField.font=[UIFont fontWithName:FONTTYPEME size:15];
    accountsTextField.placeholder=@"请输入手机号";
    //    accountsTextField.text=@"13108690718";
    accountsTextField.keyboardType=UIKeyboardTypeNumberPad;
    [BGScrollView addSubview:accountsTextField];
    
    [self addLineLabel:CGRectMake(79, aImageView.frame.origin.y+37,SCREENWIDTH-119, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UIImageView *pImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, aImageView.frame.origin.y+aImageView.frame.size.height+41, 24, 24)];
    pImageView.image=[UIImage imageNamed:@"password"];
    [BGScrollView addSubview:pImageView];
    
    passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(79, pImageView.frame.origin.y+2, SCREENWIDTH-80, 20)];
    passwordTextField.font=[UIFont fontWithName:FONTTYPEME size:15];
    passwordTextField.delegate=self;
    passwordTextField.placeholder=@"密码";
    passwordTextField.delegate=self;
    passwordTextField.secureTextEntry=YES;
    [BGScrollView addSubview:passwordTextField];
    
    [self addLineLabel:CGRectMake(79, pImageView.frame.origin.y+37,SCREENWIDTH-119, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    NSString *mesage=@"请选择区域";
    if (CHOICEURL) {
        mesage=CHOICEURL;
    }
    choiceURLButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-120,20,100,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceURL) andText:mesage andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:2];
    [BGScrollView addSubview:choiceURLButton];
    
    loginButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-200)/2,pImageView.frame.origin.y+60,200,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(loginClick:) andText:@"登录" andFont:SUPERFONT andColor:GREENCOLOR andAlignment:1];
    loginButton.layer.borderColor=GREENCOLOR.CGColor;
    loginButton.layer.borderWidth=0.5;
    [loginButton.layer setCornerRadius:20];
    [BGScrollView addSubview:loginButton];
    
    UIButton *regButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-200)/2,loginButton.frame.origin.y+50,200,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoReg) andText:@"注册" andFont:SUPERFONT andColor:GREENCOLOR andAlignment:1];
    regButton.layer.borderColor=GREENCOLOR.CGColor;
    regButton.layer.borderWidth=0.5;
    [regButton.layer setCornerRadius:20];
    [BGScrollView addSubview:regButton];
    
    UIButton *foundKeyButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-80)/2,regButton.frame.origin.y+50,80,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(foundPWClick:) andText:@"忘记密码？" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
    [BGScrollView addSubview:foundKeyButton];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    UILabel *versionLabel=[self addLabel:CGRectMake(0, foundKeyButton.frame.origin.y+foundKeyButton.frame.size.height+5, SCREENWIDTH, 20) andText:[NSString stringWithFormat:@"V%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [BGScrollView addSubview:versionLabel];
    
    BGScrollView.contentSize=CGSizeMake(SCREENWIDTH, foundKeyButton.frame.origin.y+foundKeyButton.frame.size.height+80);
}


- (void)choiceURL{
    [self sendRequest:GETURLLISTTYPE andPath:GETURLLIST andSqlParameter:@"GET" and:self];
}

- (void)printChoiceURL:(NSString*)url{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [usd setObject:url forKey:URLSAVENAME];
    [printView cancel];
    [self showSimplePromptBox:self andMesage:@"选择服务器成功，您可以继续操作了！"];
    [self setChoieURL];
    UILabel *label=[[choiceURLButton subviews] lastObject];
    label.text=[[NSUserDefaults standardUserDefaults] objectForKey:URLSAVENAME];
}

- (void)cancelPrinView{};

- (void)gotoReg{
    if (!CHOICEURL){
        [self showSimplePromptBox:self andMesage:@"请先点击右上角选择您所属的区域！"];
    }else{
        EntryRegViewController *evc=[EntryRegViewController new];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:evc animated:YES];
    }
}

- (void)foundPWClick:(UIButton*)button{
    if (!CHOICEURL){
        [self showSimplePromptBox:self andMesage:@"请先点击右上角选择您所属的区域！"];
    }else{
        FoundPWViewController *fvc=[FoundPWViewController new];
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:fvc animated:YES];
    }
}

- (void)loginClick:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *pwString = [passwordTextField.text stringByTrimmingCharactersInSet:set];
        if (![self checkPhoneNumber:accountsTextField.text]){
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else if (!CHOICEURL){
            [self showSimplePromptBox:self andMesage:@"请先点击右上角选择您所属的区域！"];
        }else{
            button.selected=YES;
            [self sendRequest:USERLOGINTYPE andPath:USERLOGIN andSqlParameter:@{@"authtype":@"2",@"username":accountsTextField.text,@"password":passwordTextField.text} and:self];
        }
    }
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
            [self.view addSubview:updataBGView];
            
            UIImage *updataImage=[UIImage imageNamed:@"version_bg"];
            UIView *sBGView=[self addSimpleBackView:CGRectMake((SCREENWIDTH-250)/2,0,250,250/updataImage.size.width*updataImage.size.height+100) andColor:MAINWHITECOLOR];
            sBGView.center=self.view.center;
            [sBGView.layer setCornerRadius:10];
            sBGView.tag=12;
            [self.view addSubview:sBGView];
            
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
        NSMutableArray *nameArray=[NSMutableArray new];
        NSArray *host=[urldic objectForKey:@"host"];
        for (NSDictionary *dic in host) {
            if ([[dic objectForKey:@"app_enable"] isEqualToString:@"true"]) {
                [nameArray addObject:[dic objectForKey:@"orgName"]]; 
            }
        }
        printView=[[PrintView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
        printView.delegate=self;
        [self.navigationController.view addSubview:printView];
        [printView creatUI:nameArray andPrintID:@"" andTitle:@"选择服务器"];
    }
    else{
        loginButton.selected=NO;
        if ([message isKindOfClass:[NSArray class]]) {
            NSArray *data=message;
            for (NSDictionary *dic in data) {
                UserItem *item=[RMMapper objectWithClass:[UserItem class] fromDictionary:dic];
                [self saveItemToUserDeful:item];
            }
            [self creatTabBarController];
        }else{
            [self showSimplePromptBox:self andMesage:message];
        }
    }
}

- (void)requestFail:(NSString *)type{
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
    loginButton.selected=NO;
}

- (void)updataNow{
    NSString*urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",plistUrl];
    
    NSURL*url  = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)cancelUpload{
    UIView *fBGVIew=(UIView*)[self.view viewWithTag:11];
    UIView *sBGVIew=(UIView*)[self.view viewWithTag:12];
    UIView *tBGVIew=(UIView*)[self.view viewWithTag:13];
    [fBGVIew removeFromSuperview];
    [sBGVIew removeFromSuperview];
    [tBGVIew removeFromSuperview];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)creatTabBarController{
    BusinessViewController *bvc=[BusinessViewController new];
    UINavigationController *nbvc=[[UINavigationController alloc]initWithRootViewController:bvc];
    
    CenterViewController *cvc=[[CenterViewController alloc]init];
    UINavigationController *ncvc=[[UINavigationController alloc]initWithRootViewController:cvc];
    
    MyTabBarController *tabVC=[[MyTabBarController alloc]init];
    NSArray *nvcAry=[NSArray arrayWithObjects:nbvc,ncvc,nil];
    tabVC.viewControllers=nvcAry;
    [self presentViewController:tabVC animated:YES completion:nil];
}

- (void)cancelKeyboard{
    [accountsTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    BGScrollView.frame=CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    BGScrollView.frame=CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT);
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
