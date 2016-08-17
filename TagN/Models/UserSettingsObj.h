//
//  UserSettingsObj.h
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettingsObj : NSObject

//network
@property (nonatomic, readwrite) BOOL       use_cellular_data;

//notification
@property (nonatomic, readwrite) BOOL       show_unshare_noti;
@property (nonatomic, readwrite) BOOL       show_remove_tag_noti;
@property (nonatomic, readwrite) BOOL       show_upload_image_noti;
@property (nonatomic, readwrite) BOOL       show_remove_image_noti;
@property (nonatomic, readwrite) BOOL       show_like_noti;
@property (nonatomic, readwrite) BOOL       show_comment_noti;

- (UserSettingsObj *)initWithDictionary:(NSDictionary *)dicUserSettings;
- (NSDictionary *)currentDictionary;

@end
