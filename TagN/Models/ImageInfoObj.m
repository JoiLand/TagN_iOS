//
//  ImageInfoObj.m
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageInfoObj.h"

@implementation ImageInfoObj

- (id)init{
    self = [super init];
    if(self) {
        self.imageinfo_tag = [[TagObj alloc] init];
        self.imageinfo_images = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (ImageInfoObj *)initWithTag:(TagObj *)imageinfo_tag
                       Images:(NSArray *)imageinfo_images {
    ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] init];
    
    objImageInfo.imageinfo_tag = imageinfo_tag;
    objImageInfo.imageinfo_images = [[NSMutableArray alloc] initWithArray:imageinfo_images];
    
    return objImageInfo;
}

- (ImageInfoObj *)initWithDictionary:(NSDictionary *)dicImageInfoObj {
    ImageInfoObj *objImageInfo = [[ImageInfoObj alloc] init];
    
    if(dicImageInfoObj[@"imageinfo_tag"] && ![dicImageInfoObj[@"imageinfo_tag"] isEqual:[NSNull null]]) {
        objImageInfo.imageinfo_tag = [[TagObj alloc] initWithDictionary:dicImageInfoObj[@"imageinfo_tag"]];
    }
    
    if(dicImageInfoObj[@"imageinfo_images"] && ![dicImageInfoObj[@"imageinfo_images"] isEqual:[NSNull null]]) {
        NSMutableArray *aryImageInfoImages = [[NSMutableArray alloc] init];
        for(NSDictionary *dicImageInfoImage in dicImageInfoObj[@"imageinfo_images"]) {
            [aryImageInfoImages addObject:[[ImageObj alloc] initWithDictionary:dicImageInfoImage]];
        }
        
        objImageInfo.imageinfo_images = aryImageInfoImages;
    }
    return objImageInfo;
}

- (NSDictionary *)currentDictionary {
    NSMutableArray *aryDicImages = [[NSMutableArray alloc] init];
    for(ImageObj *objImage in self.imageinfo_images) {
        [aryDicImages addObject:objImage.currentDictionary];
    }
    
    return @{
             @"imageinfo_tag":    self.imageinfo_tag.currentDictionary,
             @"imageinfo_images": aryDicImages
             };
}

@end
