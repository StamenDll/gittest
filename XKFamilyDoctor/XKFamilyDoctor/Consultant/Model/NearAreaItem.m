//
//  NearAreaItem.m
//  XKFamilyDoctor
//
//  Created by XKXX_Apple on 2017/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NearAreaItem.h"

@implementation NearAreaItem
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.sName forKey:@"sName"];
    [aCoder encodeObject:self.sUnit forKey:@"sUnit"];
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeObject:self.sDistrictId forKey:@"sDistrictId"];
    [aCoder encodeObject:self.sDistrictAddress forKey:@"sDistrictAddress"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.OrgID] forKey:@"OrgID"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.iUnit] forKey:@"iUnit"];
     [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.AreaId] forKey:@"AreaId"];
     [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.iTotalCell] forKey:@"iTotalCell"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",self.Distance] forKey:@"Distance"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.sName=[aDecoder decodeObjectForKey:@"sName"];
        self.sUnit=[aDecoder decodeObjectForKey:@"sUnit"];
        self.place=[aDecoder decodeObjectForKey:@"place"];
        self.sDistrictId=[aDecoder decodeObjectForKey:@"sDistrictId"];
        self.sDistrictAddress=[aDecoder decodeObjectForKey:@"sDistrictAddress"];
        self.OrgID=[[aDecoder decodeObjectForKey:@"OrgID"] intValue];
        self.iUnit=[[aDecoder decodeObjectForKey:@"iUnit"] intValue];
        self.AreaId=[[aDecoder decodeObjectForKey:@"AreaId"] intValue];
        self.iTotalCell=[[aDecoder decodeObjectForKey:@"iTotalCell"] intValue];
        self.Distance=[[aDecoder decodeObjectForKey:@"Distance"] floatValue];
    }
    return self;
}
@end
