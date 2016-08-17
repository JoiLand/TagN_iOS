//
//  TransitionService.m
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TransitionService.h"

@implementation TransitionService

static TransitionService *_transitionService = nil;

+ (TransitionService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_transitionService == nil) {
            _transitionService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _transitionService;
}

- (id)init {
    self = [super init];
    if(self) {
        self.duration = 1.f;
        self.type = CROSSFADE_ANIMATION;
    }
    
    return self;
}

- (void)transitionFromView:(UIView *)fromView
                    ToView:(UIView *)toView
                 Completed:(void (^)(BOOL))completed {
    
    if(self.type == FLIP_ANIMATION) {
        [self flipTransitionForDuration:self.duration
                               FromView:fromView
                                 ToView:toView
                               Complete:completed];
    } else if(self.type == FOLD_ANIMATION) {
        [self foldTransitionForDuration:self.duration
                               FromView:fromView
                                 ToView:toView
                               Complete:completed];
    } else if(self.type == CROSSFADE_ANIMATION) {
        [self crossfadeTransitionForDuration:self.duration
                                    FromView:fromView
                                      ToView:toView
                                    Complete:completed];
    } else if(self.type == EXPLODE_ANIMATION) {
        [self explodeTransitionForDuration:self.duration
                                  FromView:fromView
                                    ToView:toView
                                  Complete:completed];
    } else if(self.type == TURN_ANIMATION) {
        [self turnTransitionForDuration:self.duration
                               FromView:fromView
                                 ToView:toView
                               Complete:completed];
    } else if(self.type == PORTAL_ANIMATION) {
        [self portalTransitionForDuration:self.duration
                                 FromView:fromView
                                   ToView:toView
                                 Complete:completed];
    } else {
        [self panTransitionForDuration:self.duration
                              FromView:fromView
                                ToView:toView
                              Complete:completed];
        
    }
}

#pragma mark - FlipTransition

- (void)flipTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed {
    
    NSMutableArray *snapshots = [NSMutableArray new];
        
    // create two-part snapshots of both the from- and to- views
    NSArray* toViewSnapshots = [self createSnapshotsForFlip:toView afterScreenUpdates:YES];
    UIView* flippedSectionOfToView = toViewSnapshots[0];
    [snapshots addObjectsFromArray:toViewSnapshots];
    
    NSArray* fromViewSnapshots = [self createSnapshotsForFlip:fromView afterScreenUpdates:NO];
    UIView* flippedSectionOfFromView = fromViewSnapshots[1];
    [snapshots addObjectsFromArray:fromViewSnapshots];
    
    // replace the from- and to- views with container views that include gradients
    flippedSectionOfFromView = [self addShadowToViewForFlip:flippedSectionOfFromView reverse:NO];
    UIView* flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1];
    flippedSectionOfFromViewShadow.alpha = 0.0;
    [snapshots addObject:flippedSectionOfFromView];
    
    flippedSectionOfToView = [self addShadowToViewForFlip:flippedSectionOfToView reverse:YES];
    UIView* flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1];
    flippedSectionOfToViewShadow.alpha = 1.0;
    [snapshots addObject:flippedSectionOfToView];
    
    // change the anchor point so that the view rotate around the correct edge
    [self updateAnchorPointAndOffsetForFlip:CGPointMake(0.0, 0.5) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffsetForFlip:CGPointMake(1.0, 0.5) view:flippedSectionOfToView];
    
    // rotate the to- view by 90 degrees, hiding it
    flippedSectionOfToView.layer.transform = [self rotate: M_PI_2];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:duration / 2.f
                                                                animations:^{
                                                                    // rotate the from- view to 90 degrees
                                                                    flippedSectionOfFromView.layer.transform = [self rotate: -M_PI_2];
                                                                    flippedSectionOfFromViewShadow.alpha = 1.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:duration / 2.f
                                                          relativeDuration:duration / 2.f
                                                                animations:^{
                                                                    // rotate the to- view to 0 degrees
                                                                    flippedSectionOfToView.layer.transform = [self rotate: 0.001];
                                                                    flippedSectionOfToViewShadow.alpha = 0.0;
                                                                }];
                              } completion:^(BOOL finished) {
                                  // remove the snapshot views

                                  for(UIView *view in snapshots) {
                                      [view removeFromSuperview];
                                  }

                                  fromView.hidden = YES;

                                  // inform the context of completion
                                  completed(finished);
                              }];
}


// adds a gradient to an image by creating a containing UIView with both the given view
// and the gradient as subviews
- (UIView*)addShadowToViewForFlip:(UIView*)view reverse:(BOOL)reverse {
    
    UIView* containerView = view.superview;
    
    // create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // replace the view that we are adding a shadow to
    [containerView insertSubview:viewWithShadow aboveSubview:view];
    [view removeFromSuperview];
    
    // create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

// creates a pair of snapshots from the given view
- (NSArray*)createSnapshotsForFlip:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    
    // snapshot the left-hand side of the view
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the view
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    return @[leftHandView, rightHandView];
}

