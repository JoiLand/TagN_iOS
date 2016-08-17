//
//  WebService.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "WebService.h"
#import <AFNetworking/AFNetworking.h>

@implementation WebService

static WebService *_webService = nil;
AFHTTPSessionManager *manager;

+ (WebService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_webService == nil) {
            _webService = [[self alloc] init]; // assignment not done here
            
            manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"image/jpeg", nil];
        }
    });
    
    return _webService;
}

- (void)loginWithUserEmail:(NSString *)user_email
                  UserPass:(NSString *)user_pass
                   success:(void (^)(UserMe *))success
                   failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_email":          user_email,
                                    @"user_pass":           user_pass,
                                    @"user_device_token":   [GlobalService sharedInstance].user_device_token,
                                    @"user_time_zone":      [[GlobalService sharedInstance] getUserTimeZone],
                                    @"user_device_type":    @"iOS"
                                    };
        
        [manager GET:@"v1/users/login"
          parameters:dicParams
            progress:^(NSProgress * _Nonnull uploadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     UserMe *objMe = [[UserMe alloc] initWithDictionary:dicResult[SERVER_RESULT_MESSAGES]];
                     success(objMe);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)fbloginWithName:(NSString *)user_name
               UserName:(NSString *)user_username
               UserPass:(NSString *)user_pass
              UserEmail:(NSString *)user_email
          UserAvatarUrl:(NSString *)user_avatar_url
              UserPhone:(NSString *)user_phone
                success:(void (^)(UserMe *))success
                failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_name":           user_name,
                                    @"user_username":       user_username,
                                    @"user_pass":           user_pass,
                                    @"user_email":          user_email,
                                    @"user_avatar_url":     user_avatar_url,
                                    @"user_phone":          user_phone,
                                    @"user_device_token":   [GlobalService sharedInstance].user_device_token,
                                    @"user_time_zone":      [[GlobalService sharedInstance] getUserTimeZone],
                                    @"user_device_type":    @"iOS"
                                    };
        
        [manager GET:@"v1/users/fblogin"
          parameters:dicParams
            progress:^(NSProgress * _Nonnull uploadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     UserMe *objMe = [[UserMe alloc] initWithDictionary:dicResult[SERVER_RESULT_MESSAGES]];
                     success(objMe);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)forgotPasswordWithUserEmail:(NSString *)user_email
                            success:(void (^)(NSString *))success
                            failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        
        NSDictionary *dicParams = @{
                                    @"user_email": user_email
                                    };
        [manager GET:@"v1/users/forgotpassword"
          parameters:dicParams
            progress:^(NSProgress * _Nonnull uploadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                     success(strResult);
                 } else {
                     NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strResult);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)signupWithName:(NSString *)user_name
              UserName:(NSString *)user_username
             UserEmail:(NSString *)user_email
             UserPhone:(NSString *)user_phone
              UserPass:(NSString *)user_pass
            UserAvatar:(UIImage *)user_avatar
               success:(void (^)(UserMe *))success
               failure:(void (^)(NSString *))failure
              progress:(void (^)(double))progress {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_name":           user_name,
                                    @"user_username":       user_username,
                                    @"user_pass":           user_pass,
                                    @"user_email":          user_email,
                                    @"user_phone":          user_phone,
                                    @"user_device_token":   [GlobalService sharedInstance].user_device_token,
                                    @"user_time_zone":      [[GlobalService sharedInstance] getUserTimeZone],
                                    @"user_device_type":    @"iOS"
                                    };
        
        if(user_avatar) {
            [manager POST:@"v1/users"
               parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(user_avatar, 0.5f)]
                                name:@"avatar"
                            fileName:@"avatar.jpg"
                            mimeType:@"image/jpeg"];
}
                 progress:^(NSProgress * _Nonnull uploadProgress) {
                     progress(uploadProgress.fractionCompleted);
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *dicResult = (NSDictionary *)responseObject;
                      NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                      if(nCode.intValue == SERVER_RES_CODE_OK) {
                          UserMe *objMe = [[UserMe alloc] initWithDictionary:dicResult[SERVER_RESULT_MESSAGES]];
                          success(objMe);
                      } else {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      failure(error.localizedDescription);
                  }];
        } else {
            [manager POST:@"v1/users"
               parameters:dicParams
                 progress:^(NSProgress * _Nonnull uploadProgress) {
                     progress(uploadProgress.fractionCompleted);
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *dicResult = (NSDictionary *)responseObject;
                      NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                      if(nCode.intValue == SERVER_RES_CODE_OK) {
                          UserMe *objMe = [[UserMe alloc] initWithDictionary:dicResult[SERVER_RESULT_MESSAGES]];
                          success(objMe);
                      } else {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      failure(error.localizedDescription);
                  }];
        }
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)logoutWithUserId:(NSNumber *)user_id
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager PATCH:[NSString stringWithFormat:@"v1/users/%d", user_id.intValue]
            parameters:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *dicResult = (NSDictionary *)responseObject;
                   NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                   if(nCode.intValue == SERVER_RES_CODE_OK) {
                       NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                       success(strResult);
                   } else {
                       NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                       success(strError);
                   }
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(error.localizedDescription);
               }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)updateUser:(UserMe *)objMe
        UserAvatar:(UIImage *)user_avatar
           success:(void (^)(UserMe *))success
           failure:(void (^)(NSString *))failure
          progress:(void (^)(double))progress {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_name":       objMe.user_name,
                                    @"user_username":   objMe.user_username,
                                    @"user_phone":      objMe.user_phone,
                                    @"user_avatar_url": objMe.user_avatar_url
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        if(user_avatar) {
            [manager POST:[NSString stringWithFormat:@"v1/users/%d", objMe.user_id.intValue]
               parameters:dicParams
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(user_avatar, 0.5f)]
                                name:@"avatar"
                            fileName:@"avatar.jpg"
                            mimeType:@"image/jpeg"];
}
                 progress:^(NSProgress * _Nonnull uploadProgress) {
                     progress(uploadProgress.fractionCompleted);
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *dicResult = (NSDictionary *)responseObject;
                      NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                      if(nCode.intValue == SERVER_RES_CODE_OK) {
                          NSDictionary *dicUser = dicResult[SERVER_RESULT_MESSAGES];
                          UserMe *objMe = [[UserMe alloc] initWithDictionary:dicUser];
                          
                          success(objMe);
                      } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      } else {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      failure(error.localizedDescription);
                  }];
        } else {
            [manager POST:[NSString stringWithFormat:@"v1/users/%d", objMe.user_id.intValue]
               parameters:dicParams
                 progress:^(NSProgress * _Nonnull uploadProgress) {
                     progress(uploadProgress.fractionCompleted);
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *dicResult = (NSDictionary *)responseObject;
                      NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                      if(nCode.intValue == SERVER_RES_CODE_OK) {
                          NSDictionary *dicUser = dicResult[SERVER_RESULT_MESSAGES];
                          UserMe *objMe = [[UserMe alloc] initWithDictionary:dicUser];
                          
                          success(objMe);
                      } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      } else {
                          NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                          failure(strError);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      failure(error.localizedDescription);
                  }];
        }
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)changePassword:(NSNumber *)user_id
           CurrentPass:(NSString *)user_current_pass
               NewPass:(NSString *)user_new_pass
               success:(void (^)(NSString *))success
               failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_current_pass":   user_current_pass,
                                    @"user_new_pass":       user_new_pass
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager PUT:[NSString stringWithFormat:@"v1/users/%d", user_id.intValue]
          parameters:dicParams
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                     success(strResult);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)addTagWithUserId:(NSNumber *)tag_user_id
                    Text:(NSString *)tag_text
                 success:(void (^)(NSNumber *))success
                 failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParams = @{
                                    @"tag_user_id":     tag_user_id,
                                    @"tag_text":        tag_text
                                    };
        
        [manager POST:@"v1/tags"
           parameters:dicParams
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dicResult = (NSDictionary *)responseObject;
                  NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                  if(nCode.intValue == SERVER_RES_CODE_OK) {
                      NSNumber *nResult = dicResult[SERVER_RESULT_MESSAGES];
                      success(nResult);
                  } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  } else {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(error.localizedDescription);
              }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)deleteTagWithTagId:(NSNumber *)tag_id
                    UserId:(NSNumber *)user_id
                   success:(void (^)(NSString *))success
                   failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParams = @{
                                    @"user_id": user_id
                                    };
        [manager DELETE:[NSString stringWithFormat:@"v1/tags/%d", tag_id.intValue]
             parameters:dicParams
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dicResult = (NSDictionary *)responseObject;
                    NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                    if(nCode.intValue == SERVER_RES_CODE_OK) {
                        NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                        success(strResult);
                    } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    } else {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error.localizedDescription);
                }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getTagImagesWithTagId:(NSNumber *)tag_id
                       UserId:(NSNumber *)user_id
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_id":  user_id
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"v1/tags/%d/images", tag_id.intValue]
          parameters:dicParams
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicImages = dicResult[SERVER_RESULT_MESSAGES];
                     success(aryDicImages);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)deleteImagesWithImageIds:(NSString *)image_ids
                          UserId:(NSNumber *)user_id
                        UserName:(NSString *)user_name
                         success:(void (^)(NSString *))success
                         failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        NSDictionary *dicParams = @{
                                    @"image_ids":           image_ids,
                                    @"image_user_id":       user_id,
                                    @"image_user_name":     user_name
                                    };
        [manager DELETE:@"v1/images"
             parameters:dicParams
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dicResult = (NSDictionary *)responseObject;
                    NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                    if(nCode.intValue == SERVER_RES_CODE_OK) {
                        NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                        success(strResult);
                    } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    } else {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error.localizedDescription);
                }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getMyImagesWithUserId:(NSNumber *)user_id
                      PageNum:(NSInteger)page_num
                    PageCount:(NSInteger)page_count
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSString *))failure {
    
    NSDictionary *dicParam = @{
                               @"page_num":     [NSNumber numberWithInteger:page_num],
                               @"page_count":   [NSNumber numberWithInteger:page_count]
                               };
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"/v1/users/%d/images", user_id.intValue]
          parameters:dicParam
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicImageInfos = dicResult[SERVER_RESULT_MESSAGES];
                     NSMutableArray *aryImageInfos = [[NSMutableArray alloc] init];
                     for(NSDictionary *dicImageInfo in aryDicImageInfos) {
                         ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] initWithDictionary:dicImageInfo];
                         [aryImageInfos addObject:objImageInfo];
                     }
                     success(aryImageInfos);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getShareImagesWithUserId:(NSNumber *)user_id
                         PageNum:(NSInteger)page_num
                       PageCount:(NSInteger)page_count
                         success:(void (^)(NSArray *))success
                         failure:(void (^)(NSString *))failure {
    
    NSDictionary *dicParam = @{
                               @"page_num":     [NSNumber numberWithInteger:page_num],
                               @"page_count":   [NSNumber numberWithInteger:page_count]
                               };
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"/v1/users/%d/images/share", user_id.intValue]
          parameters:dicParam
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicImageInfos = dicResult[SERVER_RESULT_MESSAGES];
                     NSMutableArray *aryImageInfos = [[NSMutableArray alloc] init];
                     for(NSDictionary *dicImageInfo in aryDicImageInfos) {
                         ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] initWithDictionary:dicImageInfo];
                         [aryImageInfos addObject:objImageInfo];
                     }
                     success(aryImageInfos);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)uploadImageObj:(ImageObj *)objImage
              WithData:(NSData *)dataImage
               success:(void (^)(NSNumber *))success
               failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager POST:@"v1/images"
           parameters:objImage.currentDictionary
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:dataImage
                                name:@"image"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpeg"];
}
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dicResult = (NSDictionary *)responseObject;
                  NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                  if(nCode.intValue == SERVER_RES_CODE_OK) {
                      NSNumber *nImageId = [NSNumber numberWithInt:[dicResult[SERVER_RESULT_MESSAGES] intValue]];
                      success(nImageId);
                  } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  } else {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(error.localizedDescription);
              }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getTagUsersWithId:(NSNumber *)user_id
                    TagId:(NSNumber *)tag_id
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"/v1/users/%d/tag/%d/users", user_id.intValue, tag_id.intValue]
          parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryCategories = dicResult[SERVER_RESULT_MESSAGES];
                     
                     NSMutableArray *aryFriends = [[NSMutableArray alloc] init];
                     NSMutableArray *aryStrangers = [[NSMutableArray alloc] init];
                     
                     for(NSDictionary *dicUser in aryCategories[0]) {
                         UserObj *objUser = [[UserObj alloc] initWithDictionary:dicUser];
                         [aryFriends addObject:objUser];
                     }
                     
                     for(NSDictionary *dicUser in aryCategories[1]) {
                         UserObj *objUser = [[UserObj alloc] initWithDictionary:dicUser];
                         [aryStrangers addObject:objUser];
                     }
                     
                     success(@[aryFriends, aryStrangers]);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)sendShareRequestFrom:(NSNumber *)from_user_id
                FromUserName:(NSString *)from_user_name
                     ToUsers:(NSString *)to_user_ids
                       TagId:(NSNumber *)tag_id
                 TagFullText:(NSString *)tag_text
                     success:(void (^)(NSArray *))success
                     failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"share_from_user_id":      from_user_id,
                                    @"share_from_user_name":    from_user_name,
                                    @"share_to_user_ids":       to_user_ids,
                                    @"share_tag_id":            tag_id,
                                    @"share_tag_text":          tag_text
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager POST:@"/v1/shares"
           parameters:dicParams
             progress:^(NSProgress * _Nonnull downloadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dicResult = (NSDictionary *)responseObject;
                  NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                  if(nCode.intValue == SERVER_RES_CODE_OK) {
                      NSArray *aryShareIds = dicResult[SERVER_RESULT_MESSAGES];
                      
                      success(aryShareIds);
                  } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  } else {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(error.localizedDescription);
              }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)sendUnshareRequestFrom:(NSNumber *)from_user_id
                  FromUserName:(NSString *)from_user_name
                            To:(NSNumber *)to_user_id
                       ShareId:(NSNumber *)share_id
                   TagFullText:(NSString *)tag_text
                       success:(void (^)(NSString *))success
                       failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"sender_id":       from_user_id,
                                    @"sender_user_name":from_user_name,
                                    @"receiver_id":     to_user_id,
                                    @"tag_text":        tag_text
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager DELETE:[NSString stringWithFormat:@"/v1/shares/%d", share_id.intValue]
             parameters:dicParams
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dicResult = (NSDictionary *)responseObject;
                    NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                    if(nCode.intValue == SERVER_RES_CODE_OK) {
                        NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                        
                        success(strResult);
                    } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    } else {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error.localizedDescription);
                }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)sendUnshareMe:(NSNumber *)user_id
              FromTag:(NSNumber *)tag_id
              success:(void (^)(NSString *))success
              failure:(void (^)(NSString *))failure {
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager DELETE:[NSString stringWithFormat:@"/v1/users/%d/tag/%d", user_id.intValue, tag_id.intValue]
          parameters:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                     success(strResult);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getAllNotificationsWithUserId:(NSNumber *)user_id
                              success:(void (^)(NSArray *))success
                              failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        
        [manager GET:[NSString stringWithFormat:@"/v1/users/%d/notifications", user_id.intValue]
          parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicNotis = dicResult[SERVER_RESULT_MESSAGES];
                     NSMutableArray *aryNotis = [[NSMutableArray alloc] init];
                     
                     for(NSDictionary *dicNoti in aryDicNotis) {
                         NotiObj *objNoti = [[NotiObj alloc] initWithDictionary:dicNoti];
                         [aryNotis addObject:objNoti];
                     }
                     
                     success(aryNotis);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)markAllNotificationsAsRead:(NSNumber *)user_id
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager PATCH:[NSString stringWithFormat:@"/v1/users/%d/notifications", user_id.intValue]
            parameters:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *dicResult = (NSDictionary *)responseObject;
                   NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                   if(nCode.intValue == SERVER_RES_CODE_OK) {
                       NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                       
                       success(strResult);
                   } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                       NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                       failure(strError);
                   } else {
                       NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                       failure(strError);
                   }
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(error.localizedDescription);
               }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)sendShareResponseWithId:(NSNumber *)share_id
                         Status:(TAG_USER_STATUS)share_status
                   FromUserName:(NSString *)sender_user_name
                        success:(void (^)(NSString *))success
                        failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"sender_user_name":    sender_user_name,
                                    @"share_status":        [NSNumber numberWithInt:share_status]
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager PATCH:[NSString stringWithFormat:@"/v1/shares/%d", share_id.intValue]
            parameters:dicParams
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *dicResult = (NSDictionary *)responseObject;
                   NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                   if(nCode.intValue == SERVER_RES_CODE_OK) {
                       NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                       
                       success(strResult);
                   } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                       NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                       failure(strError);
                   } else {
                       NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                       failure(strError);
                   }
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(error.localizedDescription);
               }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getNotificationWithId:(NSNumber *)noti_id
                      success:(void (^)(NotiObj *))success
                      failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"v1/notifications/%d", noti_id.intValue]
          parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSDictionary *dicNoti = dicResult[SERVER_RESULT_MESSAGES];
                     NotiObj *objNoti = [[NotiObj alloc] initWithDictionary:dicNoti];
                     
                     success(objNoti);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)removeNotificationWithId:(NSNumber *)noti_id
                         success:(void (^)(NSString *))success
                         failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager DELETE:[NSString stringWithFormat:@"v1/notifications/%d", noti_id.intValue]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dicResult = (NSDictionary *)responseObject;
                    NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                    if(nCode.intValue == SERVER_RES_CODE_OK) {
                        NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                        
                        success(strResult);
                    } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    } else {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    }
                    
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error.localizedDescription);
                }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

