//
//  CommentTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;
@property (weak, nonatomic) IBOutlet UILabel *m_lblComment;

- (void)setViewsWithCommentObj:(CommentObj *)objComment;

@end
