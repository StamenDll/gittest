
//
//  ChangePWViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChangePWViewController.h"
#import "LoginViewController.h"
@interface ChangePWViewController ()

@end

@implementation ChangePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"修改密码"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [BGScrollView addGestureRecognizer:tap];
    
    UIView *FBGView=[self addSimpleBackView:CGRectMake(0, 15, SCREENWIDTH, 110) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:FBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
    [self addLineLabel:CGRectMake(15,55, SCREENWIDTH-15, 0.5) andColor:LINECOLOR andBackView:FBGView];
    [self addLineLabel:CGRectMake(0,110, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
    
    oldPWTextField=[self addTextfield:CGRectMake(15, 18, SCREENWIDTH-30, 20) andPlaceholder:@"当前密码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    oldPWTextField.delegate=self;
    oldPWTextField.secureTextEntry=YES;
    [FBGView addSubview:oldPWTextField];
    
    newPWTextField=[self addTextfield:CGRectMake(15,73, SCREENWIDTH-30, 20) andPlaceholder:@"新密码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    newPWTextField.delegate=self;
    newPWTextField.secureTextEntry=YES;
    [FBGView addSubview:newPWTextField];
    
    
    UIView *SBGView=[self addSimpleBackView:CGRectMake(0,FBGView.frame.origin.y+FBGView.frame.size.height+10, SCREENWIDTH, 55) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:SBGView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:SBGView];
    [self addLineLabel:CGRectMake(0,55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:SBGView];
    
    sureNewPWTextField=[self addTextfield:CGRectMake(15, 18, SCREENWIDTH-30, 20) andPlaceholder:@"确认新密码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    sureNewPWTextField.delegate=self;
    sureNewPWTextField.secureTextEntry=YES;
    [SBGView addSubview:sureNewPWTextField];
    
    overButton=[self addCurrencyButton:CGRectMake(40, SBGView.frame.origin.y+SBGView.frame.size.height+40, SCREENWIDTH-80, 40) andText:@"提交" andSEL:@selector(sureChangePW)];
    [BGScrollView addSubview:overButton];
}

- (void)sureChangePW{
    if (overButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *oldPWString = [oldPWTextField.text stringByTrimmingCharactersInSet:set];
        NSString *newPWString = [newPWTextField.text stringByTrimmingCharactersInSet:set];
        NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
        if (oldPWString.length==0) {
            [self showSimplePromptBox:self andMesage:@"请输入当前密码！"];
        }else if (newPWString.length==0){
            [self showSimplePromptBox:self andMesage:@"请输入新密码！"];
        }else if (![sureNewPWTextField.text isEqualToString:newPWString]){
            [self showSimplePromptBox:self andMesage:@"两次密码输入不一致！"];
        }else{
            overButton.selected=YES;
            NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
            [self sendRequest:CHANGEPWTYPE andPath:CHANGEPWTAURL andSqlParameter:@{@"username":[usd objectForKey:@"mobile"],@"authtype":@"2",@"newpassword":newPWString,@"oldpassword":oldPWString} and:self];
        }
        
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    overButton.selected=NO;
    if([message isKindOfClass:[NSDictionary class]]){
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"密码修改成功！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }

}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFail:(NSString *)type{
    overButton.selected=NO;
    [self showSimplePromptBox:self andMesage:@"服务器开小差了，请稍后重试！"];
}

- (void)cancelKeyboard{
    [oldPWTextField resignFirstResponder];
    [newPWTextField resignFirstResponder];
    [sureNewPWTextField resignFirstResponder];
}

//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    BGScrollView.frame=CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64-size.height);
}

//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    BGScrollView.frame=CGRectMake(0,64, SCREENWIDTH,SCREENHEIGHT-64);
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
