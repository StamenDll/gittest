//
//  ChatroomTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatroomTableViewCell.h"

@implementation ChatroomTableViewCell

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
    
    self.BGView=[UIView new];
    self.BGView.backgroundColor=MAINWHITECOLOR;
    [self.contentView addSubview:self.BGView];
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    self.mainImageView=[UIImageView new];
    [self.mainImageView.layer setCornerRadius:20];
    self.mainImageView.clipsToBounds=YES;
    [self.BGView addSubview:self.mainImageView];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BGView.mas_left).offset(15);
        make.top.equalTo(self.BGView.mas_top).offset(10);
        make.height.width.mas_equalTo(40);
    }];
    
    self.nameLabel=[UILabel new];
    self.nameLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.nameLabel.textColor=TEXTCOLOR;
    [self.BGView addSubview:self.nameLabel];
    
    self.personLabel=[UILabel new];
    self.personLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    self.personLabel.textColor=[self colorWithHexString:@"f4631c"];
    self.personLabel.textAlignment=2;
    [self.BGView addSubview:self.personLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_top).offset(10);
        make.left.equalTo(self.mainImageView.mas_right).offset(15);
        make.right.equalTo(self.personLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_top).offset(10);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.BGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.doctorLabel=[UILabel new];
    self.doctorLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.doctorLabel.textColor=TEXTCOLORDG;
    [self.BGView addSubview:self.doctorLabel];
    
    self.markLabel=[UILabel new];
    self.markLabel.font=[UIFont fontWithName:FONTTYPEME size:SMALLFONT];
    self.markLabel.textColor=TEXTCOLORDG;
    self.markLabel.textAlignment=2;
    [self.BGView addSubview:self.markLabel];
    
    [self.doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.mainImageView.mas_right).offset(15);
        make.right.equalTo(self.markLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.doctorLabel.mas_right).offset(10);
        make.right.equalTo(self.BGView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.detailImageView=[UIImageView new];
    self.detailImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.detailImageView.clipsToBounds=YES;
    [self.BGView addSubview:self.detailImageView];
    [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.BGView);
        make.top.equalTo(self.mainImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(162);
    }];
    
    self.lineLabel=[UILabel new];
    [self.BGView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor=LINECOLOR;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.BGView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.lineLabel1=[UILabel new];
    [self.BGView addSubview:self.lineLabel1];
    self.lineLabel1.backgroundColor=LINECOLOR;
    [self.lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.BGView);
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
