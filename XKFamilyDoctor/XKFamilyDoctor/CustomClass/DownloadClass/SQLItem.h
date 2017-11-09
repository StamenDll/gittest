//
//  SQLItem.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLItem : NSObject
- (NSString*)returnSqlString:(id)sqlParameter andType:(NSString*)type;
@end
