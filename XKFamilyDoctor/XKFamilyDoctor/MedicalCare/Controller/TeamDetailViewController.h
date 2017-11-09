//
//  TeamDetailViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "HomeDoctorItem.h"
#import "CardScrollView.h"
@interface TeamDetailViewController : RootViewController<UIScrollViewDelegate,CardScrollViewDelegate,CardScrollViewDataSource>
{
    UIScrollView *nameButtonBGView;
    UIScrollView *doctorBGView;
    NSMutableArray *mainArray;
    
    UIButton *lastNameButton;
    UIButton *signButton;
}
@property(nonatomic,strong)HomeDoctorItem *homeDoctorTeamItem;
@property(nonatomic,strong)CardScrollView *cardScrollView;
@end
