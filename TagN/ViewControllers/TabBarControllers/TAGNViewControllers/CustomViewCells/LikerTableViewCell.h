//
//  LikerTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

- (void)setViewsWithImageLikerObj:(ImageLikerObj *)objImageLiker;

@end
