//
//  ImageInfoObj.h
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObj.h"
#import "TagObj.h"

@interface ImageInfoObj : NSObject

@property (nonatomic, retain) TagObj            *imageinfo_tag;
@property (nonatomic, retain) NSMutableArray    *imageinfo_images;

- (ImageInfoObj *)initWithTag:(TagObj *)imageinfo_tag
                       Images:(NSArray *)imageinfo_images;

- (ImageInfoObj *)initWithDictionary:(NSDictionary *)dicImageInfoObj;
- (NSDictionary *)currentDictionary;

@end
