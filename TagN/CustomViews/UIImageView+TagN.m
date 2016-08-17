//
//  UIImageView+TagN.m
//  TagN
//
//  Created by JH Lee on 1/15/16.
//  Copyright © 2016 DMSoft. All rights reserved.
//

#import "UIImageView+TagN.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@implementation UIImageView(TagN)

- (void)setImageWithObj:(ImageObj *)objImage withPlaceholder:(NSString *)imgPlaceholder {
    
    DGActivityIndicatorView *activityIndicatorView = [self addActivityIndicatorViewSize:40.f];
    [activityIndicatorView startAnimating];
    
    if(objImage.image_photo) {
        self.image = objImage.image_photo;
        [activityIndicatorView removeFromSuperview];
    } else {
        __weak UIImageView *weak = self;
        UIImage *image = [[CoreDataService sharedInstance] getImageWithImageUrl:objImage.image_url];
        if(image) {
            weak.image = image;
            objImage.image_photo = image;
            [activityIndicatorView removeFromSuperview];
        } else {
            weak.image = [UIImage imageNamed:imgPlaceholder];
            if([GlobalService sharedInstance].is_internet_alive) {
                [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:IMAGE_FULL_URL_STRING(objImage.image_url)]]
                            placeholderImage:[UIImage imageNamed:imgPlaceholder]
                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {                            
                                         weak.image = image;
                                         objImage.image_photo = image;
                                         [activityIndicatorView removeFromSuperview];
                                         [[CoreDataService sharedInstance] saveImageObj:objImage
                                                                              withImage:image];
                                     }
                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                         NSLog(@"%@", error.localizedDescription);
                                         [activityIndicatorView removeFromSuperview];
                                     }];
            } else {
                [activityIndicatorView removeFromSuperview];
            }
        }
    }
}

- (void)setImageThumbWithObj:(ImageObj *)objImage withPlaceholder:(NSString *)imgPlaceholder {
    
    DGActivityIndicatorView *activityIndicatorView = [self addActivityIndicatorViewSize:20.f];
    [activityIndicatorView startAnimating];
    
    if(objImage.image_thumb_photo) {
        self.image = objImage.image_thumb_photo;
        [activityIndicatorView removeFromSuperview];
    } else {
        __weak UIImageView *weak = self;
        UIImage *image = [[CoreDataService sharedInstance] getThumbImageWithImageUrl:objImage.image_thumb_url];
        if(image) {
            weak.image = image;
            objImage.image_thumb_photo = image;
            [activityIndicatorView removeFromSuperview];
        } else {
            if([GlobalService sharedInstance].is_internet_alive) {
                [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:IMAGE_THUMB_FULL_URL_STRING(objImage.image_thumb_url)]]
                            placeholderImage:[UIImage imageNamed:imgPlaceholder]
                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                         weak.image = image;
                                         objImage.image_thumb_photo = image;
                                         [activityIndicatorView removeFromSuperview];
                                         [[CoreDataService sharedInstance] saveImageObj:objImage
                                                                         withThumbImage:image];
                                     }
                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                         NSLog(@"%@", error.localizedDescription);
                                     }];
            } else {
                [activityIndicatorView removeFromSuperview];
            }
        }
    }
}

- (DGActivityIndicatorView *)addActivityIndicatorViewSize:(CGFloat)size {
    //remove old activity view
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DGActivityIndicatorView class]]) {
            [view removeFromSuperview];
        }
    }
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate
                                                                                         tintColor:[UIColor whiteColor]
                                                                                              size:size];
    
    [self addSubview:activityIndicatorView];
    
    //add constraint
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //center x
    [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    //center y
    [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    return activityIndicatorView;
}

@end
