//
//  TagNDetailHeaderView.m
//  TagN
//
//  Created by JH Lee on 2/13/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNDetailHeaderView.h"

@implementation TagNDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setViewWithImageObj:(ImageObj *)objImage {
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objImage.image_user_avatar_url)]];
    
    self.m_lblName.text = objImage.image_user_name;
    self.m_lblTime.text = [objImage.image_created_at stringWithTimeDifference];
}

@end
