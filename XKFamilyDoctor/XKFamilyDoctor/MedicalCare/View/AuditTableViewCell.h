//
//  AuditTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *ageLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@end
