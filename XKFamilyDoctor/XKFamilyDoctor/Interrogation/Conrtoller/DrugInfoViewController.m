//
//  DrugInfoViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DrugInfoViewController.h"
#import "WriteRecipeViewController.h"
#import "SDCycleScrollView.h"
@interface DrugInfoViewController ()<SDCycleScrollViewDelegate>

@end

@implementation DrugInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)popViewController{
    if ([self.isChoiceDrug isEqualToString:@"Y"]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-128)];
    [self.view addSubview:mainScrollView];
    
    UIView *drugBackView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 250) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:drugBackView];
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,SCREENWIDTH,164) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.backgroundColor=[UIColor clearColor];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.pageDotImage=[UIImage imageNamed:@"focus_3"];
    cycleScrollView.currentPageDotImage=[UIImage imageNamed:@"focus"];
    [drugBackView addSubview:cycleScrollView];
    
    UIImageView *drugSignImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, cycleScrollView.frame.origin.y+cycleScrollView.frame.size.height+16, 19, 12)];
    drugSignImageView.image=[UIImage imageNamed:@"ylfcfyp"];
    [drugBackView addSubview:drugSignImageView];
    
    UILabel *drugNameLabel=[self addLabel:CGRectMake(46, cycleScrollView.frame.origin.y+cycleScrollView.frame.size.height+12, SCREENWIDTH-20, 20) andText:@"云丰 四季感冒片" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugBackView addSubview:drugNameLabel];
    
    [self addLineLabel:CGRectMake(0, drugNameLabel.frame.origin.y+drugNameLabel.frame.size.height+12, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugBackView];
    
    UILabel *ggLabel=[self addLabel:CGRectMake(15,drugNameLabel.frame.origin.y+drugNameLabel.frame.size.height+24, 30, 20) andText:@"规格" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugBackView addSubview:ggLabel];
    
    NSArray *ggArray=@[@"0.36g*12片*2板",@"0.36g*12片*2板"];
    for (int i=0; i<ggArray.count; i++) {
        UIButton *ggButton=[self addSimpleButton:CGRectMake(60+120*(i%2), ggLabel.frame.origin.y-2+40*(i/2), 110, 25) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceGG:) andText:[ggArray objectAtIndex:i] andFont:SMALLFONT andColor:MAINWHITECOLOR andAlignment:1];
        [ggButton setImage:[UIImage imageNamed:@"rec_gg"] forState:UIControlStateNormal];
        [ggButton setImage:[UIImage imageNamed:@"rec_ggc"] forState:UIControlStateSelected];
        [drugBackView addSubview:ggButton];
        if (i==0) {
            UILabel *label=[[ggButton subviews]lastObject];
            label.textColor=TEXTCOLOR;
            ggButton.selected=YES;
            lastGGButton=ggButton;
        }
        
        drugBackView.frame=CGRectMake(0, 0,SCREENWIDTH,ggButton.frame.origin.y+ggButton.frame.size.height+9);
    }
    
    [self addLineLabel:CGRectMake(15, drugBackView.frame.size.height, SCREENWIDTH-15, 0.5) andColor:LINECOLOR andBackView:drugBackView];
    
    UILabel *countLabel=[self addLabel:CGRectMake(15,drugBackView.frame.size.height+12,30, 20) andText:@"数量" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugBackView addSubview:countLabel];
    
    UIButton *reduceButton=[self addButton:CGRectMake(60, drugBackView.frame.size.height+10, 32, 25) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(reduceDrugCount)];
    [reduceButton setImage:[UIImage imageNamed:@"reduce_3"] forState:UIControlStateNormal];
    [drugBackView addSubview:reduceButton];
    
    UILabel *countCLabel=[self addLabel:CGRectMake(92, drugBackView.frame.size.height+12, 46, 20) andText:@"1" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    countCLabel.tag=13;
    [drugBackView addSubview:countCLabel];
    
    UIButton *addButton=[self addButton:CGRectMake(138, drugBackView.frame.size.height+10, 32, 25) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(addDrugCount)];
    [addButton setImage:[UIImage imageNamed:@"add_3"] forState:UIControlStateNormal];
    [drugBackView addSubview:addButton];
    
    drugBackView.frame=CGRectMake(0, 0,SCREENWIDTH,addButton.frame.origin.y+addButton.frame.size.height+9);
    
    [self addLineLabel:CGRectMake(0, drugBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugBackView];
    
    UIView *drugDetailBackView=[self addSimpleBackView:CGRectMake(0, drugBackView.frame.origin.y+drugBackView.frame.size.height+8, SCREENWIDTH, 98) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:drugDetailBackView];
    
    UILabel *drugDetailLabel=[self addLabel:CGRectMake(15,12, SCREENWIDTH-30, 20) andText:@"药品成分" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugDetailBackView addSubview:drugDetailLabel];
    
    [self addLineLabel:CGRectMake(0,44, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugDetailBackView];
    
    UILabel *drugDetailCLabel=[self addLabel:CGRectMake(15,54, SCREENWIDTH-30, 20) andText:@"桔梗、紫苏叶、陈皮、大青叶、连翘、炙甘草、香附（炒）、防风。辅料为淀粉、糊精。" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    drugDetailCLabel.numberOfLines=0;
    [drugDetailCLabel sizeToFit];
    [drugDetailBackView addSubview:drugDetailCLabel];
    
    if (drugDetailCLabel.frame.size.height<32) {
        drugDetailCLabel.frame=CGRectMake(15, 44+(52-drugDetailCLabel.frame.size.height)/2, SCREENWIDTH-30, drugDetailCLabel.frame.size.height);
        drugDetailBackView.frame=CGRectMake(0, drugDetailBackView.frame.origin.y, SCREENWIDTH,96);
    }else{
        drugDetailBackView.frame=CGRectMake(0, drugDetailBackView.frame.origin.y, SCREENWIDTH, drugDetailCLabel.frame.origin.y+drugDetailCLabel.frame.size.height+10);
    }
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugDetailBackView];
    
    [self addLineLabel:CGRectMake(0,drugDetailBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugDetailBackView];
    
    UIView *drugEffectBackView=[self addSimpleBackView:CGRectMake(0, drugDetailBackView.frame.origin.y+drugDetailBackView.frame.size.height+8, SCREENWIDTH, 98) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:drugEffectBackView];
    
    UILabel *drugEffectLabel=[self addLabel:CGRectMake(15,12,SCREENWIDTH-20, 20) andText:@"功能主治" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugEffectBackView addSubview:drugEffectLabel];
    
    [self addLineLabel:CGRectMake(0, 44, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugEffectBackView];
    
    UILabel *drugEffectCLabel=[self addLabel:CGRectMake(15,54, SCREENWIDTH-30, 20) andText:@"清热解毒用于司机风寒感冒引起的发热头痛，鼻流清涕，咳嗽口干，咽喉疼痛，恶心厌食。" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    drugEffectCLabel.numberOfLines=0;
    [drugEffectCLabel sizeToFit];
    [drugEffectBackView addSubview:drugEffectCLabel];
    
    if (drugEffectCLabel.frame.size.height<32) {
        drugEffectCLabel.frame=CGRectMake(15, 44+(52-drugEffectCLabel.frame.size.height)/2, SCREENWIDTH-30, drugEffectCLabel.frame.size.height);
        drugEffectBackView.frame=CGRectMake(0, drugEffectBackView.frame.origin.y, SCREENWIDTH,96);
    }else{
        drugEffectBackView.frame=CGRectMake(0, drugEffectBackView.frame.origin.y, SCREENWIDTH, drugEffectCLabel.frame.origin.y+drugEffectCLabel.frame.size.height+10);
    }
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugEffectBackView];
    
    [self addLineLabel:CGRectMake(0,drugEffectBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugEffectBackView];
    
    UIView *drugUADBackView=[self addSimpleBackView:CGRectMake(0, drugEffectBackView.frame.origin.y+drugEffectBackView.frame.size.height+8, SCREENWIDTH, 98) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:drugUADBackView];
    
    UILabel *drugUADLabel=[self addLabel:CGRectMake(15,12,SCREENWIDTH-20, 20) andText:@"用法用量" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugUADBackView addSubview:drugUADLabel];
    
    [self addLineLabel:CGRectMake(0, 44, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugUADBackView];
    
    UILabel *drugUADCLabel=[self addLabel:CGRectMake(15,54, SCREENWIDTH-30, 20) andText:@"口服，一次3～5片，一日3次" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    drugUADCLabel.numberOfLines=0;
    [drugUADCLabel sizeToFit];
    [drugUADBackView addSubview:drugUADCLabel];
    
    if (drugUADLabel.frame.size.height<32) {
        drugUADCLabel.frame=CGRectMake(15, 44+(52-drugUADLabel.frame.size.height)/2, SCREENWIDTH-30, drugUADLabel.frame.size.height);
        drugUADBackView.frame=CGRectMake(0, drugUADBackView.frame.origin.y, SCREENWIDTH,96);
    }else{
        drugUADBackView.frame=CGRectMake(0, drugUADBackView.frame.origin.y, SCREENWIDTH, drugUADCLabel.frame.origin.y+drugUADCLabel.frame.size.height+10);
    }
    
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugUADBackView];
    
    [self addLineLabel:CGRectMake(0,drugUADBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugUADBackView];
    
    UIView *drugCarefulBackView=[self addSimpleBackView:CGRectMake(0, drugUADBackView.frame.origin.y+drugUADBackView.frame.size.height+8, SCREENWIDTH, 98) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:drugCarefulBackView];
    
    UILabel *drugCarefulLabel=[self addLabel:CGRectMake(15,12,SCREENWIDTH-20, 20) andText:@"注意事项" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [drugCarefulBackView addSubview:drugCarefulLabel];
    
    [self addLineLabel:CGRectMake(0, 44, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugCarefulBackView];
    
    UILabel *drugCarefulCLabel=[self addLabel:CGRectMake(15,54, SCREENWIDTH-30, 20) andText:@"1.忌烟、酒及辛辣、生冷、油腻食物。\n2.不宜在服药期间同时服用滋补型中成药。\n3.注意事项注意事项注意事项注意事项注意事项注意事项" andFont:SMALLFONT andColor:TEXTCOLOR andAlignment:0];
    drugCarefulCLabel.numberOfLines=0;
    [drugCarefulCLabel sizeToFit];
    [drugCarefulBackView addSubview:drugCarefulCLabel];
    
    if (drugCarefulCLabel.frame.size.height<32) {
        drugCarefulCLabel.frame=CGRectMake(15, 44+(52-drugCarefulCLabel.frame.size.height)/2, SCREENWIDTH-30, drugCarefulCLabel.frame.size.height);
        drugCarefulBackView.frame=CGRectMake(0, drugCarefulBackView.frame.origin.y, SCREENWIDTH,96);
    }else{
        drugCarefulBackView.frame=CGRectMake(0, drugCarefulBackView.frame.origin.y, SCREENWIDTH, drugCarefulCLabel.frame.origin.y+drugCarefulCLabel.frame.size.height+10);
    }
    
    
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugCarefulBackView];
    
    [self addLineLabel:CGRectMake(0,drugCarefulBackView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:drugCarefulBackView];
    
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, drugCarefulBackView.frame.origin.y+drugCarefulBackView.frame.size.height+20);
    
    if ([self.isChoiceDrug isEqualToString:@"Y"]) {
        UIView *addBackView=[self addSimpleBackView:CGRectMake(0, SCREENHEIGHT-64, SCREENWIDTH,64) andColor:MAINWHITECOLOR];
        [self.view addSubview:addBackView];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:addBackView];
    
        UIButton *sureAddButton=[self addSimpleButton:CGRectMake(15,12, SCREENWIDTH-30, 40) andBColor:GREENCOLOR andTag:0 andSEL:@selector(sureAddDrug) andText:@"添加" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
        [sureAddButton.layer setCornerRadius:5];
        [addBackView addSubview:sureAddButton];
    }else{
        mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    }
    
}

- (void)reduceDrugCount{
    UILabel *countLabel=(UILabel*)[self.view viewWithTag:13];
    if ([countLabel.text intValue]>1) {
        countLabel.text=[NSString stringWithFormat:@"%d",[countLabel.text intValue]-1];
    }
}

- (void)addDrugCount{
    UILabel *countLabel=(UILabel*)[self.view viewWithTag:13];
    countLabel.text=[NSString stringWithFormat:@"%d",[countLabel.text intValue]+1];
}

- (void)choiceGG:(UIButton*)button{
    if (button!=lastGGButton) {
        UILabel *label=[[button subviews]lastObject];
        UILabel *lastLabel=[[lastGGButton subviews]lastObject];
        label.textColor=TEXTCOLOR;
        lastLabel.textColor=MAINWHITECOLOR;
        button.selected=YES;
        lastGGButton.selected=NO;
        lastGGButton=button;
        
    }
}

- (void)sureAddDrug{
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[WriteRecipeViewController class]]) {
            WriteRecipeViewController *cvc=(WriteRecipeViewController*)nvc;
            cvc.isAddDrug=@"Y";
            [self.navigationController popToViewController:cvc animated:YES];
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
