//
//  QuestionDetailTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"
#import "QuestiondetailFrame.h"
@interface QuestionDetailTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *BGView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *commentImageView;
@property(nonatomic,strong)UIButton *replyButton;
@property(nonatomic,strong)UILabel *replyLabel;
@property(nonatomic,strong)UILabel *lineLabelO;
@property(nonatomic,strong)UILabel *lineLabelT;
- (void)setAnswerViewFrame:(QuestiondetailFrame*)model;
@end
