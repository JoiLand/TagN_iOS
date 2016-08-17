//
//  JHImageService.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHImageService : NSObject

+ (JHImageService *) sharedInstance;

- (void)getAllTagNImagesWithId:(NSNumber *)user_id
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure;

- (void)getMyTagNImagesWithId:(NSNumber *)user_id
                      PageNum:(NSInteger)page_num
                    PageCount:(NSInteger)page_count
                      success:(void (^)(BOOL))success
                      failure:(void (^)(NSString *))failure;

- (void)getShareTagNImagesWithId:(NSNumber *)user_id
                         PageNum:(NSInteger)page_num
                       PageCount:(NSInteger)page_count
                         success:(void (^)(BOOL))success
                         failure:(void (^)(NSString *))failure;

- (void)addShareTagWithTagId:(NSNumber *)tag_id
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure;

- (void)addTagWithUserId:(NSNumber *)user_id
                    Text:(NSString *)tag_text
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure;

- (void)deleteTagWithId:(NSNumber *)tag_id
                 UserId:(NSNumber *)user_id
                success:(void (^)(NSString *))success
                failure:(void (^)(NSString *))failure;

- (void)deleteImagesWithIds:(NSString *)image_ids
                     UserId:(NSNumber *)user_id
                   UserName:(NSString *)user_name
                      TagId:(NSNumber *)tag_id
                    success:(void (^)(NSString *))success
                    failure:(void (^)(NSString *))failure;

- (void)updateImageWithImageId:(NSNumber *)image_id
                        UserId:(NSNumber *)user_id
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure;

@end
