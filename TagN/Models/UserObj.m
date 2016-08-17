//
//  UserObj.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "UserObj.h"
#import "ContactUserObj.h"

@implementation UserObj

- (id)init {
    self = [super init];
    if(self) {
        self.user_id = @0;
        self.user_name = @"";
        self.user_username = @"";
        self.user_email = @"";
        self.user_avatar_url = @"";
        self.user_phone = @"";
        self.user_device_token = @"";
        self.user_share_id = @0;
        self.user_share_status = TAG_USER_STATUS_UNKNOWN;
    }
    
    return self;
}

- (UserObj *)initWithDictionary:(NSDictionary *)dicUser {
    UserObj *objUser = [[UserObj alloc] init];
    
    if(dicUser[@"user_id"] && ![dicUser[@"user_id"] isEqual:[NSNull null]]) {
        objUser.user_id = [NSNumber numberWithInt:[dicUser[@"user_id"] intValue]];
    }
    
    if(dicUser[@"user_name"] && ![dicUser[@"user_name"] isEqual:[NSNull null]]) {
        objUser.user_name = dicUser[@"user_name"];
    }
    
    if(dicUser[@"user_username"] && ![dicUser[@"user_username"] isEqual:[NSNull null]]) {
        objUser.user_username = dicUser[@"user_username"];
    }
    
    if(dicUser[@"user_email"] && ![dicUser[@"user_email"] isEqual:[NSNull null]]) {
        objUser.user_email = dicUser[@"user_email"];
    }
    
    if(dicUser[@"user_avatar_url"] && ![dicUser[@"user_avatar_url"] isEqual:[NSNull null]]) {
        objUser.user_avatar_url = dicUser[@"user_avatar_url"];
    }
    
    if(dicUser[@"user_phone"] && ![dicUser[@"user_phone"] isEqual:[NSNull null]]) {
        objUser.user_phone = dicUser[@"user_phone"];
    }
    
    if(dicUser[@"user_device_token"] && ![dicUser[@"user_device_token"] isEqual:[NSNull null]]) {
        objUser.user_device_token = dicUser[@"user_device_token"];
    }
    
    if(dicUser[@"user_share_id"] && ![dicUser[@"user_share_id"] isEqual:[NSNull null]]) {
        objUser.user_share_id = [NSNumber numberWithInt:[dicUser[@"user_share_id"] intValue]];
    }
    
    if(dicUser[@"user_share_status"] && ![dicUser[@"user_share_status"] isEqual:[NSNull null]]) {
        objUser.user_share_status = [dicUser[@"user_share_status"] intValue];
    }
    
    objUser.user_is_contact = [self is_contact_user:objUser];
    
    return objUser;
}

- (BOOL)is_contact_user:(UserObj *)objUser {
    BOOL is_contact_user = NO;
    
    for(int nI = 0; nI < [GlobalService sharedInstance].user_contacts.count; nI++) {
        ContactUserObj *objContact = [GlobalService sharedInstance].user_contacts[nI];
        
        if([objContact.contact_emails containsObject:objUser.user_email]) {
            is_contact_user = YES;
            break;
        }
        
        if(objUser.user_phone.length > 0 && [objContact.contact_phones containsObject:objUser.user_phone]) {
            is_contact_user = YES;
            break;
        }
    }
    
    return is_contact_user;
}

@end
