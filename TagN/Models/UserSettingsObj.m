//
//  UserSettingsObj.m
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "UserSettingsObj.h"

@implementation UserSettingsObj

- (id)init {
    self = [super init];
    if(self) {
        self.use_cellular_data = YES;
        
        self.show_unshare_noti = NO;
        self.show_remove_tag_noti = NO;
        self.show_upload_image_noti = YES;
        self.show_remove_image_noti = NO;
        self.show_like_noti = YES;
        self.show_comment_noti = YES;
    }
    
    return self;
}

- (UserSettingsObj *)initWithDictionary:(NSDictionary *)dicUserSettings {
    UserSettingsObj *objUserSettings = [[UserSettingsObj alloc] init];
    
    if(dicUserSettings[@"use_cellular_data"] && ![dicUserSettings[@"use_cellular_data"] isEqual:[NSNull null]]) {
        objUserSettings.use_cellular_data = [dicUserSettings[@"use_cellular_data"] boolValue];
    }
    
    if(dicUserSettings[@"show_unshare_noti"] && ![dicUserSettings[@"show_unshare_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_unshare_noti = [dicUserSettings[@"show_unshare_noti"] boolValue];
    }
    
    if(dicUserSettings[@"show_remove_tag_noti"] && ![dicUserSettings[@"show_remove_tag_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_remove_tag_noti = [dicUserSettings[@"show_remove_tag_noti"] boolValue];
    }
    
    if(dicUserSettings[@"show_upload_image_noti"] && ![dicUserSettings[@"show_upload_image_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_upload_image_noti = [dicUserSettings[@"show_upload_image_noti"] boolValue];
    }
    
    if(dicUserSettings[@"show_remove_image_noti"] && ![dicUserSettings[@"show_remove_image_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_remove_image_noti = [dicUserSettings[@"show_remove_image_noti"] boolValue];
    }
    
    if(dicUserSettings[@"show_like_noti"] && ![dicUserSettings[@"show_like_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_like_noti = [dicUserSettings[@"show_like_noti"] boolValue];
    }
    
    if(dicUserSettings[@"show_comment_noti"] && ![dicUserSettings[@"show_comment_noti"] isEqual:[NSNull null]]) {
        objUserSettings.show_comment_noti = [dicUserSettings[@"show_comment_noti"] boolValue];
    }

    return objUserSettings;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"use_cellular_data":          [NSNumber numberWithBool:self.use_cellular_data],
             @"show_unshare_noti":          [NSNumber numberWithBool:self.show_unshare_noti],
             @"show_remove_tag_noti":       [NSNumber numberWithBool:self.show_remove_tag_noti],
             @"show_upload_image_noti":     [NSNumber numberWithBool:self.show_upload_image_noti],
             @"show_remove_image_noti":     [NSNumber numberWithBool:self.show_remove_image_noti],
             @"show_like_noti":             [NSNumber numberWithBool:self.show_like_noti],
             @"show_comment_noti":          [NSNumber numberWithBool:self.show_comment_noti]
             };
}

@end
