//
//  ChangeJobViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "CommenModel.h"
#import "OrgItem.h"
@interface ChangeJobViewController : RootViewController
{
    UIScrollView *mainBGVSrollView;
    UIButton *choiceBusinessDep;
    UIButton *choiceDepartment;
    UIButton *choiceMechanism;
    UIButton *choicePost;
    
    UIButton *uploadButton;
}
@property(nonatomic,strong)CommenModel *bdItem;
@property(nonatomic,strong)OrgItem *orgItem;
@property(nonatomic,strong)CommenModel *depItem;
@property(nonatomic,strong)CommenModel *postItem;
@end
