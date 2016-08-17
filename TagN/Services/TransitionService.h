//
//  TransitionService.h
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CROSSFADE_ANIMATION = 0,
    TURN_ANIMATION,
    PAN_ANIMATION,
    FLIP_ANIMATION,
    FOLD_ANIMATION,
    EXPLODE_ANIMATION,
    PORTAL_ANIMATION
}ANIMATION_TYPE;

@interface TransitionService : NSObject

@property (nonatomic, readwrite) CGFloat            duration;
@property (nonatomic, readwrite) ANIMATION_TYPE     type;

+ (TransitionService *) sharedInstance;

- (void)transitionFromView:(UIView *)fromView
                    ToView:(UIView *)toView
                 Completed:(void (^)(BOOL))completed;

- (void)flipTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed;

- (void)foldTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed;

- (void)crossfadeTransitionForDuration:(NSInteger)duration
                              FromView:(UIView *)fromView
                                ToView:(UIView *)toView
                              Complete:(void (^)(BOOL))completed;

- (void)explodeTransitionForDuration:(NSInteger)duration
                            FromView:(UIView *)fromView
                              ToView:(UIView *)toView
                            Complete:(void (^)(BOOL))completed;

- (void)turnTransitionForDuration:(NSInteger)duration
                         FromView:(UIView *)fromView
                           ToView:(UIView *)toView
                         Complete:(void (^)(BOOL))completed;

- (void)portalTransitionForDuration:(NSInteger)duration
                           FromView:(UIView *)fromView
                             ToView:(UIView *)toView
                           Complete:(void (^)(BOOL))completed;

- (void)panTransitionForDuration:(NSInteger)duration
                        FromView:(UIView *)fromView
                          ToView:(UIView *)toView
                        Complete:(void (^)(BOOL))completed;

@end
