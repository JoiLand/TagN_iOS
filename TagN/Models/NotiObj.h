//
//  NotiObj.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotiObj : NSObject

@property (nonatomic, retain) NSNumber          *noti_id;
@property (nonatomic, retain) NSNumber          *noti_from_user_id;
@property (nonatomic, retain) NSNumber          *noti_share_id;
@property (nonatomic, retain) NSNumber          *noti_share_tag_id;
@property (nonatomic, retain) NSNumber          *noti_share_image_id;
@property (nonatomic, retain) NSString          *noti_from_user_name;
@property (nonatomic, retain) NSString          *noti_from_user_avatar_url;
@property (nonatomic, readwrite) TAGN_PUSH_TYPE noti_type;
@property (nonatomic, retain) NSString          *noti_string;
@property (nonatomic, retain) NSDate            *noti_created_at;
@property (nonatomic, readwrite) BOOL           noti_is_read;

- (NotiObj *)initWithDictionary:(NSDictionary *)dicNotification;
- (NSDictionary *)currentDictionary;

@end
