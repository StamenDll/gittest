//
//  HandleViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HandleViewController.h"

@interface HandleViewController ()

@end

@implementation HandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"申请办结"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-114)];
    [self.view addSubview:mainScrollView];
    
    UIView *labelBackView=[[UIView alloc]initWithFrame:CGRectMake(130, 0,SCREENWIDTH-130,270)];
    labelBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:labelBackView];
    
    UILabel *resultLabel=[self addLabel:CGRectMake(15, 10,100, 20) andText:@"审核结果" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:resultLabel];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(15, 50, 100, 20) andText:@"入院联系人姓名" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:nameLabel];
    
    UILabel *phonenumberLabel=[self addLabel:CGRectMake(15,90, 100, 20) andText:@"入院联系人电话" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:phonenumberLabel];
    
    UILabel *timeLabel=[self addLabel:CGRectMake(15, 130, 100, 20) andText:@"入院时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:timeLabel];
    
    UILabel *explainLabel=[self addLabel:CGRectMake(15,205, 100, 20) andText:@"说明" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:explainLabel];
    
    for (int i=1; i<6; i++) {
        if (i!=5) {
            [self addLineLabel:CGRectMake(0, 40*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else{
            [self addLineLabel:CGRectMake(0,270, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }
    }
    
    UIButton *sureHandleButton=[self addSimpleButton:CGRectMake(37,330, SCREENWIDTH-75, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureHandle:) andText:@"办结" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureHandleButton.layer setCornerRadius:20];
    [mainScrollView addSubview:sureHandleButton];
}

- (void)sureHandle:(UIButton*)button{
    
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
