//
//  DrugInfoTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/2/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface DrugInfoTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UIButton *choiceButton;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *companyLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *lineLabel1;
@end
