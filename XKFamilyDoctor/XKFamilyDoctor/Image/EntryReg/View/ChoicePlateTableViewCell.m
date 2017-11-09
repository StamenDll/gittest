//
//  ChoicePlateTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ChoicePlateTableViewCell.h"

@implementation ChoicePlateTableViewCell
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
    self.addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.addButton setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    self.addButton.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.nameLabel=[UILabel new];
    self.nameLabel.textColor=TEXTCOLOR;
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textAlignment=0;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addButton.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.goImageView=[UIImageView new];
    self.goImageView.image=[UIImage imageNamed:@"arrow_2"];
    [self.contentView addSubview:self.goImageView];
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.height.width.mas_equalTo(15);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,59.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}
@end
