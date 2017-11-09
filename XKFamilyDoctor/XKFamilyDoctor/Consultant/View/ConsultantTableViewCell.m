//
//  ConsultantTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ConsultantTableViewCell.h"

@implementation ConsultantTableViewCell

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
    self.userImageView=[UIImageView new];
    [self.contentView addSubview:self.userImageView];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(self.userImageView.mas_height);
    }];
    self.userImageView.clipsToBounds=YES;
    [self.userImageView.layer setCornerRadius:30];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textColor=TEXTCOLOR;
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImageView.mas_centerY);
        make.left.equalTo(self.userImageView.mas_right).offset(10);
    }];
    
//    self.infoLabel=[UILabel new];
//    self.infoLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
//    self.infoLabel.textColor=TEXTCOLORG;
//    [self.contentView addSubview:self.infoLabel];
//    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userImageView.mas_right).offset(10);
//        make.right.equalTo(self.contentView.mas_right).offset(-110);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
//        make.height.mas_equalTo(20);
//    }];
    
    self.manageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.manageButton.layer.borderColor=LINECOLOR.CGColor;
    self.manageButton.layer.borderWidth=0.5;
    [self.manageButton.layer setCornerRadius:17.5];
    [self.contentView addSubview:self.manageButton];
    [self.manageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-95);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *manageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 7.5,80,20)];
    manageLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    manageLabel.textColor=TEXTCOLORG;
    manageLabel.text=@"管理信息";
    manageLabel.textAlignment=1;
    [self.manageButton addSubview:manageLabel];
    
    self.lineLabel=[UILabel new];
    [self.contentView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor=LINECOLOR;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
