//
//  AddBPViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddBPViewController.h"
#import "BPSListViewController.h"
#import "MyDeviceViewController.h"
#import "ArchiveClass.h"
#import "SVProgressHUD.h"
@interface AddBPViewController ()

@end

@implementation AddBPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:self.titleString];
    [self addLeftButtonItem];
    [self creatUI];
    self.dataSource=@"手动录入";
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.choiceDevice.length>0) {
        self.cMgr=[self cmgr];
        self.cMgr.delegate = self;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.peripheral) {
        [self.cMgr cancelPeripheralConnection:self.peripheral];
        [self.cMgr stopScan];
        self.peripheral=nil;
        self.cMgr=nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)creatUI{
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT)];
    [self.view addSubview:mainScrollView];
    
    UIView *FBGView=[self addSimpleBackView:CGRectMake(0,20, SCREENWIDTH, 250) andColor:MAINWHITECOLOR];
    [mainScrollView addSubview:FBGView];
    
    if ([self.titleString isEqualToString:@"血压录入"]) {
        
        UILabel *hBPLabel=[self addLabel:CGRectMake(10, 15, 100, 20) andText:@"收缩压（高压）" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [FBGView addSubview:hBPLabel];
        
        hBPTextField=[self addTextfield:CGRectMake(SCREENWIDTH-110, hBPLabel.frame.origin.y-5,100,30) andPlaceholder:@"请输入高压值" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        hBPTextField.delegate=self;
        hBPTextField.textAlignment=2;
        [FBGView addSubview:hBPTextField];
        
        UILabel *lBPLabel=[self addLabel:CGRectMake(10, hBPLabel.frame.origin.y+50, 100, 20) andText:@"收缩压（低压）" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [FBGView addSubview:lBPLabel];
        
        lBPTextField=[self addTextfield:CGRectMake(SCREENWIDTH-110, lBPLabel.frame.origin.y-5,100,30) andPlaceholder:@"请输入低压值" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        lBPTextField.delegate=self;
        lBPTextField.textAlignment=2;
        [FBGView addSubview:lBPTextField];
        
        UILabel *hrLabel=[self addLabel:CGRectMake(10, lBPLabel.frame.origin.y+50, 100, 20) andText:@"心率" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [FBGView addSubview:hrLabel];
        
        hrTextField=[self addTextfield:CGRectMake(SCREENWIDTH-110, hrLabel.frame.origin.y-5,100,30) andPlaceholder:@"请输入心率值" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        hrTextField.delegate=self;
        hrTextField.textAlignment=2;
        [FBGView addSubview:hrTextField];
        
        UIButton *choiceDateButton=[self addButton:CGRectMake(0, hrLabel.frame.origin.y+35, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:1001 andSEL:@selector(addChoiceDateView:)];
        [FBGView addSubview:choiceDateButton];
        
        [self addLabel:CGRectMake(10,15, 100, 20) andText:@"测量日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:choiceDateButton];
        
        dateLabel=[self addLabel:CGRectMake(SCREENWIDTH-180, 15, 150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
        [choiceDateButton addSubview:dateLabel];
        
        [self addGotoNextImageView:choiceDateButton];
        
        UIButton *choiceTimeButton=[self addButton:CGRectMake(0, choiceDateButton.frame.origin.y+50, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:1002 andSEL:@selector(addChoiceDateView:)];
        [FBGView addSubview:choiceTimeButton];
        
        [self addLabel:CGRectMake(10,15, 100, 20) andText:@"测量时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:choiceTimeButton];
        
        timeLabel=[self addLabel:CGRectMake(SCREENWIDTH-180, 15, 150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
        [choiceTimeButton addSubview:timeLabel];
        
        [self addGotoNextImageView:choiceTimeButton];
        
        
        for (int i=0; i<6; i++) {
            [self addLineLabel:CGRectMake(0, 50*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
        }
    }else{
        UILabel *BSLabel=[self addLabel:CGRectMake(10, 15, 100, 20) andText:@"血糖" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0];
        [FBGView addSubview:BSLabel];
        
        bsTextField=[self addTextfield:CGRectMake(SCREENWIDTH-110, BSLabel.frame.origin.y-5,100,30) andPlaceholder:@"请输入血糖值" andFont:MIDDLEFONT andTextColor:TEXTCOLOR];
        bsTextField.delegate=self;
        bsTextField.textAlignment=2;
        [FBGView addSubview:bsTextField];

        
        UIButton *choiceTimeIntButton=[self addButton:CGRectMake(0, BSLabel.frame.origin.y+35, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceTimeInt)];
        [FBGView addSubview:choiceTimeIntButton];
        
        [self addLabel:CGRectMake(10,15, 100, 20) andText:@"测量时间段" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:choiceTimeIntButton];
        
        timeIntLabel=[self addLabel:CGRectMake(SCREENWIDTH-180, 15, 150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
        [choiceTimeIntButton addSubview:timeIntLabel];
        
        [self addGotoNextImageView:choiceTimeIntButton];
        
        UIButton *choiceDateButton=[self addButton:CGRectMake(0, choiceTimeIntButton.frame.origin.y+50, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:1001 andSEL:@selector(addChoiceDateView:)];
        [FBGView addSubview:choiceDateButton];
        
        [self addLabel:CGRectMake(10,15, 100, 20) andText:@"测量日期" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:choiceDateButton];
        
        dateLabel=[self addLabel:CGRectMake(SCREENWIDTH-180, 15, 150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
        [choiceDateButton addSubview:dateLabel];
        
        [self addGotoNextImageView:choiceDateButton];
        
        UIButton *choiceTimeButton=[self addButton:CGRectMake(0, choiceDateButton.frame.origin.y+50, SCREENWIDTH, 50) adnColor:MAINWHITECOLOR andTag:1002 andSEL:@selector(addChoiceDateView:)];
        [FBGView addSubview:choiceTimeButton];
        
        [self addLabel:CGRectMake(10,15, 100, 20) andText:@"测量时间" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:choiceTimeButton];
        
        timeLabel=[self addLabel:CGRectMake(SCREENWIDTH-180, 15, 150, 20) andText:@"" andFont:MIDDLEFONT andColor:TEXTCOLORG andAlignment:2];
        [choiceTimeButton addSubview:timeLabel];
        
        [self addGotoNextImageView:choiceTimeButton];
        
        FBGView.frame=CGRectMake(0, 20, SCREENWIDTH, 200);
        for (int i=0; i<5; i++) {
            [self addLineLabel:CGRectMake(0, 50*i, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:FBGView];
        }
    }
    
    UIButton *importButton=[self addButton:CGRectMake(0, FBGView.frame.origin.y+FBGView.frame.size.height+20, SCREENWIDTH, 60) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(choiceMyDevice)];
    [mainScrollView addSubview:importButton];
    
    [self addLabel:CGRectMake(10, 20,100, 20) andText:@"设备导入" andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:importButton];
    
    [self addGotoNextImageView:importButton];
    
    
    deviceStateLabel=[self addLabel:CGRectMake(120, 20, SCREENWIDTH-154, 20) andText:@"未连接" andFont:MIDDLEFONT andColor:[UIColor redColor] andAlignment:2];
    [importButton addSubview:deviceStateLabel];
    
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:importButton];
    [self addLineLabel:CGRectMake(0, 60, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:importButton];
    
    saveButton=[self addCurrencyButton:CGRectMake(40, importButton.frame.origin.y+100, SCREENWIDTH-80, 40) andText:@"保存" andSEL:@selector(sureSave)];
    [mainScrollView addSubview:saveButton];
    
    mainScrollView.contentSize=CGSizeMake(0, saveButton.frame.origin.y+saveButton.frame.size.height+40);
}

- (void)choiceMyDevice{
    MyDeviceViewController *mvc=[MyDeviceViewController new];
    if ([self.titleString isEqualToString:@"血压录入"]) {
        mvc.whoChoice=@"P";
    }else{
        mvc.whoChoice=@"S";
    }
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)sureSave{
    if (saveButton.selected==NO) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if ([self.titleString isEqualToString:@"血压录入"]) {
            NSString *hBPStr = [hBPTextField.text stringByTrimmingCharactersInSet:set];
            NSString *lBPStr = [lBPTextField.text stringByTrimmingCharactersInSet:set];
            NSString *hrStr = [hrTextField.text stringByTrimmingCharactersInSet:set];
            if (hBPStr.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输入高压值"];
            }else if (lBPStr.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输入低压值"];
            }else if (hrStr.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输入心率值"];
            }else if (dateLabel.text.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输选择测量日期"];
            }else if (timeLabel.text.length==0) {
                [self showSimplePromptBox:self andMesage:@"请选择测量时间"];
            }else{
                [self sendRequest:UPLOADBPTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,UPLOADBPURL] andSqlParameter:@{@"LOnlyCode":self.LOnlyCode,@"memberId":self.memberID,@"dataSource":self.dataSource,@"name":self.name,@"checkDate":[NSString stringWithFormat:@"%@ %@",dateLabel.text,timeLabel.text],@"highPressure":hBPStr,@"lowPressure":lBPStr,@"pulse":hrStr} and:self];
            }
        }else{
            NSString *BSStr = [bsTextField.text stringByTrimmingCharactersInSet:set];
            if (BSStr.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输入血糖值"];
            }else if (timeIntLabel.text.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输选择测量时间段"];
            }else if (dateLabel.text.length==0) {
                [self showSimplePromptBox:self andMesage:@"请输选择测量日期"];
            }else if (timeLabel.text.length==0) {
                [self showSimplePromptBox:self andMesage:@"请选择测量时间"];
            }else{
                [self sendRequest:UPLOADBSTYPE andPath:[NSString stringWithFormat:@"%@%@",mainURL,UPLOADBSURL] andSqlParameter:@{@"LOnlyCode":self.LOnlyCode,@"memberId":self.memberID,@"dataSource":self.dataSource,@"name":self.name,@"checkDate":[NSString stringWithFormat:@"%@ %@",dateLabel.text,timeLabel.text],@"value":BSStr,@"checkType":timeIntLabel.text} and:self];
            }
        }
        
    }
}

- (void)requestSuccess:(id)message andType:(NSString *)type{
    if ([message isKindOfClass:[NSArray class]]) {
        UIAlertController *av=[UIAlertController alertControllerWithTitle:nil message:@"数据上传成功！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:av animated:YES completion:nil];
        [self performSelector:@selector(delayMethod:) withObject:av afterDelay:0.5f];
    }else{
        [self showSimplePromptBox:self andMesage:message];
    }
}

- (void)delayMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
    
    if (self.whoPush.length>0) {
        BPSListViewController *mvc=[BPSListViewController new];
        if ([self.titleString isEqualToString:@"血压录入"]) {
            mvc.titleString=@"血压数据";
        }
        else{
            mvc.titleString=@"血糖数据";
        }
        mvc.whoPush=self.whoPush;
        mvc.LOnlyCode=self.LOnlyCode;
        mvc.memberID=self.memberID;
        mvc.name=self.name;
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[BPSListViewController class]]) {
            BPSListViewController *mvc=(BPSListViewController*)nvc;
            mvc.isRefresh=YES;
            [self.navigationController popToViewController:mvc animated:YES];
        }
    }
    }
}


- (void)addChoiceDateView:(UIButton*)button{
    lastButton=button;
    [self.view endEditing:YES];
    if (dateChoiceView) {
        [dateChoiceView removeFromSuperview];
        dateChoiceView=nil;
    }
    dateChoiceView=[[DateChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200,SCREENWIDTH, 200)];
    if (button.tag==1001) {
        [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"yyyy-MM-dd"]];
    }else{
        [dateChoiceView initDateChoiceView:[self getSubTime:[self getNowTime] andFormat:@"HH:mm"]];
    }
    dateChoiceView.delegate=self;
    [self.view addSubview:dateChoiceView];
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}

- (void)sureChoiceDate:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    if (lastButton.tag==1001) {
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString* s1 = [df stringFromDate:date];
        dateLabel.text=s1;
    }else{
        [df setDateFormat:@"HH:mm"];
        NSString* s1 = [df stringFromDate:date];
        timeLabel.text=s1;
    }
    
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)cancelChoiceDate{
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)choiceTimeInt{
    NSMutableArray *sexArray=[NSMutableArray arrayWithObjects:@"餐前",@"餐后", nil];
    [self addChoiceView:sexArray];
}
- (void)addChoiceView:(NSMutableArray*)array{
    [self.view endEditing:YES];
    if (menuChoiceView) {
        [menuChoiceView removeFromSuperview];
    }
    menuChoiceView=[[PMenuChoiceView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-200, SCREENWIDTH, 200)];
    [menuChoiceView initMenuChoiceView:array andFirst:[array objectAtIndex:0]];
    menuChoiceView.delegate=self;
    [self.view addSubview:menuChoiceView];
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-200);
}

- (void)cancelChoiceMenu{
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

- (void)sureChoiceMenu:(NSString *)menuString{
    timeIntLabel.text=menuString;
    mainScrollView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    
}

#pragma mark 蓝牙
-(CBCentralManager *)cmgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _cMgr;
}

//只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
        }
            break;
        default:
            break;
    }
}
//2.搜索外围设备 (我这里为了举例，采用了自己身边的一个手环)
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    
    NSLog(@"1111111111111111111============%@==================%@",peripheral.name,advertisementData);
    NSArray *kCBAdvDataServiceUUIDs=[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    
    if (([peripheral.name hasPrefix:@"BPM-188"]&&[((CBUUID*)[kCBAdvDataServiceUUIDs objectAtIndex:0]).UUIDString isEqualToString:[[ArchiveClass new] getLocalDeviceUUID:@"P"]])||([peripheral.name isEqualToString:@"Sinocare"]&&[((CBUUID*)[kCBAdvDataServiceUUIDs objectAtIndex:0]).UUIDString isEqualToString:[[ArchiveClass new] getLocalDeviceUUID:@"S"]])) {
        self.peripheral = peripheral;
        // 发现完之后就是进行连接
        [self.cMgr connectPeripheral:self.peripheral options:nil];
    }
}
//3.连接外围设备
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    [self.cMgr stopScan];
    self.peripheral.delegate = self;    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    deviceStateLabel.text=@"已连接";
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
    deviceStateLabel.text=@"连接失败";
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
    deviceStateLabel.text=@"连接已断开";
    [self.cMgr connectPeripheral:self.peripheral options:nil];

}
//4.获得外围设备的服务 &5.获得服务的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"=========%@==================",peripheral.name);
    
    for (CBCharacteristic *cha in service.characteristics) {
        NSLog(@"=======<%@>=====",cha);
        
        [peripheral setNotifyValue:YES forCharacteristic:cha];
        
    }
}
//6.从外围设备读数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData * data = characteristic.value;
    NSLog(@"========{=%@=}=========",[self convertDataToHexStr:data]);
    NSString *resultString=[self convertDataToHexStr:data];
    if ([self.titleString isEqualToString:@"血压录入"]) {
        NSLog(@"%lu",(unsigned long)[resultString rangeOfString:@"3c"].location);
        NSRange rang_1c=[resultString rangeOfString:@"1c"];
        NSRange rang_3c=[resultString rangeOfString:@"3c"];
        if (rang_1c.location!=NSNotFound&&rang_1c.location==8) {
            deviceStateLabel.text=@"测量成功";
            hBPTextField.text=[NSString stringWithFormat:@"%@",[self numberHexString:[resultString substringWithRange:NSMakeRange(10, 4)]]];
            lBPTextField.text=[NSString stringWithFormat:@"%@",[self numberHexString:[resultString substringWithRange:NSMakeRange(14, 4)]]];
            hrTextField.text=[NSString stringWithFormat:@"%@",[self numberHexString:[resultString substringWithRange:NSMakeRange(22, 4)]]];
        }else if (rang_3c.location!=NSNotFound&&rang_3c.location==8){
            [self showSimplePromptBox:self andMesage:@"测量失败，请重新进行测量！"];
        }else{
            if (![deviceStateLabel.text isEqualToString:@"测量成功"]) {
                deviceStateLabel.text=@"正在测量中";
            }
        }
    }else{
        NSString *subResult=[resultString substringWithRange:NSMakeRange(10, 2)];
        if ([subResult isEqualToString:@"02"]) {
           [self showSimplePromptBox:self andMesage:@"操作异常，请检查试条是否已用过或重新插入试条！"];
        }else if([subResult isEqualToString:@"04"]){
            deviceStateLabel.text=@"测量成功";
            bsTextField.text=[NSString stringWithFormat:@"%.1f",[[self numberHexString:[resultString substringWithRange:NSMakeRange(24, 2)]] floatValue]/10];
        }else if([subResult isEqualToString:@"0a"]){
            deviceStateLabel.text=@"正在测量中";
        }else if([subResult isEqualToString:@"0b"]){
            [SVProgressHUD dismiss];
            deviceStateLabel.text=@"设备已关闭";
            [self.cMgr connectPeripheral:self.peripheral options:nil];
        }
    }
    
}

- (void)cancelMessageMethod:(UIAlertController*)av{
    [av dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange,BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) &0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

- (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}



//键盘将要弹出
- (void)keyboardWillShow:(NSNotification*)noti{
    //得到键盘的高
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    mainScrollView.frame=CGRectMake(0, NAVHEIGHT, SCREENWIDTH,SCREENHEIGHT-NAVHEIGHT-size.height);
}


//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification*)noti{
    mainScrollView.frame=CGRectMake(0, NAVHEIGHT, SCREENWIDTH,SCREENHEIGHT-NAVHEIGHT);
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
