//
//  WriteQuestionViewController.h
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import "FileUpAndDown.h"
@interface WriteQuestionViewController : RootViewController<UITextViewDelegate,UITextFieldDelegate,FileUpAndDownDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UITextField *titleTextField;
    UITextView *questionTextView;
    UILabel *adviceLabel;
    
    UIButton *addButton;
    UIImageView *imageView1;
    UIImageView *imageView2;
    NSMutableArray *imageArray;
    NSMutableArray *imageDataArray;
}
@property(nonatomic,copy)NSString *oneSuccess;
@property(nonatomic,copy)NSString *twoSuccess;
@end
