//
//  MyDeviceViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "AddBPViewController.h"
#import "AddDeviceViewController.h"
#import "ArchiveClass.h"
@interface MyDeviceViewController ()

@end

@implementation MyDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"我的设备"];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self creatUI];
}

- (void)addRightButtonItem{
    UIButton *rButton=[self addSimpleButton:CGRectMake(0, 0, 60,40) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(addNewDvice) andText:@"添加设备" andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
    
    UIBarButtonItem *rItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=rItem;
}

- (void)addNewDvice{
    AddDeviceViewController *avc=[AddDeviceViewController new];
    avc.whoChoice=self.whoChoice;
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)creatUI{
    if ([[ArchiveClass new] getLocalDeviceUUID:self.whoChoice].length>0) {
        UIButton *deviceButton=[self addButton:CGRectMake(0, NAVHEIGHT+10, SCREENWIDTH,60) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(sureChoiceDevice)];
        [self.view addSubview:deviceButton];
        
        NSString *dNameString=@"捷美瑞B07T智能血压仪";
        UIImageView *dImageView=[self addImageView:CGRectMake(10, 2, 56, 56) andName:@"img_blood pressure"];
        if ([self.whoChoice isEqualToString:@"S"]) {
            dImageView.image=[UIImage imageNamed:@"img_blood sugar"];
            dNameString=@"三诺WL-1血糖仪";
        }
        [deviceButton addSubview:dImageView];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:deviceButton];
        [self addLineLabel:CGRectMake(0, 59.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:deviceButton];
        
        [self addGotoNextImageView:deviceButton];
        
        [self addLabel:CGRectMake(75, 20, SCREENWIDTH-85, 20) andText:dNameString andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:deviceButton];
    }else{
        [self addNoDataView];
    }
    
}

- (void)sureChoiceDevice{
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[AddBPViewController class]]) {
            AddBPViewController *mvc=(AddBPViewController*)nvc;
            mvc.choiceDevice=@"Y";
            [self.navigationController popToViewController:mvc animated:YES];
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
