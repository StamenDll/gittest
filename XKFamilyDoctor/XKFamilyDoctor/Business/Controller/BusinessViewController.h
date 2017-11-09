//
//  BusinessViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface BusinessViewController : RootViewController
{
    UIScrollView *BGScrollView;
    UILabel *nameLabel;
    UILabel *jobLabel;
    
    BOOL ismust;
    NSString *plistUrl;
    
    UILabel *signCountLabel;
}

@end
