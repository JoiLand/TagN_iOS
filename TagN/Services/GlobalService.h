//
//  GlobalService.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "UserMe.h"
#import "SideMenuViewController.h"
#import "TabBarViewController.h"

@interface GlobalService : NSObject

@property (nonatomic, retain) AppDelegate               *app_delegate;
@property (nonatomic, retain) UserMe                    *user_me;
@property (nonatomic, retain) NSString                  *user_device_token;
@property (nonatomic, retain) NSString                  *user_access_token;
@property (nonatomic, retain) NSArray                   *user_contacts;
@property (nonatomic, readwrite) BOOL                   is_internet_alive;

@property (nonatomic, retain) SideMenuViewController    *sidemenu_vc;
@property (nonatomic, retain) TabBarViewController      *tabbar_vc;

+ (GlobalService *) sharedInstance;

- (UserMe *)loadMe;
- (void)saveMe:(UserMe *)objMe;
- (void)deleteMe;

- (UserSettingsObj *)loadMySettings;
- (void)saveMySettings;

- (NSString *)getUserTimeZone;

- (NSString *)makeMyImageUrlWithTagId:(NSNumber *)tag_id;
- (NSString *)makeMyThumbImageUrlWithTagId:(NSNumber *)tag_id;

- (void)setNotificationBadge:(NSInteger)nBadgeNum;

//comment
- (NSAttributedString *)makeCommentsWithData:(NSArray *)aryComments;
- (CGFloat)labelHeightForText:(NSAttributedString *)txt withLabelWidth:(CGFloat)maxWidth;

//notification
- (BOOL)isAvailableNotification:(NotiObj *)objNoti;

@end
