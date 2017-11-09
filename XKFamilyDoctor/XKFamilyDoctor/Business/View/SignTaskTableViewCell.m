//
//  SignTaskTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SignTaskTableViewCell.h"

@implementation SignTaskTableViewCell

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
    self.nameLabel=[UILabel new];
    self.nameLabel.textColor=TEXTCOLOR;
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    self.mobileLabel=[UILabel new];
    self.mobileLabel.textColor=TEXTCOLOR;
    self.mobileLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.addressLabel=[UILabel new];
    self.addressLabel.textColor=TEXTCOLORG;
    self.addressLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,69.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

@end
