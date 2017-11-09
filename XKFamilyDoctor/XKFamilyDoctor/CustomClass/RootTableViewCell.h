//
//  RootTableViewCell.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
- (UIColor *) colorWithHexString: (NSString *)color;
/**
 截取部分时间
 
 @param timeString 时间字符串
 @param formt 截取目标
 @return 截取结果
 */
- (NSString*)getSubTime:(NSString *)timeString andFormat:(NSString*)formt;

- (NSString*)changeString:(NSString*)string andType:(NSString*)type;
@end
