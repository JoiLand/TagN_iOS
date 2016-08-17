//
//  UserMe.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObj : NSObject

@property (nonatomic, retain) NSNumber          *user_id;
@property (nonatomic, retain) NSString          *user_name;
@property (nonatomic, retain) NSString          *user_username;
@property (nonatomic, retain) NSString          *user_email;
@property (nonatomic, retain) NSString          *user_avatar_url;
@property (nonatomic, retain) NSString          *user_phone;
@property (nonatomic, retain) NSString          *user_device_token;
@property (nonatomic, retain) NSNumber          *user_share_id;
@property (nonatomic, readwrite) TAG_USER_STATUS user_share_status;

//this needs for only share page
@property (nonatomic, readwrite) BOOL           user_already_status;
@property (nonatomic, readwrite) BOOL           user_is_contact;

- (UserObj *)initWithDictionary:(NSDictionary *)dicUser;

@end
