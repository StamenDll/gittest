//
//  CNewsViewController.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/10/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CNewsViewController.h"
#import "WriteRecipeViewController.h"
#import "RecipeDetailViewController.h"
#import "ChatItem.h"
#import "ChartFrame.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CNewsViewController ()

@end

@implementation CNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.chatItem.fromName];
    [self addLeftButtonItem];
    
    [self creatUI];
    self.lastTimeString=[self getNowTime];
    
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [usd setObject:self.chatItem.from forKey:@"ChatNowCode"];
    
    [self sendRequest:@"HistoryNews" andPath:queryURL andSqlParameter:@[CHATCODE,self.chatItem.from,@"单聊",[self getTomorrowTime]] and:self];
    
}

- (void)popViewController{
    if ([self.whoPush isEqualToString:@"INT"]) {
        [self.myTabBarController showTabBar];
    }
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    [usd removeObjectForKey:@"ChatNowCode"];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)addRightButtonItem{
//    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    rButton.frame=CGRectMake(0, 0, 30,30);
//    [rButton setImage:[UIImage imageNamed:@"prescribe"] forState:UIControlStateNormal];
//    rButton.imageEdgeInsets=UIEdgeInsetsMake(5, 10, 5, 0);
//    [rButton addTarget:self action:@selector(writeRecipe) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *lItem=[[UIBarButtonItem alloc]initWithCustomView:rButton];
//    self.navigationItem.rightBarButtonItem=lItem;
//}
//
//- (void)writeRecipe{
//
//}

- (void)creatUI{
    chatView=[[ChatView alloc]initWithFrame:CGRectMake(0,64, mainWidth, mainHeight-64)];
    [chatView creatUI:self.chatItem.from andName:self.chatItem.fromName andFace:self.chatItem.fromFace andType:@"chat" andOwer:@""];
    chatView.delegate=self;
    [self.view addSubview:chatView];
}

#pragma mark 获取历史消息
- (void)getHistoryNews{
    if (!loadBGView) {
        loadBGView=[self addSimpleBackView:CGRectMake(0, 0, SCREENWIDTH, 40) andColor:MAINWHITECOLOR];
        
        UILabel *loadLabel=[self addLabel:CGRectMake(140,10,50, 20) andText:@"加载中" andFont:MIDDLEFONT andColor:TEXTCOLORDG andAlignment:0];
        [loadBGView addSubview:loadLabel];
        
        testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        testActivityIndicator.center = CGPointMake(110.0f, loadLabel.center.y);
        [loadBGView addSubview:testActivityIndicator];
        [testActivityIndicator startAnimating];
        
    }else{
        [testActivityIndicator startAnimating];
        loadBGView.hidden=NO;
    }
    chatView.mainTableView.tableHeaderView=loadBGView;
    
    if (self.getHistoryString.length==0) {
        self.getHistoryString=[self getNowTime];
    }
    [self sendRequest:@"HistoryNews" andPath:queryURL andSqlParameter:@[CHATCODE,self.chatItem.from,@"单聊",self.getHistoryString] and:self];
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    NSUserDefaults *usd=[NSUserDefaults standardUserDefaults];
    if ([message isKindOfClass:[NSArray class]]) {
        NSArray *data=message;
        if ([type isEqualToString:@"HistoryNews"]) {
            if (data.count>0) {
                NSMutableArray *newsArray=[NSMutableArray new];
                data=(NSArray *)[[data reverseObjectEnumerator] allObjects];
                for (int i=0;i<data.count;i++) {
                    NSDictionary *dic=[data objectAtIndex:i];
                    if (i==0) {
                        self.getHistoryString=[dic objectForKey:@"LSendTime"];
                    }
                    ChatItem *item2=[ChatItem new];
                    item2.content=[dic objectForKey:@"content"];
                    item2.contentType=[dic objectForKey:@"contentType"];
                    item2.from=[dic objectForKey:@"from"];
                    item2.fromName=[dic objectForKey:@"fromName"];
                    item2.fromFace=[dic objectForKey:@"fromFace"];
                    item2.to=[dic objectForKey:@"to"];
                    item2.toName=[dic objectForKey:@"toName"];
                    item2.toFace=[dic objectForKey:@"toFace"];
                    item2.type=[dic objectForKey:@"type"];
                    if ([item2.content rangeOfString:@"|"].location!=NSNotFound) {
                        NSArray *array=[item2.content componentsSeparatedByString:@"|"];
                        NSLog(@"语音长度＝＝＝＝＝＝＝＝＝＝%@",[array objectAtIndex:0]);
                        item2.yyLength=[[array objectAtIndex:0] intValue];
                    }else{
                        item2.yyLength=0;
                    }
                    item2.timestamp=item2.timestamp=[self getSubTime:[dic objectForKey:@"LSendTime"] andFormat:@"MM-dd HH:mm"];
                    if (self.lastTimeString.length>0) {
                        CGFloat minGyNow=[self intervalSinceNow:self.lastTimeString];
                        NSArray *timeArray=[self intervalFromLastDate:self.lastTimeString toTheDate:[dic objectForKey:@"LSendTime"]];
                        if (minGyNow<1440) {
                            NSLog(@"时间差＝＝＝%@",timeArray);
                            int hour=[[timeArray objectAtIndex:0] intValue];
                            int min=[[timeArray objectAtIndex:1] intValue];
                            if (abs(hour)==0&&abs(min)==0){
                                item2.timestamp=@"";
                            }else if (abs(hour)<24){
                                item2.timestamp=[self getSubTime:[dic objectForKey:@"LSendTime"] andFormat:@"HH:mm"];
                            }
                        }else{
                            int hour=[[timeArray objectAtIndex:0] intValue];
                            int min=[[timeArray objectAtIndex:1] intValue];
                            if (abs(hour)==0&&abs(min)==0){
                                item2.timestamp=@"";
                            }
                            
                        }
                    }
                    self.lastTimeString=[dic objectForKey:@"LSendTime"];
                    
                    ChartFrame *frame2=[ChartFrame new];
                    frame2.chartMessage=item2;
                    [newsArray addObject:frame2];
                }
                [chatView relaodMainTableView:newsArray];
            }
            loadBGView.hidden=YES;
            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
            [chatView.mainTableView setTableHeaderView:view];
        }
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)choiceImageView:(NSString *)whoChoice{
    if ([whoChoice isEqualToString:@"TP"]) {
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
            
            picker.allowsEditing = NO;
            
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
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
        
        picker.allowsEditing = NO;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *data;
        data =[self imageData:image];
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        NSString *imageName=[self getUniqueStrByUUID];
        imageString=[NSString stringWithFormat:@"%@.jpg",imageName];
        
        FileUpAndDown *file=[FileUpAndDown new];
        file.delegate=self;
        [file uploadFile:UPLOADFILE andData:data andFileName:[NSString stringWithFormat:@"%@.jpg",imageName] andController:self];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        
        if (data.length>1024*1024) {//1M以及以上
            
            data=UIImageJPEGRepresentation(myimage, 0.1);
            
        }else if (data.length>512*1024) {//0.5M-1M
            
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
            
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
    
}

- (void)uploadDataSuccess:(id)message{
    [chatView sendPicNews:imageString];
    UIImageView *imageView=[UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,imageString]]];
}


- (void)uploadDataFail{
    [self showSimplePromptBox:self andMesage:@"图片发送失败"];
}

-(void)saveMessage:(ChatItem *)chatItem{
    NSArray *sqlParameter=@[chatItem.from,chatItem.fromName,chatItem.to,chatItem.toName,chatItem.from,chatItem.to,chatItem.content,chatItem.contentType,@"单聊",@"iOS",chatItem.fromFace,chatItem.toFace];
    [self sendRequest:@"SaveNews" andPath:queryWithoutURL andSqlParameter:sqlParameter and:self];
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
