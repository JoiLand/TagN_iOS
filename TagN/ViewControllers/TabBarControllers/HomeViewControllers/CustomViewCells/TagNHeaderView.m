//
//  TagNHeaderView.m
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNHeaderView.h"

@implementation TagNHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickBtnDropDown:(id)sender {
    [self.delegate onClickBtnDropDown:self onSection:self.m_nSection];
}

@end
