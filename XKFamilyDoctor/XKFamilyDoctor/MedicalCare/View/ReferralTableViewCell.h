//
//  ReferralTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferralTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *lineLabel1;
@property(nonatomic,strong)UILabel *lineLabel2;
@property(nonatomic,strong)UILabel *lineLabel3;
@property(nonatomic,strong)UIButton *detailButton;
@property(nonatomic,strong)UIButton *handleButton;
@property(nonatomic,strong)UIButton *returnButton;
@property(nonatomic,strong)UIButton *applyButton;
@end