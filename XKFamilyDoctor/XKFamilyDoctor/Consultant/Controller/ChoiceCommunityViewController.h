//
//  ChoiceCommunityViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
@interface ChoiceCommunityViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,selfRequestDelegate,BMKLocationServiceDelegate>
{
    UITableView *mainTableView;
    NSMutableArray *mainArray;
    
    BMKLocationService *locationService;
}
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,copy)NSString *radiusString;
@property(nonatomic,copy)NSString *whoPush;
@end
