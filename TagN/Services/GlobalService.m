//
//  GlobalService.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "GlobalService.h"

@implementation GlobalService

static GlobalService *_globalService = nil;

+ (GlobalService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalService == nil) {
            _globalService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalService;
}

- (id)init {
    self = [super init];
    if(self) {
        self.user_device_token = @"";
        self.user_access_token = @"";
        self.is_internet_alive = YES;
    }
    
    return self;
}

- (UserMe *)loadMe {
    UserMe *objMe = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicMe = [defaults objectForKey:USER_DEFAULTS_KEY_ME];
    if(dicMe) {
        objMe = [[UserMe alloc] initWithDictionary:dicMe];
        
        self.user_access_token = objMe.user_access_token;
    }
    
    return objMe;
}

- (void)saveMe:(UserMe *)objMe {
    self.user_me = objMe;
    self.user_access_token = objMe.user_access_token;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user_me.currentDictionary forKey:USER_DEFAULTS_KEY_ME];
    [defaults synchronize];
}

- (void)deleteMe {
    self.user_me = nil;
    self.user_access_token = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_DEFAULTS_KEY_ME];
    [defaults removeObjectForKey:USER_DEFAULTS_KEY_MY_SETTINGS];
    [defaults synchronize];
}

- (UserSettingsObj *)loadMySettings {
    UserSettingsObj *objMySettings = [[UserSettingsObj alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicMySettings = [defaults objectForKey:USER_DEFAULTS_KEY_MY_SETTINGS];
    if(dicMySettings) {
        objMySettings = [[UserSettingsObj alloc] initWithDictionary:dicMySettings];
    }
    
    return objMySettings;
}

- (void)saveMySettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user_me.user_settings.currentDictionary forKey:USER_DEFAULTS_KEY_MY_SETTINGS];
    [defaults synchronize];
}

- (NSString *)getUserTimeZone {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger nDiffMins = [zone secondsFromGMT] / 60;
    NSInteger nMin = nDiffMins % 60;
    NSInteger nHour = nDiffMins / 60;
    
    //make user time zone => example +10:00, -8:00
    NSString *strTimeZone = [NSString stringWithFormat:@"%@%d:%d", nHour > 0 ? @"+" : @"", (int)nHour, (int)nMin];
    return strTimeZone;
}

- (NSString *)makeMyImageUrlWithTagId:(NSNumber *)tag_id {
    NSString *strFileName = [NSString stringWithFormat:@"image-%d-%d-%f.jpg", self.user_me.user_id.intValue, tag_id.intValue, [[NSDate date] timeIntervalSince1970]];
    
    return strFileName;
}

- (NSString *)makeMyThumbImageUrlWithTagId:(NSNumber *)tag_id {
    NSString *strFileName = [NSString stringWithFormat:@"thumb-%d-%d-%f.jpg", self.user_me.user_id.intValue, tag_id.intValue, [[NSDate date] timeIntervalSince1970]];
    
    return strFileName;
}

- (void)setNotificationBadge:(NSInteger)nBadgeNum {
    if(nBadgeNum > 0) {
        [self.tabbar_vc.tabBar.items[NOTIFICATION_TABBAR_INDEX] setBadgeValue:[NSString stringWithFormat:@"%d", (int)nBadgeNum]];
    } else {
        [self.tabbar_vc.tabBar.items[NOTIFICATION_TABBAR_INDEX] setBadgeValue:@""];
    }
}

- (NSAttributedString *)makeCommentsWithData:(NSArray *)aryComments {
    NSMutableAttributedString *strComments = [[NSMutableAttributedString alloc] init];
    
    //if exist comments, add "view more comments..."
    if(aryComments.count == 2) {
        NSMutableAttributedString *strTmp = [[NSMutableAttributedString alloc] init];
        [strTmp appendAttributedString:[[NSAttributedString alloc] initWithString:@"View all comments..."]];
        [strTmp addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]
                       range:NSMakeRange(0, strTmp.length)];
        [strTmp addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Arial" size:COMMENT_FONT_SIZE]
                       range:NSMakeRange(0, strTmp.length)];
        
        [strComments appendAttributedString:strTmp];
        [strComments appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    for(int nIndex = 0; nIndex < aryComments.count; nIndex++) {
        CommentObj *objComment = aryComments[nIndex];
        
        NSMutableAttributedString *strTmp = [[NSMutableAttributedString alloc] init];
        [strTmp appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", objComment.comment_user_name]]];
        [strTmp addAttribute:NSForegroundColorAttributeName value:TAGN_PANTONE_7477_COLOR
                       range:NSMakeRange(0, strTmp.length)];
        [strTmp addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Arial Rounded MT Bold" size:COMMENT_FONT_SIZE]
                       range:NSMakeRange(0, strTmp.length)];
        
        [strTmp appendAttributedString:[[NSAttributedString alloc] initWithString:objComment.comment_string]];
        [strTmp addAttribute:NSForegroundColorAttributeName value:TAGN_PANTONE_423_COLOR
                       range:NSMakeRange(objComment.comment_user_name.length + 1, objComment.comment_string.length)];
        [strTmp addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Arial" size:COMMENT_FONT_SIZE]
                       range:NSMakeRange(objComment.comment_user_name.length + 1, objComment.comment_string.length)];
        
        [strComments appendAttributedString:strTmp];
        
        if(nIndex != aryComments.count - 1) {
            [strComments appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    
    return strComments;
}

- (CGFloat)labelHeightForText:(NSAttributedString *)txt withLabelWidth:(CGFloat)maxWidth
{
    CGFloat maxHeight = 1000;
    
    CGSize stringSize;
    
    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    
    return roundf(stringSize.height);
}

- (BOOL)isAvailableNotification:(NotiObj *)objNoti {
    BOOL isAvailable = YES;
    
    switch (objNoti.noti_type) {
        case TAGN_PUSH_UNSHARE_REQUEST:
            if(!self.user_me.user_settings.show_unshare_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_REMOVE_SHARE_TAG:
            if(!self.user_me.user_settings.show_remove_tag_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_UPLOAD_PHOTO:
            if(!self.user_me.user_settings.show_upload_image_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_REMOVE_PHOTO:
            if(!self.user_me.user_settings.show_remove_image_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_LIKED_IMAGE:
            if(!self.user_me.user_settings.show_like_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_ADD_COMMENT:
            if(!self.user_me.user_settings.show_comment_noti) {
                isAvailable = NO;
            }
            break;
            
        case TAGN_PUSH_DISLIKED_IMAGE:
        case TAGN_PUSH_REMOVE_COMMENT:
            isAvailable = NO;
            break;
            
        default:
            break;
    }
    
    return isAvailable;
}

@end
