//
//  InterrogationCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InterrogationCell.h"

@implementation InterrogationCell

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
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.equalTo(self.contentView.mas_height).offset(-16);
    }];
    self.mainImageView.clipsToBounds=YES;
    [self.mainImageView.layer setCornerRadius:25];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textColor=TEXTCOLOR;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.mainImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-70);
        make.height.mas_equalTo(20);
    }];
    
    self.newsLabel=[UILabel new];
    self.newsLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.newsLabel.textColor=TEXTCOLORDG;
    [self.contentView addSubview:self.newsLabel];
    [self.newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-60);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.timeLabel.textColor=TEXTCOLORDG;
    self.timeLabel.textAlignment=2;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.countLabel=[UILabel new];
    self.countLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.countLabel.textColor=MAINWHITECOLOR;
    self.countLabel.textAlignment=1;
    self.countLabel.clipsToBounds=YES;
    self.countLabel.backgroundColor=[UIColor redColor];
    [self.countLabel.layer setCornerRadius:10];
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newsLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.width.mas_equalTo(20);
    }];
    
    self.lineLabel=[UILabel new];
    [self.contentView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor=LINECOLOR;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}


@end
