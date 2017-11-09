//
//  QuestiondetailFrame.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionDetailIItem.h"
@interface QuestiondetailFrame : NSObject
@property (nonatomic,strong) QuestionDetailIItem *questionAnswer;
@property (nonatomic, assign) CGFloat cellHeight;
@end
