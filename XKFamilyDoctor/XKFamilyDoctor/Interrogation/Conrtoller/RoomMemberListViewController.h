//
//  RoomMemberListViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ChatRoomPeopleItem.h"
#import "MQTTKit.h"
#import "ChatRoomItem.h"
@interface RoomMemberListViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTableView;
    UITextView *reasonTextView;
    UITextField *timeField;
    ChatRoomPeopleItem *choicePeopleItem;
    MQTTClient *client;
    
    NSMutableArray *mainArray;
}
@property(nonatomic,copy)NSMutableArray *mainArray;
@property(nonatomic,strong)ChatRoomItem *chatRoomItem;
@end
