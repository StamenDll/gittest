//
//  InApplyDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InApplyDetailViewController.h"

@interface InApplyDetailViewController ()

@end

@implementation InApplyDetailViewController

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
    
    UIView *labelBackView=[[UIView alloc]initWithFrame:CGRectMake(130, 0,SCREENWIDTH-130,500)];
    labelBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:labelBackView];
    
    UILabel *numberLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"档案编号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:numberLabel];
    
    UILabel *communityLabel=[self addLabel:CGRectMake(15, 50, 100, 20) andText:@"社区名称" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:communityLabel];
    
    UILabel *receiveDNLabel=[self addLabel:CGRectMake(15,90,110, 20) andText:@"接诊医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:receiveDNLabel];
    
    UILabel *diagnosisRLabel=[self addLabel:CGRectMake(15,130,110, 20) andText:@"诊断结果" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:diagnosisRLabel];
    
    UILabel *patientNumberLabel=[self addLabel:CGRectMake(15,170,110, 20) andText:@"住院病案号" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:patientNumberLabel];
    
    UILabel *inspectionRLabel=[self addLabel:CGRectMake(15,245,110, 20) andText:@"主要检查结果" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:inspectionRLabel];
    
    UILabel *treatPLabel=[self addLabel:CGRectMake(15,355,110, 20) andText:@"治疗经过" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:treatPLabel];
    
    UILabel *referralDLabel=[self addLabel:CGRectMake(15,430,110, 20) andText:@"转诊医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:referralDLabel];
    
    UILabel *pnLabel=[self addLabel:CGRectMake(15,470,110, 20) andText:@"联系电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:pnLabel];
    
    for (int i=1; i<10; i++) {
        if (i<6) {
            [self addLineLabel:CGRectMake(0, 40*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else if(i<8){
            [self addLineLabel:CGRectMake(0,200+110*(i-5), SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else{
            [self addLineLabel:CGRectMake(0,420+40*(i-7), SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
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
