//
//  UserMe.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "UserMe.h"

@implementation UserMe

- (id)init {
    self = [super init];
    if(self) {
        self.user_id = @0;
        self.user_name = @"";
        self.user_username = @"";
        self.user_email = @"";
        self.user_avatar_url = @"";
        self.user_phone = @"";
        self.user_device_token = @"";
        self.user_access_token = @"";
        
        self.user_active_tag = [[TagObj alloc] init];
        self.user_tags = [[NSMutableArray alloc] init];
        self.user_recent_tags = [[NSMutableArray alloc] init];
        self.user_my_albums = [[NSMutableArray alloc] init];
        self.user_share_albums = [[NSMutableArray alloc] init];
        self.user_notifications = [[NSMutableArray alloc] init];
        self.user_settings = [[UserSettingsObj alloc] init];
    }
    
    return self;
}

- (UserMe *)initWithDictionary:(NSDictionary *)dicUser {
    UserMe *objMe = [[UserMe alloc] init];
    
    if(dicUser[@"user_id"] && ![dicUser[@"user_id"] isEqual:[NSNull null]]) {
        objMe.user_id = [NSNumber numberWithInt:[dicUser[@"user_id"] intValue]];
    }
    
    if(dicUser[@"user_name"] && ![dicUser[@"user_name"] isEqual:[NSNull null]]) {
        objMe.user_name = dicUser[@"user_name"];
    }
    
    if(dicUser[@"user_username"] && ![dicUser[@"user_username"] isEqual:[NSNull null]]) {
        objMe.user_username = dicUser[@"user_username"];
    }
    
    if(dicUser[@"user_email"] && ![dicUser[@"user_email"] isEqual:[NSNull null]]) {
        objMe.user_email = dicUser[@"user_email"];
    }
    
    if(dicUser[@"user_avatar_url"] && ![dicUser[@"user_avatar_url"] isEqual:[NSNull null]]) {
        objMe.user_avatar_url = dicUser[@"user_avatar_url"];
    }
    
    if(dicUser[@"user_phone"] && ![dicUser[@"user_phone"] isEqual:[NSNull null]]) {
        objMe.user_phone = dicUser[@"user_phone"];
    }
    
    if(dicUser[@"user_device_token"] && ![dicUser[@"user_device_token"] isEqual:[NSNull null]]) {
        objMe.user_device_token = dicUser[@"user_device_token"];
    }
    
    if(dicUser[@"user_access_token"] && ![dicUser[@"user_access_token"] isEqual:[NSNull null]]) {
        objMe.user_access_token = dicUser[@"user_access_token"];
    }
    
    if(dicUser[@"user_tags"] && ![dicUser[@"user_tags"] isEqual:[NSNull null]]) {
        NSArray *aryDicTags = dicUser[@"user_tags"];
        for(NSDictionary *dicTag in aryDicTags) {
            TagObj *objTag = [[TagObj alloc] initWithDictionary:dicTag];
            [objMe.user_tags addObject:objTag];
        }
    }
    
    if(dicUser[@"user_active_tag"] && ![dicUser[@"user_active_tag"] isEqual:[NSNull null]]) {
        objMe.user_active_tag = [[TagObj alloc] initWithDictionary:dicUser[@"user_active_tag"]];
    }
    
    if(dicUser[@"user_recent_tags"] && ![dicUser[@"user_recent_tags"] isEqual:[NSNull null]]) {
        NSMutableArray *aryRecentTags = [[NSMutableArray alloc] init];
        for(NSDictionary *dicRecentTag in dicUser[@"user_recent_tags"]) {
            [aryRecentTags addObject:[[TagObj alloc] initWithDictionary:dicRecentTag]];
        }
        
        objMe.user_recent_tags = aryRecentTags;
    }
    
    if(dicUser[@"user_my_albums"] && ![dicUser[@"user_my_albums"] isEqual:[NSNull null]]) {
        NSMutableArray *aryMyAlbums = [[NSMutableArray alloc] init];
        for(NSDictionary *dicMyImageInfo in dicUser[@"user_my_albums"]) {
            [aryMyAlbums addObject:[[ImageInfoObj alloc] initWithDictionary:dicMyImageInfo]];
        }
        
        objMe.user_my_albums = aryMyAlbums;
    }
    
    if(dicUser[@"user_share_albums"] && ![dicUser[@"user_share_albums"] isEqual:[NSNull null]]) {
        NSMutableArray *aryShareAlbums = [[NSMutableArray alloc] init];
        for(NSDictionary *dicShareImageInfo in dicUser[@"user_share_albums"]) {
            [aryShareAlbums addObject:[[ImageInfoObj alloc] initWithDictionary:dicShareImageInfo]];
        }
        
        objMe.user_share_albums = aryShareAlbums;
    }
    
    if(dicUser[@"user_notifications"] && ![dicUser[@"user_notifications"] isEqual:[NSNull null]]) {
        NSMutableArray *aryNotifications = [[NSMutableArray alloc] init];
        for(NSDictionary *dicNotification in dicUser[@"user_notifications"]) {
            [aryNotifications addObject:[[NotiObj alloc] initWithDictionary:dicNotification]];
        }
        
        objMe.user_notifications = aryNotifications;
    }
    
    objMe.user_settings = [[GlobalService sharedInstance] loadMySettings];
    
    return objMe;
}

