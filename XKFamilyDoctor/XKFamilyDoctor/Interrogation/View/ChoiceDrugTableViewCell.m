//
//  ChoiceDrugTableViewCell.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChoiceDrugTableViewCell.h"
#import <CoreText/CoreText.h>

@implementation ChoiceDrugTableViewCell

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
    self.drugBackViewO=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.drugBackViewO];
    
    self.drugBackViewT=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.drugBackViewT];
    
    self.drugImageViewO=[UIImageView new];
    [self.drugBackViewO addSubview:self.drugImageViewO];
    
    self.drugImageViewT=[UIImageView new];
    [self.drugBackViewT addSubview:self.drugImageViewT];
    
    self.signImageViewO=[UIImageView new];
    [self.drugBackViewO addSubview:self.signImageViewO];
    
    self.signImageViewT=[UIImageView new];
    [self.drugBackViewT addSubview:self.signImageViewT];
    
    self.drugNameLabelO=[UILabel new];
    self.drugNameLabelO.font=[UIFont systemFontOfSize:SMALLFONT];
    self.drugNameLabelO.numberOfLines=2;
    [self.contentView addSubview:self.drugNameLabelO];
    
    self.drugNameLabelT=[UILabel new];
    self.drugNameLabelT.font=[UIFont systemFontOfSize:SMALLFONT];
    self.drugNameLabelT.numberOfLines=2;
    [self.contentView addSubview:self.drugNameLabelT];
    
    self.priceLabelO=[UILabel new];
    self.priceLabelO.font=[UIFont systemFontOfSize:BIGFONT];
    self.priceLabelO.textColor=PRICECOLOR;
    [self.contentView addSubview:self.priceLabelO];
    
    self.priceLabelT=[UILabel new];
    self.priceLabelT.font=[UIFont systemFontOfSize:BIGFONT];
    self.priceLabelT.textColor=PRICECOLOR;
    [self.contentView addSubview:self.priceLabelT];
    
    self.addButtonO=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButtonO setImage:[UIImage imageNamed:@"add_2"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButtonO];
    
    self.addButtonT=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButtonT setImage:[UIImage imageNamed:@"add_2"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButtonT];
    
    
    [self.drugBackViewO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(7);
        make.top.equalTo(self.contentView.mas_top).offset(4);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.width.equalTo(self.drugBackViewT);
        
    }];
    
    [self.drugBackViewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugBackViewO.mas_right).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-7);
        make.top.equalTo(self.drugBackViewO.mas_top);
        make.bottom.equalTo(self.drugBackViewO.mas_bottom);
        make.width.equalTo(self.drugBackViewO);
    }];
    

    [self.drugImageViewO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugBackViewO.mas_left).offset(8);
        make.right.equalTo(self.drugBackViewO.mas_right).offset(-8);
        make.top.equalTo(self.drugBackViewO.mas_top).offset(15);
        make.height.mas_equalTo(self.drugImageViewO.mas_width).multipliedBy(0.6);
        
    }];
    

    [self.drugImageViewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugBackViewT.mas_left).offset(8);
        make.right.equalTo(self.drugBackViewT.mas_right).offset(-8);
        make.top.equalTo(self.drugBackViewT.mas_top).offset(15);
        make.height.mas_equalTo(self.drugImageViewO.mas_width).multipliedBy(0.6);
    }];
    

    [self.signImageViewO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugBackViewO.mas_left).offset(8);
        make.top.equalTo(self.drugImageViewO.mas_bottom).offset(12);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(12);
        
    }];
    

    [self.signImageViewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugBackViewT.mas_left).offset(8);
        make.top.equalTo(self.drugImageViewT.mas_bottom).offset(12);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(12);
    }];
    

    
    [self.drugNameLabelO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugImageViewO.mas_left);
        make.right.equalTo(self.drugImageViewO.mas_right);
        make.top.equalTo(self.drugImageViewO.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    

    
    [self.drugNameLabelT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugImageViewT.mas_left);
        make.right.equalTo(self.drugImageViewT.mas_right);
        make.top.equalTo(self.drugImageViewT.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    

    
    [self.priceLabelO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugNameLabelO);
        make.right.equalTo(self.drugNameLabelO.mas_right).offset(-40);
        make.top.equalTo(self.drugNameLabelO.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    



    
    [self.priceLabelT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drugNameLabelT);
        make.right.equalTo(self.drugNameLabelT.mas_right).offset(-40);
        make.top.equalTo(self.drugNameLabelT.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
    }];
    

    [self.addButtonO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drugNameLabelO.mas_bottom).offset(8);
        make.right.equalTo(self.drugBackViewO.mas_right).offset(-8);
        make.width.height.mas_equalTo(32);
    }];
    

    [self.addButtonT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drugNameLabelT.mas_bottom).offset(8);
        make.right.equalTo(self.drugBackViewT.mas_right).offset(-8);
        make.width.height.mas_equalTo(32);
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
