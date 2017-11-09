//
//  DateChoiceView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
@protocol DateChoiceDelegate <NSObject>
- (void)sureChoiceDate:(NSDate*)date;
- (void)cancelChoiceDate;
@end
@interface DateChoiceView : RootView
{
    UIDatePicker *datePicker;
}
- (void)initDateChoiceView:(NSString*)firstDateString;
@property(nonatomic,assign)id<DateChoiceDelegate>delegate;
@end
