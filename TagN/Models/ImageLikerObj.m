//
//  ImageLikerObj.m
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageLikerObj.h"

@implementation ImageLikerObj

- (id)init {
    self = [super init];
    if(self) {
        self.like_id = @0;
        self.like_user_id = @0;
        self.like_user_name = @"";
        self.like_user_username = @"";
        self.like_user_avatar_url = @"";
        self.like_image_id = @0;
        self.like_created_at = [NSDate date];
    }
    
    return self;
}

- (ImageLikerObj *)initWithDictionary:(NSDictionary *)dicImageLiker {
    ImageLikerObj *objImageLiker = [[ImageLikerObj alloc] init];
    
    if(dicImageLiker[@"like_id"] && ![dicImageLiker[@"like_id"] isEqual:[NSNull null]]) {
        objImageLiker.like_id = [NSNumber numberWithInt:[dicImageLiker[@"like_id"] intValue]];
    }
    
    if(dicImageLiker[@"like_user_id"] && ![dicImageLiker[@"like_user_id"] isEqual:[NSNull null]]) {
        objImageLiker.like_user_id = [NSNumber numberWithInt:[dicImageLiker[@"like_user_id"] intValue]];
    }
    
    if(dicImageLiker[@"like_user_name"] && ![dicImageLiker[@"like_user_name"] isEqual:[NSNull null]]) {
        objImageLiker.like_user_name = dicImageLiker[@"like_user_name"];
    }
    
    if(dicImageLiker[@"like_user_username"] && ![dicImageLiker[@"like_user_username"] isEqual:[NSNull null]]) {
        objImageLiker.like_user_username = dicImageLiker[@"like_user_username"];
    }
    
    if(dicImageLiker[@"like_user_avatar_url"] && ![dicImageLiker[@"like_user_avatar_url"] isEqual:[NSNull null]]) {
        objImageLiker.like_user_avatar_url = dicImageLiker[@"like_user_avatar_url"];
    }
    
    if(dicImageLiker[@"like_image_id"] && ![dicImageLiker[@"like_image_id"] isEqual:[NSNull null]]) {
        objImageLiker.like_image_id = [NSNumber numberWithInt:[dicImageLiker[@"like_image_id"] intValue]];
    }
    
    if(dicImageLiker[@"user_created_at"] && ![dicImageLiker[@"user_created_at"] isEqual:[NSNull null]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        objImageLiker.like_created_at = [formatter dateFromString:dicImageLiker[@"user_created_at"]];
    }
    
    return objImageLiker;
}

@end
