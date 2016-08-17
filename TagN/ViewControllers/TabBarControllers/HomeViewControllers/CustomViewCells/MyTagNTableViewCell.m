//
//  MyTagNTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "MyTagNTableViewCell.h"

@implementation MyTagNTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithImageInfoObj:(ImageInfoObj *)objImageInfo onSection:(NSInteger)nSection {
    NSArray *aryTagImages = @[];
    NSInteger nImageCount = objImageInfo.imageinfo_images.count > 4 ? 4 : objImageInfo.imageinfo_images.count;
    for(int nIndex = 0; nIndex < nImageCount; nIndex++) {
        
        ImageObj *objImage = objImageInfo.imageinfo_images[nIndex];
        if(!objImage.image_thumb_photo) {
            aryTagImages = [[CoreDataService sharedInstance] loadImagesWithTagId:objImageInfo.imageinfo_tag.tag_id];
            break;
        }
    }
    
    for(int nIndex = 0; nIndex < nImageCount; nIndex++) {
        
        ImageObj *objImage = objImageInfo.imageinfo_images[nIndex];
        UIImage *image = nil;
        if(objImage.image_thumb_photo) {
            image = objImage.image_thumb_photo;
        } else {
            image = [self imageWithThumbUrl:objImage.image_thumb_url From:aryTagImages];
            objImage.image_thumb_photo = image;
        }
        
        if(image) {
            switch (nIndex) {
                case 0:
                    self.m_imgFirstPhoto.image = image;
                    if(objImage.image_is_uploaded.boolValue == NO) {   //is_not_uploaded
                        self.m_imgFirstStatus.alpha = 0.7f;
                    } else {
                        self.m_imgFirstStatus.alpha = 0.f;
                    }
                    break;
                
                case 1:
                    self.m_imgSecondPhoto.image = image;
                    if(objImage.image_is_uploaded.boolValue == NO) {   //is_not_uploaded
                        self.m_imgSecondStatus.alpha = 0.7f;
                    } else {
                        [UIView animateWithDuration:0.3f animations:^{
                            self.m_imgSecondStatus.alpha = 0.f;
                        }];
                    }
                    break;
                    
                case 2:
                    self.m_imgThirdPhoto.image = image;
                    if(objImage.image_is_uploaded.boolValue == NO) {   //is_not_uploaded
                        self.m_imgThirdStatus.alpha = 0.7f;
                    } else {
                        [UIView animateWithDuration:0.3f animations:^{
                            self.m_imgThirdStatus.alpha = 0.f;
                        }];
                    }
                    break;
                    
                case 3:
                    self.m_imgForthPhoto.image = image;
                    if(objImage.image_is_uploaded.boolValue == NO) {   //is_not_uploaded
                        self.m_imgForthStatus.alpha = 0.7f;
                    } else {
                        [UIView animateWithDuration:0.3f animations:^{
                            self.m_imgForthStatus.alpha = 0.f;
                        }];
                    }
                    break;
                    
                default:
                    break;
            }
        } else {
            switch (nIndex) {
                case 0:
                    [self.m_imgFirstPhoto setImageThumbWithObj:objImage
                                               withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                    break;
                    
                case 1:
                    [self.m_imgSecondPhoto setImageThumbWithObj:objImage
                                                withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                    break;
                    
                case 2:
                    [self.m_imgThirdPhoto setImageThumbWithObj:objImage
                                               withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                    break;
                    
                case 3:
                    [self.m_imgForthPhoto setImageThumbWithObj:objImage
                                               withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (UIImage *)imageWithThumbUrl:(NSString *)image_thumb_url
                          From:(NSArray *)aryImages {
    UIImage *image = nil;
    
    for(int nIndex = 0; nIndex < aryImages.count; nIndex++) {
        CoreDataImage *objCoreDataImage = aryImages[nIndex];
        
        if([objCoreDataImage.image_thumb_url isEqualToString:image_thumb_url]) {
            image = [UIImage imageWithData:objCoreDataImage.image_thumb_data];
            break;
        }
    }
    
    return image;
}

@end
