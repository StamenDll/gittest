//
//  PMenuChoiceView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PMenuChoiceView.h"

@implementation PMenuChoiceView

- (void)initMenuChoiceView:(NSArray*)menuArray andFirst:(NSString*)firstString{
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
    
    pickerArray=menuArray;
    self.resultString=firstString;
    UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0,50,SCREENWIDTH,self.frame.size.height-50)];
    picker.backgroundColor=MAINWHITECOLOR;
    picker.delegate=self;
    picker.dataSource=self;
    [picker selectRow:[pickerArray indexOfObject:firstString] inComponent:0 animated:NO];
    [self addSubview:picker];
}

- (void)overOnclik{
    if ([self.delegate respondsToSelector:@selector(sureChoiceMenu:)]) {
        [self.delegate sureChoiceMenu:self.resultString];
        [self removeFromSuperview];
    }
}

- (void)cancelOnclik{
    if ([self.delegate respondsToSelector:@selector(cancelChoiceMenu)]) {
        [self.delegate cancelChoiceMenu];
        [self removeFromSuperview];
    }
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel=[self addLabel:view.frame andText:[self pickerView:pickerView titleForRow:row forComponent:component] andFont:SUPERFONT andColor:TEXTCOLORG andAlignment:1];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    self.resultString=[pickerArray objectAtIndex:row];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}
@end
