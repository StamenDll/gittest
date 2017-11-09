//
//  PutQuestionTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootTableViewCell.h"
#import "PutQuestionFrame.h"
@interface PutQuestionTableViewCell : RootTableViewCell
@property(nonatomic,strong)UIView *BGView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *contentImageView1;
@property(nonatomic,strong)UIImageView *contentImageView2;
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)UILabel *cCountLabel;
@property(nonatomic,strong)UIButton *praiseButton;
@property(nonatomic,strong)UILabel *pCountLabel;


- (void)setMessageFrame:(PutQuestionFrame*)model;
@end
