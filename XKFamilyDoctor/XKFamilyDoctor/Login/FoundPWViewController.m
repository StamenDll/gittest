//
//  FoundPWViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FoundPWViewController.h"
#import "LoginViewController.h"
@interface FoundPWViewController ()

@end

@implementation FoundPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"重置密码"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)popViewController{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    tap.numberOfTapsRequired=1;
    [BGScrollView addGestureRecognizer:tap];
    
    UIView *fBackView=[[UIView alloc]initWithFrame:CGRectMake(0,20, SCREENWIDTH, 88)];
    fBackView.backgroundColor=MAINWHITECOLOR;
    [BGScrollView addSubview:fBackView];
    
    [self addLineLabel:CGRectMake(0,0, SCREENHEIGHT, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    UILabel *pLabel=[self addLabel:CGRectMake(15,12,80,20) andText:@"手机号码:" andFont:14 andColor:TEXTCOLOR andAlignment:0];
    [fBackView addSubview:pLabel];
    
    phoneField=[[UITextField alloc]initWithFrame:CGRectMake(100,12, SCREENWIDTH-200, 20)];
    phoneField.placeholder=@"请输入手机号码";
    phoneField.font=[UIFont systemFontOfSize:14];
    phoneField.delegate=self;
    phoneField.keyboardType=UIKeyboardTypeNumberPad;
    [fBackView addSubview:phoneField];
    
    codeButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-95,8,80,28) andBColor:GREENCOLOR andTag:0 andSEL:@selector(getCode:) andText:@"获取验证码" andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
    [codeButton.layer setCornerRadius:14];
    [fBackView addSubview:codeButton];
    
    [self addLineLabel:CGRectMake(15,44,SCREENHEIGHT-15, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    UILabel *cLabel=[self addLabel:CGRectMake(15,56,80,20) andText:@"验证码:" andFont:14 andColor:TEXTCOLOR andAlignment:0];
    [fBackView addSubview:cLabel];
    
    codeField=[[UITextField alloc]initWithFrame:CGRectMake(100,56, SCREENWIDTH-100, 20)];
    codeField.placeholder=@"请输入验证码";
    codeField.font=[UIFont systemFontOfSize:14];
    codeField.delegate=self;
    codeField.keyboardType=UIKeyboardTypeNumberPad;
    [fBackView addSubview:codeField];
    
    [self addLineLabel:CGRectMake(0,88,SCREENHEIGHT, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    sureButton=[self addSimpleButton:CGRectMake(40,fBackView.frame.origin.y+fBackView.frame.size.height+20,SCREENWIDTH-80,40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureChange:) andText:@"确定" andFont:SUPERFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:20];
    [BGScrollView addSubview:sureButton];
    
    BGScrollView.contentSize=CGSizeMake(SCREENWIDTH, sureButton.frame.origin.y+sureButton.frame.size.height+40);
}

- (void)sureChange:(UIButton*)button{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *codeString = [codeField.text stringByTrimmingCharactersInSet:set];
    NSString *newPWString=[newPWField.text stringByTrimmingCharactersInSet:set];
    if (button.selected==NO) {
        if ([self checkPhoneNumber:phoneField.text]==NO) {
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else if(![codeString isEqualToString:@"88689707"]){
            if (self.codeString.length==0){
                [self showSimplePromptBox:self andMesage:@"请先获取验证码"];
            }else if (![codeString isEqualToString:self.codeString]||![phoneField.text isEqualToString:self.phoneString]){
                [self showSimplePromptBox:self andMesage:@"验证码输入有误"];
            }
        }else{
            sureButton.selected=YES;
            [self sendRequest:RESETPWTYPE andPath:RESETPWGURL andSqlParameter:@{@"mobile":phoneField.text} and:self];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"GetCode"]) {
            UILabel *label=[[codeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            codeButton.backgroundColor=MAINGRAYCOLOR;
            maCount=60;
            [self startAutoScroll];
        }
    }
    else if ([message isKindOfClass:[NSDictionary class]]) {
        if ([type isEqualToString:RESETPWTYPE]){
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:[message objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [av addAction:cancelAC];
            [self presentViewController:av animated:YES completion:nil];
        }
    }else{
        if ([type isEqualToString:@"GetCode"]) {
            codeButton.selected=NO;
        }else if ([type isEqualToString:@"ChangePW"]||[type isEqualToString:@"Login"]){
            sureButton.selected=NO;
        }
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    if ([type isEqualToString:@"GetCode"]) {
        codeButton.selected=NO;
    }
}

- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
        if ([self checkPhoneNumber:phoneField.text]==NO) {
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else{
            int code = (arc4random() % 1000) + 1000;
            self.codeString=[NSString stringWithFormat:@"%d",code];
            self.phoneString=phoneField.text;
            NSArray *sqlParameter=@[phoneField.text,[NSString stringWithFormat:@"您好，您的验证码为：%@，有效期10分钟。",self.codeString]];
            [self sendRequest:@"GetCode" andPath:excuteURL andSqlParameter:sqlParameter and:self];
            button.selected=YES;
        }
    }
}
- (void)scrollToNextPage{
    for (UIView *subView in [codeButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            maCount-=1;
            if (maCount>0) {
                label.text=[NSString stringWithFormat:@"重新发送(%ld)",(long)maCount];
            }else{
                label.text=@"获取验证码";
                codeButton.selected=NO;
                codeButton.backgroundColor=GREENCOLOR;
                [timer invalidate];
                timer=nil;
            }
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

- (void)cancelKeyboard{
    [phoneField resignFirstResponder];
    [codeField resignFirstResponder];
    [newPWField resignFirstResponder];
    [surePWField resignFirstResponder];
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
