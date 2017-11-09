//
//  EntryRegViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PMenuChoiceView.h"
#import "DateChoiceView.h"
#import "CommenModel.h"
#import "OrgItem.h"
@interface EntryRegViewController : RootViewController<MenuChoiceDelegate,UITextFieldDelegate,DateChoiceDelegate>
{
    UIScrollView *mainBGVSrollView;
    UIButton *choiceBusinessDep;
    UIButton *choiceDepartment;
    UIButton *choiceMechanism;
    UIButton *choicePost;
    UIButton *lastChoiceButton;
    
    PMenuChoiceView *menuChoiceView;
    DateChoiceView *dateChoiceView;
    CommenModel *choiceBusinessDepItem;
    CommenModel *choiceDepartmentItem;
    
    NSMutableArray *businessDepArray;
    NSMutableArray *departmentArray;
    NSMutableArray *mechanismArray;
    
    UITextField *phoneTextField;
    UITextField *vCodeTextField;
    UITextField *nameTextField;
    UITextField *nationTextField;
    UITextField *addressTextField;
    UITextField *IDCardTextField;
    
    UIButton *getCodeButton;
    NSTimer *timer;
    NSInteger maCount;
    
    UILabel *birDateLabel;
    UILabel *sexNumLabel;

    UIButton *uploadButton;
}
@property(nonatomic,copy)NSString *phoneString;
@property(nonatomic,copy)NSString *codeString;

@property(nonatomic,copy)NSString *bdString;
@property(nonatomic,copy)NSString *depString;
@property(nonatomic,copy)NSString *mString;
@property(nonatomic,copy)NSString *postString;

@property(nonatomic,strong)CommenModel *bdItem;
@property(nonatomic,strong)OrgItem *orgItem;
@property(nonatomic,strong)CommenModel *depItem;
@property(nonatomic,strong)CommenModel *postItem;

@end
