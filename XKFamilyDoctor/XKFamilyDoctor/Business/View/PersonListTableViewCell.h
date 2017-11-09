//
//  PersonListTableViewCell.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface PersonListTableViewCell : RootTableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *depNameLabel;
@property(nonatomic,strong)UILabel *printLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *printButton;
@end
