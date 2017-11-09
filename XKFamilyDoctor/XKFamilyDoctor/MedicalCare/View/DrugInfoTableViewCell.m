//
//  DrugInfoTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DrugInfoTableViewCell.h"

@implementation DrugInfoTableViewCell

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
    self.mainImageView=[UIImageView new];
    [self.contentView addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.mas_equalTo(80);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.textColor=TEXTCOLOR;
    self.nameLabel.numberOfLines=0;
    [self.nameLabel sizeToFit];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    self.companyLabel=[UILabel new];
    self.companyLabel.textColor=TEXTCOLORG;
    self.companyLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    [self.contentView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.priceLabel=[UILabel new];
    self.priceLabel.textColor=[UIColor redColor];
    self.priceLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel.mas_bottom).offset(5);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    self.choiceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.choiceButton.backgroundColor=GREENCOLOR;
    [self.choiceButton.layer setCornerRadius:5];
    [self.contentView addSubview:self.choiceButton];
    [self.choiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *choiceLabel=[UILabel new];
    choiceLabel.textColor=MAINWHITECOLOR;
    choiceLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    choiceLabel.textAlignment=1;
    choiceLabel.text=@"选择";
    [self.choiceButton addSubview:choiceLabel];
    [choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.choiceButton);
    }];
    
    self.lineLabel1=[UILabel new];
    self.lineLabel1.backgroundColor=LINECOLOR;
    [self.contentView addSubview:self.lineLabel1];
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(0.5);
    }];
}

@end
