//
//  FollowListViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/3/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FollowListViewController.h"
#import "FollowUpViewController.h"
@interface FollowListViewController ()

@end

@implementation FollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"随访"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    NSArray *nameArray=@[@"肺结核第一次随访",@"肺结核普通随访",@"精神病患者随访",@"高血压患者随访",@"2型糖尿病随访"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *button=[self addButton:CGRectMake(0, 80+65*i, SCREENWIDTH, 55) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(onclick:)];
        [self.view addSubview:button];
        
        UILabel *menuLabel=[self addLabel:CGRectMake(15, 15,150, 25) andText:[nameArray objectAtIndex:i] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [button addSubview:menuLabel];
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:button];
        [self addLineLabel:CGRectMake(0, 55, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:button];
        
        UIImageView *goImagView=[self addImageView:CGRectMake(SCREENWIDTH-30,20,15,15) andName:@"godetail"];
        [button addSubview:goImagView];
    }
}

- (void)onclick:(UIButton*)button{
    UILabel *label=button.subviews.firstObject;
    FollowUpViewController *fvc=[FollowUpViewController new];
    fvc.peopleOnlyID=self.peopleOnlyID;
    fvc.titleString=label.text;
    if (button.tag==101) {
        fvc.tableName=@"APP_IntoHouseService_FJH_fist";
        fvc.tableAliasName=@"intoHouseServiceFJHFist";
    }else if (button.tag==102) {
        fvc.tableName=@"APP_IntoHouseService_FJH_Normal";
        fvc.tableAliasName=@"intoHouseServiceFJHNormal";
    }else if (button.tag==103) {
        fvc.tableName=@"APP_mental_Normal";
        fvc.tableAliasName=@"mentalNormal";
    }else if (button.tag==104) {
        fvc.tableName=@"APP_hypertension_Normal";
        fvc.tableAliasName=@"hypertensionNormal";
    }else{
        fvc.tableName=@"APP_diabetes_Normal";
        fvc.tableAliasName=@"diabetesNormal";
    }
    [self.navigationController pushViewController:fvc animated:YES];
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
