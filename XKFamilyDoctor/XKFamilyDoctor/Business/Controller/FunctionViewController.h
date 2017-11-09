//
//  FunctionViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/6/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface FunctionViewController : RootViewController
@property(nonatomic,copy)NSString *sexString;
@property(nonatomic,copy)NSString *memberID;
@property(nonatomic,copy)NSString *lOnlyString;
@property(nonatomic,copy)NSString *fileNo;
@property(nonatomic,strong)NSMutableDictionary *IDCardDic;
@end
