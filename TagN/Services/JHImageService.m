//
//  JHImageService.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "JHImageService.h"

@implementation JHImageService

static JHImageService *_jhImageService = nil;

+ (JHImageService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_jhImageService == nil) {
            _jhImageService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _jhImageService;
}

- (void)getAllTagNImagesWithId:(NSNumber *)user_id
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure {
    [self getMyTagNImagesWithId:user_id
                        PageNum:1
                      PageCount:PAGE_COUNT
                        success:^(BOOL isMoreTags) {
                            [self getShareTagNImagesWithId:user_id
                                                   PageNum:1
                                                 PageCount:PAGE_COUNT
                                                   success:^(BOOL isMoreTags) {
                                                       [self addNotUploadedCoreDataImages];
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS object:nil];
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_MY_PHOTOS object:nil];
                                                       success(@"Get All images from server");
                                                   }
                                                   failure:^(NSString *strError) {
                                                       failure(strError);
                                                   }];
                        }
                        failure:^(NSString *strError) {
                            failure(strError);
                        }];
}

- (void)getMyTagNImagesWithId:(NSNumber *)user_id
                      PageNum:(NSInteger)page_num
                    PageCount:(NSInteger)page_count
                      success:(void (^)(BOOL))success
                      failure:(void (^)(NSString *))failure {
    
    [[WebService sharedInstance] getMyImagesWithUserId:user_id
                                               PageNum:page_num
                                             PageCount:page_count
                                               success:^(NSArray *aryServerImages) {
                                                   //Init user albums
                                                   if(page_num == 1) {
                                                       [[GlobalService sharedInstance].user_me.user_my_albums removeAllObjects];
                                                   }
                                                   
                                                   //add user albums
                                                   [[GlobalService sharedInstance].user_me addMyImageInfos:aryServerImages];
                                                   [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                                   success(aryServerImages.count == page_count);
                                               }
                                               failure:^(NSString *strError) {
                                                   NSLog(@"%@", strError);
                                                   failure(strError);
                                               }];
}

- (void)getShareTagNImagesWithId:(NSNumber *)user_id
                         PageNum:(NSInteger)page_num
                       PageCount:(NSInteger)page_count
                         success:(void (^)(BOOL))success
                         failure:(void (^)(NSString *))failure {
    [[WebService sharedInstance] getShareImagesWithUserId:user_id
                                                  PageNum:page_num
                                                PageCount:page_count
                                                  success:^(NSArray *aryServerImages) {
                                                      //Init share albums
                                                      if(page_num == 1) {
                                                          [[GlobalService sharedInstance].user_me.user_share_albums removeAllObjects];
                                                      }
                                                      //add server albums
                                                      [[GlobalService sharedInstance].user_me addShareImageInfos:aryServerImages];
                                                      [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                                      success(aryServerImages.count == page_count);
                                                  }
                                                  failure:^(NSString *strError) {
                                                      NSLog(@"%@", strError);
                                                      failure(strError);
                                                  }];
}

- (void)addShareTagWithTagId:(NSNumber *)tag_id
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure {
    [[WebService sharedInstance] getTagImagesWithTagId:tag_id
                                                UserId:[GlobalService sharedInstance].user_me.user_id
                                               success:^(NSArray *aryTagImages) {
                                                   [[GlobalService sharedInstance].user_me deleteUserTagWithTagID:tag_id];
                                                   
                                                   if(aryTagImages.count > 0) {
                                                       TagObj *objTag = [[TagObj alloc] initWithDictionary:aryTagImages[0]];
                                                       
                                                       NSMutableArray *aryImages = [[NSMutableArray alloc] init];
                                                       for(int nIndex = 0; nIndex < aryTagImages.count; nIndex++) {
                                                           ImageObj *objImage = [[ImageObj alloc] initWithDictionary:aryTagImages[nIndex]];
                                                           
                                                           [aryImages addObject:objImage];
                                                       }
                                                       
                                                       ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] initWithTag:objTag
                                                                                                               Images:aryImages];
                                                       
                                                       [[GlobalService sharedInstance].user_me.user_share_albums insertObject:objImageInfo atIndex:0];
                                                   }
                                                   
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS
                                                                                                       object:nil];
                                                   
                                                   success(@"Updated share albums successfully");
                                               }
                                               failure:^(NSString *strError) {
                                                   failure(strError);
                                               }];
}

