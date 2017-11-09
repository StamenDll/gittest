//
//  DrugDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DrugDetailViewController.h"

@interface DrugDetailViewController ()

@end

@implementation DrugDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    UIView *FBGview=[self addSimpleBackView:CGRectMake(0, 0,SCREENWIDTH, SCREENWIDTH/2.5+30) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:FBGview];
    
    UIImageView *drugImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2.5)];
    [drugImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,self.drugInfoItem.LPic]] placeholderImage:[UIImage imageNamed:@"logosss"]];
    drugImageView.contentMode=UIViewContentModeScaleAspectFit;
    [FBGview addSubview:drugImageView];
    
    [self addLineLabel:CGRectMake(0, drugImageView.frame.origin.y+drugImageView.frame.size.height+20, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:BGScrollView];
    
    UILabel *drugNameLabel=[self addLabel:CGRectMake(15,  drugImageView.frame.origin.y+drugImageView.frame.size.height+30, 0, 20) andText:@"药品名称" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [drugNameLabel sizeToFit];
    [FBGview addSubview:drugNameLabel];
    
    UILabel *drugNameCLabel=[self addLabel:CGRectMake(drugNameLabel.frame.size.width+20,drugImageView.frame.origin.y+drugImageView.frame.size.height+30,0,20) andText:self.drugInfoItem.LName andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [drugNameCLabel sizeToFit];
    [FBGview addSubview:drugNameCLabel];
    
    UILabel *drugFormatLabel=[self addLabel:CGRectMake(15, drugNameCLabel.frame.origin.y+drugNameCLabel.frame.size.height+5, 0, 20) andText:@"规格" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [drugFormatLabel sizeToFit];
    [FBGview addSubview:drugFormatLabel];
    drugFormatLabel.frame=CGRectMake(drugNameLabel.frame.origin.x+drugNameLabel.frame.size.width-drugFormatLabel.frame.size.width, drugNameCLabel.frame.origin.y+drugNameCLabel.frame.size.height+5, drugFormatLabel.frame.size.width, drugFormatLabel.frame.size.height);
    
    UILabel *drugFormatCLabel=[self addLabel:CGRectMake(drugFormatLabel.frame.origin.x+drugFormatLabel.frame.size.width+5,drugNameCLabel.frame.origin.y+drugNameCLabel.frame.size.height+5,0,20) andText:self.drugInfoItem.LModel andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [drugFormatCLabel sizeToFit];
    [FBGview addSubview:drugFormatCLabel];
    
    UILabel *drugNumberLabel=[self addLabel:CGRectMake(15,drugFormatCLabel.frame.origin.y+drugFormatCLabel.frame.size.height+5, 0, 20) andText:@"生产批号" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGview addSubview:drugNumberLabel];
    
    UILabel *drugNumberCLabel=[self addLabel:CGRectMake(drugNumberLabel.frame.size.width+20,drugFormatCLabel.frame.origin.y+drugFormatCLabel.frame.size.height+5,0,20) andText:self.drugInfoItem.LSerial andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [drugNumberCLabel sizeToFit];
    [FBGview addSubview:drugNumberCLabel];
    
    FBGview.frame=CGRectMake(0, 0, SCREENWIDTH, drugNumberCLabel.frame.origin.y+drugNumberCLabel.frame.size.height+10);
    [self addLineLabel:CGRectMake(0, FBGview.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGview];
    
    UIView *SBGview=[self addSimpleBackView:CGRectMake(0,FBGview.frame.origin.y+FBGview.frame.size.height+10,SCREENWIDTH, SCREENWIDTH/2.5+30) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:SBGview];
    
    UILabel *componentLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-20, 20) andText:@"功能主治" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    [SBGview addSubview:componentLabel];
    
    UILabel *componentCLabel=[self addLabel:CGRectMake(15,35, SCREENWIDTH-30, 0) andText:self.drugInfoItem.LMainFun andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    componentCLabel.numberOfLines=0;
    [componentCLabel sizeToFit];
    [SBGview addSubview:componentCLabel];
    
    SBGview.frame=CGRectMake(0, FBGview.frame.origin.y+FBGview.frame.size.height+10, SCREENWIDTH, componentCLabel.frame.origin.y+componentCLabel.frame.size.height+10);
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:SBGview];
    [self addLineLabel:CGRectMake(0, SBGview.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:SBGview];

    
    BGScrollView.contentSize=CGSizeMake(0, SBGview.frame.origin.y+SBGview.frame.size.height);
    
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
