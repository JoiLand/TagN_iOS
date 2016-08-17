//
//  HomeDetailTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "HomeDetailTableViewCell.h"

@implementation HomeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithImageObj:(ImageObj *)objImage {
    [self.m_imgPhoto setImageWithObj:objImage
                     withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    
    if(objImage.image_is_uploaded.boolValue == NO) {
        self.m_imgUploadingStatus.alpha = 0.7f;
    } else {
        self.m_imgUploadingStatus.alpha = 0.f;
    }
}

@end
