//
//  ORTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface ORTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *hospitalName;
@property(nonatomic,strong)UILabel *orderTime;
@property(nonatomic,strong)UILabel *lineLabel;
@end
