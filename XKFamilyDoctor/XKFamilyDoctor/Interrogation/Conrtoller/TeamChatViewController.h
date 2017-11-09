//
//  TeamChatViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "ChatView.h"
#import "ChatItem.h"
#import "FileUpAndDown.h"
@interface TeamChatViewController : RootViewController<chatViewDelegate,FileUpAndDownDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    ChatView *chatView;
    UIView *loadBGView;
    UIActivityIndicatorView *testActivityIndicator;
    
    NSString *imageString;
}
@property(nonatomic,strong)UITextView *newsTextView;
@property(nonatomic,strong)ChatItem *chatItem;

@property(nonatomic,copy)NSString *lastTimeString;
@property(nonatomic,copy)NSString *getHistoryString;
@property(nonatomic,copy)NSString *whoPush;
@end
