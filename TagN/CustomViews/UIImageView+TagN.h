//
//  UIImageView+TagN.h
//  TagN
//
//  Created by JH Lee on 1/15/16.
//  Copyright © 2016 DMSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObj.h"

@interface UIImageView(TagN)

- (void)setImageWithObj:(ImageObj *)objImage withPlaceholder:(NSString *)imgPlaceholder;
- (void)setImageThumbWithObj:(ImageObj *)objImage withPlaceholder:(NSString *)imgPlaceholder;

@end
