//
//  CRMessageViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ChatRoomItem.h"
@interface CRMessageViewController : RootViewController
{
    UIScrollView *mainScrollView;
    NSMutableArray *mainArray;
    
}
@property(nonatomic,strong)ChatRoomItem *chatRoomItem;
@property(nonatomic,strong)UIButton *allMemberButton;
@end
