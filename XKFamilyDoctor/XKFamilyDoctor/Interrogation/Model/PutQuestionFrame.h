//
//  PutQuestionFrame.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PutQuestionItem.h"
@interface PutQuestionFrame : NSObject
@property (nonatomic,strong) PutQuestionItem *questionMessage;
@property (nonatomic, assign) CGFloat cellHeight;
@end