- (NSDictionary *)currentDictionary {
    NSMutableArray *aryDicTags = [[NSMutableArray alloc] init];
    for(TagObj *objTag in self.user_tags) {
        [aryDicTags addObject:objTag.currentDictionary];
    }
    
    NSMutableArray *aryRecentTags = [[NSMutableArray alloc] init];
    for(TagObj *objTag in self.user_recent_tags) {
        [aryRecentTags addObject:objTag.currentDictionary];
    }
    
    NSMutableArray *aryDicMyAlubms = [[NSMutableArray alloc] init];
    for(ImageInfoObj *objMyImageInfo in self.user_my_albums) {
        [aryDicMyAlubms addObject:objMyImageInfo.currentDictionary];
    }
    
    NSMutableArray *aryDicShareAlubms = [[NSMutableArray alloc] init];
    for(ImageInfoObj *objShareImageInfo in self.user_share_albums) {
        [aryDicShareAlubms addObject:objShareImageInfo.currentDictionary];
    }
    
    NSMutableArray *aryDicNotifications = [[NSMutableArray alloc] init];
    for(NotiObj *objNoti in self.user_notifications) {
        [aryDicNotifications addObject:objNoti.currentDictionary];
    }
    
    return @{
             @"user_id":            self.user_id,
             @"user_name":          self.user_name,
             @"user_username":      self.user_username,
             @"user_email":         self.user_email,
             @"user_avatar_url":    self.user_avatar_url,
             @"user_phone":         self.user_phone,
             @"user_device_token":  self.user_device_token,
             @"user_access_token":  self.user_access_token,
             @"user_tags":          aryDicTags,
             @"user_active_tag":    self.user_active_tag.currentDictionary,
             @"user_recent_tags":   aryRecentTags,
             @"user_my_albums":     aryDicMyAlubms,
             @"user_share_albums":  aryDicShareAlubms,
             @"user_notifications": aryDicNotifications
             };
}