- (void)addNotUploadedCoreDataImages {
    //get not uploaded core data albums
    NSArray *aryCoreDataImages = [[CoreDataService sharedInstance] loadNotUploadedImages];
    for(int nIndex = 0; nIndex < aryCoreDataImages.count; nIndex++) {
        ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:aryCoreDataImages[nIndex]];
        
        TagObj *objTag = [[GlobalService sharedInstance].user_me getTagObjFromId:objImage.image_tag_id];
        if(objTag) {
            ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] initWithTag:objTag
                                                                    Images:@[objImage]];
            
            [[GlobalService sharedInstance].user_me addMyImageInfo:objImageInfo];
            [[GlobalService sharedInstance].user_me addShareImageInfo:objImageInfo];
        }
    }
}

- (void)addTagWithUserId:(NSNumber *)user_id
                    Text:(NSString *)tag_text
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure {
    
    [[WebService sharedInstance] addTagWithUserId:user_id
                                             Text:tag_text
                                          success:^(NSNumber *tag_id) {
                                              [[GlobalService sharedInstance].user_me addUserTagWithId:tag_id
                                                                                                  Text:tag_text];
                                              success(@"Added Tag Successfully");
                                          }
                                          failure:^(NSString *strError) {
                                              failure(strError);
                                          }];
    
}

- (void)deleteTagWithId:(NSNumber *)tag_id
                 UserId:(NSNumber *)user_id
                success:(void (^)(NSString *))success
                failure:(void (^)(NSString *))failure {
    
    [[WebService sharedInstance] deleteTagWithTagId:tag_id
                                             UserId:user_id
                                            success:^(NSString *strResult) {
                                                //delete images and tags from user object
                                                [[GlobalService sharedInstance].user_me deleteUserTagWithTagID:tag_id];
                                                
                                                //delete images and tags from core data object
                                                [[CoreDataService sharedInstance] deleteImagesWithTagID:tag_id];
                                                
                                                success(strResult);
                                            }
                                            failure:^(NSString *strError) {
                                                failure(strError);
                                            }];
}

- (void)deleteImagesWithIds:(NSString *)image_ids
                     UserId:(NSNumber *)user_id
                   UserName:(NSString *)user_name
                      TagId:(NSNumber *)tag_id
                    success:(void (^)(NSString *))success
                    failure:(void (^)(NSString *))failure {
    [[WebService sharedInstance] deleteImagesWithImageIds:image_ids
                                                   UserId:user_id
                                                 UserName:user_name
                                                  success:^(NSString *strResult) {
                                                      //delete images and tags from user object
                                                      [[GlobalService sharedInstance].user_me deleteUserImagesWithImageIDs:image_ids
                                                                                                                     TagId:tag_id];
                                                      
                                                      //delete images and tags from core data object
                                                      [[CoreDataService sharedInstance] deleteImagesWithImageIDs:image_ids];
                                                      
                                                      success(strResult);
                                                  }
                                                  failure:^(NSString *strError) {
                                                      failure(strError);
                                                  }];
}

- (void)updateImageWithImageId:(NSNumber *)image_id
                        UserId:(NSNumber *)user_id
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure {
    [[WebService sharedInstance] getImageWithImageId:image_id
                                              UserId:user_id
                                             success:^(ImageObj *objImage) {
                                                 [[GlobalService sharedInstance].user_me updateMyImageInfoWith:objImage];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_MY_PHOTOS
                                                                                                     object:nil
                                                                                                   userInfo:@{@"image_obj": objImage.image_tag_id}];
                                                 
                                                 [[GlobalService sharedInstance].user_me updateShareImageInfoWith:objImage];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS
                                                                                                     object:nil
                                                                                                   userInfo:@{@"image_obj": objImage.image_tag_id}];
                                                 
                                                 success(@"Updated Image Object successfully");
                                             }
                                             failure:^(NSString *strError) {
                                                 failure(strError);
                                             }];
}

@end