// updates the anchor point for the given view, offseting the frame to compensate for the resulting movement
- (void)updateAnchorPointAndOffsetForFlip:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.x - 0.5;
    view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0);
}


- (CATransform3D)rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

#pragma mark - FoldTransition

- (void)foldTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed {
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
    
    CGSize size = toView.frame.size;
    
    float foldWidth = size.width * 0.5 / 2.f;
    
    // arrays that hold the snapshot views
    NSMutableArray* fromViewFolds = [NSMutableArray new];
    NSMutableArray* toViewFolds = [NSMutableArray new];
    
    // create the folds for the form- and to- views
    for (int i = 0 ; i < 2; i++){
        float offset = (float)i * foldWidth * 2;
        
        // the left and right side of the fold for the to- view, with a 90-degree transform and 1.0 alpha
        // on the shadow, with each view positioned at the very edge of the screen
        UIView *leftToViewFold = [self createSnapshotFromViewForFold:toView afterUpdates:YES location:offset left:YES];
        leftToViewFold.layer.position = CGPointMake(size.width, size.height / 2);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
        [leftToViewFold.subviews[1] setAlpha:1.0];
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromViewForFold:toView afterUpdates:YES location:offset + foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(size.width, size.height / 2);
        rightToViewFold.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        [rightToViewFold.subviews[1] setAlpha:1.0];
        [toViewFolds addObject:rightToViewFold];
        
        // the left and right side of the fold for the from- view, with identity transform and 0.0 alpha
        // on the shadow, with each view at its initial position
        UIView *leftFromViewFold = [self createSnapshotFromViewForFold:fromView afterUpdates:NO location:offset left:YES];
        leftFromViewFold.layer.position = CGPointMake(offset, size.height/2);
        [fromViewFolds addObject:leftFromViewFold];
        [leftFromViewFold.subviews[1] setAlpha:0.0];
        
        UIView *rightFromViewFold = [self createSnapshotFromViewForFold:fromView afterUpdates:NO location:offset + foldWidth left:NO];
        rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
        [fromViewFolds addObject:rightFromViewFold];
        [rightFromViewFold.subviews[1] setAlpha:0.0];
    }
    
    // move the from- view off screen
    toView.hidden = YES;
    fromView.hidden = YES;
    
    // create the animation
    [UIView animateWithDuration:duration animations:^{
        // set the final state for each fold
        for (int i = 0; i < 2; i++){
            
            float offset = (float)i * foldWidth * 2;
            
            // the left and right side of the fold for the from- view, with 90 degree transform and 1.0 alpha
            // on the shadow, with each view positioned at the edge of thw screen.
            UIView* leftFromView = fromViewFolds[i * 2];
            leftFromView.layer.position = CGPointMake(0.0, size.height / 2);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView* rightFromView = fromViewFolds[i * 2 + 1];
            rightFromView.layer.position = CGPointMake(0.0, size.height / 2);
            rightFromView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 1.0, 0);
            [rightFromView.subviews[1] setAlpha:1.0];
            
            // the left and right side of the fold for the to- view, with identity transform and 0.0 alpha
            // on the shadow, with each view at its final position
            UIView* leftToView = toViewFolds[i * 2];
            leftToView.layer.position = CGPointMake(offset, size.height / 2);
            leftToView.layer.transform = CATransform3DIdentity;
            [leftToView.subviews[1] setAlpha:0.0];
            
            UIView* rightToView = toViewFolds[i * 2 + 1];
            rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height / 2);
            rightToView.layer.transform = CATransform3DIdentity;
            [rightToView.subviews[1] setAlpha:0.0];
        }
    }  completion:^(BOOL finished) {
        // remove the snapshot views
        for (UIView *view in toViewFolds) {
            [view removeFromSuperview];
        }
        for (UIView *view in fromViewFolds) {
            [view removeFromSuperview];
        }
        
        toView.hidden = NO;
        fromView.hidden = YES;
        
        completed(finished);
    }];
}

// creates a snapshot for the gives view
-(UIView*) createSnapshotFromViewForFold:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left {
    
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / 2 ;
    
    UIView* snapshotView;
    
    if (!afterUpdates) {
        // create a regular snapshot
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        
    } else {
        // for the to- view for some reason the snapshot takes a while to create. Here we place the snapshot within
        // another view, with the same bckground color, so that it is less noticeable when the snapshot initially renders
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
        
    }
    
    // create a shadow
    UIView* snapshotWithShadowView = [self addShadowToViewForFold:snapshotView reverse:left];
    
    // add to the container
    [containerView addSubview:snapshotWithShadowView];
    
    // set the anchor to the left or right edge of the view
    snapshotWithShadowView.layer.anchorPoint = CGPointMake( left ? 0.0 : 1.0, 0.5);
    
    return snapshotWithShadowView;
}


