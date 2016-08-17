//
//  HomeDetailCollectionViewCell.h
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgUploadingStatus;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgSelected;

- (void)setViewsWithImageObj:(ImageObj *)objImage;

@end
