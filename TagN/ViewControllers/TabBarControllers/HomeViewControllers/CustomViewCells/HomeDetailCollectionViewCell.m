//
//  HomeDetailCollectionViewCell.m
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "HomeDetailCollectionViewCell.h"

@implementation HomeDetailCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setViewsWithImageObj:(ImageObj *)objImage {
    [self.m_imgPhoto setImageThumbWithObj:objImage
                          withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    
    if(objImage.image_is_uploaded.boolValue == NO) {
        self.m_imgUploadingStatus.alpha = 0.7f;
    } else {
        self.m_imgUploadingStatus.alpha = 0.f;
    }
}

@end
