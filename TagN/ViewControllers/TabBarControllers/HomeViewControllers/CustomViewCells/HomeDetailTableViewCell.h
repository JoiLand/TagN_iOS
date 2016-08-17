//
//  HomeDetailTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgSelected;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgUploadingStatus;

- (void)setViewsWithImageObj:(ImageObj *)objImage;

@end
