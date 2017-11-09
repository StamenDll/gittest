//
//  ApplyDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ApplyDetailViewController.h"

@interface ApplyDetailViewController ()

@end

@implementation ApplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"申请单详情"];
    [self addLeftButtonItem];
    [self creatUI];
    
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    
    UIView *contentBackView=[[UIView alloc]initWithFrame:CGRectMake(110, 0,SCREENWIDTH-110,380)];
    contentBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:contentBackView];
    
    UILabel *resultLabel=[self addLabel:CGRectMake(15, 10,95, 20) andText:@"编号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:resultLabel];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15, 50, 95, 20) andText:@"患者姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:nameLabel];
    
    UILabel *phonenumberLabel=[self addLabel:CGRectMake(15,90, 95, 20) andText:@"性别" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:phonenumberLabel];
    
    UILabel *timeLabel=[self addLabel:CGRectMake(15,130, 95, 20) andText:@"年龄" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:timeLabel];
    
    UILabel *explainLabel=[self addLabel:CGRectMake(15,195,80,20) andText:@"主要现病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [mainScrollView addSubview:explainLabel];
    
    UILabel *ressonLabel=[self addLabel:CGRectMake(15,215,80,20) andText:@"（转出原因）" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:1];
    [mainScrollView addSubview:ressonLabel];
    
    UILabel *processLabel=[self addLabel:CGRectMake(15,315,80,20) andText:@"治疗过程" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:processLabel];
    
    
    for (int i=1; i<7; i++) {
        if (i<5) {
            [self addLineLabel:CGRectMake(0, 40*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else{
            [self addLineLabel:CGRectMake(0,160+110*(i-4), SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
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
