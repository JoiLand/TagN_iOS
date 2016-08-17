//
//  TagObj.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagObj.h"

@implementation TagObj

- (id)init {
    self = [super init];
    if(self) {
        self.tag_id = @0;
        self.tag_user_id = @0;
        self.tag_text = @"";
    }
    
    return self;
}

- (TagObj *)initWithDictionary:(NSDictionary *)dicTag {
    TagObj *objTag = [[TagObj alloc] init];
    
    if(dicTag[@"tag_id"] && ![dicTag[@"tag_id"] isEqual:[NSNull null]]) {
        objTag.tag_id = [NSNumber numberWithInt:[dicTag[@"tag_id"] intValue]];
    }
    
    if(dicTag[@"tag_user_id"] && ![dicTag[@"tag_user_id"] isEqual:[NSNull null]]) {
        objTag.tag_user_id = [NSNumber numberWithInt:[dicTag[@"tag_user_id"] intValue]];
    }
    
    if(dicTag[@"tag_text"] && ![dicTag[@"tag_text"] isEqual:[NSNull null]]) {
        objTag.tag_text = dicTag[@"tag_text"];
    }
    
    return objTag;
}

- (TagObj *)initWithId:(NSNumber *)tag_id
                UserId:(NSNumber *)user_id
                  Text:(NSString *)tag_text {
    TagObj *objTag = [[TagObj alloc] init];
    
    objTag.tag_id = [NSNumber numberWithInt:tag_id.intValue];
    objTag.tag_user_id = [NSNumber numberWithInt:user_id.intValue];
    objTag.tag_text = tag_text;
    
    return objTag;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"tag_id":         self.tag_id,
             @"tag_user_id":    self.tag_user_id,
             @"tag_text":       self.tag_text
             };
}

@end
