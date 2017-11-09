//
//  FamilyTableViewCell.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/11/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FamilyTableViewCell.h"

@implementation FamilyTableViewCell

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
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,49.5, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor=LINECOLOR;
    [self.contentView addSubview:lineLabel];
}
@end
