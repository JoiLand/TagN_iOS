//
//  SearchYearTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SearchYearTableViewCell.h"

@implementation SearchYearTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagesWithImageArray:(NSArray *)aryImages {
    NSInteger nImageCount = aryImages.count > 6 ? 6 : aryImages.count;
    
    for(int nIndex = 0; nIndex < nImageCount; nIndex++) {
        switch (nIndex) {
            case 0:
                [self.m_imgPhoto1 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
                
            case 1:
                [self.m_imgPhoto2 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
                
            case 2:
                [self.m_imgPhoto3 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
            
            case 3:
                [self.m_imgPhoto4 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
                
            case 4:
                [self.m_imgPhoto5 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
                
            case 5:
                [self.m_imgPhoto6 setImageThumbWithObj:aryImages[nIndex]
                                       withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
                break;
                
            default:
                break;
        }
    }
}

@end
