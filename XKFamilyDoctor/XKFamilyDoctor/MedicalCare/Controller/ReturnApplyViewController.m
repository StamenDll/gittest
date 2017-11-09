//
//  ReturnApplyViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReturnApplyViewController.h"
#import "ReferralViewController.h"
#import "ReferraItem.h"
#import "ReferralOutItem.h"
@interface ReturnApplyViewController ()

@end

@implementation ReturnApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"退回申请"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    UIView *labelBackView=[[UIView alloc]initWithFrame:CGRectMake(110,64,SCREENWIDTH-110,110)];
    labelBackView.backgroundColor=MAINWHITECOLOR;
    [self.view  addSubview:labelBackView];
    
    UILabel *resultLabel=[self addLabel:CGRectMake(15,109,80, 20) andText:@"退回原因" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.view addSubview:resultLabel];
    
    reasonTextView=[[UITextView alloc]initWithFrame:CGRectMake(125,70, SCREENWIDTH-140,100)];
    reasonTextView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    reasonTextView.textColor=TEXTCOLOR;
    [self.view addSubview:reasonTextView];
    
    [self addLineLabel:CGRectMake(0,labelBackView.frame.size.height+labelBackView.frame.origin.y, SCREENHEIGHT, 0.5) andColor:LINECOLOR andBackView:self.view];
    
    sureBackButton=[self addSimpleButton:CGRectMake(37,labelBackView.frame.size.height+labelBackView.frame.origin.y+60, SCREENWIDTH-75, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureBack) andText:@"退回" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureBackButton.layer setCornerRadius:20];
    [self.view addSubview:sureBackButton];
}


- (void)sureBack{
    if (sureBackButton.selected==NO) {
        if (reasonTextView.text.length==0) {
            [self showSimplePromptBox:self andMesage:@"退回原因不能为空"];
        }else{
            sureBackButton.selected=YES;
            NSString *reID=nil;
            if ([self.Item isKindOfClass:[ReferraItem class]]) {
                ReferraItem *newItem=(ReferraItem*)self.Item;
                reID=newItem.ID;
            }else{
                ReferralOutItem *newItem=(ReferralOutItem*)self.Item;
                reID=newItem.ID;
            }
            [self sendRequest:@"SureBack" andPath:excuteURL andSqlParameter:@[reID,@"退回",reasonTextView.text] and:self];
        }
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"SureBack"]) {
            sureBackButton.selected=NO;
            UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"退回成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:av animated:YES completion:nil];
            [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ReferralViewController class]]) {
            ReferralViewController *pvc=(ReferralViewController*)vc;
            if ([self.Item isKindOfClass:[ReferraItem class]]) {
                pvc.isChange=@"in";
            }else{
                pvc.isChange=@"out";
            }
            [self.navigationController popToViewController:pvc animated:YES];
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
