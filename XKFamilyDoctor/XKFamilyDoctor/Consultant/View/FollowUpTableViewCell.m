//
//  FollowUpTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FollowUpTableViewCell.h"

@implementation FollowUpTableViewCell
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
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(self.mainImageView.mas_height);
    }];
    self.mainImageView.clipsToBounds=YES;
    [self.mainImageView.layer setCornerRadius:20];
    
//    self.fileNoLabel=[UILabel new];
//    self.fileNoLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
//    self.fileNoLabel.textColor=TEXTCOLOR;
//    [self.fileNoLabel sizeToFit];
//    [self.contentView addSubview:self.fileNoLabel];
//    [self.fileNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mainImageView);
//        make.left.equalTo(self.mainImageView.mas_right).offset(10);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.height.mas_equalTo(20);
//    }];
    
    self.writeTimeLabel=[UILabel new];
    self.writeTimeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.writeTimeLabel.textColor=TEXTCOLORG;
    [self.writeTimeLabel sizeToFit];
    [self.contentView addSubview:self.writeTimeLabel];
    [self.writeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.centerY.equalTo(self.mainImageView.mas_centerY);
        make.height.mas_equalTo(20);
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
