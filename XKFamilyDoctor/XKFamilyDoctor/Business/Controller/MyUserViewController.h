//
//  MyUserViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface MyUserViewController : RootViewController<UIActionSheetDelegate>
{
    UIScrollView *BGScrollViw;
    int pageCount;
    CGFloat lastOff;
    NSMutableArray *mainDataArray;
}
@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *diseaseType;
@property(nonatomic,copy)NSString *personkind;
@property(nonatomic,copy)NSString *LAiderId;
@property(nonatomic,assign)BOOL isSearch;

@property(nonatomic,assign)BOOL isRefresh;

@end
