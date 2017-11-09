//
//  ChoiceDrugTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceDrugTableViewCell : UITableViewCell
@property(nonatomic,strong)UIButton *drugBackViewO;
@property(nonatomic,strong)UIButton *drugBackViewT;

@property(nonatomic,strong)UIImageView *drugImageViewO;
@property(nonatomic,strong)UIImageView *drugImageViewT;

@property(nonatomic,strong)UIImageView *signImageViewO;
@property(nonatomic,strong)UIImageView *signImageViewT;

@property(nonatomic,strong)UILabel *drugNameLabelO;
@property(nonatomic,strong)UILabel *drugNameLabelT;

@property(nonatomic,strong)UILabel *priceLabelO;
@property(nonatomic,strong)UILabel *priceLabelT;

@property(nonatomic,strong)UIButton *addButtonO;
@property(nonatomic,strong)UIButton *addButtonT;

@end
