//
//  MyQuestionTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"

@interface MyQuestionTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *BGView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UILabel *lineLabelO;
@property(nonatomic,strong)UILabel *lineLabelT;
@end
