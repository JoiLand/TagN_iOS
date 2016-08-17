//
//  TagNDetailTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/13/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNDetailTableViewCell.h"

@implementation TagNDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickBtnLike:(id)sender {
    self.m_btnLike.selected = !self.m_btnLike.selected;
    
    [self.delegate onClickBtnLikeSelected:self.m_btnLike.selected onSection:m_nSection];
}

- (IBAction)onClickBtnComment:(id)sender {
    [self.delegate onClickBtnComment:m_nSection];
}

- (IBAction)onClickBtnDownload:(id)sender {
    [self.delegate onClickBtnDownload:m_nSection];
}

- (IBAction)onClickBtnLikes:(id)sender {
    [self.delegate onClickBtnLikes:m_nSection];
}

- (void)setViewsWithImageObj:(ImageObj *)objImage onSection:(NSInteger)section {
    m_nSection = section;
    
    [self.m_imgPhoto setImageWithObj:objImage
                     withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    
    if(objImage.image_is_uploaded.boolValue == NO) {
        self.m_imgUploadingStatus.alpha = 0.7f;
    } else {
        self.m_imgUploadingStatus.alpha = 0.f;
    }
    
    self.m_btnLike.selected = objImage.image_is_like.boolValue;
    [self.m_btnLikes setTitle:[NSString stringWithFormat:@"♥︎ %d likes", objImage.image_likes.intValue]
                     forState:UIControlStateNormal];
}

@end
