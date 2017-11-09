//
//  FollowUpTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface FollowUpTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *fileNoLabel;
@property(nonatomic,strong)UILabel *writeTimeLabel;
@property(nonatomic,strong)UILabel *lineLabel;
@end
