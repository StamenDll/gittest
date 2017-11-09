
//
//  MyOrderTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell{
    self.orderBGView=[UIView new];
    self.orderBGView.backgroundColor=MAINWHITECOLOR;
    [self.contentView addSubview:self.orderBGView];
    [self.orderBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.right.bottom.equalTo(self.contentView);
        
    }];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textColor=TEXTCOLOR;
    [self.orderBGView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderBGView.mas_top).offset(10);
        make.left.equalTo(self.orderBGView.mas_left).offset(15);
        make.right.equalTo(self.orderBGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.moneyLabel=[UILabel new];
    self.moneyLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.moneyLabel.textColor=[UIColor redColor];
    [self.orderBGView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.orderBGView.mas_left).offset(15);
        make.right.equalTo(self.orderBGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.stateLabel=[UILabel new];
    self.stateLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.stateLabel.textColor=TEXTCOLORG;
    [self.orderBGView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.left.equalTo(self.orderBGView.mas_left).offset(15);
        make.right.equalTo(self.orderBGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.timeLabel.textColor=TEXTCOLORG;
    [self.orderBGView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom);
        make.left.equalTo(self.orderBGView.mas_left).offset(15);
        make.right.equalTo(self.orderBGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.selLabel=[UILabel new];
    self.selLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.selLabel.textColor=MAINWHITECOLOR;
    self.selLabel.textAlignment=1;
    [self.orderBGView addSubview:self.selLabel];
    [self.selLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderBGView.mas_right).offset(-75);
        make.right.equalTo(self.orderBGView.mas_right).offset(-15);
        make.bottom.equalTo(self.timeLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];

    UILabel *lineLabel=[UILabel new];
    lineLabel.backgroundColor=LINECOLOR;
    [self.orderBGView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.orderBGView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *lineLabel1=[UILabel new];
    lineLabel1.backgroundColor=LINECOLOR;
    [self.orderBGView addSubview:lineLabel1];
    [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.orderBGView);
        make.height.mas_equalTo(0.5);
    }];
    
}

//- (void)setOrderViewFrame:(OrderFrame *)model{
//    self.orderBGView.frame=CGRectMake(0, 10, SCREENWIDTH, model.cellHeight-10);
//    
//    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 0.5)];
//    lineLabel.backgroundColor=LINECOLOR;
//    [self.orderBGView addSubview:lineLabel];
//    
//    UIImageView *communityImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20,13, 15, 15)];
//    communityImageView.image=[UIImage imageNamed:@"community-logo"];
//    [self.orderBGView addSubview:communityImageView];
//    
//    UILabel *communityLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 100, 20)];
//    communityLabel.text=model.orderInfo.communityName;
//    communityLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//    communityLabel.textColor=TEXTCOLOR;
//    communityLabel.numberOfLines=0;
//    [communityLabel sizeToFit];
//    [self.orderBGView addSubview:communityLabel];
//    
//    UILabel *stateLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-80, 10,65, 20)];
//    stateLabel.text=model.orderInfo.state;
//    stateLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//    stateLabel.textColor=[UIColor orangeColor];
//    stateLabel.textAlignment=2;
//    [self.orderBGView addSubview:stateLabel];
//    
//    for (int i=0; i<model.orderInfo.goodsArray.count; i++) {
//        UIView *goodsBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 40+90*i, SCREENWIDTH, 90)];
//        goodsBGView.backgroundColor=BGGRAYCOLOR;
//        [self.orderBGView addSubview:goodsBGView];
//        
//        UIImageView *goodsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 70, 70)];
//        goodsImageView.backgroundColor=GREENCOLOR;
//        [goodsBGView addSubview:goodsImageView];
//        
//        UILabel *goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 15,SCREENWIDTH-180, 20)];
//        goodsNameLabel.text=@"产品名称";
//        goodsNameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//        goodsNameLabel.textColor=TEXTCOLOR;
//        [goodsBGView addSubview:goodsNameLabel];
//        
//        UILabel *goodsPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-80, 15,65, 20)];
//        goodsPriceLabel.text=@"¥40.00";
//        goodsPriceLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//        goodsPriceLabel.textColor=TEXTCOLOR;
//        goodsPriceLabel.textAlignment=2;
//        [goodsBGView addSubview:goodsPriceLabel];
//        
//        UILabel *goodsCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-80,35,65, 20)];
//        goodsCountLabel.text=@"X1";
//        goodsCountLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//        goodsCountLabel.textColor=TEXTCOLORDG;
//        goodsCountLabel.textAlignment=2;
//        [goodsBGView addSubview:goodsCountLabel];
//    }
//    
//    UILabel *totleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,40+90*model.orderInfo.goodsArray.count+10,SCREENWIDTH-30, 20)];
//    totleLabel.text=[NSString stringWithFormat:@"共计%lu件商品 合计：¥40.00元 （含运费¥0.00）",(unsigned long)model.orderInfo.goodsArray.count];
//    totleLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
//    totleLabel.textColor=TEXTCOLOR;
//    totleLabel.textAlignment=2;
//    [self.orderBGView addSubview:totleLabel];
//    
//    UILabel *lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0,totleLabel.frame.origin.y+totleLabel.frame.size.height+10, SCREENWIDTH, 0.5)];
//    lineLabel2.backgroundColor=LINECOLOR;
//    [self.orderBGView addSubview:lineLabel2];
//    
//    self.menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    self.menuButton.frame=CGRectMake(SCREENWIDTH-85, lineLabel2.frame.origin.y+10, 70, 25);
//    self.menuButton.layer.borderColor=LINECOLOR.CGColor;
//    self.menuButton.layer.borderWidth=0.5;
//    [self.menuButton.layer setCornerRadius:5];
//    [self.orderBGView addSubview:self.menuButton];
//    
//    UILabel *menuLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,70, 25)];
//    menuLabel.text=@"删除订单";
//    menuLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//    menuLabel.textColor=TEXTCOLOR;
//    menuLabel.textAlignment=1;
//    [self.menuButton addSubview:menuLabel];
//    
//    UILabel *lineLabel3=[[UILabel alloc]initWithFrame:CGRectMake(0,self.menuButton.frame.origin.y+self.menuButton.frame.size.height+10, SCREENWIDTH, 0.5)];
//    lineLabel3.backgroundColor=LINECOLOR;
//    [self.orderBGView addSubview:lineLabel3];
//}
@end
