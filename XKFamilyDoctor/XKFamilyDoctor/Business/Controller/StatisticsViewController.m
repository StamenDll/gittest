//
//  StatisticsViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "StatisticsViewController.h"
#import "FreeDiagnoseViewController.h"
#import "MyAddPersonViewController.h"
#import "ChangePostHisViewController.h"
@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"历史记录"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    mainSrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:mainSrollView];
    
    NSArray *nameArray=@[@"义诊",@"导诊",@"调换岗位"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *menuButton=[self addButton:CGRectMake(0, 10+60*i, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(menuOnclik:)];
        [mainSrollView addSubview:menuButton];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:menuButton];
        [self addLineLabel:CGRectMake(0,menuButton.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:menuButton];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 15, SCREENWIDTH-50, 20) andText:[nameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [menuButton addSubview:nameLabel];
        
        [self addGotoNextImageView:menuButton];
    }
}

- (void)menuOnclik:(UIButton*)button{
    if (button.tag==101) {
        FreeDiagnoseViewController *fvc=[FreeDiagnoseViewController new];
        fvc.whoPush=@"Sta_Y";
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (button.tag==102){
        MyAddPersonViewController *fvc=[MyAddPersonViewController new];
        fvc.whoPush=@"Sta_D";
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (button.tag==103){
        ChangePostHisViewController *fvc=[ChangePostHisViewController new];
        [self.navigationController pushViewController:fvc animated:YES];
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
