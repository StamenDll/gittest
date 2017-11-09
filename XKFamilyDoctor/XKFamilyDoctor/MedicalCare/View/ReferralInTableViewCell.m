//
//  ReferralInTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReferralInTableViewCell.h"

@implementation ReferralInTableViewCell

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
    self.contentView.backgroundColor=BGGRAYCOLOR;
    self.backView=[UIView new];
    self.backView.backgroundColor=MAINWHITECOLOR;
    [self.contentView addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    
    self.mainImageView=[UIImageView new];
    [self.backView addSubview:self.mainImageView];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(15);
        make.top.equalTo(self.backView.mas_top).offset(18);
        make.width.height.mas_equalTo(63);
    }];
    
    
    self.nameLabel=[UILabel new];
    self.nameLabel.textColor=TEXTCOLOR;
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:BIGFONT];
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.numberLabel=[UILabel new];
    self.numberLabel.textColor=TEXTCOLORDG;
    self.numberLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameLabel);
    }];
    
    self.stateLabel=[UILabel new];
    self.stateLabel.textColor=TEXTCOLORDG;
    self.stateLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.backView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom);
        make.left.right.height.equalTo(self.numberLabel);
    }];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.textColor=TEXTCOLORDG;
    self.timeLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom);
        make.left.right.height.equalTo(self.stateLabel);
    }];
    
    self.detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.detailButton];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(-37);
        make.left.equalTo(self.mainImageView);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-7);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *detailLabel=[UILabel new];
    detailLabel.text=@"申请详情";
    detailLabel.textColor=TEXTCOLOR;
    detailLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    detailLabel.textAlignment=NSTextAlignmentLeft;
    [self.detailButton addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailButton);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.detailButton.mas_centerY);
    }];


    self.returnButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.returnButton.layer.borderColor=LINECOLOR.CGColor;
    self.returnButton.layer.borderWidth=0.5;
    [self.returnButton.layer setCornerRadius:15];
    [self.backView addSubview:self.returnButton];
    
    self.receiveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.receiveButton.layer.borderColor=LINECOLOR.CGColor;
    self.receiveButton.layer.borderWidth=0.5;
    [self.receiveButton.layer setCornerRadius:15];
    [self.backView addSubview:self.receiveButton];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(-37);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-7);
        make.right.equalTo(self.receiveButton.mas_left).offset(-9);
        make.width.equalTo(self.detailButton);
    }];
    
    [self.receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(-37);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-7);
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.width.equalTo(self.detailButton);
    }];
    
    
    
    UILabel *returnLabel=[UILabel new];
    returnLabel.text=@"退回申请";
    returnLabel.font=[UIFont systemFontOfSize:14];
    returnLabel.textAlignment=NSTextAlignmentCenter;
    [self.returnButton addSubview:returnLabel];
    [returnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.returnButton);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.returnButton.mas_centerY);
    }];
    
    UILabel *receiveLabel=[UILabel new];
    receiveLabel.text=@"接收申请";
    receiveLabel.font=[UIFont systemFontOfSize:14];
    receiveLabel.textAlignment=NSTextAlignmentCenter;
    [self.receiveButton addSubview:receiveLabel];
    [receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.receiveButton);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.receiveButton.mas_centerY);
    }];
    
    self.lineLabel1=[UILabel new];
    [self.backView addSubview:self.lineLabel1];
    self.lineLabel1.backgroundColor=LINECOLOR;
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.lineLabel2=[UILabel new];
    [self.backView addSubview:self.lineLabel2];
    self.lineLabel2.backgroundColor=LINECOLOR;
    [self.lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.backView.mas_bottom).offset(-45);
        make.width.equalTo(self.backView.mas_width);
        make.height.mas_equalTo(0.5);
    }];
    
    self.lineLabel3=[UILabel new];
    [self.backView addSubview:self.lineLabel3];
    self.lineLabel3.backgroundColor=LINECOLOR;
    [self.lineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.backView.mas_bottom).offset(-0.5);
        make.width.equalTo(self.backView.mas_width);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end