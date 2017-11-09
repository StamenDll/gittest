//
//  CheckboxView.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootView.h"

@protocol CheckboxViewDelegate <NSObject>
- (void)cancelCheckboxView;
- (void)sureBackOption:(NSString*)Option;
@end

@interface CheckboxView : RootView
{
    UIView *subBGView;
    NSMutableArray *choiceArray;
}
@property(nonatomic,assign)id<CheckboxViewDelegate>delegate;
- (void)cancel;
- (void)creatUI:(NSString*)title andOption:(NSArray*)option andConnect:(NSString*)connectString;
@end
