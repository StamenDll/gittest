//
//  FDCensusViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/7/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DateChoiceView.h"
#import "RightChoiceView.h"
@interface FDCensusViewController : RootViewController<DateChoiceDelegate,RightChoiceViewDelegate>
{
    UIButton *bTimeButton;
    UIButton *eTimeButton;
    UIButton *sureButton;
    UIButton *lastButton;
    DateChoiceView *dateChoiceView;
    
    UIView *barBGView;
    UIView *tableBGView;
    UIView *piechartBGView;
    RightChoiceView *rightMenuView;
    
    NSMutableArray *mainDataArray;
    UILabel *rightItemLabel;
}

@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSString *bTime;
@property(nonatomic,copy)NSString *eTime;

@end
