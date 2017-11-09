//
//  BillingTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BillingTableViewCell.h"

@implementation BillingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    self.contentView.backgroundColor=BGGRAYCOLOR;
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:11]
    ;
    self.timeLabel.textColor=TEXTCOLORDG;
    self.timeLabel.textAlignment=1;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.backView=[UIView new];
    self.backView.backgroundColor=MAINWHITECOLOR;
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    self.numberLabel=[UILabel new];
    self.numberLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT]
    ;
    self.numberLabel.textColor=TEXTCOLOR;
    [self.backView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.mainImageView=[UIImageView new];
    [self.backView addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom).offset(10);
        make.left.equalTo(self.numberLabel);
        make.width.height.mas_equalTo(50);
    }];
    
    self.vipImageView=[UIImageView new];
    [self.backView addSubview:self.vipImageView];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.mainImageView);
        make.width.height.mas_equalTo(14);
    }];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT]
    ;
    self.nameLabel.textColor=TEXTCOLOR;
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mainImageView.mas_right).offset(15);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.diseaseLabel=[UILabel new];
    self.diseaseLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT]
    ;
    self.diseaseLabel.textColor=TEXTCOLOR;
    [self.backView addSubview:self.diseaseLabel];
    [self.diseaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.left.height.right.equalTo(self.nameLabel);
    }];
    
    self.detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(-36);
        make.left.equalTo(self.mainImageView);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.right.equalTo(self.backView).offset(-9);
    }];
    
    UILabel *detailLabel=[UILabel new];
    detailLabel.text=@"查看详情";
    detailLabel.textColor=TEXTCOLORDG;
    detailLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    [self.detailButton addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailButton);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.detailButton.mas_centerY);
    }];
    

    UILabel *lineLabel=[UILabel new];
    lineLabel.backgroundColor=LINECOLOR;
    [self.backView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailButton);
        make.left.mas_equalTo(10);
        make.right.equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
}
@end