#pragma mark images likes
- (void)updateUserLikeWithId:(NSNumber *)user_id
                    UserName:(NSString *)user_name
                     ImageId:(NSNumber *)image_id
                  ImageTagId:(NSNumber *)image_tag_id
                    Selected:(BOOL)is_like
                     success:(void (^)(NSString *))success
                     failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_id":     user_id,
                                    @"user_name":   user_name,
                                    @"image_tag_id":image_tag_id,
                                    @"is_like":     [NSNumber numberWithBool:is_like]
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager POST:[NSString stringWithFormat:@"v1/images/%d/likes", image_id.intValue]
           parameters:dicParams
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dicResult = (NSDictionary *)responseObject;
                  NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                  if(nCode.intValue == SERVER_RES_CODE_OK) {
                      NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                      
                      success(strResult);
                  } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  } else {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(error.localizedDescription);
              }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

#pragma mark comment

- (void)getImageComments:(NSNumber *)image_id
                  UserId:(NSNumber *)user_id
                 success:(void (^)(NSArray *))success
                 failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_id": user_id
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"v1/images/%d/comments", image_id.intValue]
          parameters:dicParams
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicComments = dicResult[SERVER_RESULT_MESSAGES];
                     NSMutableArray *aryComments = [[NSMutableArray alloc] init];
                     
                     for(NSDictionary *dicComment in aryDicComments) {
                         CommentObj *objComment = [[CommentObj alloc] initWithDictionary:dicComment];
                         [aryComments addObject:objComment];
                     }
                     
                     success(aryComments);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
                 
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getImageLikers:(NSNumber *)image_id
                UserId:(NSNumber *)user_id
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_id": user_id
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"v1/images/%d/likers", image_id.intValue]
          parameters:dicParams
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSArray *aryDicLikers = dicResult[SERVER_RESULT_MESSAGES];
                     NSMutableArray *aryImageLikers = [[NSMutableArray alloc] init];
                     
                     for(NSDictionary *dicLiker in aryDicLikers) {
                         ImageLikerObj *objLiker = [[ImageLikerObj alloc] initWithDictionary:dicLiker];
                         [aryImageLikers addObject:objLiker];
                     }
                     
                     success(aryImageLikers);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
                 
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)getImageWithImageId:(NSNumber *)image_id
                     UserId:(NSNumber *)user_id
                    success:(void (^)(ImageObj *))success
                    failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"user_id": user_id
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager GET:[NSString stringWithFormat:@"v1/images/%d", image_id.intValue]
          parameters:dicParams
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dicResult = (NSDictionary *)responseObject;
                 NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                 if(nCode.intValue == SERVER_RES_CODE_OK) {
                     NSDictionary *dicImageObj = dicResult[SERVER_RESULT_MESSAGES];
                     
                     ImageObj *objImage = [[ImageObj alloc] initWithDictionary:dicImageObj];
                     
                     success(objImage);
                 } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 } else {
                     NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                     failure(strError);
                 }
                 
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error.localizedDescription);
             }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)addCommentWithUserId:(NSNumber *)comment_user_id
                     ImageId:(NSNumber *)comment_image_id
                      String:(NSString *)comment_string
                     success:(void (^)(CommentObj *))success
                     failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        NSDictionary *dicParams = @{
                                    @"comment_user_id":     comment_user_id,
                                    @"comment_image_id":    comment_image_id,
                                    @"comment_string":      comment_string
                                    };
        
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager POST:@"v1/comments"
           parameters:dicParams
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSDictionary *dicResult = (NSDictionary *)responseObject;
                  NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                  if(nCode.intValue == SERVER_RES_CODE_OK) {
                      NSDictionary *dicComment = dicResult[SERVER_RESULT_MESSAGES];
                      CommentObj *objComment = [[CommentObj alloc] initWithDictionary:dicComment];
                      
                      success(objComment);
                  } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  } else {
                      NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                      failure(strError);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(error.localizedDescription);
              }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

- (void)removeCommentWithCommentId:(NSNumber *)comment_id
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure {
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [manager.requestSerializer setValue:[GlobalService sharedInstance].user_access_token
                         forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
        [manager DELETE:[NSString stringWithFormat:@"v1/comments/%d", comment_id.intValue]
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dicResult = (NSDictionary *)responseObject;
                    NSNumber *nCode = dicResult[SERVER_RESULT_CODE];
                    if(nCode.intValue == SERVER_RES_CODE_OK) {
                        NSString *strResult = dicResult[SERVER_RESULT_MESSAGES];
                        
                        success(strResult);
                    } else if(nCode.intValue == SERVER_RES_CODE_ERROR) {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    } else {
                        NSString *strError = dicResult[SERVER_RESULT_MESSAGES];
                        failure(strError);
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error.localizedDescription);
                }];
    } else {
        failure(JDSTATUS_NOTIFICATION_NO_INTERNET);
    }
}

@end
