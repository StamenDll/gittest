//
//  ConsultantTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface ConsultantTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *tagLabel;
@property(nonatomic,strong)UILabel *infoLabel;
@property(nonatomic,strong)UIButton *manageButton;
@property(nonatomic,strong)UILabel *lineLabel;
@end
