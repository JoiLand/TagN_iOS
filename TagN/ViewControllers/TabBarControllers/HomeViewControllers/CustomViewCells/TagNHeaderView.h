//
//  TagNHeaderView.h
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagNHeaderViewDelegate <NSObject>

- (void)onClickBtnDropDown:(UIView *)sender onSection:(NSInteger)nSection;

@end

@interface TagNHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel    *m_lblTagFullText;
@property (weak, nonatomic) IBOutlet UIButton *m_btnShowDropDown;

@property (nonatomic, readwrite) NSInteger      m_nSection;
@property (nonatomic, retain) id<TagNHeaderViewDelegate> delegate;

- (IBAction)onClickBtnDropDown:(id)sender;

@end
