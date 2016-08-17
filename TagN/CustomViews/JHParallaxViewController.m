//
//  JHParallaxViewController.m
//  ParallaxTest
//
//  Created by JH Lee on 2/19/16.
//  Copyright © 2016 DMSoft. All rights reserved.
//

#import "JHParallaxViewController.h"

@interface JHParallaxViewController ()

@end

@implementation JHParallaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_viewScroll.delegate = self;

    //get header view's height constraint
    headerViewHeightConstraint = [[NSLayoutConstraint alloc] init];
    for(NSLayoutConstraint *constraint in self.m_viewHeader.constraints) {
        if(constraint.firstItem == self.m_viewHeader
           && constraint.firstAttribute == NSLayoutAttributeHeight) {
            headerViewHeightConstraint = constraint;
        }
    }
    
    expandedHeaderViewHeight = headerViewHeightConstraint.constant == 0.f ? 65.f : headerViewHeightConstraint.constant;
    headerBeganCollapsed = NO;
    collapsedHeaderViewHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    headerExpandDelay = 100.f;
    tableViewScrollOffsetBeginDraggingY = 0.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) animateHeaderViewHeight {
    
    CGFloat headerViewHeightDestinationConstant = 0.f;
    
    if(headerViewHeightConstraint.constant < ((expandedHeaderViewHeight - collapsedHeaderViewHeight) / 2.0 + collapsedHeaderViewHeight)) {
        headerViewHeightDestinationConstant = collapsedHeaderViewHeight;
    } else {
        headerViewHeightDestinationConstant = expandedHeaderViewHeight;
    }
    
    if(headerViewHeightConstraint.constant != expandedHeaderViewHeight && headerViewHeightConstraint.constant != collapsedHeaderViewHeight) {
        CGFloat animationDuration = 0.5f;
        [UIView animateWithDuration:animationDuration animations:^{
            headerViewHeightConstraint.constant = headerViewHeightDestinationConstant;
            CGFloat progress = (headerViewHeightConstraint.constant - collapsedHeaderViewHeight) / (expandedHeaderViewHeight - collapsedHeaderViewHeight);
            [self expandToProgress:progress];
        }];
    }
}

- (void)expandToProgress:(CGFloat)progress {
    self.m_viewHeader.alpha = progress;
    for(UIView *view in self.m_viewHeader.subviews) {
        view.transform = CGAffineTransformMakeScale(progress, progress);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Clamp the beginning point to 0 and the max content offset to prevent unintentional resizing when dragging during rubber banding
    tableViewScrollOffsetBeginDraggingY = MIN(MAX(scrollView.contentOffset.y, 0), scrollView.contentSize.height - scrollView.frame.size.height);
    
    // Keep track of whether or not the header was collapsed to determine if we can add the delay of expansion
    headerBeganCollapsed = (headerViewHeightConstraint.constant == collapsedHeaderViewHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Do nothing if the table view is not scrollable
    if(self.m_viewScroll.contentSize.height <= CGRectGetHeight(self.m_viewScroll.bounds)) {
        return;
    }
    
    CGFloat contentOffsetY = self.m_viewScroll.contentOffset.y - tableViewScrollOffsetBeginDraggingY;
    // Add a delay to expanding the header only if the user began scrolling below the allotted amount of space to actually expand the header with no delay (e.g. If it takes 30 pixels to scroll up the scrollview to expand the header then don't add the delay of the user started scrolling at 10 pixels)
    if((tableViewScrollOffsetBeginDraggingY > ((expandedHeaderViewHeight - collapsedHeaderViewHeight) + headerExpandDelay))
       && (contentOffsetY < 0)
       && headerBeganCollapsed) {
        contentOffsetY = contentOffsetY + headerExpandDelay;
    }
    
    CGFloat changeInHeaderViewHeight = headerViewHeightConstraint.constant - MIN(MAX(headerViewHeightConstraint.constant - contentOffsetY, collapsedHeaderViewHeight), expandedHeaderViewHeight);
    headerViewHeightConstraint.constant = MIN(MAX(headerViewHeightConstraint.constant - contentOffsetY, collapsedHeaderViewHeight), expandedHeaderViewHeight);
    
    CGFloat progress = (headerViewHeightConstraint.constant - collapsedHeaderViewHeight) / (expandedHeaderViewHeight - collapsedHeaderViewHeight);
    [self expandToProgress:progress];
    
    // When the header view height is changing, freeze the content in the table view
    if((headerViewHeightConstraint.constant != collapsedHeaderViewHeight)
       && (headerViewHeightConstraint.constant != expandedHeaderViewHeight)) {
        self.m_viewScroll.contentOffset = CGPointMake(0, self.m_viewScroll.contentOffset.y - changeInHeaderViewHeight);
    }
}

// Animate the header view when the user ends dragging or flicks the scroll view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self animateHeaderViewHeight];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animateHeaderViewHeight];
}

@end
