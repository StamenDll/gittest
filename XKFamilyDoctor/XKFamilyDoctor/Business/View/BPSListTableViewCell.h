//
//  BPSListTableViewCell.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface BPSListTableViewCell : RootTableViewCell
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *BPSCountLabel;
@property(nonatomic,strong)UILabel *HRCountLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@end
