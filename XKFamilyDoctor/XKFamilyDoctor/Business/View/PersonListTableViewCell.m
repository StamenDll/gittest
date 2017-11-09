//
//  PersonListTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PersonListTableViewCell.h"

@implementation PersonListTableViewCell

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
    self.nameLabel=[UILabel new];
    self.nameLabel.textColor=TEXTCOLOR;
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    self.nameLabel.textAlignment=0;
    [self.contentView addSubview:self.nameLabel];
    
    self.printButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.printButton.backgroundColor=GREENCOLOR;
    [self.printButton.layer setCornerRadius:5];
    [self.contentView addSubview:self.printButton];
    
    [self.printButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *printNLabel=[UILabel new];
    printNLabel.textColor=MAINWHITECOLOR;
    printNLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    printNLabel.textAlignment=1;
    printNLabel.text=@"打印";
    [self.printButton addSubview:printNLabel];
    [printNLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.printButton);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.printButton.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.phoneLabel=[UILabel new];
    self.phoneLabel.textColor=TEXTCOLORG;
    self.phoneLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.phoneLabel.textAlignment=0;
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.depNameLabel=[UILabel new];
    self.depNameLabel.textColor=TEXTCOLORG;
    self.depNameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.depNameLabel.textAlignment=0;
    [self.contentView addSubview:self.depNameLabel];
    [self.depNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.printLabel=[UILabel new];
    self.printLabel.textColor=GREENCOLOR;
    self.printLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.printLabel.textAlignment=0;
    [self.contentView addSubview:self.printLabel];
    [self.printLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.addressLabel=[UILabel new];
    self.addressLabel.textColor=TEXTCOLORG;
    self.addressLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.addressLabel.textAlignment=0;
    self.addressLabel.numberOfLines=2;
    [self.addressLabel sizeToFit];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.printLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.textColor=TEXTCOLORG;
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.timeLabel.textAlignment=0;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,179.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

@end
