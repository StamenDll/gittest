//
//  ChoiceHouseholdViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoiceHouseholdViewController.h"
#import "ChoiceNowAreaViewController.h"
#import "HouseholdItem.h"
@interface ChoiceHouseholdViewController ()

@end

@implementation ChoiceHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择住户"];
    [self addLeftButtonItem];
    mainDataArray=[NSMutableArray new];
    unitArray=[NSMutableArray new];
    [self sendRequest:GETHHTYPE andPath:GETHHURL andSqlParameter:@{@"orgid":self.orgid,@"AreaID":self.AreaID,@"UnitID":self.UnitID} and:self];
}

- (void)changeChoice:(UIButton*)button{
    UIView *choiceBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andColor:CLEARCOLOR];
    choiceBGView.tag=11;
    [self.navigationController.view addSubview:choiceBGView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBabyChoiceView)];
    tap.numberOfTapsRequired=1;
    [choiceBGView addGestureRecognizer:tap];
    
    UIImageView *babyMenuView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-85, 64, 85, 170)];
    babyMenuView.tag=12;
    babyMenuView.userInteractionEnabled=YES;
    UIImage* image =[UIImage imageNamed:@"babyChoice"];
    [babyMenuView setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 40, 35, 40) resizingMode:UIImageResizingModeStretch]];
    [self.navigationController.view addSubview:babyMenuView];
    
    UIScrollView *menuBgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,10, 85, 160)];
    [babyMenuView addSubview:menuBgScrollView];
    
    for (int i=0; i<unitArray.count; i++) {
        NSString *unitStr=[unitArray objectAtIndex:i];
        UIButton *babyButton=[self addSimpleButton:CGRectMake(0, 40*i, 85, 40) andBColor:CLEARCOLOR andTag:101+i andSEL:@selector(sureChoiceButton:) andText:[NSString stringWithFormat:@"%@单元",unitStr] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [menuBgScrollView addSubview:babyButton];
        if (i>0) {
            [self addLineLabel:CGRectMake(5, 0, 75, 0.5) andColor:LINECOLOR andBackView:babyButton];
        }
        
        menuBgScrollView.contentSize=CGSizeMake(0, babyButton.frame.origin.y+babyButton.frame.size.height);
        babyMenuView.frame=CGRectMake(babyMenuView.frame.origin.x, babyMenuView.frame.origin.y, 85,10+menuBgScrollView.contentSize.height);
    }
    if (unitArray.count>4) {
        babyMenuView.frame=CGRectMake(SCREENWIDTH-85, 64, 85, 170);
    }
    
}

