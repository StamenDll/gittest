//
//  CommunityTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommunityTableViewCell.h"

@implementation CommunityTableViewCell

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
//    self.mainImageView=[UIImageView new];
//    [self.contentView addSubview:self.mainImageView];
//    
//    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.height.width.equalTo(self.contentView.mas_height).offset(-18);
//    }];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textColor=TEXTCOLOR;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-130);
        make.height.mas_equalTo(20);
    }];
    
    self.distanceLabel=[UILabel new];
    self.distanceLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.distanceLabel.textColor=TEXTCOLORG;
    self.distanceLabel.textAlignment=2;
    [self.contentView addSubview:self.distanceLabel];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.nameLabel.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    self.addressImageView=[UIImageView new];
    [self.contentView addSubview:self.addressImageView];
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.height.with.mas_equalTo(15);
    }];
    
    self.addressLabel=[UILabel new];
    self.addressLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.addressLabel.textColor=TEXTCOLORDG;
    [self.contentView addSubview:self.addressLabel];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.equalTo(self.nameLabel.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.lineLabel=[UILabel new];
    [self.contentView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor=LINECOLOR;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(0.5);
    }];
    
    self.goImageView=[UIImageView new];
    self.goImageView.image=[UIImage imageNamed:@"godetail"];
    [self.contentView addSubview:self.goImageView];
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_right).offset(-25);
        make.height.with.mas_equalTo(15);
    }];
}

@end
