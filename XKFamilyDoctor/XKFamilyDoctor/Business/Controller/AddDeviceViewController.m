//
//  AddDeviceViewController.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddBPViewController.h"
#import "ArchiveClass.h"
#import "SVProgressHUD.h"
@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleView:@"选择设备"];
    [self addLeftButtonItem];
    
    self.cMgr=[self cmgr];
    self.cMgr.delegate = self;
}

- (void)creatUI{
    UIButton *deviceButton=[self addButton:CGRectMake(0, NAVHEIGHT+10, SCREENWIDTH,60) adnColor:MAINWHITECOLOR andTag:0 andSEL:@selector(sureChoiceDevice)];
    [self.view addSubview:deviceButton];
    
    NSString *dNameString=@"捷美瑞B07T智能血压仪";
    UIImageView *dImageView=[self addImageView:CGRectMake(10, 2, 56, 56) andName:@"img_blood pressure"];
    if ([self.whoChoice isEqualToString:@"S"]) {
        dImageView.image=[UIImage imageNamed:@"img_blood sugar"];
        dNameString=@"三诺WL-1血糖仪";
    }
    [deviceButton addSubview:dImageView];
    
    [self addLineLabel:CGRectMake(0, 0, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:deviceButton];
    [self addLineLabel:CGRectMake(0, 59.5, SCREENWIDTH, 0.5) andColor:LINECOLOR andBackView:deviceButton];
    
    [self addLabel:CGRectMake(75, 20, SCREENWIDTH-140, 20) andText:dNameString andFont:MIDDLEFONT andColor:TEXTCOLOR andAlignment:0 andBGView:deviceButton];
    
    NSString *btnName=@"绑定";
    if ([[[ArchiveClass new] getLocalDeviceUUID:self.whoChoice]isEqualToString:self.deviceUUID]) {
        btnName=@"已绑定";
    }
    UIButton *sureButton=[self addSimpleButton:CGRectMake(SCREENWIDTH-70,15,60,25) andBColor:CLEARCOLOR andTag:0 andSEL:@selector((sureChoiceDevice)) andText:btnName andFont:MIDDLEFONT andColor:GREENCOLOR andAlignment:1];
    [sureButton.layer setCornerRadius:12.5];
    sureButton.layer.borderWidth=0.5;
    sureButton.layer.borderColor=GREENCOLOR.CGColor;
    [deviceButton addSubview:sureButton];
    
}

- (void)sureChoiceDevice{
    [[ArchiveClass new] saveDeviceUUIDToLocal:self.deviceUUID andType:self.whoChoice];
    for (UINavigationController *nvc in self.navigationController.viewControllers) {
        if ([nvc isKindOfClass:[AddBPViewController class]]) {
            AddBPViewController *mvc=(AddBPViewController*)nvc;
            mvc.choiceDevice=@"Y";
            [self.navigationController popToViewController:mvc animated:YES];
        }
    }
}


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
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
            [SVProgressHUD setRingThickness:5];
            [SVProgressHUD setForegroundColor:GREENCOLOR];
            [SVProgressHUD setBackgroundColor:MAINWHITECOLOR];
            [SVProgressHUD show];
            [self performSelector:@selector(cancelMessageMethod) withObject:nil afterDelay:5.0f];
        }
            break;
        default:
            break;
    }
}

- (void)cancelMessageMethod{
    [SVProgressHUD dismiss];
    if (self.deviceUUID.length==0) {
        [self showSimplePromptBox:self andMesage:@"未搜索到对应设备，请确定设备已开启，或未被其他设备连接！" ];
    }
}
//2.搜索外围设备
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    
    if (([self.whoChoice isEqualToString:@"P"]&&[peripheral.name hasPrefix:@"BPM-188"])||([self.whoChoice isEqualToString:@"S"]&&[peripheral.name isEqualToString:@"Sinocare"])) {
        [SVProgressHUD dismiss];
        NSArray *kCBAdvDataServiceUUIDs=[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
        self.deviceUUID=((CBUUID*)[kCBAdvDataServiceUUIDs objectAtIndex:0]).UUIDString;
        self.peripheral = peripheral;
        [self creatUI];
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
