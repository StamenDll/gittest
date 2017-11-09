//
//  UncaughtExceptionHandler.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject
{
    
    BOOL dismissed;
    
}
@end
void InstallUncaughtExceptionHandler();