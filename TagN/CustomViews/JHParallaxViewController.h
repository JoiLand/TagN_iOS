//
//  JHParallaxViewController.h
//  ParallaxTest
//
//  Created by JH Lee on 2/19/16.
//  Copyright © 2016 DMSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHParallaxViewController : UIViewController<UIScrollViewDelegate> {
    NSLayoutConstraint  *headerViewHeightConstraint;
    BOOL                headerBeganCollapsed;
    CGFloat             collapsedHeaderViewHeight;
    CGFloat             expandedHeaderViewHeight;
    CGFloat             headerExpandDelay;
    CGFloat             tableViewScrollOffsetBeginDraggingY;
}

@property (nonatomic, retain) IBOutlet  UIView              *m_viewHeader;
@property (nonatomic, retain) IBOutlet  UIScrollView        *m_viewScroll;

@end
