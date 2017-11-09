//
//  ChatTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartFrame.h"
@interface ChatTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UIImageView* newsBackView;
@property(nonatomic,strong)UIImageView* newsImageView;
@property(nonatomic,strong)UIImageView* messageVoiceStatusImageView;
@property(nonatomic,strong)UILabel *yyTimeLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *newsLabel;
- (void)setMessageFrame:(ChartFrame*)model;
@end
