//
//  CommentObj.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "CommentObj.h"

@implementation CommentObj

- (id)init {
    self = [super init];
    
    if(self) {
        self.comment_id = @0;
        self.comment_user_id = @0;
        self.comment_user_name = @"";
        self.comment_user_avatar_url = @"";
        self.comment_image_id = @0;
        self.comment_string = @"";
        self.comment_created_at = [NSDate date];
    }
    
    return self;
}

- (CommentObj *)initWithDictionary:(NSDictionary *)dicComment {
    CommentObj *objComment = [[CommentObj alloc] init];
    
    if(dicComment[@"comment_id"] && ![dicComment[@"comment_id"] isEqual:[NSNull null]]) {
        objComment.comment_id = [NSNumber numberWithInt:[dicComment[@"comment_id"] intValue]];
    }
    
    if(dicComment[@"comment_user_id"] && ![dicComment[@"comment_user_id"] isEqual:[NSNull null]]) {
        objComment.comment_user_id = [NSNumber numberWithInt:[dicComment[@"comment_user_id"] intValue]];
    }
    
    if(dicComment[@"comment_user_name"] && ![dicComment[@"comment_user_name"] isEqual:[NSNull null]]) {
        objComment.comment_user_name = dicComment[@"comment_user_name"];
    }
    
    if(dicComment[@"comment_user_avatar_url"] && ![dicComment[@"comment_user_avatar_url"] isEqual:[NSNull null]]) {
        objComment.comment_user_avatar_url = dicComment[@"comment_user_avatar_url"];
    }
    
    if(dicComment[@"comment_image_id"] && ![dicComment[@"comment_image_id"] isEqual:[NSNull null]]) {
        objComment.comment_image_id = [NSNumber numberWithInt:[dicComment[@"comment_image_id"] intValue]];
    }
    
    if(dicComment[@"comment_string"] && ![dicComment[@"comment_string"] isEqual:[NSNull null]]) {
        objComment.comment_string = dicComment[@"comment_string"];
    }
    
    if(dicComment[@"user_created_at"] && ![dicComment[@"user_created_at"] isEqual:[NSNull null]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        objComment.comment_created_at = [formatter dateFromString:dicComment[@"user_created_at"]];
    }
    
    return objComment;
}

- (NSDictionary *)currentDictionary {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return @{
             @"comment_id":             self.comment_id,
             @"comment_user_id":        self.comment_user_id,
             @"comment_user_name":      self.comment_user_name,
             @"comment_user_avatar_url":self.comment_user_avatar_url,
             @"comment_image_id":       self.comment_image_id,
             @"comment_string":         self.comment_string,
             @"user_created_at":        [formatter stringFromDate:self.comment_created_at]
             };
}

@end