#pragma mark Tag
- (void)updateActiveTag:(TagObj *)objTag {
    self.user_active_tag = objTag;

    NSMutableArray *aryRecentTags = [self.user_recent_tags mutableCopy];
    for(int nIndex = 0; nIndex < aryRecentTags.count; nIndex++) {
        TagObj *objTmpTag = aryRecentTags[nIndex];
        if(objTmpTag.tag_id.intValue == objTag.tag_id.intValue) {
            [aryRecentTags removeObject:objTmpTag];
            break;
        }
    }
    
    if(aryRecentTags.count == MOST_RECENT_TAGS_COUNT) {
        [aryRecentTags removeObjectAtIndex:aryRecentTags.count - 1];
    }
    [aryRecentTags insertObject:objTag atIndex:0];
    self.user_recent_tags = [aryRecentTags mutableCopy];
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)removeUserRecentTag:(NSInteger)nIndex {
    [self.user_recent_tags removeObjectAtIndex:nIndex];
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)addUserTagWithId:(NSNumber *)tag_id
                    Text:(NSString *)tag_text {
    TagObj *objTag = [[TagObj alloc] initWithId:tag_id
                                         UserId:self.user_id
                                           Text:tag_text];
    [self.user_tags addObject:objTag];
    
    ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] initWithTag:objTag Images:@[]];
    [self.user_my_albums insertObject:objImageInfo atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_MY_PHOTOS object:nil];
    
    [self updateActiveTag:objTag];    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)deleteUserTagWithTagID:(NSNumber *)tag_id {
    
    //remove images with deleted tag
    for(int nI = 0; nI < self.user_my_albums.count; nI++) {
        ImageInfoObj *objImageInfo = self.user_my_albums[nI];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            [self.user_my_albums removeObjectAtIndex:nI];
            break;
        }
    }
    
    for(int nI = 0; nI < self.user_share_albums.count; nI++) {
        ImageInfoObj *objImageInfo = self.user_share_albums[nI];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            [self.user_share_albums removeObjectAtIndex:nI];
            break;
        }
    }
    
    for(int nI = 0; nI < self.user_tags.count; nI++) {
        TagObj *objTag = self.user_tags[nI];
        if(tag_id.intValue == objTag.tag_id.intValue) {
            [self.user_tags removeObjectAtIndex:nI];
            break;
        }
    }
    
    for(int nI = 0; nI < self.user_recent_tags.count; nI++) {
        TagObj *objTag = self.user_recent_tags[nI];
        if(tag_id.intValue == objTag.tag_id.intValue) {
            [self.user_recent_tags removeObjectAtIndex:nI];
            break;
        }
    }
    
    if(self.user_active_tag.tag_id.intValue == tag_id.intValue) {
        self.user_active_tag = [[TagObj alloc] init];
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)deleteUserImagesWithImageIDs:(NSString *)image_ids
                               TagId:(NSNumber *)tag_id {
    NSArray *aryImageIDs = [image_ids componentsSeparatedByString:@","];
    
    for(int nI = 0; nI < self.user_my_albums.count; nI++) {
        ImageInfoObj *objImageInfo = self.user_my_albums[nI];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            for(int nJ = 0; nJ < aryImageIDs.count; nJ++) {
                for(int nK = 0; nK < objImageInfo.imageinfo_images.count; nK++) {
                    ImageObj *objImage = objImageInfo.imageinfo_images[nK];
                    if(objImage.image_id.intValue == [aryImageIDs[nJ] intValue]) {
                        [objImageInfo.imageinfo_images removeObjectAtIndex:nK];
                        break;
                    }
                }
            }
            
            if(objImageInfo.imageinfo_images.count == 0) {  //no images
                [self.user_my_albums removeObjectAtIndex:nI];
            }
            
            break;
        }
    }
    
    for(int nI = 0; nI < self.user_share_albums.count; nI++) {
        ImageInfoObj *objImageInfo = self.user_share_albums[nI];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            for(int nJ = 0; nJ < aryImageIDs.count; nJ++) {
                for(int nK = 0; nK < objImageInfo.imageinfo_images.count; nK++) {
                    ImageObj *objImage = objImageInfo.imageinfo_images[nK];
                    if(objImage.image_id.intValue == [aryImageIDs[nJ] intValue]) {
                        [objImageInfo.imageinfo_images removeObjectAtIndex:nK];
                        break;
                    }
                }
            }
            
            if(objImageInfo.imageinfo_images.count == 0) {  //no images
                [self.user_share_albums removeObjectAtIndex:nI];
            }
            
            break;
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (TagObj *)getTagObjFromId:(NSNumber *)tag_id {
    TagObj *objTag = nil;
    
    //search tag from my tags
    BOOL got_Tag = NO;
    for(int nIndex = 0; nIndex < self.user_tags.count; nIndex++) {
        TagObj *objTmpTag = self.user_tags[nIndex];
        if([objTmpTag.tag_id intValue] == tag_id.intValue) {
            objTag = objTmpTag;
            got_Tag = YES;
            break;
        }
    }
    
    if(!got_Tag) {
        //search tag from shared images
        for(int nIndex = 0; nIndex < self.user_share_albums.count; nIndex++) {
            ImageInfoObj *objImageInfo = self.user_share_albums[nIndex];
            if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
                objTag = objImageInfo.imageinfo_tag;
                break;
            }
        }
    }
    
    return objTag;
}

