//
//  MemberInfoViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "CNewsViewController.h"
#import "ChatItem.h"

@interface MemberInfoViewController ()

@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self addRightButtonItem];
    [self sendRequest:@"MemberInfo" andPath:queryURL andSqlParameter:self.LOnlyCode and:self];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightButtonItem{
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame=CGRectMake(0, 0, 30,30);
    [rButton addTarget:self action:@selector(addFollow:) forControlEvents:UIControlEventTouchUpInside];
    [rButton setImage:[UIImage imageNamed:@"concern"] forState:UIControlStateNormal];
    rButton.imageEdgeInsets=UIEdgeInsetsMake(5, 10, 5, 0);
    
    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem=lItem;
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"MemberInfo"]) {
            if (data.count>0) {
                memberItem=[RMMapper objectWithClass:[MemberInfoItem class] fromDictionary:[data objectAtIndex:0]];
                [self creatUI];
            }
        }
    }else{
    [self showSimplePromptBox:self andMesage:message];
    }
}


- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH, SCREENHEIGHT-114)];
    [self.view addSubview:mainScrollView];
    
    UIView *fBackView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 178) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:fBackView];
    
    UIImageView *hpImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-63)/2,35,63,63)];
    hpImageView.image=[UIImage imageNamed:@"ell_4"];
    [fBackView addSubview:hpImageView];
    
    if (1) {
        UIImageView *vipImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-63)/2+45,80,18,18)];
        vipImageView.image=[UIImage imageNamed:@"v_2"];
        [fBackView addSubview:vipImageView];
    }
    
    UILabel *levelLabel=[self addLabel:CGRectMake(0, hpImageView.frame.origin.y+hpImageView.frame.size.height+10, SCREENWIDTH, 20) andText:memberItem.member_truename andFont:BIGFONT andColor:TEXTCOLOR andAlignment:1];
    [fBackView addSubview:levelLabel];
    
    UILabel *numberLabel=[self addLabel:CGRectMake(0,levelLabel.frame.origin.y+levelLabel.frame.size.height, SCREENWIDTH, 20) andText:@"52岁  女" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:1];
    [fBackView addSubview:numberLabel];
    
    [self addLineLabel:CGRectMake(0,178, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fBackView];
    
    infoButton=[self addButton:CGRectMake(0, fBackView.frame.origin.y+fBackView.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openInfo:)];
    [mainScrollView addSubview:infoButton];
    
    UIImageView *infoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    infoImageView.image=[UIImage imageNamed:@"General-Information"];
    [infoButton addSubview:infoImageView];
    
    UILabel *infoLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"基本信息" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [infoButton addSubview:infoLabel];
    
    UILabel *iopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [infoButton addSubview:iopenLabel];
    
    UIImageView *igoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    igoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [infoButton addSubview:igoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:infoButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:infoButton];
    
    sHistoryButton=[self addButton:CGRectMake(0,infoButton.frame.origin.y+infoButton.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openSelfHistory:)];
    [mainScrollView addSubview:sHistoryButton];
    
    UIImageView *sHistoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    sHistoryImageView.image=[UIImage imageNamed:@"anamnesis"];
    [sHistoryButton addSubview:sHistoryImageView];
    
    UILabel *sHistoryLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"既往病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [sHistoryButton addSubview:sHistoryLabel];
    
    UILabel *sopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [sHistoryButton addSubview:sopenLabel];
    
    UIImageView *sgoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    sgoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [sHistoryButton addSubview:sgoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sHistoryButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:sHistoryButton];
    
    fHistoryButton=[self addButton:CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,45) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(openFamilyHistory:)];
    [mainScrollView addSubview:fHistoryButton];
    
    UIImageView *fHistoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5, 20,20)];
    fHistoryImageView.image=[UIImage imageNamed:@"Family-History"];
    [fHistoryButton addSubview:fHistoryImageView];
    
    UILabel *fHistoryLabel=[self addLabel:CGRectMake(47.5,12.5, 100, 20) andText:@"家族病史" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [fHistoryButton addSubview:fHistoryLabel];
    
    UILabel *fopenLabel=[self addLabel:CGRectMake(SCREENWIDTH-80, 12.5, 45, 20) andText:@"展开" andFont:SMALLFONT andColor:TEXTCOLORDG andAlignment:2];
    [fHistoryButton addSubview:fopenLabel];
    
    UIImageView *fgoImagView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-29,15,14,14)];
    fgoImagView.image=[UIImage imageNamed:@"arrow_2"];
    [fHistoryButton addSubview:fgoImagView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    [self addLineLabel:CGRectMake(0, 45, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:fHistoryButton];
    
    
    UIButton *chatButton=[self addSimpleButton:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH/2, 50) andBColor:GREENCOLOR andTag:0 andSEL:@selector(startChat:) andText:@"发起会话" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:chatButton];
    
    UIButton *videoButton=[self addSimpleButton:CGRectMake(SCREENWIDTH/2, SCREENHEIGHT-50, SCREENWIDTH/2, 50) andBColor:GREENCOLOR andTag:0 andSEL:nil andText:@"视频会话" andFont:BIGFONT andColor:MAINWHITECOLOR andAlignment:1];
    [self.view addSubview:videoButton];

    [self addLineLabel:CGRectMake(SCREENWIDTH/2, SCREENHEIGHT-50, 0.5, 50) andColor:[self colorWithHexString:@"dddddd"] andBackView:self.view];
}

