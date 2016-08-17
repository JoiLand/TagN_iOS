//
//  UserMe.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagObj.h"
#import "ImageObj.h"
#import "ImageInfoObj.h"
#import "NotiObj.h"
#import "UserObj.h"
#import "UserSettingsObj.h"

@interface UserMe : NSObject

//User object
@property (nonatomic, retain) NSNumber          *user_id;
@property (nonatomic, retain) NSString          *user_name;
@property (nonatomic, retain) NSString          *user_username;
@property (nonatomic, retain) NSString          *user_email;
@property (nonatomic, retain) NSString          *user_avatar_url;
@property (nonatomic, retain) NSString          *user_phone;
@property (nonatomic, retain) NSString          *user_device_token;
@property (nonatomic, retain) NSString          *user_access_token;

//User data
@property (nonatomic, retain) NSMutableArray    *user_tags;
@property (nonatomic, retain) NSMutableArray    *user_recent_tags;
@property (nonatomic, retain) TagObj            *user_active_tag;
@property (nonatomic, retain) NSMutableArray    *user_my_albums;
@property (nonatomic, retain) NSMutableArray    *user_share_albums;
@property (nonatomic, retain) NSMutableArray    *user_notifications;
@property (nonatomic, retain) UserSettingsObj   *user_settings;

- (UserMe *)initWithDictionary:(NSDictionary *)dicUser;
- (NSDictionary *)currentDictionary;

//Tag
- (void)addUserTagWithId:(NSNumber *)tag_id
                    Text:(NSString *)tag_text;

- (void)removeUserRecentTag:(NSInteger)nIndex;

- (void)updateActiveTag:(TagObj *)objTag;

- (void)deleteUserTagWithTagID:(NSNumber *)tag_id;

- (void)deleteUserImagesWithImageIDs:(NSString *)image_ids
                               TagId:(NSNumber *)tag_id;

- (TagObj *)getTagObjFromId:(NSNumber *)tag_id;

//ImageObj
- (ImageObj *)getImageObjFromId:(NSNumber *)image_id;

//ImageInfo
- (void)addMyImageInfos:(NSArray *)aryImageInfos;
- (void)addShareImageInfos:(NSArray *)aryImageInfos;
- (void)addMyImageInfo:(ImageInfoObj *)objImageInfo;
- (void)addShareImageInfo:(ImageInfoObj *)objImageInfo;
- (void)updateMyImageInfoWith:(ImageObj *)objImage;
- (void)updateShareImageInfoWith:(ImageObj *)objImage;
- (NSMutableArray *)getMyAllImageInfos;

//share
- (void)shareMyImageInfoWithTagId:(NSNumber *)tag_id;

@end
