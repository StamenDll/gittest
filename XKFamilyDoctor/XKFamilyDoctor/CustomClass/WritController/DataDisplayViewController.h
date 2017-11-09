//
//  DataDisplayViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "DataDisplayView.h"
#import "CommunityItem.h"
@interface DataDisplayViewController : RootViewController<saveMessageDelegate>
{   
    DataDisplayView *dView;
    NSMutableArray *mainArray;
    NSInteger maCount;
    NSTimer *timer;
}
@property(nonatomic,strong)UITextField *memberTextField;
@property(nonatomic,strong)UILabel *communityLabel;
@property(nonatomic,strong)UIButton *getCodeButton;

@property(nonatomic,copy)NSString *listTypeString;
@property(nonatomic,strong)UIButton *getCommenListButton;
@property(nonatomic,strong)NSArray *commenListKeyArray;
@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *peopleOnlyID;
@property(nonatomic,copy)NSString *peopleMemberID;
@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *writeType;

@property(nonatomic,copy)NSString *tableName;
@property(nonatomic,copy)NSString *tableAliasName;
@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,strong)CommunityItem *communityItem;
@property(nonatomic,strong)id item;
@end
