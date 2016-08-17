//
//  TagNPhotoView.h
//  TagN
//
//  Created by JH Lee on 2/22/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagNPhotoView : UIScrollView

- (void)initViews:(CGRect)frame;
- (void)setImageWithImageObj:(ImageObj *)objImage;

@end
