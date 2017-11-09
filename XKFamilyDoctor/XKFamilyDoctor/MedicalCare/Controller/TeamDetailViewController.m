//
//  TeamDetailViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "TeamDoctorItem.h"
@interface TeamDetailViewController ()

@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"我的医生团队"];
    [self addLeftButtonItem];
    [self initializationArray];
    [self creatUI];
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if (![[usd objectForKey:@"LTeamId"] isKindOfClass:[NSNull class]]) {
        [self sendRequest:@"TeamDoctor" andPath:queryURL andSqlParameter:[usd objectForKey:@"LTeamId"] and:self];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
}

- (void)popViewController{
    [self.cardScrollView removeFromSuperview];
    self.cardScrollView=nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initializationArray{
    mainArray=[NSMutableArray new];
}

-(void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        if ([type isEqualToString:@"TeamDoctor"]) {
            NSArray *data=message;
            if (data.count>0) {
                for (NSDictionary *dic in data) {
                    TeamDoctorItem *item=[RMMapper objectWithClass:[TeamDoctorItem class] fromDictionary:dic];
                    [mainArray addObject:item];
                }
                [self.cardScrollView loadCard];
            }else{
            }
        }
        
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)creatUI{
    self.cardScrollView = [[CardScrollView alloc]initWithFrame:CGRectMake(0,110, SCREENWIDTH, SCREENHEIGHT-220)];
    self.cardScrollView.cardDelegate = self;
    self.cardScrollView.cardDataSource = self;
    self.cardScrollView.scrollView.center=CGPointMake(self.cardScrollView.center.x, self.cardScrollView.scrollView.frame.size.height/2);
    [self.view addSubview:self.cardScrollView];
}

- (void)changeNameOnClick:(UIButton*)button{
    if (button.selected==NO) {
        UILabel *nameLabel=[[button subviews] firstObject];
        if (nameLabel.text.length>0) {
            [UIView animateWithDuration:0.5 animations:^{
                if (button.frame.origin.x>SCREENWIDTH/5*2) {
                    nameButtonBGView.contentOffset=CGPointMake(button.frame.origin.x-SCREENWIDTH/5*2, 0);
                }else if (nameButtonBGView.contentOffset.x==button.frame.origin.x){
                    nameButtonBGView.contentOffset=CGPointMake(0, 0);
                }
                button.selected=YES;
                button.backgroundColor=GREENCOLOR;
                nameLabel.textColor=MAINWHITECOLOR;
                nameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
                lastNameButton.backgroundColor=CLEARCOLOR;
                UILabel *lastNameLabel=[[lastNameButton subviews]firstObject];
                lastNameLabel.textColor=TEXTCOLORDG;
                lastNameLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
                lastNameButton.selected=NO;
                lastNameButton=button;
                
                doctorBGView.contentOffset=CGPointMake((SCREENWIDTH-70)*(button.frame.origin.x/(SCREENWIDTH/5)), 0);
            }];
        }
    }
}

#pragma mark - CardScrollViewDelegate
- (void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction {
    if (direction == CardMoveDirectionNone) {
        if (card.tag != [self.cardScrollView currentCard]) {
            CGFloat scale = 1 - 0.1 * progress;
            card.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
            card.layer.opacity = 1 - 0.2*progress;
        } else {
            card.layer.transform = CATransform3DIdentity;
            card.layer.opacity = 1;
        }
    } else {
        NSInteger transCardTag = direction == CardMoveDirectionLeft ? [self.cardScrollView currentCard] + 1 : [self.cardScrollView currentCard] - 1;
        if (card.tag != [self.cardScrollView currentCard] && card.tag == transCardTag) {
            card.layer.transform = CATransform3DMakeScale(0.9 + 0.1*progress, 0.9 + 0.1*progress, 1.0);
            card.layer.opacity = 0.8 + 0.2*progress;
        } else if (card.tag == [self.cardScrollView currentCard]) {
            card.layer.transform = CATransform3DMakeScale(1 - 0.1 * progress, 1 - 0.1 * progress, 1.0);
            card.layer.opacity = 1 - 0.2*progress;
        }
    }
}

#pragma mark - CardScrollViewDataSource
- (NSInteger)numberOfCards {
    return mainArray.count;
}

- (UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index {
    if (reuseView) {
        // you can set new style
        return reuseView;
    }
    
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH*0.8,SCREENHEIGHT-230)];
    card.layer.cornerRadius = 10;
    card.layer.masksToBounds = YES;
    
    TeamDoctorItem *item=[mainArray objectAtIndex:index];
    UIScrollView *contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH*0.8,SCREENHEIGHT-230)];
    contentScrollView.backgroundColor=MAINWHITECOLOR;
    [contentScrollView.layer setCornerRadius:10];
    [card addSubview:contentScrollView];
    
    UIImageView *doctorImageView=[self addImageView:CGRectMake(SCREENWIDTH*0.8-100,24,80,80) andName:@""];
    [doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,item.LPic]] placeholderImage:DOCDEFAULTPIC];
    doctorImageView.clipsToBounds=YES;
    [doctorImageView.layer setCornerRadius:40];
    [contentScrollView addSubview:doctorImageView];
    
    NSString *nameString=item.LName;
    if ([item.LLeader isEqualToString:@"是"]) {
        nameString=[NSString stringWithFormat:@"%@(队长)",nameString];
    }
    UILabel *doctorNameLabel=[self addLabel:CGRectMake(21,46, contentScrollView.frame.size.width-130,20) andText:nameString andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [contentScrollView addSubview:doctorNameLabel];
    
    [self addLineLabel:CGRectMake(15, 48, 1.5,16) andColor:[self colorWithHexString:@"#ff5d6a"] andBackView:contentScrollView];
    
    UILabel *specialtyLabel=[self addLabel:CGRectMake(21,70, contentScrollView.frame.size.width-130, 20) andText:item.LSpecialty andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:0];
    [contentScrollView addSubview:specialtyLabel];
    
    [self addLineLabel:CGRectMake(15, 122,1.5,16) andColor:[self colorWithHexString:@"#fda609"] andBackView:contentScrollView];
    
    UILabel *cTitleLabel=[self addLabel:CGRectMake(21,120, contentScrollView.frame.size.width-130, 20) andText:@"服务机构:" andFont:BIGFONT andColor:TEXTCOLOR andAlignment:0];
    [contentScrollView addSubview:cTitleLabel];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    UILabel *cNameLabel=[self addLabel:CGRectMake(21,145, contentScrollView.frame.size.width-40, 20) andText:[usd objectForKey:@"CommunityName"] andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
    cNameLabel.numberOfLines=0;
    [cNameLabel sizeToFit];
    [contentScrollView addSubview:cNameLabel];
    
    [self addLineLabel:CGRectMake(15, cNameLabel.frame.origin.y+cNameLabel.frame.size.height+17,1.5,16) andColor:[self colorWithHexString:@"#00acef"] andBackView:contentScrollView];
    
    UILabel *presentLabel=[self addLabel:CGRectMake(21, cNameLabel.frame.origin.y+cNameLabel.frame.size.height+15, 100, 20) andText:@"简介:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [contentScrollView addSubview:presentLabel];
    
    UILabel *contentLabel=[self addLabel:CGRectMake(21, presentLabel.frame.origin.y+presentLabel.frame.size.height+5, contentScrollView.frame.size.width-40, 20) andText:item.LDetail andFont:SMALLFONT andColor:TEXTCOLORG andAlignment:0];
    contentLabel.numberOfLines=0;
    [contentLabel sizeToFit];
    [contentScrollView addSubview:contentLabel];
    contentScrollView.contentSize=CGSizeMake(contentScrollView.frame.size.width, contentLabel.frame.origin.y+contentLabel.frame.size.height+20);
    return card;
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
