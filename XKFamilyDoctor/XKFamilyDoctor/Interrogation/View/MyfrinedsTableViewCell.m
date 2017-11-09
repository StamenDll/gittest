//
//  MyfrinedsTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyfrinedsTableViewCell.h"

@implementation MyfrinedsTableViewCell

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
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.equalTo(self.contentView.mas_height).offset(-20);
    }];
    [self.mainImageView.layer setCornerRadius:25];
    self.mainImageView.clipsToBounds=YES;
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainImageView.mas_centerY);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    self.timeLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainImageView.mas_top);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
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
