//
//  ImageLikerObj.h
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLikerObj : NSObject

@property (nonatomic, retain) NSNumber      *like_id;
@property (nonatomic, retain) NSNumber      *like_user_id;
@property (nonatomic, retain) NSString      *like_user_name;
@property (nonatomic, retain) NSString      *like_user_username;
@property (nonatomic, retain) NSString      *like_user_avatar_url;
@property (nonatomic, retain) NSNumber      *like_image_id;
@property (nonatomic, retain) NSDate        *like_created_at;

- (ImageLikerObj *)initWithDictionary:(NSDictionary *)dicImageLiker;

@end
