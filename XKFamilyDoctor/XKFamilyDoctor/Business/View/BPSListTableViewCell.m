//
//  BPSListTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BPSListTableViewCell.h"

@implementation BPSListTableViewCell

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
    self.timeLabel=[UILabel new];
    self.timeLabel.textColor=TEXTCOLORG;
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.BPSCountLabel=[UILabel new];
    self.BPSCountLabel.textColor=TEXTCOLORG;
    self.BPSCountLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.BPSCountLabel];
    
    self.HRCountLabel=[UILabel new];
    self.HRCountLabel.textColor=TEXTCOLORG;
    self.HRCountLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.HRCountLabel];
    
    self.stateLabel=[UILabel new];
    self.stateLabel.textColor=GREENCOLOR;
    self.stateLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.stateLabel];
    
    [self.BPSCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.HRCountLabel.mas_left).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(self.HRCountLabel.mas_width);
    }];
    
    [self.HRCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BPSCountLabel.mas_right).offset(10);
        make.right.equalTo(self.stateLabel.mas_left).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.equalTo(self.BPSCountLabel.mas_width);

    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HRCountLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,69.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

@end
