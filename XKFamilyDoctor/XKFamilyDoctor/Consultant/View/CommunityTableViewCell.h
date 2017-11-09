//
//  CommunityTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface CommunityTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *addressImageView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UIImageView *goImageView;
@end
