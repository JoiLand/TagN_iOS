//
//  CommentTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithCommentObj:(CommentObj *)objComment {
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objComment.comment_user_avatar_url)]];
    
    self.m_lblUserName.text = objComment.comment_user_name;
    self.m_lblTime.text = [objComment.comment_created_at stringWithTimeDifference];
}

@end
