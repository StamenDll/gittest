//
//  PostDetailViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "PutQuestionFrame.h"
@interface PostDetailViewController : RootViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIView *qBGView;
    UITableView *mainTableView;
    NSMutableArray *dataArray;
    
    UIView *writeCommentBGView;
    UITextView *inciteTextView;
    
    NSMutableArray *imageArray;
    BOOL isChange;
    
    UIView *pageBGView;
    UIButton *lastCountButton;
    UIButton *fPageButton;
    UIButton *upPageButton;
    UIButton *lPageButton;
    UIButton *nextPageButton;
    int totalCount;
    int nowCount;
    
}
@property(nonatomic,strong)PutQuestionFrame *putQuestionFrame;
@property(nonatomic,copy)NSString *isAdd;
@end
