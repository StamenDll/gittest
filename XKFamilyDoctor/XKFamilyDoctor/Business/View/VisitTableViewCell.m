//
//  VisitTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "VisitTableViewCell.h"

@implementation VisitTableViewCell

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
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.IDCardLabel=[UILabel new];
    self.IDCardLabel.textColor=TEXTCOLORG;
    self.IDCardLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.IDCardLabel];
    [self.IDCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.sexAndNationLabel=[UILabel new];
    self.sexAndNationLabel.textColor=TEXTCOLORG;
    self.sexAndNationLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.sexAndNationLabel];
    [self.sexAndNationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.IDCardLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    self.birLabel=[UILabel new];
    self.birLabel.textColor=TEXTCOLORG;
    self.birLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.birLabel];
    [self.birLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.sexAndNationLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    self.addressLabel=[UILabel new];
    self.addressLabel.textColor=TEXTCOLORG;
    self.addressLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.addressLabel.numberOfLines=2;
    [self.addressLabel sizeToFit];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.birLabel.mas_bottom).offset(5);
    }];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,149.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

@end
