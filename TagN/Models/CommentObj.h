//
//  CommentObj.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentObj : NSObject

@property (nonatomic, retain) NSNumber      *comment_id;
@property (nonatomic, retain) NSNumber      *comment_user_id;
@property (nonatomic, retain) NSString      *comment_user_name;
@property (nonatomic, retain) NSString      *comment_user_avatar_url;
@property (nonatomic, retain) NSNumber      *comment_image_id;
@property (nonatomic, retain) NSString      *comment_string;
@property (nonatomic, retain) NSDate        *comment_created_at;

- (CommentObj *)initWithDictionary:(NSDictionary *)dicComment;
- (NSDictionary *)currentDictionary;

@end
