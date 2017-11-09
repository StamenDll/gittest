//
//  BillingTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface BillingTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *diseaseLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *detailButton;
@end
