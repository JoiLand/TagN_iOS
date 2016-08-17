//
//  TagNImageView.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNImageView.h"

@implementation TagNImageView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.layer.masksToBounds            = YES;
    self.layer.cornerRadius             = self.frame.size.height / 2;
    self.layer.borderWidth              = 2.f;
    self.layer.borderColor              = [UIColor whiteColor].CGColor;
    
    self.userInteractionEnabled         = YES;
}

@end