- (void)sureChoiceButton:(UIButton*)button{
    NSString *newUnitStr=[unitArray objectAtIndex:button.tag-101];
    unitNameLabel.text=[NSString stringWithFormat:@"%@单元",newUnitStr];
    [self cancelBabyChoiceView];
    for (UIView *subView in [BGScrollView subviews]) {
        [subView removeFromSuperview];
    }
    [nowUnitArray removeAllObjects];
    for (HouseholdItem *item in mainDataArray) {
        NSString *unitStr=[[item.sCellName componentsSeparatedByString:@"-"] objectAtIndex:1];
        if ([unitStr isEqualToString:newUnitStr]) {
            [nowUnitArray addObject:item];
        }
    }
    for (int i=0; i<nowUnitArray.count; i++) {
        HouseholdItem *item=[nowUnitArray objectAtIndex:i];
        UIButton *hhButton=[self addButton:CGRectMake(10+((SCREENWIDTH-35)/4+5)*(i%4), 10+((SCREENWIDTH-35)/4+5)*(i/4),(SCREENWIDTH-35)/4, (SCREENWIDTH-35)/4) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(choiceHouseHold:)];
        hhButton.layer.borderWidth=0.5;
        hhButton.layer.borderColor=LINECOLOR.CGColor;
        [BGScrollView addSubview:hhButton];
        
        UILabel *numLabel=[self addLabel:CGRectMake(0, 10, hhButton.frame.size.width, 20) andText:[[item.sCellName componentsSeparatedByString:@"-"] lastObject] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [hhButton addSubview:numLabel];
        
        UILabel *haveNumLabel=[self addLabel:CGRectMake(0,40, hhButton.frame.size.width, 20) andText:@"" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [hhButton addSubview:haveNumLabel];
        
        int haveNum=[item.fileTotalCount intValue];
        if (haveNum>0) {
            haveNumLabel.text=[NSString stringWithFormat:@"%d人已建档",haveNum];
        }else{
            haveNumLabel.text=@"未建档";
            haveNumLabel.textColor=[self colorWithHexString:@"#FE7871"];
        }
        
        BGScrollView.contentSize=CGSizeMake(0, hhButton.frame.origin.y+hhButton.frame.size.height+20);
    }
}

- (void)cancelBabyChoiceView{
    UIView *choiceBGView=[self.navigationController.view viewWithTag:11];
    [choiceBGView removeFromSuperview];
    UIImageView *babyMenuView=(UIImageView*)[self.navigationController.view viewWithTag:12];
    [babyMenuView removeFromSuperview];
}


- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *dataArray=message;
        if (dataArray.count>0) {
            for (NSDictionary *dic in dataArray) {
                HouseholdItem *item=[RMMapper objectWithClass:[HouseholdItem class] fromDictionary:dic];
                [mainDataArray addObject:item];
            }
            [self creatUI];
        }
        
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH, SCREENHEIGHT-110)];
    [self.view addSubview:BGScrollView];
    
    for (HouseholdItem *item in mainDataArray) {
        NSString *unitStr=[[item.sCellName componentsSeparatedByString:@"-"] objectAtIndex:1];
        if (![unitArray containsObject:unitStr]) {
            [unitArray addObject:unitStr];
        }
    }
    unitArray = (NSMutableArray*)[unitArray sortedArrayUsingSelector:@selector(compare:)];
    UIButton *lButton=[UIButton buttonWithType:UIButtonTypeCustom];
    lButton.frame=CGRectMake(0, 0,83,44);
    [lButton setImage:[UIImage imageNamed:@"baby_down"] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(changeChoice:) forControlEvents:UIControlEventTouchUpInside];
    lButton.imageEdgeInsets=UIEdgeInsetsMake(13,65,13,0);
    
    unitNameLabel=[self addLabel:CGRectMake(0, 12,60, 20) andText:[NSString stringWithFormat:@"%@单元",[unitArray firstObject]] andFont:MIDDLEFONT andColor:MAINWHITECOLOR andAlignment:2];
    [unitNameLabel adjustsFontSizeToFitWidth];
    [lButton addSubview:unitNameLabel];
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:lButton];
    self.navigationItem.rightBarButtonItem=lItem;
    
    
    nowUnitArray=[NSMutableArray new];
    for (HouseholdItem *item in mainDataArray) {
        NSString *unitStr=[[item.sCellName componentsSeparatedByString:@"-"] objectAtIndex:1];
        if ([unitStr isEqualToString:[unitArray firstObject]]) {
            [nowUnitArray addObject:item];
        }
    }
    for (int i=0; i<nowUnitArray.count; i++) {
        HouseholdItem *item=[nowUnitArray objectAtIndex:i];
        UIButton *hhButton=[self addButton:CGRectMake(10+((SCREENWIDTH-35)/4+5)*(i%4), 10+((SCREENWIDTH-35)/4+5)*(i/4),(SCREENWIDTH-35)/4, (SCREENWIDTH-35)/4) adnColor:MAINWHITECOLOR andTag:101+i andSEL:@selector(choiceHouseHold:)];
        hhButton.layer.borderWidth=0.5;
        hhButton.layer.borderColor=LINECOLOR.CGColor;
        [BGScrollView addSubview:hhButton];
        
        UILabel *numLabel=[self addLabel:CGRectMake(0, 10, hhButton.frame.size.width, 20) andText:[[item.sCellName componentsSeparatedByString:@"-"] lastObject] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [hhButton addSubview:numLabel];
        
        UILabel *haveNumLabel=[self addLabel:CGRectMake(0,40, hhButton.frame.size.width, 20) andText:@"" andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:1];
        [hhButton addSubview:haveNumLabel];
        
        int haveNum=[item.fileTotalCount intValue];
        if (haveNum>0) {
            haveNumLabel.text=[NSString stringWithFormat:@"%d人已建档",haveNum];
        }else{
            haveNumLabel.text=@"未建档";
            haveNumLabel.textColor=[self colorWithHexString:@"#FE7871"];
        }
        
        BGScrollView.contentSize=CGSizeMake(0, hhButton.frame.origin.y+hhButton.frame.size.height+20);
    }
    
    UIButton *sureButton=[self addSimpleButton:CGRectMake(0, SCREENHEIGHT-45, SCREENWIDTH, 45) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureUpload) andText:@"确定" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:sureButton];
}

- (void)choiceHouseHold:(UIButton*)button{
    if (button!=lastButton) {
        lastButton.selected=NO;
        lastButton.backgroundColor=MAINWHITECOLOR;
        UILabel *lastFLabel=[[lastButton subviews] firstObject];
        UILabel *lastSLabel=[[lastButton subviews]lastObject];
        lastFLabel.textColor=TEXTCOLOR;
        lastSLabel.textColor=TEXTCOLORG;
        if ([lastSLabel.text isEqualToString:@"未建档"]) {
            lastSLabel.textColor=[self colorWithHexString:@"#FE7871"];
        }
        button.selected=YES;
        button.backgroundColor=GREENCOLOR;
        UILabel *nowFLabel=[[button subviews] firstObject];
        UILabel *nowSLabel=[[button subviews]lastObject];
        nowFLabel.textColor=MAINWHITECOLOR;
        nowSLabel.textColor=MAINWHITECOLOR;
        lastButton=button;
        
        self.choiceHousehold=[nowUnitArray objectAtIndex:button.tag-101];
    }
}

- (void)sureUpload{
    if (self.choiceHousehold) {
        for (UINavigationController *nvc in self.navigationController.viewControllers) {
            if ([nvc isKindOfClass:[ChoiceNowAreaViewController class]]) {
                ChoiceNowAreaViewController *mvc=(ChoiceNowAreaViewController*)nvc;
                mvc.choiceHouseholdItem=self.choiceHousehold;
                [self.navigationController popToViewController:mvc animated:YES];
            }
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
