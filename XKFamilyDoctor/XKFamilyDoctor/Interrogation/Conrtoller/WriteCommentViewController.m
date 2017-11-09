//
//  WriteCommentViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WriteCommentViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PostDetailViewController.h"
@interface WriteCommentViewController ()

@end

@implementation WriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKebord)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    UIView *questionBGView=[self addSimpleBackView:CGRectMake(15,75, SCREENWIDTH-30,(SCREENWIDTH-30)/2) andColor:MAINWHITECOLOR];
    questionBGView.layer.borderColor=LINECOLOR.CGColor;
    questionBGView.layer.borderWidth=0.5;
    [self.view addSubview:questionBGView];
    
    questionTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-40, questionBGView.frame.size.height-10)];
    questionTextView.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    questionTextView.textColor=TEXTCOLOR;
    [questionBGView addSubview:questionTextView];
    
    addButton=[self addButton:CGRectMake(15, questionBGView.frame.origin.y+questionBGView.frame.size.height+15,70,70) adnColor:CLEARCOLOR andTag:0 andSEL:@selector(choiceImage:)];
    [addButton setImage:[UIImage imageNamed:@"add_1"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    
    UIButton *uploadButton=[self addCurrencyButton:CGRectMake(40, addButton.frame.origin.y+addButton.frame.size.height+40, SCREENWIDTH-80, 40) andText:@"提交" andSEL:@selector(uploadOnclick:)];
    [self.view addSubview:uploadButton];
}

- (void)cancelKebord{
    [questionTextView resignFirstResponder];
}

- (void)uploadOnclick:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *question = [questionTextView.text stringByTrimmingCharactersInSet:set];
        if (question.length==0){
            [self showSimplePromptBox:self andMesage:@"内容不能为空"];
        }else{
            if (!imageData) {
                NSString *nameString=nil;
                NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                if ([self changeNullString:[usd objectForKey:@"LNickname"]].length>0) {
                    nameString=[usd objectForKey:@"LNickname"];
                }else{
                    nameString=[usd objectForKey:@"LName"];
                }
                NSString *content=nil;
                if ([self.titleString isEqualToString:@"评论"]) {
                    content=[self changeString:questionTextView.text andType:@"out"];
                }else{
                   content=[NSString stringWithFormat:@"%@%@: %@",nameString,self.titleString,[self changeString:questionTextView.text andType:@"out"]];
                }
                [self sendRequest:@"CommentPost" andPath:queryWithoutURL andSqlParameter:@[self.postID,CHATCODE,nameString,content,@""] and:self];
            }else{
                FileUpAndDown *file=[FileUpAndDown new];
                file.delegate=self;
                [file uploadFile:UPLOADFILE andData:imageData andFileName:imageString andController:self];
            }
        }
    }
}


- (void)uploadDataSuccess:(id)message{
    NSString *nameString=nil;
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if ([self changeNullString:[usd objectForKey:@"LNickname"]].length>0) {
        nameString=[usd objectForKey:@"LNickname"];
    }else{
        nameString=[usd objectForKey:@"LName"];
    }
    NSString *content=nil;
    if ([self.titleString isEqualToString:@"评论"]) {
        content=[self changeString:questionTextView.text andType:@"out"];
    }else{
        content=[NSString stringWithFormat:@"%@%@: %@",nameString,self.titleString,[self changeString:questionTextView.text andType:@"out"]];
    }
    [self sendRequest:@"CommentPost" andPath:queryWithoutURL andSqlParameter:@[self.postID,CHATCODE,nameString,[self changeString:questionTextView.text andType:@"out"],imageString] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        NSString *advice=nil;
        if ([self.titleString isEqualToString:@"评论"]) {
            advice=@"评论成功";
        }else{
            advice=@"回复成功";
        }
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:advice preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PostDetailViewController class]]) {
            PostDetailViewController *pvc=(PostDetailViewController*)vc;
            pvc.isAdd=@"Y";
            [self.navigationController popToViewController:pvc animated:YES];
        }
    }
}
- (void)requestFail:(NSString *)type{
    
}

- (void)uploadDataFail{
    [self showSimplePromptBox:self andMesage:@"修改头像失败，请稍候重试"];
}

- (void)choiceImage:(UIButton*)button{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"拍照", @"从手机相册选择",nil];
    [myActionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    //呼出的菜单按钮点击后的响应
    
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {}
    switch (buttonIndex)
    
    {
            
        case 0:  //打开照相机拍照
            
            [self takePhoto];
            
            break;
            
        case 1:  //打开本地相册
            
            [self LocalPhoto];
            
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    NSLog(@"111111111111111111111");
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"相机授权未开启" message:@"请在系统设置中开启相机授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL success) {}];
            }else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }];
        [av addAction:sureAC];
        
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        [av addAction:cancelAC];
        [self presentViewController:av animated:YES completion:nil];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        
        picker.allowsEditing = YES;
        
        picker.sourceType = sourceType;
        
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}


//打开本地相册
-(void)LocalPhoto
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        UIAlertController *av=[UIAlertController alertControllerWithTitle:@"相册授权未开启" message:@"请在系统设置中开启相册授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAC=[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL success) {}];
            }else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }];
        [av addAction:sureAC];
        
        UIAlertAction *cancelAC=[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        [av addAction:cancelAC];
        [self presentViewController:av animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        

        [addButton setImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
        
        imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1.0);
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.jpg"] contents:imageData attributes:nil];
        imageString=[NSString stringWithFormat:@"%@.jpg",[self getUniqueStrByUUID]];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
