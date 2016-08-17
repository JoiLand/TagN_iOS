//
//  Constants.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define APP_NAME                                @"TagN"

#define SERVER_URL                              @"http://52.32.169.200"
#define SERVER_RESULT_CODE                      @"code"
#define SERVER_RESULT_MESSAGES                  @"messages"

#define ONESIGNAL_APP_ID                        @"fc17a318-dc7e-4810-9e96-ee85478ad7cc"

//Server response codes
#define SERVER_RES_CODE_OK                      200
#define SERVER_RES_CODE_ERROR                   400
#define SERVER_RES_NO_AUTH                      401
#define SERVER_RES_FORBIDDEN                    403

#define HTTP_HEADER_TOKEN_KEY                   @"AccessToken"

//NSUserDefaults Keys
#define USER_DEFAULTS_KEY_ME                    @"UserDefaultsKeyMe"
#define USER_DEFAULTS_KEY_MY_SETTINGS           @"UserDefaultsKeyMySettings"

//SVProgressHUD
#define SVPROGRESSHUD_PLEASE_WAIT               [SVProgressHUD showWithStatus:@"Please wait..."]
#define SVPROGRESSHUD_DISMISS                   [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)           [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)             [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_PROGRESS(progress)        [SVProgressHUD showProgress:progress status:@"Uploading..."];

//Toast Messages
#define TOAST_NO_NAME                           @"Please input your name"
#define TOAST_NO_USER_NAME                      @"Please input your user name"
#define TOAST_INVALID_EMAIL_ADDRESS             @"Invalid Email Address"
#define TOAST_INVALID_PHONE_NUMBER              @"Invalid Phone Number"
#define TOAST_SHORT_PASSWORD                    @"Password must be 6 over characters"
#define TOAST_MISMATCH_PASSWORD                 @"Mismatch your password"
#define TOAST_PHOTO_NOT_DOWNLOAD                @"This photo has not been loaded yet :("
#define APP_SHARE_TEXT                          @"Sharing it via TAGN"
#define TOAST_REMOVED_IMAGE                     @"This image was removed by owner"
#define TOAST_OVER_STORY_IMAGES(count)          [NSString stringWithFormat:@"You can select %d photos at most", (int)count]
#define TOAST_NO_SELECTED_PHOTO                 @"Please select your story photos"

//TagN Colors
#define TAGN_PANTONE_423_COLOR                  [UIColor hx_colorWithHexString:@"96938E"]
#define TAGN_PANTONE_422_COLOR                  [UIColor hx_colorWithHexString:@"AFAAA3"]
#define TAGN_PANTONE_394_COLOR                  [UIColor hx_colorWithHexString:@"EAED35"]
#define TAGN_PANTONE_368_COLOR                  [UIColor hx_colorWithHexString:@"5BBF21"]
#define TAGN_PANTONE_7477_COLOR                 [UIColor hx_colorWithHexString:@"2B5763"]
#define TAGN_DELETE_BUTTON_COLOR                [UIColor hx_colorWithHexString:@"ff3b30"]

//settings page
#define PRIVACY_POLICY_LINK                     @"https://www.iubenda.com/privacy-policy/261602"
#define HELP_LINK                               @"https://www.youtube.com/channel/UC2SRIhSr6Bsr_KYKap7AS_A"
#define APP_STORE_URL                           @"https://itunes.apple.com/sb/app/tagn/id1012801370?mt=8"

//image size
#define AVATAR_IMAGE_SIZE                       CGSizeMake(200, 200)
#define PHOTO_IMAGE_SIZE                        CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)

//font size
#define COMMENT_FONT_SIZE                       14.f

//JDStatusNotification
#define JDSTATUS_NOTIFICATION_NO_INTERNET       @"No Internet Connection!"

//NSNotification Keys
#define NOTIFICATION_ADD_MY_PHOTOS              @"NotificationAddMyPhotos"
#define NOTIFICATION_ADD_SHARE_PHOTOS           @"NotificationAddSharePhotos"
#define NOTIFICATION_GET_NOTIFICATION           @"NotificationGetNotification"

//Image url
#define AVATAR_FULL_URL_STRING(url)             url.length > 7 ? ([[url substringToIndex:7] isEqualToString:@"http://"]?url:[NSString stringWithFormat:@"https://s3-us-west-2.amazonaws.com/avatar.tagn.s3.com/%@", url]):@""
#define IMAGE_FULL_URL_STRING(url)              [NSString stringWithFormat:@"https://s3-us-west-2.amazonaws.com/image.tagn.s3.com/%@", url]
#define IMAGE_THUMB_FULL_URL_STRING(url)        [NSString stringWithFormat:@"https://s3-us-west-2.amazonaws.com/thumb.tagn.s3.com/%@", url]
#define IMAGE_PLACEHOLDER_URL_STRING            @"common_imgGreyBackground"
#define IMAGE_UNKNOWN_URL_STRING                @"common_imgDeleted"

// Tumblr
#define TUMBLR_CUSTOMER_KEY                     @"FdFHrGl8xQaRYO0OV3e3DWy2oga6BJN9TAFGTDcD35SnUEtxnE"
#define TUMBLR_CUSTOMER_SECRET                  @"xnQi1ZRfUV4QTRORN4GKIKasN7yH17PZMvVVCWEVLpecIBb7HE"
#define TUMBLR_CUSTOMER_TOKEN                   @"t5g3kwqM1Wp2QUJ8C0u2FVBFQHSDJFZlv8SMHGHeOIO9LBFJ5S"
#define TUMBLR_CUSTOMER_TOKEN_SECRET            @"OHekJJD2AOqK0XVffwluXOEwXmYssd8nNe188fny46Aw0bbIJT"

//Tags
#define MOST_RECENT_TAGS_COUNT                  10
#define MOST_POPULAR_TAGS_COUNT                 10

#define PAGE_COUNT                              5

#define STORY_MAX_IMAGES                        30

//enums

typedef enum {
    TAG_USER_STATUS_UNKNOWN = -10,
    TAG_USER_STATUS_PENDING = 0,
    TAG_USER_STATUS_REJECTED = -1,
    TAG_USER_STATUS_ACCEPTED = 1
}TAG_USER_STATUS;

typedef enum{
    TAG_USER_REQUEST_SHARE  = 0,
    TAG_USER_REQUEST_UNSHARE = -1
}TAG_USER_REQUEST_TYPE;

typedef enum{
    TAGN_PUSH_SHARE_REQUEST = 0,
    TAGN_PUSH_ACCEPT_SHARE,
    TAGN_PUSH_REJECT_SHARE,
    TAGN_PUSH_UNSHARE_REQUEST,
    TAGN_PUSH_REMOVE_SHARE_TAG,
    TAGN_PUSH_UPLOAD_PHOTO,
    TAGN_PUSH_REMOVE_PHOTO,
    TAGN_PUSH_ADD_COMMENT,
    TAGN_PUSH_REMOVE_COMMENT,
    TAGN_PUSH_LIKED_IMAGE,
    TAGN_PUSH_DISLIKED_IMAGE
}TAGN_PUSH_TYPE;

#endif /* Constants_h */
