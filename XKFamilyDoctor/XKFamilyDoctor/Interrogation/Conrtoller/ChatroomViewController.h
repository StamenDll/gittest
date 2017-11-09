//
//  ChatroomViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface ChatroomViewController : RootViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    UITableView *myTableView;
    UITableView *publicTableView;
    UIButton *lastChatroomButton;
    UITextField *searchField;
    
    NSMutableArray *myChatRoomArray;
    NSMutableArray *allChatRoomArray;
}
@end
