//
//  SearchAreaViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "NearAreaItem.h"
#import "MyUserItem.h"
@interface SearchAreaViewController : RootViewController<BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *searchField;
    UITableView *mainTableView;
    UIView *hAreaBGView;
    UIView *nearBGView;
    UIButton *nowAreaButton;
    
    NSMutableArray *areaArray;
    NSMutableArray *searchAreaArray;
    BMKLocationService *locationService;
}
@property(nonatomic,copy)NSString *whoPush;
@property(nonatomic,strong)MyUserItem *userItem;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,assign)CGFloat latitude;

@end
