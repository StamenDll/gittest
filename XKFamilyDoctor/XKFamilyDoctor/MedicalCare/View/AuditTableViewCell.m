//
//  AuditTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AuditTableViewCell.h"

@implementation AuditTableViewCell

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
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.equalTo(self.mainImageView.mas_height);
    }];
    
    self.nameLabel=[UILabel new];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    self.timeLabel=[UILabel new];
     self.timeLabel.font=[UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    

    
    self.ageLabel=[UILabel new];
    self.ageLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.ageLabel];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-70);
        make.height.mas_equalTo(20);
    }];
    
    self.stateLabel=[UILabel new];
    self.stateLabel.textColor=MAINWHITECOLOR;
    self.stateLabel.font=[UIFont systemFontOfSize:12];
    [self.stateLabel.layer setCornerRadius:10];
    self.stateLabel.clipsToBounds=YES;
    self.stateLabel.textAlignment=1;
    [self.contentView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-60);
        make.top.equalTo(self.ageLabel);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,66.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}

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