- (ImageObj *)getImageObjFromId:(NSNumber *)image_id {
    ImageObj *objImage = nil;
    
    BOOL got_image = NO;
    for(int nIndex = 0; nIndex < self.user_share_albums.count; nIndex++) {
        ImageInfoObj *objImageInfo = self.user_share_albums[nIndex];
        for(ImageObj *objTmpImage in objImageInfo.imageinfo_images) {
            if(objTmpImage.image_id.intValue == image_id.intValue) {
                objImage = objTmpImage;
                got_image = YES;
                break;
            }
        }
        
        if(got_image) {
            break;
        }
    }
    
    return objImage;
}

- (void)addMyImageInfos:(NSArray *)aryImageInfos {
    for(ImageInfoObj *objImageInfo in aryImageInfos) {
        
        BOOL isNewImageInfo = YES;
        for(ImageInfoObj *objMyImageInfo in self.user_my_albums) {
            if(objImageInfo.imageinfo_tag.tag_id.intValue == objMyImageInfo.imageinfo_tag.tag_id.intValue) {
                isNewImageInfo = NO;
                break;
            }
        }
        
        if(isNewImageInfo) {
            [self.user_my_albums addObject:objImageInfo];
        }
    }
}

- (void)addShareImageInfos:(NSArray *)aryImageInfos {
    for(ImageInfoObj *objImageInfo in aryImageInfos) {
        
        BOOL isNewImageInfo = YES;
        for(ImageInfoObj *objShareImageInfo in self.user_share_albums) {
            if(objImageInfo.imageinfo_tag.tag_id.intValue == objShareImageInfo.imageinfo_tag.tag_id.intValue) {
                isNewImageInfo = NO;
                break;
            }
        }
        
        if(isNewImageInfo) {
            [self.user_share_albums addObject:objImageInfo];
        }
    }
}

