//
//  ContactUserObj.h
//  TagN
//
//  Created by JH Lee on 2/23/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUserObj : NSObject

@property (nonatomic, retain) UIImage               *contact_avatar;
@property (nonatomic, retain) NSString              *contact_name;
@property (nonatomic, retain) NSArray               *contact_emails;
@property (nonatomic, retain) NSArray               *contact_phones;
@property (nonatomic, readwrite) TAG_USER_STATUS    contact_status;

- (id)initWithAvatar:(UIImage *)contact_avatar
                Name:(NSString *)contact_name
              Emails:(NSArray *)contact_emails
              Phones:(NSArray *)contact_phones;

@end
