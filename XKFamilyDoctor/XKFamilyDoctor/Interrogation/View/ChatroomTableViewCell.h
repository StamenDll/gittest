//
//  ChatroomTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatroomTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *BGView;
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UIImageView *detailImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *personLabel;
@property(nonatomic,strong)UILabel *doctorLabel;
@property(nonatomic,strong)UILabel *markLabel;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)UILabel *lineLabel1;
@end
