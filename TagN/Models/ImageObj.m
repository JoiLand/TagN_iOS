//
//  ImageObj.m
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageObj.h"

@implementation ImageObj

- (id)init {
    self = [super init];
    if(self) {
        self.image_id = @0;
        self.image_user_id = @0;
        self.image_user_name = @"";
        self.image_user_avatar_url = @"";
        self.image_tag_id = @0;
        self.image_url = @"";
        self.image_thumb_url = @"";
        self.image_width = @0;
        self.image_height = @0;
        self.image_created_at = [NSDate date];
        self.image_is_uploaded = [NSNumber numberWithBool:NO];
        
        //for share
        self.image_is_like = [NSNumber numberWithBool:NO];
        self.image_likes = @0;
        self.image_last_2_comments = @[];
    }
    
    return self;
}

- (ImageObj *)initWithDictionary:(NSDictionary *)dicImage {
    ImageObj *objImage = [[ImageObj alloc] init];
    
    if(dicImage[@"image_id"] && ![dicImage[@"image_id"] isEqual:[NSNull null]]) {
        objImage.image_id = [NSNumber numberWithInt:[dicImage[@"image_id"] intValue]];
    }
    
    if(dicImage[@"image_user_id"] && ![dicImage[@"image_user_id"] isEqual:[NSNull null]]) {
        objImage.image_user_id = [NSNumber numberWithInt:[dicImage[@"image_user_id"] intValue]];
    }
    
    if(dicImage[@"image_user_name"] && ![dicImage[@"image_user_name"] isEqual:[NSNull null]]) {
        objImage.image_user_name = dicImage[@"image_user_name"];
    }
    
    if(dicImage[@"image_user_avatar_url"] && ![dicImage[@"image_user_avatar_url"] isEqual:[NSNull null]]) {
        objImage.image_user_avatar_url = dicImage[@"image_user_avatar_url"];
    }
    
    if(dicImage[@"image_tag_id"] && ![dicImage[@"image_tag_id"] isEqual:[NSNull null]]) {
        objImage.image_tag_id = [NSNumber numberWithInt:[dicImage[@"image_tag_id"] intValue]];
    }
    
    if(dicImage[@"image_url"] && ![dicImage[@"image_url"] isEqual:[NSNull null]]) {
        objImage.image_url = dicImage[@"image_url"];
    }
    
    if(dicImage[@"image_thumb_url"] && ![dicImage[@"image_thumb_url"] isEqual:[NSNull null]]) {
        objImage.image_thumb_url = dicImage[@"image_thumb_url"];
    }
    
    if(dicImage[@"image_width"] && ![dicImage[@"image_width"] isEqual:[NSNull null]]) {
        objImage.image_width = dicImage[@"image_width"];
    }
    
    if(dicImage[@"image_height"] && ![dicImage[@"image_height"] isEqual:[NSNull null]]) {
        objImage.image_height = dicImage[@"image_height"];
    }
    
    if(dicImage[@"user_created_at"] && ![dicImage[@"user_created_at"] isEqual:[NSNull null]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        objImage.image_created_at = [formatter dateFromString:dicImage[@"user_created_at"]];
    }
    
    objImage.image_is_uploaded = objImage.image_id.intValue > 0 ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    //for share
    if(dicImage[@"image_is_like"] && ![dicImage[@"image_is_like"] isEqual:[NSNull null]]) {
        objImage.image_is_like = dicImage[@"image_is_like"];
    }
    
    if(dicImage[@"image_likes"] && ![dicImage[@"image_likes"] isEqual:[NSNull null]]) {
        objImage.image_likes = dicImage[@"image_likes"];
    }
    
    if(dicImage[@"image_last_2_comments"] && ![dicImage[@"image_last_2_comments"] isEqual:[NSNull null]]) {
        NSArray *aryDicComments = dicImage[@"image_last_2_comments"];
        NSMutableArray *aryComments = [[NSMutableArray alloc] init];
        
        for(int nIndex = 0; nIndex < aryDicComments.count; nIndex++) {
            CommentObj *objComment = [[CommentObj alloc] initWithDictionary:aryDicComments[nIndex]];
            [aryComments addObject:objComment];
        }
        
        objImage.image_last_2_comments = aryComments;
    }
    
    return objImage;
}

- (ImageObj *)initWithCoreDataImage:(CoreDataImage *)coreDataImage {
    ImageObj *objImage = [[ImageObj alloc] init];
    
    objImage.image_id = coreDataImage.image_id;
    objImage.image_user_id = coreDataImage.image_user_id;
    objImage.image_user_name = [GlobalService sharedInstance].user_me.user_name;
    objImage.image_user_avatar_url = [GlobalService sharedInstance].user_me.user_avatar_url;
    objImage.image_tag_id = coreDataImage.image_tag_id;
    objImage.image_url = coreDataImage.image_url;
    objImage.image_thumb_url = coreDataImage.image_thumb_url;
    objImage.image_width = coreDataImage.image_width;
    objImage.image_height = coreDataImage.image_height;
    objImage.image_is_uploaded = coreDataImage.image_is_uploaded;
    objImage.image_created_at = coreDataImage.image_created_at;
    
    return objImage;
}

- (ImageObj *)initWithId:(NSNumber *)image_id
                  UserId:(NSNumber *)image_user_id
                   Photo:(UIImage *)image_photo {
    ImageObj *objImage = [[ImageObj alloc] init];
    
    objImage.image_id = image_id;
    objImage.image_user_id = image_user_id;
    objImage.image_photo = image_photo;
    
    return objImage;
}

- (NSDictionary *)currentDictionary {
    NSMutableArray *aryComments = [[NSMutableArray alloc] init];
    for(CommentObj *objComment in self.image_last_2_comments) {
        [aryComments addObject:objComment.currentDictionary];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return @{
             @"image_id":               self.image_id,
             @"image_user_id":          self.image_user_id,
             @"image_user_name":        self.image_user_name,
             @"image_user_avatar_url":  self.image_user_avatar_url,
             @"image_tag_id":           self.image_tag_id,
             @"image_url":              self.image_url,
             @"image_thumb_url":        self.image_thumb_url,
             @"image_width":            self.image_width,
             @"image_height":           self.image_height,
             @"user_created_at":        [formatter stringFromDate:self.image_created_at],
             @"image_is_like":          self.image_is_like,
             @"image_likes":            self.image_likes,
             @"image_last_2_comments":  [aryComments copy]
             };
}

@end
