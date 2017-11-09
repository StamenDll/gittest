//
//  MyTabBarController.h
//  CH999
//
//  Created by LIUSHAO WEN on 14-6-23.
//  Copyright (c) 2014年 ch999.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyTabBarController : UITabBarController <UITabBarDelegate>
{
    UIButton *lastButton;
}
- (void)hidesTabBar;
- (void)showTabBar;
- (void)makeButtonTextColor:(NSInteger)count;
- (void)addNewsCountToView:(NSString*)count;

@property(nonatomic,strong)UIView *mainBackView;
@property(nonatomic,strong)UILabel *newsLabel;
@property(nonatomic,assign)NSInteger seletedInteger;
@property(nonatomic, assign)NSInteger lastSelect;
@end
@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, retain, readonly) MyTabBarController *myTabBarController;
@end
