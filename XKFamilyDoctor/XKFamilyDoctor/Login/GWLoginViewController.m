//
//  GWLoginViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "GWLoginViewController.h"

@interface GWLoginViewController ()

@end

@implementation GWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"绑定公卫账号"];
    [self addLeftButtonItem];
    self.view.backgroundColor=MAINWHITECOLOR;
    [self creatUI];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [BGScrollView addGestureRecognizer:tap];
    
    UIImageView *aImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,40, 24, 24)];
    aImageView.image=[UIImage imageNamed:@"user"];
    [BGScrollView addSubview:aImageView];
    
    accountsTextField=[[UITextField alloc]initWithFrame:CGRectMake(79, aImageView.frame.origin.y+2, SCREENWIDTH-80, 20)];
    accountsTextField.font=[UIFont fontWithName:FONTTYPEME size:15];
    accountsTextField.placeholder=@"请输入公卫账号";
    [BGScrollView addSubview:accountsTextField];
    
    [self addLineLabel:CGRectMake(79, aImageView.frame.origin.y+37,SCREENWIDTH-119, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UIImageView *pImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, aImageView.frame.origin.y+aImageView.frame.size.height+41, 24, 24)];
    pImageView.image=[UIImage imageNamed:@"password"];
    [BGScrollView addSubview:pImageView];
    
    passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(79, pImageView.frame.origin.y+2, SCREENWIDTH-80, 20)];
    passwordTextField.font=[UIFont fontWithName:FONTTYPEME size:15];
    passwordTextField.placeholder=@"请输入密码";
    passwordTextField.delegate=self;
    passwordTextField.secureTextEntry=YES;
    [BGScrollView addSubview:passwordTextField];
    
    [self addLineLabel:CGRectMake(79, pImageView.frame.origin.y+37,SCREENWIDTH-119, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    //    UIButton *foundKeyButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-100)/2,pImageView.frame.origin.y+47,100,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(foundPWClick:) andText:@"忘记密码？" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
    //    [BGScrollView addSubview:foundKeyButton];
    
    loginButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-200)/2,pImageView.frame.origin.y+80,200,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(loginClick:) andText:@"绑定公卫账号" andFont:SUPERFONT andColor:GREENCOLOR andAlignment:1];
    loginButton.layer.borderColor=GREENCOLOR.CGColor;
    loginButton.layer.borderWidth=0.5;
    [loginButton.layer setCornerRadius:20];
    [BGScrollView addSubview:loginButton];
    
    UIButton *regButton=[self addSimpleButton:CGRectMake((SCREENWIDTH-200)/2,loginButton.frame.origin.y+50,200,40) andBColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoReg) andText:@"注册公卫账号" andFont:SUPERFONT andColor:GREENCOLOR andAlignment:1];
    regButton.layer.borderColor=GREENCOLOR.CGColor;
    regButton.layer.borderWidth=0.5;
    [regButton.layer setCornerRadius:20];
    [BGScrollView addSubview:regButton];
    
    BGScrollView.contentSize=CGSizeMake(SCREENWIDTH, regButton.frame.origin.y+regButton.frame.size.height+40);
}

- (void)loginClick:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *pwString = [passwordTextField.text stringByTrimmingCharactersInSet:set];
        button.selected=YES;
        [self sendRequest:LOGINGWTYPE andPath:LOGINGWGURL andSqlParameter:@{@"id":[NSString stringWithFormat:@"%d",[EMPKEY intValue]],@"username":accountsTextField.text,@"password":passwordTextField.text} and:self];
    }
}

- (void)gotoReg{
    [self showPromptBox:self andMesage:@"确定注册公卫系统账号后，您原来已有公卫账号将无法继续使用，并且原有账号相关的数据无法关联到新注册公卫账号！" andSel:@selector(sureReg)];
}

- (void)sureReg{
    [self showPromptBox:self andMesage:@"此操作不可逆，确定要继续吗？" andSel:@selector(uploadReg)];
}

- (void)uploadReg{
    [self sendRequest:BINDINGTYPE andPath:BINDINGURL andSqlParameter:@{@"id":EMPKEY} and:self];
    
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    loginButton.selected=NO;
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:LOGINGWTYPE]) {
            
        }
        
    }else if ([message isKindOfClass:[NSDictionary class]]) {
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if ([type isEqualToString:BINDINGTYPE]){
            [usd setObject:[NSString stringWithFormat:@"%d",[[message objectForKey:@"gwuser"] intValue]] forKey:@"gwuser"];
            [self showPromptBox:self andMesage:[NSString stringWithFormat:@"公卫账号已注册成功，您的账号为%@,密码与新康助手登录密码一致，请截图保存，以供下次登录使用！",[NSString stringWithFormat:@"%d",[EMPKEY intValue]]] andSel:@selector(goback)];
        }else if ([type isEqualToString:LOGINGWTYPE]){
          [usd setObject:[NSString stringWithFormat:@"%d",[[message objectForKey:@"gwuser"] intValue]] forKey:@"gwuser"];
            [self showPromptBox:self andMesage:@"绑定公卫账号成功！" andSel:@selector(goback)];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)goback{
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (void)requestFail:(NSString *)type{
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
    loginButton.selected=NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


- (void)cancelKeyboard{
    [accountsTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
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
