//
//  CommenWebViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface CommenWebViewController : RootViewController<UIWebViewDelegate>
{
    UIWebView *mainWebView;
}
@property(nonatomic,copy)NSString *mainUrl;
@property(nonatomic,copy)NSString *whopush;
@end