- (void)startChat:(UIButton*)button{
    ChatItem *item=[ChatItem new];
    item.from=self.LOnlyCode;
    item.fromName=memberItem.member_truename;
    item.fromFace=@"";
    CNewsViewController *cvc=[CNewsViewController new];
    cvc.chatItem=item;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)openInfo:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        infoButton.frame=CGRectMake(0, infoButton.frame.origin.y,SCREENWIDTH, 125);
        [self addLineLabel:CGRectMake(0, infoButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:infoButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        infoButton.frame=CGRectMake(0, infoButton.frame.origin.y,SCREENWIDTH, 45);
        for (UIView *subView in [infoButton subviews]) {
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    sHistoryButton.frame=CGRectMake(0,infoButton.frame.origin.y+infoButton.frame.size.height+8, SCREENWIDTH,sHistoryButton.frame.size.height);
    fHistoryButton.frame=CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,fHistoryButton.frame.size.height);
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
}

- (void)openSelfHistory:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        sHistoryButton.frame=CGRectMake(0, sHistoryButton.frame.origin.y,SCREENWIDTH, 120);
        [self addLineLabel:CGRectMake(0, sHistoryButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:sHistoryButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        sHistoryButton.frame=CGRectMake(0, sHistoryButton.frame.origin.y,SCREENWIDTH, 45);
        for (UIView *subView in [sHistoryButton subviews]) {
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    fHistoryButton.frame=CGRectMake(0,sHistoryButton.frame.origin.y+sHistoryButton.frame.size.height+8, SCREENWIDTH,fHistoryButton.frame.size.height);
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
}

- (void)openFamilyHistory:(UIButton*)button{
    UILabel *openLabel=[[button subviews] objectAtIndex:2];
    UIImageView *openImageView=[[button subviews] objectAtIndex:3];
    if (button.selected==NO) {
        openLabel.text=@"收起";
        openImageView.image=[UIImage imageNamed:@"arrow_2_down"];
        fHistoryButton.frame=CGRectMake(0, fHistoryButton.frame.origin.y,SCREENWIDTH, 120);
        [self addLineLabel:CGRectMake(0, fHistoryButton.frame.size.height, SCREENWIDTH,0.5) andColor:LINECOLOR andBackView:fHistoryButton];
        button.selected=YES;
    }else{
        openLabel.text=@"展开";
        openImageView.image=[UIImage imageNamed:@"arrow_2"];
        fHistoryButton.frame=CGRectMake(0, fHistoryButton.frame.origin.y,SCREENWIDTH, 45);
        for (UIView *subView in [fHistoryButton subviews]) {
            if (subView.frame.origin.y>45) {
                [subView removeFromSuperview];
            }
        }
        button.selected=NO;
    }
    mainScrollView.contentSize=CGSizeMake(SCREENWIDTH, fHistoryButton.frame.origin.y+fHistoryButton.frame.size.height+20);
}



- (void)addFollow:(UIButton*)button{
    [self showSimplePromptBox:self andMesage:@"添加关注成功"];
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
