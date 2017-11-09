//
//  PMenuChoiceView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
@protocol MenuChoiceDelegate <NSObject>
- (void)sureChoiceMenu:(NSString*)menuString;
- (void)cancelChoiceMenu;
@end
@interface PMenuChoiceView : RootView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIDatePicker *datePicker;
    NSArray *pickerArray;
}
- (void)initMenuChoiceView:(NSArray*)menuArray andFirst:(NSString*)firstString;
@property(nonatomic,assign)id<MenuChoiceDelegate>delegate;
@property(nonatomic,assign)NSString *resultString;
@end
