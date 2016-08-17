//
//  NotiObj.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "NotiObj.h"

@implementation NotiObj

- (id)init {
    self = [super init];
    if(self) {
        self.noti_id = @0;
        self.noti_from_user_id = @0;
        self.noti_from_user_name = @"";
        self.noti_from_user_avatar_url = @"";
        self.noti_share_id = @0;
        self.noti_share_tag_id = @0;
        self.noti_share_image_id = @0;
        self.noti_string = @"";
        self.noti_type = TAGN_PUSH_SHARE_REQUEST;
        self.noti_created_at = [NSDate date];
        self.noti_is_read = NO;
    }
    
    return self;
}

- (NotiObj *)initWithDictionary:(NSDictionary *)dicNotification {
    NotiObj *objNoti = [[NotiObj alloc] init];
    
    if(dicNotification[@"noti_id"] && ![dicNotification[@"noti_id"] isEqual:[NSNull null]]) {
        objNoti.noti_id = [NSNumber numberWithInt:[dicNotification[@"noti_id"] intValue]];
    }
    
    if(dicNotification[@"noti_from_user_id"] && ![dicNotification[@"noti_from_user_id"] isEqual:[NSNull null]]) {
        objNoti.noti_from_user_id = [NSNumber numberWithInt:[dicNotification[@"noti_from_user_id"] intValue]];
    }
    
    if(dicNotification[@"noti_from_user_name"] && ![dicNotification[@"noti_from_user_name"] isEqual:[NSNull null]]) {
        objNoti.noti_from_user_name = dicNotification[@"noti_from_user_name"];
    }
    
    if(dicNotification[@"noti_from_user_avatar_url"] && ![dicNotification[@"noti_from_user_avatar_url"] isEqual:[NSNull null]]) {
        objNoti.noti_from_user_avatar_url = dicNotification[@"noti_from_user_avatar_url"];
    }
    
    if(dicNotification[@"noti_share_id"] && ![dicNotification[@"noti_share_id"] isEqual:[NSNull null]]) {
        objNoti.noti_share_id = [NSNumber numberWithInt:[dicNotification[@"noti_share_id"] intValue]];
    }
    
    if(dicNotification[@"noti_share_tag_id"] && ![dicNotification[@"noti_share_tag_id"] isEqual:[NSNull null]]) {
        objNoti.noti_share_tag_id = [NSNumber numberWithInt:[dicNotification[@"noti_share_tag_id"] intValue]];
    }
    
    if(dicNotification[@"noti_share_image_id"] && ![dicNotification[@"noti_share_image_id"] isEqual:[NSNull null]]) {
        objNoti.noti_share_image_id = [NSNumber numberWithInt:[dicNotification[@"noti_share_image_id"] intValue]];
    }
    
    if(dicNotification[@"noti_string"] && ![dicNotification[@"noti_string"] isEqual:[NSNull null]]) {
        objNoti.noti_string = dicNotification[@"noti_string"];
    }
    
    if(dicNotification[@"noti_type"] && ![dicNotification[@"noti_type"] isEqual:[NSNull null]]) {
        objNoti.noti_type = [dicNotification[@"noti_type"] intValue];
    }
    
    if(dicNotification[@"user_created_at"] && ![dicNotification[@"user_created_at"] isEqual:[NSNull null]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        objNoti.noti_created_at = [formatter dateFromString:dicNotification[@"user_created_at"]];
    }
    
    if(dicNotification[@"noti_is_read"] && ![dicNotification[@"noti_is_read"] isEqual:[NSNull null]]) {
        objNoti.noti_is_read = [dicNotification[@"noti_is_read"] boolValue];
    }
    
    return objNoti;
}

- (NSDictionary *)currentDictionary {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return @{
             @"noti_id":                    self.noti_id,
             @"noti_from_user_id":          self.noti_from_user_id,
             @"noti_from_user_name":        self.noti_from_user_name,
             @"noti_from_user_avatar_url":  self.noti_from_user_avatar_url,
             @"noti_share_id":              self.noti_share_id,
             @"noti_share_tag_id":          self.noti_share_tag_id,
             @"noti_share_image_id":        self.noti_share_image_id,
             @"noti_string":                self.noti_string,
             @"noti_type":                  [NSNumber numberWithInt:self.noti_type],
             @"user_created_at":            [formatter stringFromDate:self.noti_created_at],
             @"noti_is_read":               [NSNumber numberWithBool:self.noti_is_read]
             };
}

@end
