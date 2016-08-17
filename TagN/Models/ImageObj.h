//
//  ImageObj.h
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataImage.h"
#import "CommentObj.h"
#import "ImageLikerObj.h"

@interface ImageObj : NSObject

@property (nonatomic, retain) NSNumber      *image_id;
@property (nonatomic, retain) NSNumber      *image_user_id;
@property (nonatomic, retain) NSString      *image_user_name;
@property (nonatomic, retain) NSString      *image_user_avatar_url;
@property (nonatomic, retain) NSNumber      *image_tag_id;
@property (nonatomic, retain) NSString      *image_url;
@property (nonatomic, retain) NSString      *image_thumb_url;
@property (nonatomic, retain) NSNumber      *image_width;
@property (nonatomic, retain) NSNumber      *image_height;
@property (nonatomic, retain) NSDate        *image_created_at;
@property (nonatomic, retain) UIImage       *image_photo;
@property (nonatomic, retain) UIImage       *image_thumb_photo;
@property (nonatomic, retain) NSNumber      *image_is_uploaded;

//for share
@property (nonatomic, retain) NSNumber      *image_is_like;
@property (nonatomic, retain) NSNumber      *image_likes;
@property (nonatomic, retain) NSArray       *image_last_2_comments;

- (ImageObj *)initWithDictionary:(NSDictionary *)dicImage;
- (ImageObj *)initWithCoreDataImage:(CoreDataImage *)coreDataMyImage;
- (ImageObj *)initWithId:(NSNumber *)image_id
                  UserId:(NSNumber *)image_user_id
                   Photo:(UIImage *)image_photo;

- (NSDictionary *)currentDictionary;

@end
