//
//  WebService.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+ (WebService *) sharedInstance;

#pragma mark Users

- (void)loginWithUserEmail:(NSString *)user_email
                  UserPass:(NSString *)user_pass
                   success:(void (^)(UserMe *))success
                   failure:(void (^)(NSString *))failure;

- (void)fbloginWithName:(NSString *)user_name
               UserName:(NSString *)user_username
               UserPass:(NSString *)user_pass
              UserEmail:(NSString *)user_email
          UserAvatarUrl:(NSString *)user_avatar_url
              UserPhone:(NSString *)user_phone
                success:(void (^)(UserMe *))success
                failure:(void (^)(NSString *))failure;

- (void)forgotPasswordWithUserEmail:(NSString *)user_email
                            success:(void (^)(NSString *))success
                            failure:(void (^)(NSString *))failure;

- (void)signupWithName:(NSString *)user_name
              UserName:(NSString *)user_username
             UserEmail:(NSString *)user_email
             UserPhone:(NSString *)user_phone
              UserPass:(NSString *)user_pass
            UserAvatar:(UIImage *)user_avatar
               success:(void (^)(UserMe *))success
               failure:(void (^)(NSString *))failure
              progress:(void (^)(double))progress;

- (void)logoutWithUserId:(NSNumber *)user_id
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure;

- (void)updateUser:(UserMe *)objMe
        UserAvatar:(UIImage *)user_avatar
           success:(void (^)(UserMe *))success
           failure:(void (^)(NSString *))failure
          progress:(void (^)(double))progress;

- (void)changePassword:(NSNumber *)user_id
           CurrentPass:(NSString *)user_current_pass
               NewPass:(NSString *)user_new_pass
               success:(void (^)(NSString *))success
               failure:(void (^)(NSString *))failure;

//users/{user_id}/images
- (void)getMyImagesWithUserId:(NSNumber *)user_id
                      PageNum:(NSInteger)page_num
                    PageCount:(NSInteger)page_count
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSString *))failure;

//users/{user_id}/tags/{tag_id}
- (void)getTagUsersWithId:(NSNumber *)user_id
                    TagId:(NSNumber *)tag_id
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSString *))failure;

//users/{user_id}/notifications
- (void)getAllNotificationsWithUserId:(NSNumber *)user_id
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSString *))failure;

- (void)markAllNotificationsAsRead:(NSNumber *)user_id
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure;

//users/{user_id}/images/share
- (void)getShareImagesWithUserId:(NSNumber *)user_id
                         PageNum:(NSInteger)page_num
                       PageCount:(NSInteger)page_count
                         success:(void (^)(NSArray *))success
                         failure:(void (^)(NSString *))failure;

#pragma mark Tag
- (void)addTagWithUserId:(NSNumber *)tag_user_id
                    Text:(NSString *)tag_text
                 success:(void (^)(NSNumber *))success
                 failure:(void (^)(NSString *))failure;

- (void)deleteTagWithTagId:(NSNumber *)tag_id
                    UserId:(NSNumber *)user_id
                   success:(void (^)(NSString *))success
                   failure:(void (^)(NSString *))failure;

- (void)getTagImagesWithTagId:(NSNumber *)tag_id
                       UserId:(NSNumber *)user_id
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSString *))failure;

#pragma mrak Image
- (void)deleteImagesWithImageIds:(NSString *)image_ids
                          UserId:(NSNumber *)user_id
                        UserName:(NSString *)user_name
                         success:(void (^)(NSString *))success
                         failure:(void (^)(NSString *))failure;

- (void)uploadImageObj:(ImageObj *)objImage
              WithData:(NSData *)dataImage
               success:(void (^)(NSNumber *))success
               failure:(void (^)(NSString *))failure;

- (void)updateUserLikeWithId:(NSNumber *)user_id
                    UserName:(NSString *)user_name
                     ImageId:(NSNumber *)image_id
                  ImageTagId:(NSNumber *)image_tag_id
                    Selected:(BOOL)is_like
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure;

- (void)getImageLikers:(NSNumber *)image_id
                UserId:(NSNumber *)user_id
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSString *))failure;

- (void)getImageWithImageId:(NSNumber *)image_id
                     UserId:(NSNumber *)user_id
                    success:(void (^)(ImageObj *))success
                    failure:(void (^)(NSString *))failure;

#pragma mark Share
- (void)sendShareRequestFrom:(NSNumber *)from_user_id
                FromUserName:(NSString *)from_user_name
                     ToUsers:(NSString *)to_user_ids
                       TagId:(NSNumber *)tag_id
                 TagFullText:(NSString *)tag_text
                     success:(void (^)(NSArray *))success
                     failure:(void (^)(NSString *))failure;

- (void)sendUnshareRequestFrom:(NSNumber *)from_user_id
                  FromUserName:(NSString *)from_user_name
                            To:(NSNumber *)to_user_id
                       ShareId:(NSNumber *)share_id
                   TagFullText:(NSString *)tag_text
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure;

- (void)sendUnshareMe:(NSNumber *)user_id
              FromTag:(NSNumber *)tag_id
              success:(void (^)(NSString *))success
              failure:(void (^)(NSString *))failure;

- (void)sendShareResponseWithId:(NSNumber *)share_id
                         Status:(TAG_USER_STATUS)share_status
                   FromUserName:(NSString *)sender_user_name
                        success:(void (^)(NSString *))success
                        failure:(void (^)(NSString *))failure;


#pragma mark Notification
- (void)getNotificationWithId:(NSNumber *)noti_id
                      success:(void (^)(NotiObj *))success
                      failure:(void (^)(NSString *))failure;

- (void)removeNotificationWithId:(NSNumber *)noti_id
                         success:(void (^)(NSString *))success
                         failure:(void (^)(NSString *))failure;


#pragma mark Comment
- (void)getImageComments:(NSNumber *)image_id
                  UserId:(NSNumber *)user_id
                 success:(void (^)(NSArray *))success
                 failure:(void (^)(NSString *))failure;

- (void)addCommentWithUserId:(NSNumber *)comment_user_id
                     ImageId:(NSNumber *)comment_image_id
                      String:(NSString *)comment_string
                     success:(void (^)(CommentObj *))success
                     failure:(void (^)(NSString *))failure;

- (void)removeCommentWithCommentId:(NSNumber *)comment_id
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure;

@end
