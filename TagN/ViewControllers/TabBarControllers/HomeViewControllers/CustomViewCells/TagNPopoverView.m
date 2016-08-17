//
//  TagNPopoverView.m
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNPopoverView.h"

@implementation TagNPopoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setViewsWithImageInfoObj:(ImageInfoObj *)objImageInfo onSection:(NSInteger)nSection {
    self.m_nSection = nSection;
    
    //initialize dropdown menu
    TagObj *objTag = objImageInfo.imageinfo_tag;
    if(objTag.tag_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {
        self.m_btnDropDownDeleteTag.alpha = 1.0f;
        self.m_btnDropDownDeleteTag.userInteractionEnabled = YES;
    } else {
        self.m_btnDropDownDeleteTag.alpha = 0.3f;
        self.m_btnDropDownDeleteTag.userInteractionEnabled = NO;
    }
}

- (IBAction)onClickBtnDeleteTag:(id)sender {
    [self.delegate onClickBtnDeleteTagWithSection:self.m_nSection];
}

- (IBAction)onClickBtnAddPicture:(id)sender {
    [self.delegate onClickBtnAddPictureWithSection:self.m_nSection];
}

- (IBAction)onClickBtnDeletePictures:(id)sender {
    [self.delegate onClickBtnDeleteImagesWithSection:self.m_nSection];
}

- (IBAction)onClickBtnMembers:(id)sender {
    [self.delegate onClickBtnMembersWithSection:self.m_nSection];
}

- (IBAction)onClickBtnTagNStory:(id)sender {
    [self.delegate onClickBtnTagNStoryWithSection:self.m_nSection];
}

@end
