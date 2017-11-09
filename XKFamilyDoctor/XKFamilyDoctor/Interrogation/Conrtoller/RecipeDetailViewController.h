//
//  RecipeDetailViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"

@interface RecipeDetailViewController : RootViewController
{
    UIScrollView *mainScrollView;
}
@property(nonatomic,copy)NSString *titleString;
@end
