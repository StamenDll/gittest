//
//  WriteCommentViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "FileUpAndDown.h"
@interface WriteCommentViewController : RootViewController<UITextViewDelegate,UITextFieldDelegate,FileUpAndDownDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UITextView *questionTextView;
    UILabel *adviceLabel;
    UIButton *addButton;
    
    UIImageView *imageView;
    NSData *imageData;
    NSString *imageString;
}
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *postID;
@end
