//
//  TagObj.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagObj : NSObject

@property (nonatomic, retain) NSNumber      *tag_id;
@property (nonatomic, retain) NSNumber      *tag_user_id;
@property (nonatomic, retain) NSString      *tag_text;

- (TagObj *)initWithDictionary:(NSDictionary *)dicTag;
- (TagObj *)initWithId:(NSNumber *)tag_id
                UserId:(NSNumber *)user_id
                  Text:(NSString *)tag_text;

- (NSDictionary *)currentDictionary;

@end
