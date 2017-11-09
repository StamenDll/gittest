//
//  DateChoiceView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DateChoiceView.h"
#import "AMBlurView.h"
@implementation DateChoiceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initDateChoiceView:(NSString*)firstDateString{
    self.backgroundColor=MAINWHITECOLOR;
    [self addLineLabel:CGRectMake(0,0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self];
    
    UIButton *overButton=[UIButton buttonWithType:UIButtonTypeCustom];
    overButton.frame=CGRectMake(self.bounds.size.width-50, 10, 40, 20);
    [overButton setExclusiveTouch :YES];
    [overButton setTitle:@"完成" forState:UIControlStateNormal];
    [overButton addTarget:self action:@selector(overOnclik) forControlEvents:UIControlEventTouchUpInside];
    [overButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:overButton];

    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(10,10,40,20);
    [cancelButton setExclusiveTouch :YES];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelOnclik) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    
    [self addLineLabel:CGRectMake(0, 40, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:self];
    
    datePicker = [ [UIDatePicker alloc] initWithFrame:CGRectMake(0.0,50,self.bounds.size.width,self.bounds.size.height-50)];
    if ([firstDateString rangeOfString:@":"].location!=NSNotFound) {
        datePicker.datePickerMode = UIDatePickerModeTime;
    }else{
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    datePicker.minuteInterval = 5;
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* minDate = [inputFormatter dateFromString:@"1900-01-01"];
    NSDate* maxDate = [inputFormatter dateFromString:@"2099-01-01"];
    if ([firstDateString rangeOfString:@"NO"].location!=NSNotFound) {
        maxDate=[inputFormatter dateFromString:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
        firstDateString=[firstDateString stringByReplacingOccurrencesOfString:@"NO" withString:@""];
    }
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.date = [NSDate date];
    [self addSubview:datePicker];
}

- (void)overOnclik{
    if ([self.delegate respondsToSelector:@selector(sureChoiceDate:)]) {
        [self.delegate sureChoiceDate:datePicker.date];
        [self removeFromSuperview];
    }
}

- (void)cancelOnclik{
    if ([self.delegate respondsToSelector:@selector(cancelChoiceDate)]) {
        [self.delegate cancelChoiceDate];
        [self removeFromSuperview];
    }
}
@end