- (void)addMyImageInfo:(ImageInfoObj *)objImageInfo {
    
    for(int nIndex = 0; nIndex < self.user_my_albums.count; nIndex++) {
        ImageInfoObj *userImageInfo = self.user_my_albums[nIndex];
        if(userImageInfo.imageinfo_tag.tag_id.intValue == objImageInfo.imageinfo_tag.tag_id.intValue) {
            
            for(int nJ = 0; nJ < objImageInfo.imageinfo_images.count; nJ++) {
                ImageObj *objImage = objImageInfo.imageinfo_images[nJ];
                
                if(objImage.image_id.intValue == 0) { //new image
                    [userImageInfo.imageinfo_images insertObject:objImage atIndex:0];
                } else {
                    for(int nI = 0; nI < userImageInfo.imageinfo_images.count; nI++) {
                        ImageObj *userImage = userImageInfo.imageinfo_images[nI];
                        
                        if(objImage.image_id.intValue == userImage.image_id.intValue) {   // edit image
                            [userImageInfo.imageinfo_images removeObjectAtIndex:nI];
                            break;
                        }
                    }
                    
                    [userImageInfo.imageinfo_images insertObject:objImage atIndex:0];
                }
                
            }
            
            break;
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)addShareImageInfo:(ImageInfoObj *)objImageInfo {
    
    for(int nIndex = 0; nIndex < self.user_share_albums.count; nIndex++) {
        ImageInfoObj *shareImageInfo = self.user_share_albums[nIndex];
        if(shareImageInfo.imageinfo_tag.tag_id.intValue == objImageInfo.imageinfo_tag.tag_id.intValue) {
            
            for(int nJ = 0; nJ < objImageInfo.imageinfo_images.count; nJ++) {
                ImageObj *objImage = objImageInfo.imageinfo_images[nJ];
                
                if(objImage.image_id.intValue == 0) { //new image
                    [shareImageInfo.imageinfo_images insertObject:objImage atIndex:0];
                } else {
                    for(int nI = 0; nI < shareImageInfo.imageinfo_images.count; nI++) {
                        ImageObj *userImage = shareImageInfo.imageinfo_images[nI];
                        
                        if(objImage.image_id.intValue == userImage.image_id.intValue) {   // edit image
                            [shareImageInfo.imageinfo_images removeObjectAtIndex:nI];
                            break;
                        }
                    }
                    
                    [shareImageInfo.imageinfo_images insertObject:objImage atIndex:0];
                }
            }
            
            break;
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)updateMyImageInfoWith:(ImageObj *)objImage {
    
    BOOL isFind = NO;
    for(int nIndex = 0; nIndex < self.user_my_albums.count; nIndex++) {
        ImageInfoObj *objImageInfo = self.user_my_albums[nIndex];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == objImage.image_tag_id.intValue) {
            for(int nJ = 0; nJ < objImageInfo.imageinfo_images.count; nJ++) {
                ImageObj *objTmpImage = objImageInfo.imageinfo_images[nJ];
                if([objTmpImage.image_url isEqualToString:objImage.image_url]) {
                    [objImageInfo.imageinfo_images replaceObjectAtIndex:nJ withObject:objImage];
                    
                    isFind = YES;
                    break;
                }
            }
            
            if(isFind) {
                break;
            } else {
                [objImageInfo.imageinfo_images insertObject:objImage atIndex:0];
            }
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (void)updateShareImageInfoWith:(ImageObj *)objImage {
    
    BOOL isFind = NO;
    for(int nIndex = 0; nIndex < self.user_share_albums.count; nIndex++) {
        ImageInfoObj *objImageInfo = self.user_share_albums[nIndex];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == objImage.image_tag_id.intValue) {
            for(int nJ = 0; nJ < objImageInfo.imageinfo_images.count; nJ++) {
                ImageObj *objTmpImage = objImageInfo.imageinfo_images[nJ];
                if([objTmpImage.image_url isEqualToString:objImage.image_url]) {
                    [objImageInfo.imageinfo_images replaceObjectAtIndex:nJ withObject:objImage];
                    
                    isFind = YES;
                    break;
                }
            }
            
            if(isFind) {
                break;
            } else {
                [objImageInfo.imageinfo_images insertObject:objImage atIndex:0];
            }
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

//share
- (void)shareMyImageInfoWithTagId:(NSNumber *)tag_id {
    for(int nIndex = 0; nIndex < self.user_share_albums.count; nIndex++) {
        ImageInfoObj *objImageInfo = self.user_share_albums[nIndex];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            [self.user_share_albums removeObjectAtIndex:nIndex];
            break;
        }
    }
    
    for(int nIndex = 0; nIndex < self.user_my_albums.count; nIndex++) {
        ImageInfoObj *objImageInfo = self.user_my_albums[nIndex];
        if(objImageInfo.imageinfo_tag.tag_id.intValue == tag_id.intValue) {
            [self.user_share_albums insertObject:objImageInfo atIndex:0];
            break;
        }
    }
    
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
}

- (NSMutableArray *)getMyAllImageInfos {
    NSMutableArray *aryMyAllImageInfos = [NSMutableArray arrayWithArray:self.user_share_albums];
    
    for(int nI = 0; nI < self.user_my_albums.count; nI++) {
        ImageInfoObj *objMyImageInfo = self.user_my_albums[nI];
        
        BOOL isExist = NO;
        for(int nJ = 0; nJ < self.user_share_albums.count; nJ++) {
            ImageInfoObj *objShareImageInfo = self.user_share_albums[nJ];
            if(objMyImageInfo.imageinfo_tag.tag_id.intValue == objShareImageInfo.imageinfo_tag.tag_id.intValue) {
                isExist = YES;
                break;
            }
        }
        
        if(isExist == NO) {
            [aryMyAllImageInfos addObject:objMyImageInfo];
        }
    }
    
    return aryMyAllImageInfos;
}

@end
