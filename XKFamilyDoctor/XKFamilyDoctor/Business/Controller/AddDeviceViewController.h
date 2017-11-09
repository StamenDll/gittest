//
//  AddDeviceViewController.h
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/9/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface AddDeviceViewController : RootViewController<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,copy)NSString *whoChoice;
@property(nonatomic,copy)NSString *deviceUUID;

/* 中心管理者 */
@property (nonatomic, strong) CBCentralManager *cMgr;

/* 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;
@end
