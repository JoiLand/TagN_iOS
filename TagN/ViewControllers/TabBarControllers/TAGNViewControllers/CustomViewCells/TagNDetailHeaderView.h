//
//  TagNDetailHeaderView.h
//  TagN
//
//  Created by JH Lee on 2/13/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagNDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

- (void)setViewWithImageObj:(ImageObj *)objImage;

@end
