//
//  FreeDiagnoseViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FreeDiagnoseViewController.h"
#import "AddOrderUserViewController.h"
#import "MyAddPersonViewController.h"
#import "FDItem.h"
#import "CustomProgressView.h"
@interface FreeDiagnoseViewController ()

@end

@implementation FreeDiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"义诊活动"];
    [self addLeftButtonItem];
    dataArray=[NSMutableArray new];
    
    if ([self.whoPush isEqualToString:@"Sta_Y"]) {
        [self sendRequest:@"FreeDiagnoseHis" andPath:queryURL andSqlParameter:[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"] and:self];
    }else{
        [self sendRequest:@"FreeDiagnose" andPath:queryURL andSqlParameter:[[NSUserDefaults standardUserDefaults] objectForKey:@"workorgkey"] and:self];
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if (data.count>0) {
            for (NSDictionary *dic in message) {
                FDItem *item=[RMMapper objectWithClass:[FDItem class] fromDictionary:dic];
                [dataArray addObject:item];
            }
            [self creatUI];
        }else{
            [self addNoDataView];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)requestFail:(NSString *)type{
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    if (self.whoPush.length==0) {
        CustomProgressView *cProgressView=[[CustomProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,80)];
        [cProgressView creatUI:@[@"选择活动",@"身份信息",@"选择挂号医生"] andCount:0];
        [self.view addSubview:cProgressView];
        
        BGScrollView.frame=CGRectMake(0, 144, SCREENWIDTH, SCREENHEIGHT-144);
    }
    
    NSMutableArray *btnArry=[NSMutableArray new];
    for (int i=0; i<dataArray.count; i++) {
        FDItem *item=[dataArray objectAtIndex:i];
        UIButton *fdButton=[self addButton:CGRectMake(0, 0, SCREENWIDTH, 0) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(choiceFD:)];
        [BGScrollView addSubview:fdButton];
        
        UILabel *nameLabel=[self addLabel:CGRectMake(10, 10, SCREENWIDTH-50, 20) andText:[NSString stringWithFormat:@"活动名称:%@",item.sName] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        nameLabel.numberOfLines=0;
        [nameLabel sizeToFit];
        [fdButton addSubview:nameLabel];
        
        
        UILabel *introductionLabel=[self addLabel:CGRectMake(10, nameLabel.frame.size.height+15, SCREENWIDTH-100, 20) andText:item.sContent andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        introductionLabel.numberOfLines=0;
        [introductionLabel sizeToFit];
        [fdButton addSubview:introductionLabel];
        
        UILabel *bTimeLabel=[self addLabel:CGRectMake(10, introductionLabel.frame.origin.y+introductionLabel.frame.size.height+5, SCREENWIDTH-50, 20) andText:[NSString stringWithFormat:@"开始时间:%@",[self getSubTime:item.dBeginTime andFormat:@"yyyy-MM-dd"]] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        [fdButton addSubview:bTimeLabel];
        
        UILabel *eTimeLabel=[self addLabel:CGRectMake(10, bTimeLabel.frame.origin.y+bTimeLabel.frame.size.height+5, SCREENWIDTH-170, 20) andText:[NSString stringWithFormat:@"结束时间:%@",[self getSubTime:item.dEndTime andFormat:@"yyyy-MM-dd"]] andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
        [fdButton addSubview:eTimeLabel];
        
        if (![self.whoPush isEqualToString:@"Sta_Y"]) {
            if ([item.state isEqualToString:@"分诊"]) {
                UIButton *orderButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-150, bTimeLabel.frame.origin.y+10,110, 30) andBColor:GREENCOLOR andTag:101+i andSEL:@selector(orderOnclick:) andText:item.state andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:1];
                [orderButton.layer setCornerRadius:5];
                [fdButton addSubview:orderButton];
            }else{
                UILabel *label=[self addLabel:CGRectMake(SCREENWIDTH-150, bTimeLabel.frame.origin.y+10,110, 30) andText:item.state andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
                [fdButton addSubview:label];
            }
        }
        fdButton.frame=CGRectMake(0, 0, SCREENWIDTH, eTimeLabel.frame.origin.y+30);
        
        
        UIImageView *goImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-24,(fdButton.frame.size.height-14)/2,14,14)];
        goImagView.image=[UIImage imageNamed:@"arrow_2"];
        [fdButton addSubview:goImagView];
        
        [self addLineLabel:CGRectMake(0, fdButton.frame.size.height-0.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fdButton];
        
        if (i>0) {
            UIButton *beforButton=[btnArry objectAtIndex:i-1];
            fdButton.frame=CGRectMake(0, beforButton.frame.origin.y+beforButton.frame.size.height, SCREENWIDTH, fdButton.frame.size.height);
        }
        [btnArry addObject:fdButton];
        BGScrollView.contentSize=CGSizeMake(0, fdButton.frame.origin.y+fdButton.frame.size.height+40);
    }
}

- (void)choiceFD:(UIButton*)button{
    FDItem *item=[dataArray objectAtIndex:button.tag-101];
    MyAddPersonViewController *avc=[MyAddPersonViewController new];
    avc.fdSid=item.sID;
    if (self.whoPush.length>0) {
        avc.whoPush=self.whoPush;
    }else{
        avc.whoPush=@"FD";
    }
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)orderOnclick:(UIButton*)button{
    FDItem *item=[dataArray objectAtIndex:button.tag-101];
    AddOrderUserViewController *avc=[AddOrderUserViewController new];
    avc.fdItem=item;
    avc.whopush=@"FD";
    [self.navigationController pushViewController:avc animated:YES];
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
