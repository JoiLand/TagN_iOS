//
//  LikerTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "LikerTableViewCell.h"

@implementation LikerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithImageLikerObj:(ImageLikerObj *)objImageLiker {
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objImageLiker.like_user_avatar_url)]];
    
    self.m_lblName.text = objImageLiker.like_user_name;
    self.m_lblUserName.text = objImageLiker.like_user_username;
    self.m_lblTime.text = [objImageLiker.like_created_at stringWithTimeDifference];
}

@end
