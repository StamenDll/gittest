//
//  ChatItem.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/11/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChatItem.h"

@implementation ChatItem

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.from forKey:@"from"];
    [aCoder encodeObject:self.fromName forKey:@"fromName"];
    [aCoder encodeObject:self.fromFace forKey:@"fromFace"];
    [aCoder encodeObject:self.channel forKey:@"channel"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.toName forKey:@"toName"];
    [aCoder encodeObject:self.toFace forKey:@"toFace"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.contentType forKey:@"contentType"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.unsend] forKey:@"unsend"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.from=[aDecoder decodeObjectForKey:@"from"];
        self.fromName=[aDecoder decodeObjectForKey:@"fromName"];
        self.fromFace=[aDecoder decodeObjectForKey:@"fromFace"];
        self.channel=[aDecoder decodeObjectForKey:@"channel"];
        self.timestamp=[aDecoder decodeObjectForKey:@"timestamp"];
        self.to=[aDecoder decodeObjectForKey:@"to"];
        self.toName=[aDecoder decodeObjectForKey:@"toName"];
        self.toFace=[aDecoder decodeObjectForKey:@"toFace"];
        self.type=[aDecoder decodeObjectForKey:@"type"];
        self.contentType=[aDecoder decodeObjectForKey:@"contentType"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.unsend=[[aDecoder decodeObjectForKey:@"unsend"] intValue];
    }
    return self;
}
@end
