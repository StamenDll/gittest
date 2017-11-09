//
//  StaffCenterViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "StaffCenterViewController.h"
#import "EntryRegViewController.h"
@interface StaffCenterViewController ()

@end

@implementation StaffCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  addTitleView:@"新康员工中心"];
    [self creatUI];
    
}

- (void)creatUI{
    mainBGVSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT)];
    mainBGVSrollView.backgroundColor=MAINWHITECOLOR;
    [self.view addSubview:mainBGVSrollView];
    
    UIView *phoneBGView=[self addSimpleBackView:CGRectMake(20, 30, SCREENWIDTH-150, 40) andColor:CLEARCOLOR];
    phoneBGView.layer.borderColor=LINECOLOR.CGColor;
    phoneBGView.layer.borderWidth=0.5;
    [phoneBGView.layer setCornerRadius:5];
    [mainBGVSrollView addSubview:phoneBGView];
    
    
    getCodeButton=[self addCurrencyButton:CGRectMake(SCREENWIDTH-120, 35,100,30) andText:@"获取验证码" andSEL:@selector(getCode:)];
    [mainBGVSrollView addSubview:getCodeButton];
    
    phoneTextField=[self addTextfield:CGRectMake(5, 5, phoneBGView.frame.size.width-10, 30) andPlaceholder:@"请输入手机号码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;

    [phoneBGView addSubview:phoneTextField];
    
    UIView *codeBGView=[self addSimpleBackView:CGRectMake(20, phoneBGView.frame.origin.y+phoneBGView.frame.size.height+10,120, 40) andColor:CLEARCOLOR];
    codeBGView.layer.borderColor=LINECOLOR.CGColor;
    codeBGView.layer.borderWidth=0.5;
    [codeBGView.layer setCornerRadius:5];
    [mainBGVSrollView addSubview:codeBGView];
    
    codeTextField=[self addTextfield:CGRectMake(5, 5, codeBGView.frame.size.width-10, 30) andPlaceholder:@"请输入验证码" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    [codeBGView addSubview:codeTextField];
    
    UIButton *loginButton=[self addCurrencyButton:CGRectMake(20, codeBGView.frame.origin.y+codeBGView.frame.size.height+10, SCREENWIDTH-40, 40) andText:@"登录" andSEL:nil];
    [mainBGVSrollView addSubview:loginButton];
    
    [self addLineLabel:CGRectMake(0, loginButton.frame.origin.y+loginButton.frame.size.height+30, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainBGVSrollView];
    
    UIButton *newStaffButton=[self addCurrencyButton:CGRectMake(20, loginButton.frame.origin.y+loginButton.frame.size.height+60, SCREENWIDTH-40, 40) andText:@"新员工注册" andSEL:@selector(newEntryReg)];
    [mainBGVSrollView addSubview:newStaffButton];
    
    UIButton *changeWorkUnitButton=[self addCurrencyButton:CGRectMake(20, newStaffButton.frame.origin.y+newStaffButton.frame.size.height+10, SCREENWIDTH-40, 40) andText:@"更换工作单位" andSEL:nil];
    [mainBGVSrollView addSubview:changeWorkUnitButton];
    
    UIButton *waitButton=[self addCurrencyButton:CGRectMake(20, changeWorkUnitButton.frame.origin.y+changeWorkUnitButton.frame.size.height+10, SCREENWIDTH-40, 40) andText:@"待审核列表" andSEL:nil];
    [mainBGVSrollView addSubview:waitButton];
}

- (void)newEntryReg{
    EntryRegViewController *evc=[EntryRegViewController new];
    [self.navigationController pushViewController:evc animated:YES];
}

- (void)getCode:(UIButton*)button{
    if (button.selected==NO) {
        if (![self checkPhoneNumber:phoneTextField.text]){
            [self showSimplePromptBox:self andMesage:@"请输入正确的手机号码"];
        }else{
            [self sendRequest:GETVCTYPE andPath:getVCode andSqlParameter:@{@"mobile":phoneTextField.text} and:self];
            button.selected=YES;
        }
    }
}

- (void)scrollToNextPage{
    for (UIView *subView in [getCodeButton subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel*)subView;
            maCount-=1;
            if (maCount>0) {
                label.text=[NSString stringWithFormat:@"重新发送(%ld)",(long)maCount];
            }else{
                label.text=@"获取验证码";
                getCodeButton.selected=NO;
                [timer invalidate];
                timer=nil;
            }
        }
    }
}

- (void)startAutoScroll{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:GETVCTYPE]) {
            UILabel *label=[[getCodeButton subviews] objectAtIndex:0];
            label.text=@"重新获取(60)";
            maCount=60;
            [self startAutoScroll];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
    getCodeButton.selected=NO;
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
