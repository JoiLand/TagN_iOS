//
//  TagNTextField.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNTextField.h"

@implementation TagNTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIView *paddingView                         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.leftView                               = paddingView;
    self.leftViewMode                           = UITextFieldViewModeAlways;
    
    self.layer.masksToBounds                    = YES;
    self.layer.cornerRadius                     = 5.f;
    self.layer.borderWidth                      = 2.f;
    self.layer.borderColor                      = [UIColor whiteColor].CGColor;
    
    self.attributedPlaceholder                  = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                                  attributes:@{NSForegroundColorAttributeName:TAGN_PANTONE_423_COLOR}];

}

@end
