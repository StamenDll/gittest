//
//  InviteViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"APP二维码"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    UIView *codeBackViewO=[self addSimpleBackView:CGRectMake((SCREENWIDTH-290)/2, 109, 290,40) andColor:GREENCOLOR];
    [self.view addSubview:codeBackViewO];
    
    UILabel *adviceLabel=[self addLabel:CGRectMake(0, 10, 290, 20) andText:@"扫描二维码，下载新康助手app" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [codeBackViewO addSubview:adviceLabel];
    
    UIView *codeBackViewT=[self addSimpleBackView:CGRectMake((SCREENWIDTH-290)/2,codeBackViewO.frame.origin.y+codeBackViewO.frame.size.height, 290,230) andColor:MAINWHITECOLOR];
    [self.view addSubview:codeBackViewT];
    
    self.codeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 190, 190)];
    self.codeImageView.image=[UIImage imageNamed:@"QRCode"];
    [codeBackViewT addSubview:self.codeImageView];

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
