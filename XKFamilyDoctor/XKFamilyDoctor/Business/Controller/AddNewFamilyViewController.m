//
//  AddNewFamilyViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/11/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddNewFamilyViewController.h"

@interface AddNewFamilyViewController ()

@end

@implementation AddNewFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"添加家庭"];
    [self addLeftButtonItem];
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
