//
//  MyOrderTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"
#import "OrderFrame.h"
@interface MyOrderTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *orderBGView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *selLabel;
- (void)setOrderViewFrame:(OrderFrame*)model;
@end
