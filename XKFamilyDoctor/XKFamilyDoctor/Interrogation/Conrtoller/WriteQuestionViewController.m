//
//  WriteQuestionViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 17/1/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "WriteQuestionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface WriteQuestionViewController ()

@end

@implementation WriteQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageArray=[NSMutableArray new];
    imageDataArray=[NSMutableArray new];
    [self addTitleView:@"提问"];
    [self addLeftButtonItem];
    [self creatUI];
}

- (void)creatUI{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKebord)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
    
    UILabel *titleLabel=[self addLabel:CGRectMake(15, 75, 100, 20) andText:@"标题:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.view addSubview:titleLabel];
    
    UIView *titleBGView=[self addSimpleBackView:CGRectMake(15, 105, SCREENWIDTH-30, 30) andColor:MAINWHITECOLOR];
    titleBGView.layer.borderColor=LINECOLOR.CGColor;
    titleBGView.layer.borderWidth=0.5;
    [self.view addSubview:titleBGView];
    
    titleTextField=[self addTextfield:CGRectMake(5, 5, SCREENWIDTH-40, 20) andPlaceholder:@"请输入标题" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
    [titleBGView addSubview:titleTextField];
    
    UILabel *contentLabel=[self addLabel:CGRectMake(15,titleBGView.frame.origin.y+titleBGView.frame.size.height+20, 100, 20) andText:@"内容:" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
    [self.view addSubview:contentLabel];
    
    UIView *questionBGView=[self addSimpleBackView:CGRectMake(15, contentLabel.frame.size.height+contentLabel.frame.origin.y+10, SCREENWIDTH-30,(SCREENWIDTH-30)/2) andColor:MAINWHITECOLOR];
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
    [titleTextField resignFirstResponder];
    [questionTextView resignFirstResponder];
}

- (void)uploadOnclick:(UIButton*)button{
    if (button.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
         NSString *title = [titleTextField.text stringByTrimmingCharactersInSet:set];
        NSString *question = [questionTextView.text stringByTrimmingCharactersInSet:set];
        if (title.length==0){
            [self showSimplePromptBox:self andMesage:@"标题不能为空"];
        }else if (question.length==0){
            [self showSimplePromptBox:self andMesage:@"内容不能为空"];
        }else{
            if (imageArray.count>0) {
                FileUpAndDown *file=[FileUpAndDown new];
                file.delegate=self;
                [file uploadFile:UPLOADFILE andData:[imageDataArray objectAtIndex:0] andFileName:[imageArray objectAtIndex:0] andController:self];
                if (imageDataArray.count>1) {
                    [file uploadFile:UPLOADFILE andData:[imageDataArray objectAtIndex:1] andFileName:[imageArray objectAtIndex:1] andController:self];
                }
            }else{
                NSString *nameString=nil;
                NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
                if ([self changeNullString:[usd objectForKey:@"LNickname"]].length>0) {
                    nameString=[usd objectForKey:@"LNickname"];
                }else{
                    nameString=[usd objectForKey:@"LName"];
                }
                [self sendRequest:@"PutQuestion" andPath:excuteURL andSqlParameter:@[nameString,[self changeString:titleTextField.text andType:@"out"],[self changeString:questionTextView.text andType:@"out"],@"",@""] and:self];
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
    NSString *pic1=[imageArray objectAtIndex:0];
    NSString *pic2=@"";
    if (imageArray.count>1) {
        pic2=[imageArray objectAtIndex:1];
    }
    if ([message isEqualToString:[imageArray objectAtIndex:0]]) {
       self.oneSuccess=@"Y";
    }else if ([message isEqualToString:[imageArray objectAtIndex:1]]){
       self.twoSuccess=@"Y";
    }
    if (imageArray.count==1||(imageArray.count>1&&[self.oneSuccess isEqualToString:@"Y"]&&[self.twoSuccess isEqualToString:@"Y"])) {
        [self sendRequest:@"PutQuestion" andPath:excuteURL andSqlParameter:@[nameString,[self changeString:titleTextField.text andType:@"out"],[self changeString:questionTextView.text andType:@"out"],pic1,pic2] and:self];
    }else if ([self.oneSuccess isEqualToString:@"N"]||[self.twoSuccess isEqualToString:@"N"]){
        [self showSimplePromptBox:self andMesage:@"提问发布失败，请重试"];
    }
}

- (void)uploadDataFail{
    [self showSimplePromptBox:self andMesage:@"修改头像失败，请稍候重试"];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"提问发布成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:1.0f];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFail:(NSString *)type{
    
}

- (void)uploadDataFail:(id)message{
    if ([message isEqualToString:[imageArray objectAtIndex:0]]) {
        self.oneSuccess=@"N";
    }else if (imageArray.count>1&&[message isEqualToString:[imageArray objectAtIndex:1]]){
        self.twoSuccess=@"N";
    }
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
        
        if (!imageView1) {
            imageView1=[[UIImageView alloc]initWithFrame:addButton.frame];
            imageView1.image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
            [self.view addSubview:imageView1];
            addButton.frame=CGRectMake(imageView1.frame.origin.x+imageView1.frame.size.width+10, imageView1.frame.origin.y, addButton.frame.size.width, addButton.frame.size.height);
        }else{
            imageView2=[[UIImageView alloc]initWithFrame:addButton.frame];
            imageView2.image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
            [self.view addSubview:imageView2];
            addButton.hidden=YES;
            
        }
        
        NSData *data;
        data = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1.0);
        NSString *imageName=[self getUniqueStrByUUID];
        [imageArray addObject:[NSString stringWithFormat:@"%@.jpg",imageName]];
        [imageDataArray addObject:data];
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