// adds a gradient to an image by creating a containing UIView with both the given view
// and the gradient as subviews
- (UIView*)addShadowToViewForFold:(UIView*)view reverse:(BOOL)reverse {
    
    // create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

#pragma mark - CrossFadeTransition

- (void)crossfadeTransitionForDuration:(NSInteger)duration
                              FromView:(UIView *)fromView
                                ToView:(UIView *)toView
                              Complete:(void (^)(BOOL))completed {
    // animate
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
    } completion:^(BOOL finished) {
        fromView.alpha = 1.0;
        fromView.hidden = YES;
        
        completed(finished);
    }];
}

#pragma mark - ExplodeTransition

- (void)explodeTransitionForDuration:(NSInteger)duration
                            FromView:(UIView *)fromView
                              ToView:(UIView *)toView
                            Complete:(void (^)(BOOL))completed {
    
    UIView *containerView = fromView.superview;
    
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 10.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    // snapshot the from view, this makes subsequent snaphots more performant
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
    
    // create a snapshot for each of the exploding pieces
    for (CGFloat x=0; x < size.width; x+= size.width / xFactor) {
        for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
        }
    }
    
    fromView.hidden = YES;
    
    // animate
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in snapshots) {
            CGFloat xOffset = [self randomFloatBetween:-100.0 and:100.0];
            CGFloat yOffset = [self randomFloatBetween:-100.0 and:100.0];
            view.frame = CGRectOffset(view.frame, xOffset, yOffset);
            view.alpha = 0.0;
            view.transform = CGAffineTransformScale(CGAffineTransformMakeRotation([self randomFloatBetween:-10.0 and:10.0]), 0.01, 0.01);
        }
    } completion:^(BOOL finished) {
        for (UIView *view in snapshots) {
            [view removeFromSuperview];
        }
        
        completed(finished);
    }];
    
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

#pragma mark - TurnTransition

- (void)turnTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed {
    
    // flip the to VC halfway round - hiding it
    toView.layer.transform = [self rotate: -M_PI_2];
    
    // animate
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:duration / 2.f
                                                                animations:^{
                                                                    // rotate the from view
                                                                    fromView.layer.transform = [self rotate:M_PI_2];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:duration / 2.f
                                                          relativeDuration:duration / 2.f
                                                                animations:^{
                                                                    // rotate the to view
                                                                    toView.layer.transform =  [self rotate:0.0];
                                                                }];
                              } completion:^(BOOL finished) {
                                  completed(finished);
                                  fromView.layer.transform = [self rotate:0.0];
                                  fromView.hidden = YES;
                              }];
    
}

#pragma mark - PortalTransition

#define ZOOM_SCALE 0.8

- (void)portalTransitionForDuration:(NSInteger)duration
                           FromView:(UIView *)fromView
                             ToView:(UIView *)toView
                           Complete:(void (^)(BOOL))completed {
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    UIView *containerView = fromView.superview;
    
    // Create two-part snapshots of the to- view
    
    // snapshot the left-hand side of the to- view
    CGRect leftSnapshotRegion = CGRectMake(0, 0, toView.frame.size.width / 2, toView.frame.size.height);
    UIView *leftHandView = [toView resizableSnapshotViewFromRect:leftSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = leftSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    leftHandView.frame = CGRectOffset(leftHandView.frame, - leftHandView.frame.size.width, 0);
    [containerView addSubview:leftHandView];
    [snapshots addObject:leftHandView];
    
    // snapshot the right-hand side of the to- view
    CGRect rightSnapshotRegion = CGRectMake(toView.frame.size.width / 2, 0, toView.frame.size.width / 2, toView.frame.size.height);
    UIView *rightHandView = [toView resizableSnapshotViewFromRect:rightSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = rightSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0);
    [containerView addSubview:rightHandView];
    [snapshots addObject:rightHandView];
    
    toView.hidden = YES;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Close the portal doors of the to-view
                         leftHandView.frame = CGRectOffset(leftHandView.frame, leftHandView.frame.size.width, 0);
                         rightHandView.frame = CGRectOffset(rightHandView.frame, - rightHandView.frame.size.width, 0);
                         
                         // Zoom out the from-view
                         CATransform3D scale = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);
                     } completion:^(BOOL finished) {
                         for (UIView *view in snapshots) {
                             [view removeFromSuperview];
                         }
                         
                         // Zoom out the from-view
                         CATransform3D scale = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DScale(scale, 1, 1, 1);
                         
                         fromView.hidden = YES;
                         toView.hidden = NO;
                         
                         completed(finished);
                     }];
    
}

#pragma mark - PanTransition

- (void)panTransitionForDuration:(NSInteger)duration
                        FromView:(UIView *)fromView
                          ToView:(UIView *)toView
                        Complete:(void (^)(BOOL))completed {
    
    CGSize size = fromView.frame.size;
    
    // Add the toView to the container
    toView.frame = CGRectMake(size.width, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    // animate
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(-size.width, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        
        fromView.hidden = YES;
        
        completed(finished);
    }];
}
@end
