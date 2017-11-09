//
//  CRNewsViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ChatView.h"
#import "ChatRoomItem.h"
#import "ChatRoomPeopleItem.h"
@interface CRNewsViewController : RootViewController<chatViewDelegate,FileUpAndDownDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ChatView *chatView;
    UIActivityIndicatorView *testActivityIndicator;
    UIView *loadBGView;
    ChatRoomPeopleItem *peopleItme;
    
    NSString *imageString;
    
}
@property(nonatomic,strong)ChatRoomItem *chatRoomItem;
@property(nonatomic,copy)NSString *lastTimeString;
@property(nonatomic,copy)NSString *getHistoryString;

@property(nonatomic,copy)NSString *LID;
@property(nonatomic,copy)NSString *type;
@end
