//
//  TagNPhotoView.m
//  TagN
//
//  Created by JH Lee on 2/22/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNPhotoView.h"

@interface UIImage (TagNUtil)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (TagNUtil)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (TagNUtil)

- (CGSize)contentSize;

@end

@implementation UIImageView (TagNUtil)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface TagNPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

@end

@implementation TagNPhotoView

- (void)initViews:(CGRect)frame
{
    self.delegate = self;
    self.bouncesZoom = YES;
    
    // Add container view
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    _containerView = containerView;
    
    // Add image view
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = containerView.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imageView];
    _imageView = imageView;
    
    // Setup other events
    [self setupGestureRecognizer];
    [self setupRotationNotification];
}

- (void)setImageWithImageObj:(ImageObj *)objImage {
    self.zoomScale = 1.0f;
    
    [self.imageView setImageWithObj:objImage
                    withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    
    // Fit container view's size to image size
    CGSize imageSize = self.imageView.contentSize;
    self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    
    self.contentSize = imageSize;
    self.minSize = imageSize;
    
    
    [self setMaxMinZoomScale];
    
    // Center containerView by set insets
    [self centerContent];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = self.containerView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image sizeThatFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) {
            self.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    CGSize imageSize = self.imageView.image.size;
    CGSize imagePresentationSize = self.imageView.contentSize;
    CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.maximumZoomScale = MAX(1, maxScale); // Should not less than 1
    self.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

@end
