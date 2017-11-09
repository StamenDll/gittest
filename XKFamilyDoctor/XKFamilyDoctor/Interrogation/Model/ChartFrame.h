//
//  ChartFrame.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatItem.h"
@interface ChartFrame : NSObject
@property (nonatomic,strong) ChatItem *chartMessage;
@property (nonatomic,assign) CGRect iconRect;
@property (nonatomic,assign) CGRect chartViewRect;
@property (nonatomic, assign) CGFloat cellHeight;
@end
