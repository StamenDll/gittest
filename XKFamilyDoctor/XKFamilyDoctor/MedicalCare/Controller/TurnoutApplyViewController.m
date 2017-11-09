//
//  TurnoutApplyViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TurnoutApplyViewController.h"

@interface TurnoutApplyViewController ()

@end

@implementation TurnoutApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"转出申请"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:mainScrollView];
    
    UIView *labelBackView=[[UIView alloc]initWithFrame:CGRectMake(110, 0,SCREENWIDTH-110,450)];
    labelBackView.backgroundColor=MAINWHITECOLOR;
    [mainScrollView addSubview:labelBackView];
    
    UILabel *firstLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"初步印象" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:firstLabel];
    
    UILabel *newSicknessLabel=[self addLabel:CGRectMake(15,85, 100, 20) andText:@"主要既往史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:newSicknessLabel];
    
    UILabel *oldSicknessLabel=[self addLabel:CGRectMake(15,195, 100, 20) andText:@"主要现病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:oldSicknessLabel];
    
    UILabel *curePLabel=[self addLabel:CGRectMake(15,305,95, 20) andText:@"治疗过程" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:curePLabel];
    
    UILabel *hospitalLabel=[self addLabel:CGRectMake(15,380,95, 20) andText:@"申请转入科室" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:hospitalLabel];
    
    UILabel *departmentLabel=[self addLabel:CGRectMake(15,420, 95, 20) andText:@"申请转入医院" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [mainScrollView addSubview:departmentLabel];
    
    for (int i=1; i<7; i++) {
        if (i==1) {
            [self addLineLabel:CGRectMake(0, 40, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else if (i<5){
            [self addLineLabel:CGRectMake(0,40+110*(i-1), SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }else{
            [self addLineLabel:CGRectMake(0,370+40*(i-4), SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:mainScrollView];
        }
    }
    
    UIButton *sureHandleButton=[self addSimpleButton:CGRectMake(37,labelBackView.frame.origin.y+labelBackView.frame.size.height+60, SCREENWIDTH-75, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureUpload:) andText:@"提交" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [sureHandleButton.layer setCornerRadius:20];
    [mainScrollView addSubview:sureHandleButton];
}

- (void)sureUpload:(UIButton*)button{
    
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
