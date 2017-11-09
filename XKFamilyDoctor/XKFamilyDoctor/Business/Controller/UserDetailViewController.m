//
//  UserDetailViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UserDetailViewController.h"
#import "BPSListViewController.h"
#import "AddBPViewController.h"
@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"用户详情"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    UIScrollView *BGScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT)];
    [self.view addSubview:BGScrollView];
    
    UIView *FBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH,50) andColor:MAINWHITECOLOR];
    [BGScrollView addSubview:FBGView];
    
    UILabel *nameLabel=[self addLabel:CGRectMake(10, 15, 0, 20) andText:self.userItem.LName andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    nameLabel.numberOfLines=0;
    [nameLabel sizeToFit];
    [FBGView addSubview:nameLabel];
    
    
    UILabel *saLabel=[self addLabel:CGRectMake(80, nameLabel.frame.origin.y,SCREENWIDTH-90, 20) andText:[NSString stringWithFormat:@"%@   %@",self.userItem.LSex,[self getAgeByBir:[self getSubTime:self.userItem.LBirthday andFormat:@"yyyy-MM-dd"]]] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGView addSubview:saLabel];
    
    if (nameLabel.frame.size.width>80) {
        saLabel.frame=CGRectMake(nameLabel.frame.size.width+20, nameLabel.frame.origin.y, 100, 20);
    }
    
    
    NSMutableArray *ptArray=[NSMutableArray new];
    if ([self changeNullString:self.userItem.LDiseaseType].length>0) {
        for (NSString *ptString in [self.userItem.LDiseaseType componentsSeparatedByString:@","]) {
            [ptArray addObject:ptString];
        }
    }
    if ([self changeNullString:self.userItem.LPersonKind].length>0) {
        for (NSString *ptString in [self.userItem.LPersonKind componentsSeparatedByString:@","]) {
            [ptArray addObject:ptString];
        }
    }
    
    if (ptArray.count>0) {
        NSMutableArray *labelArray=[NSMutableArray new];
        for (int j=0; j<ptArray.count;j++) {
            NSString *ptString=[ptArray objectAtIndex:j];
            UILabel *tagLabel=[self addLabel:CGRectMake(10,45, 0,0) andText:ptString andFont:SMALLFONT andColor:GREENCOLOR andAlignment:1];
            tagLabel.numberOfLines=0;
            [tagLabel sizeToFit];
            tagLabel.frame=CGRectMake(10, 45, tagLabel.frame.size.width+10,22);
            tagLabel.clipsToBounds=YES;
            tagLabel.layer.borderColor=GREENCOLOR.CGColor;
            tagLabel.layer.borderWidth=0.5;
            [tagLabel.layer setCornerRadius:11];
            [FBGView addSubview:tagLabel];
            
            if (j>0) {
                UILabel *beforLabel=[labelArray objectAtIndex:j-1];
                tagLabel.frame=CGRectMake(beforLabel.frame.origin.x+beforLabel.frame.size.width+10,beforLabel.frame.origin.y, tagLabel.frame.size.width, tagLabel.frame.size.height);
                if (tagLabel.frame.origin.x+tagLabel.frame.size.width>SCREENWIDTH-20) {
                    tagLabel.frame=CGRectMake(10,beforLabel.frame.origin.y+beforLabel.frame.size.height+10, tagLabel.frame.size.width, tagLabel.frame.size.height);
                }
            }
            [labelArray addObject:tagLabel];
            
            FBGView.frame=CGRectMake(0, FBGView.frame.origin.y, FBGView.frame.size.width,tagLabel.frame.origin.y+30);
        }
    }
    
    UILabel *idNumLabel=[self addLabel:CGRectMake(10, FBGView.frame.size.height+10,80, 20) andText:@"身份证" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [FBGView addSubview:idNumLabel];
    
    UILabel *idNumCLabel=[self addLabel:CGRectMake(80, FBGView.frame.size.height+10,SCREENWIDTH-90, 20) andText:self.userItem.LIdNum andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGView addSubview:idNumCLabel];
    
    [self addLineLabel:CGRectMake(10, idNumLabel.frame.origin.y+35, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
    
    UILabel *mobileLabel=[self addLabel:CGRectMake(10, idNumLabel.frame.origin.y+50,SCREENWIDTH-20, 20) andText:@"电话" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [FBGView addSubview:mobileLabel];
    
    UILabel *mobileCLabel=[self addLabel:CGRectMake(80, idNumLabel.frame.origin.y+50,SCREENWIDTH-90, 20) andText:[[self.userItem.LMobile componentsSeparatedByString:@"_"] firstObject] andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [FBGView addSubview:mobileCLabel];
    
    [self addLineLabel:CGRectMake(10, mobileLabel.frame.origin.y+35, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];

    UILabel *addressLabel=[self addLabel:CGRectMake(10, mobileLabel.frame.origin.y+50,SCREENWIDTH-20, 20) andText:@"住址" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [FBGView addSubview:addressLabel];
    
    UILabel *addressCLabel=[self addLabel:CGRectMake(80, mobileLabel.frame.origin.y+50,SCREENWIDTH-90, 20) andText:self.userItem.LIDAddr andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    addressLabel.numberOfLines=0;
    [addressLabel sizeToFit];
    [FBGView addSubview:addressCLabel];
    
    [self addLineLabel:CGRectMake(0, addressCLabel.frame.origin.y+addressCLabel.frame.size.height+15, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
    
    FBGView.frame=CGRectMake(0, FBGView.frame.origin.y, FBGView.frame.size.width,addressCLabel.frame.origin.y+addressCLabel.frame.size.height+15);

    UILabel *sTitleLabel=[self addLabel:CGRectMake(10, FBGView.frame.size.height+15,100, 20) andText:@"健康检测" andFont:BIGFONT andColor:TEXTCOLORDG andAlignment:0];
    [BGScrollView addSubview:sTitleLabel];
    
    BGScrollView.contentSize=CGSizeMake(0, sTitleLabel.frame.origin.y+35);
    if ([self.userItem.highPressure intValue]>0) {
        UIButton *BPButton=[self addButton:CGRectMake(15, BGScrollView.contentSize.height, SCREENWIDTH-30, 85) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoBPList:)];
        [BPButton.layer setCornerRadius:5];
        [BGScrollView addSubview:BPButton];
        
        UILabel *bpSubLabel=[self addLabel:CGRectMake(10, 10,100, 20) andText:@"最近血压数据" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [BPButton addSubview:bpSubLabel];
        
        UIImageView *bpImageView=[self addImageView:CGRectMake(10, 40, 26, 25) andName:@"blood pressure"];
        [BPButton addSubview:bpImageView];
        
        UILabel *bpCountLabel=[self addLabel:CGRectMake(45, 40, (SCREENWIDTH-150)/2, 25) andText:[NSString stringWithFormat:@"%@/%@mmHG",self.userItem.highPressure,self.userItem.lowPressure] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [BPButton addSubview:bpCountLabel];
        
        UILabel *HRCountLabel=[self addLabel:CGRectMake(50+(SCREENWIDTH-150)/2, 40, (SCREENWIDTH-150)/2, 25) andText:[NSString stringWithFormat:@"%@bpm",self.userItem.pulse] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [BPButton addSubview:HRCountLabel];
        
        
        UILabel *stateLabel=[self addLabel:CGRectMake(BPButton.frame.size.width-55, 40, 55, 25) andText:@"正常" andFont:BIGFONT andColor:GREENCOLOR andAlignment:0];
        [BPButton addSubview:stateLabel];
        if ([self.userItem.highPressure intValue]>140) {
            stateLabel.text=@"偏高";
            stateLabel.textColor=[self colorWithHexString:@"#FE7871"];
        }
        if ([self.userItem.highPressure intValue]<60) {
            stateLabel.text=@"偏低";
            stateLabel.textColor=[self colorWithHexString:@"#FFA903"];
        }
        
        UILabel *moreLabel=[self addLabel:CGRectMake(BPButton.frame.size.width-55, 10, 55, 20) andText:@"更多" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [BPButton addSubview:moreLabel];
        
        [self addGotoNextImageView:moreLabel];
        
        BGScrollView.contentSize=CGSizeMake(0, BPButton.frame.origin.y+105);
    }
    
    if ([self.userItem.bloodSugarValue intValue]>0) {
        UIButton *BSButton=[self addButton:CGRectMake(15, BGScrollView.contentSize.height, SCREENWIDTH-30, 85) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoBSList)];
        [BSButton.layer setCornerRadius:5];
        [BGScrollView addSubview:BSButton];
        
        UILabel *bpSubLabel=[self addLabel:CGRectMake(10, 10,100, 20) andText:@"最近血糖数据" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [BSButton addSubview:bpSubLabel];
        
        UIImageView *bpImageView=[self addImageView:CGRectMake(10, 40, 26, 25) andName:@"blood sugar"];
        [BSButton addSubview:bpImageView];
        
        UILabel *bpCountLabel=[self addLabel:CGRectMake(45, 40, (SCREENWIDTH-150)/2, 25) andText:[NSString stringWithFormat:@"%@mol/L",self.userItem.bloodSugarValue] andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [BSButton addSubview:bpCountLabel];
        
        UILabel *HRCountLabel=[self addLabel:CGRectMake(50+(SCREENWIDTH-150)/2, 40, (SCREENWIDTH-150)/2, 25) andText:self.userItem.bloodSugarCheckType andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
        [BSButton addSubview:HRCountLabel];
        
        
        UILabel *stateLabel=[self addLabel:CGRectMake(BSButton.frame.size.width-55, 40, 55, 25) andText:@"偏高" andFont:BIGFONT andColor:[self colorWithHexString:@"#FE7871"] andAlignment:0];
        [BSButton addSubview:stateLabel];
        
        UILabel *moreLabel=[self addLabel:CGRectMake(BSButton.frame.size.width-55, 10, 55, 20) andText:@"更多" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [BSButton addSubview:moreLabel];
        
        [self addGotoNextImageView:moreLabel];
        
        BGScrollView.contentSize=CGSizeMake(0,BSButton.frame.origin.y+105);
    }
    
    
    if ([self.userItem.highPressure intValue]==0) {
        UIButton *addBPButton=[self addButton:CGRectMake(0, BGScrollView.contentSize.height, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoAddBP)];
        [BGScrollView addSubview:addBPButton];
        
        UILabel *titleLabel=[self addLabel:CGRectMake(10,15,100, 20) andText:@"添加血压数据" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
        [addBPButton addSubview:titleLabel];
        
        [self addGotoNextImageView:addBPButton];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:addBPButton];
        [self addLineLabel:CGRectMake(0,50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:addBPButton];
        
        BGScrollView.contentSize=CGSizeMake(0, addBPButton.frame.origin.y+65);

    }
    
    
    if ([self.userItem.bloodSugarValue intValue]==0) {
        UIButton *addBSButton=[self addButton:CGRectMake(0, BGScrollView.contentSize.height, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(gotoAddBS)];
        [BGScrollView addSubview:addBSButton];
        
        UILabel *titleLabel=[self addLabel:CGRectMake(10,15,100, 20) andText:@"添加血糖数据" andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:0];
        [addBSButton addSubview:titleLabel];
        
        [self addGotoNextImageView:addBSButton];
        
        [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:addBSButton];
        [self addLineLabel:CGRectMake(0, 50, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:addBSButton];
        
        BGScrollView.contentSize=CGSizeMake(0, addBSButton.frame.origin.y+45);

    }
    
}

- (void)gotoAddBP{
    AddBPViewController *avc=[AddBPViewController new];
    avc.titleString=@"血压录入";
    avc.whoPush=@"P";
    avc.LOnlyCode=self.userItem.LOnlyCode;
    avc.memberID=self.userItem.LCode;
    avc.name=self.userItem.LName;
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)gotoAddBS{
    AddBPViewController *avc=[AddBPViewController new];
    avc.titleString=@"血糖录入";
    avc.whoPush=@"P";
    avc.LOnlyCode=self.userItem.LOnlyCode;
    avc.memberID=self.userItem.LCode;
    avc.name=self.userItem.LName;
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)gotoBPList:(UIButton*)button{
    BPSListViewController *bvc=[BPSListViewController new];
    bvc.titleString=@"血压数据";
    bvc.LOnlyCode=self.userItem.LOnlyCode;
    bvc.memberID=self.userItem.LCode;
    bvc.name=self.userItem.LName;
    [self.navigationController pushViewController:bvc animated:YES];
}

- (void)gotoBSList{
    BPSListViewController *bvc=[BPSListViewController new];
    bvc.titleString=@"血糖数据";
    bvc.LOnlyCode=self.userItem.LOnlyCode;
    bvc.memberID=self.userItem.LCode;
    bvc.name=self.userItem.LName;
    [self.navigationController pushViewController:bvc animated:YES];
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
