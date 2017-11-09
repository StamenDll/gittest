//
//  MyQuestionTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyQuestionTableViewCell.h"

@implementation MyQuestionTableViewCell

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
    self.contentView.backgroundColor=MAINWHITECOLOR;
    
    self.titleLabel=[UILabel new];
    self.titleLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.titleLabel.textColor=TEXTCOLOR;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.commentLabel=[UILabel new];
    self.commentLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.commentLabel.textColor=TEXTCOLORDG;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    
    self.timeLabel=[UILabel new];
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.timeLabel.textColor=TEXTCOLORDG;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.commentLabel.mas_right);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    self.lineLabelO=[UILabel new];
    self.lineLabelO.backgroundColor=LINECOLOR;
    [self.contentView addSubview:self.lineLabelO];
    [self.lineLabelO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
   self.lineLabelT=[UILabel new];
    self.lineLabelT.backgroundColor=LINECOLOR;
    [self.contentView addSubview:self.lineLabelT];
    [self.lineLabelT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}
@end
