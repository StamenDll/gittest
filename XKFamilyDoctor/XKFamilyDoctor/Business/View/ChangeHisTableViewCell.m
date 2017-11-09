//
//  ChangeHisTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChangeHisTableViewCell.h"

@implementation ChangeHisTableViewCell

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
    self.depNameLabel=[UILabel new];
    self.depNameLabel.textColor=TEXTCOLORG;
    self.depNameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.depNameLabel.textAlignment=0;
    [self.contentView addSubview:self.depNameLabel];
    [self.depNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.nowDepNameLabel=[UILabel new];
    self.nowDepNameLabel.textColor=TEXTCOLORG;
    self.nowDepNameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.nowDepNameLabel.textAlignment=0;
    [self.contentView addSubview:self.nowDepNameLabel];
    [self.nowDepNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.textColor=TEXTCOLORG;
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.timeLabel.textAlignment=0;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nowDepNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];

    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,99.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

@end
