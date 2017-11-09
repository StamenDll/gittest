//
//  MemberInfoViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "MemberInfoItem.h"
@interface MemberInfoViewController : RootViewController
{
    UIScrollView *mainScrollView;
    UIButton *infoButton;
    UIButton *sHistoryButton;
    UIButton *fHistoryButton;
    
     MemberInfoItem *memberItem;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,copy)NSString *LOnlyCode;
@end
