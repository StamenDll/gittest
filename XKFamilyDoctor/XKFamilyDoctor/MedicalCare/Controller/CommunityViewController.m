//
//  CommunityViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityItem.h"
#import "TeamDoctorItem.h"
#import "DoctorListViewController.h"
@interface CommunityViewController ()

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButtonItem];
    doctorArray=[NSMutableArray new];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [self sendRequest:@"CommunityDetail" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"%d",[[usd objectForKey:@"LOrgid"] intValue]] and:self];
    [self sendRequest:@"CommunityDoctor" andPath:queryURL andSqlParameter:[NSString stringWithFormat:@"%d",[[usd objectForKey:@"LOrgid"] intValue]] and:self];
}

- (void)popViewController{
    [self.myTabBarController showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"CommunityDetail"]) {
            if (data.count>0) {
                NSDictionary *dic=[message objectAtIndex:0];
                communityItem=[RMMapper objectWithClass:[CommunityItem class] fromDictionary:dic];
                [self creatUI];
            }
        }else if ([type isEqualToString:@"CommunityDoctor"]){
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    TeamDoctorItem *item=[RMMapper objectWithClass:[TeamDoctorItem class] fromDictionary:dic];
                    [doctorArray addObject:item];
                }
                if (!teamBGView) {
                    [self addTeamView];
                }
            }
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    [self addTitleView:communityItem.LName];
    
    BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:BGScrollView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENWIDTH*0.4)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,communityItem.LPic]] placeholderImage:[UIImage imageNamed:@""]];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    [BGScrollView addSubview:imageView];
    
    UIView *FBGView=[self addSimpleBackView:CGRectMake(0, imageView.frame.size.height, SCREENWIDTH, 50) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:FBGView];
    
    UIImageView *scoreImageView=[self addImageView:CGRectMake(15, 13, 25, 25) andName:@"grade"];
    [FBGView addSubview:scoreImageView];
    
    UILabel *scoreLabel=[self addLabel:CGRectMake(50,15, SCREENWIDTH/2-60, 20) andText:@"社区评分  98%" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGView addSubview:scoreLabel];
    
    [self addLineLabel:CGRectMake(SCREENWIDTH/2, 5, 0.5, 40) andColor:LINECOLOR andBackView:FBGView];
    
    UIImageView *countImageView=[self addImageView:CGRectMake(SCREENWIDTH/2+15, 13, 25, 25) andName:@"grade"];
    [FBGView addSubview:countImageView];
    
    UILabel *countLabel=[self addLabel:CGRectMake(SCREENWIDTH/2+50,15, SCREENWIDTH/2-60, 20) andText:@"社区门诊  2323" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGView addSubview:countLabel];
    
    [self addLineLabel:CGRectMake(0, FBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
    
    introduceBGView=[self addSimpleBackView:CGRectMake(0, FBGView.frame.origin.y+FBGView.frame.size.height+10, SCREENWIDTH, 160) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:introduceBGView];
    
    
    
    UILabel *titleLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"社区简介" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [introduceBGView addSubview:titleLabel];
    
    UILabel *contentLabel=[self addLabel:CGRectMake(15, 40, SCREENWIDTH-30, 80) andText:communityItem.LDetail andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    contentLabel.numberOfLines=0;
    [contentLabel sizeToFit];
    [introduceBGView addSubview:contentLabel];
    
    if (contentLabel.frame.size.height>80) {
        contentLabel.frame=CGRectMake(15, 40, SCREENWIDTH-30, 80);
        UIButton *detailButton=[self addButton:CGRectMake(0, 120, SCREENWIDTH, 40) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(lookDetail:)];
        [introduceBGView addSubview:detailButton];
        
        UILabel *detailLabel=[self addLabel:CGRectMake(0, 10, SCREENWIDTH, 20) andText:@"查看详情" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:1];
        detailLabel.numberOfLines=0;
        [detailLabel sizeToFit];
        [detailButton addSubview:detailLabel];
        
        detailLabel.frame=CGRectMake((SCREENWIDTH-detailLabel.frame.size.width-20)/2, 10, detailLabel.frame.size.width, 20);
        
        UIImageView *detailImageView=[self addImageView:CGRectMake(detailLabel.frame.origin.x+detailLabel.frame.size.width+5, 13, 15, 15) andName:@"page_open"];
        [detailButton addSubview:detailImageView];
    }
    
    [self addLineLabel:CGRectMake(0,0,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:introduceBGView];
    [self addLineLabel:CGRectMake(0,160,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:introduceBGView];
    
    addressBGView=[self addSimpleBackView:CGRectMake(0, introduceBGView.frame.origin.y+introduceBGView.frame.size.height+10, SCREENWIDTH, 70) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:addressBGView];
    
    UILabel *addressLabel=[self addLabel:CGRectMake(15, 10, SCREENWIDTH-30, 20) andText:[NSString stringWithFormat:@"地址:%@",communityItem.LAddr] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [addressBGView addSubview:addressLabel];
    
    UIButton *telButton=[self addSimpleButton:CGRectMake(15,35, SCREENWIDTH-30, 35) andBColor:CLEARCOLOR andTag:0 andSEL:@selector(callNumber:) andText:[NSString stringWithFormat:@"电话:%@",communityItem.LTel] andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
    [addressBGView addSubview:telButton];
    
    [self addLineLabel:CGRectMake(0,0,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:addressBGView];
    [self addLineLabel:CGRectMake(0,70,SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:addressBGView];
    
    departmentBGView=[self addSimpleBackView:CGRectMake(0, addressBGView.frame.origin.y+addressBGView.frame.size.height+10, SCREENWIDTH, 78) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:departmentBGView];
    
    UILabel *dtitleLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"社区科室" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [departmentBGView addSubview:dtitleLabel];
    
    NSArray *departmentArray=@[@"全科",@"康复科",@"中医科科科"];
    NSArray *colorArray=@[[UIColor redColor],GREENCOLOR,[UIColor orangeColor]];
    NSMutableArray *labelArray=[NSMutableArray new];
    for (int i=0; i<departmentArray.count; i++) {
        UIColor *color=[colorArray objectAtIndex:i];
        UILabel *departmentLabel=[self addLabel:CGRectMake(15, 40, 0, 22) andText:[departmentArray objectAtIndex:i] andFont:MIDDLEFONT andColor:[colorArray objectAtIndex:i] andAlignment:1];
        departmentLabel.numberOfLines=0;
        [departmentLabel.layer setCornerRadius:11];
        departmentLabel.layer.borderColor=color.CGColor;
        departmentLabel.layer.borderWidth=0.5;
        departmentLabel.clipsToBounds=YES;
        [departmentLabel sizeToFit];
        [departmentBGView addSubview:departmentLabel];
        
        if (departmentLabel.frame.size.width<60) {
            departmentLabel.frame=CGRectMake(15, 40, 60, 22);
        }else{
            departmentLabel.frame=CGRectMake(15, 40, departmentLabel.frame.size.width+20, 22);
        }
        if (i>0) {
            UILabel *beforLabel=[labelArray objectAtIndex:i-1];
            departmentLabel.frame=CGRectMake(beforLabel.frame.origin.x+beforLabel.frame.size.width+15, departmentLabel.frame.origin.y, departmentLabel.frame.size.width, 22);
        }
        if (departmentLabel.frame.origin.x+departmentLabel.frame.size.width>SCREENWIDTH) {
            departmentLabel.frame=CGRectMake(15, departmentLabel.frame.origin.y+departmentLabel.frame.size.height+10, departmentLabel.frame.size.width, 22);
        }
        [labelArray addObject:departmentLabel];
        
        departmentBGView.frame=CGRectMake(0, departmentBGView.frame.origin.y, SCREENWIDTH, departmentLabel.frame.origin.y+departmentLabel.frame.size.height+10);
    }
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:departmentBGView];
    [self addLineLabel:CGRectMake(0, departmentBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:departmentBGView];
    
    BGScrollView.contentSize=CGSizeMake(0, departmentBGView.frame.origin.y+departmentBGView.frame.size.height+40);
    
    if (doctorArray.count>0) {
        [self addTeamView];
    }
    
}
- (void)addTeamView{
    teamBGView=[self addSimpleBackView:CGRectMake(0,departmentBGView.frame.origin.y+departmentBGView.frame.size.height+10, SCREENWIDTH, 170) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:teamBGView];
    
    UIButton *teamDetailButton=[self addButton:CGRectMake(0, 0,SCREENWIDTH, 40) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(doctorOnclick:)];
    [teamBGView addSubview:teamDetailButton];
    
    UILabel *teamLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"社区相关医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [teamBGView addSubview:teamLabel];
    
    UILabel *teamcountLabel=[self addLabel:CGRectMake(15, 10, 100, 20) andText:@"社区相关医生" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [teamBGView addSubview:teamcountLabel];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:teamBGView];
    [self addLineLabel:CGRectMake(0, 40, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:teamBGView];
    [self addLineLabel:CGRectMake(0, teamBGView.frame.size.height, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:teamBGView];
    
    
    UILabel *coutLabel=[self addLabel:CGRectMake(SCREENWIDTH-160, 10, 120, 20) andText:[NSString stringWithFormat:@"%lu人",(unsigned long)doctorArray.count] andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [teamDetailButton addSubview:coutLabel];
    
    UIImageView *goImagView=[self addImageView:CGRectMake(SCREENWIDTH-30,13,15,15) andName:@"godetail"];
    [teamDetailButton addSubview:goImagView];
    
    for (int i=0; i<4; i++) {
        TeamDoctorItem *item=[doctorArray objectAtIndex:i];
        UIImageView *doctorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*i+(SCREENWIDTH/4-50)/2, 50, 50, 50)];
        [doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:DOCDEFAULTPIC];
        doctorImageView.clipsToBounds=YES;
        [doctorImageView.layer setCornerRadius:25];
        [teamBGView addSubview:doctorImageView];
        
        UILabel *doctorNameLabel=[self addLabel:CGRectMake(SCREENWIDTH/4*i,115,SCREENWIDTH/4, 20) andText:[self changeNullString:item.LName] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
        [teamBGView addSubview:doctorNameLabel];
        
//        UILabel *depatmentLabel=[self addLabel:CGRectMake(SCREENWIDTH/4*i,135,SCREENWIDTH/4, 20) andText:@"全科" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:1];
//        [teamBGView addSubview:depatmentLabel];
    }
    
    BGScrollView.contentSize=CGSizeMake(0, teamBGView.frame.origin.y+teamBGView.frame.size.height+40);
}

- (void)doctorOnclick:(UIButton*)button{
    DoctorListViewController *dvc=[DoctorListViewController new];
    dvc.mainArray=doctorArray;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)callNumber:(UIButton*)button{
    UILabel *label=[[button subviews]lastObject];
    NSArray *array=[label.text componentsSeparatedByString:@":"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[array lastObject]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)lookDetail:(UIButton*)button{
    UILabel *contentLabel=[[introduceBGView subviews] objectAtIndex:1];
    UILabel *label=[[button subviews] objectAtIndex:0];
    UIImageView *imageView=[[button subviews]lastObject];
    UILabel *linelabel=[[introduceBGView subviews]lastObject];
    if (button.selected==NO) {
        [contentLabel sizeToFit];
        contentLabel.frame=CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, contentLabel.frame.size.height);
        button.frame=CGRectMake(button.frame.origin.x, contentLabel.frame.origin.y+contentLabel.frame.size.height, SCREENWIDTH, 40);
        label.text=@"收起";
        imageView.image=[UIImage imageNamed:@"page_up"];
        
        button.selected=YES;
    }else{
        contentLabel.frame=CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width,80);
        button.frame=CGRectMake(button.frame.origin.x, contentLabel.frame.origin.y+contentLabel.frame.size.height, SCREENWIDTH, 40);
        label.text=@"查看详情";
        imageView.image=[UIImage imageNamed:@"page_open"];
        button.selected=NO;
    }
    introduceBGView.frame=CGRectMake(introduceBGView.frame.origin.x, introduceBGView.frame.origin.y, SCREENWIDTH, contentLabel.frame.origin.y+contentLabel.frame.size.height+40);
    linelabel.frame=CGRectMake(0, introduceBGView.frame.size.height, SCREENWIDTH, 0.5);
    addressBGView.frame=CGRectMake(0, introduceBGView.frame.origin.y+introduceBGView.frame.size.height+10, SCREENWIDTH, addressBGView.frame.size.height);
    departmentBGView.frame=CGRectMake(0, addressBGView.frame.origin.y+addressBGView.frame.size.height+10, SCREENWIDTH, departmentBGView.frame.size.height);
    teamBGView.frame=CGRectMake(0, departmentBGView.frame.origin.y+departmentBGView.frame.size.height+10, SCREENWIDTH, teamBGView.frame.size.height);
    BGScrollView.contentSize=CGSizeMake(0, teamBGView.frame.origin.y+teamBGView.frame.size.height+40);
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
