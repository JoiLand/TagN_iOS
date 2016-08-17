//
//  ContactUserObj.m
//  TagN
//
//  Created by JH Lee on 2/23/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ContactUserObj.h"

@implementation ContactUserObj

- (id)initWithAvatar:(UIImage *)contact_avatar
                Name:(NSString *)contact_name
              Emails:(NSArray *)contact_emails
              Phones:(NSArray *)contact_phones {
    
    self = [super init];
    if(self) {
        self.contact_avatar = contact_avatar;
        self.contact_name = contact_name;
        self.contact_emails = [contact_emails copy];
        self.contact_phones = [contact_phones copy];
        self.contact_status = TAG_USER_STATUS_UNKNOWN;
    }
    
    return self;
}

@end
