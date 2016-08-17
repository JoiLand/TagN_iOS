//
//  TagNStoryRender.m
//  TagN
//
//  Created by JH Lee on 5/26/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNStoryRender.h"
#import <QuartzCore/QuartzCore.h>

typedef UIImage *(^UIScreenCaptureUIImageExtractor)(NSObject* inputObject);

@interface TagNStoryRender ()

@property BOOL recording;

@end

@implementation TagNStoryRender

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.width = screenRect.size.width;
        self.height = screenRect.size.height;
        self.frameBuffer = [[NSMutableArray alloc] init];
        self.frameRate = 10.f;
    }
    return self;
}

- (void)setView:(UIView *)view {
    _view = view;
    self.width = view.frame.size.width;
    self.height = view.frame.size.height;
}

- (void)prepareCapture
{
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/story.mov"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
    
    _fileURL = [NSURL fileURLWithPath:tempPath];
    _assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL
                                             fileType:AVFileTypeQuickTimeMovie error:&error];
    if (error) {
        NSLog(@"Error: %@", error.debugDescription);
    }
    NSParameterAssert(self.assetWriter);
    
    _videoSettings = [TagNStoryRender videoSettingsWithSize:CGSizeMake(self.width, self.height)];
    
    _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                      outputSettings:_videoSettings];
    NSParameterAssert(self.writerInput);
    NSParameterAssert([self.assetWriter canAddInput:self.writerInput]);
    
    [self.assetWriter addInput:self.writerInput];
    
    NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    _bufferAdapter = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.writerInput sourcePixelBufferAttributes:bufferAttributes];
    _frameTime = CMTimeMake(1, self.frameRate);
}

- (void)createVideoFromImageURLs:(NSArray *)urls withCompletion:(TagNStoryRenderCompletion)completion;
{
    [self createVideoFromSource:urls extractor:^UIImage *(NSObject *inputObject) {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:((NSURL *)inputObject)]];
    } withCompletion:completion];
}

- (void)createVideoFromImages:(NSArray *)images withCompletion:(TagNStoryRenderCompletion)completion;
{
    [self createVideoFromSource:images extractor:^UIImage *(NSObject *inputObject) {
        return (UIImage *)inputObject;
    } withCompletion:completion];
}

- (void)createVideoFromSource:(NSArray *)images extractor:(UIScreenCaptureUIImageExtractor)extractor withCompletion:(TagNStoryRenderCompletion)completion;
{
    [self prepareCapture];
    
    self.completionBlock = completion;
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 0;
    
    NSInteger frameNumber = [images count];
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i >= frameNumber) {
                break;
            }
            
            @autoreleasepool {
                if ([self.writerInput isReadyForMoreMediaData]) {
                    UIImage *img = extractor([images objectAtIndex:i]);
                    if (img == nil) {
                        i++;
                        NSLog(@"Warning: could not extract one of the frames");
                        continue;
                    }
                    CVPixelBufferRef sampleBuffer = [self newPixelBufferFromCGImage:[img CGImage]];
                    
                    if (sampleBuffer) {
                        if (i == 0) {
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                        }
                        else {
                            CMTime lastTime = CMTimeMake(i-1, self.frameTime.timescale);
                            CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                        }
                        CFRelease(sampleBuffer);
                        i++;
                    }
                }
            }
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

- (void)createStoryFromImages:(NSArray *)images withCompletion:(TagNStoryRenderCompletion)completion {
    [self prepareCapture];
    
    self.completionBlock = completion;
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 0;
    __block NSInteger nImages = 0;
    
    NSInteger frameNumber = [images count];
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i >= frameNumber) {
                break;
            }
            
            @autoreleasepool {
                UIImage *img = images[i];
                if (img == nil) {
                    i++;
                    NSLog(@"Warning: could not extract one of the frames");
                    continue;
                }
                CVPixelBufferRef sampleBuffer = [self newPixelBufferFromCGImage:[img CGImage]];
                
                if (sampleBuffer) {
                    for(int nIndex = 0; nIndex < self.speed * 10; nIndex++) {
                        if ([self.writerInput isReadyForMoreMediaData]) {
                            if (nImages == 0) {
                                [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                            }
                            else {
                                CMTime lastTime = CMTimeMake(nImages - 1, self.frameTime.timescale);
                                CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                                [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                            }
                            nImages++;
                        } else {
                            nIndex--;
                        }
                    }
                    CFRelease(sampleBuffer);
                    i++;
                }
            }
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = [[self.videoSettings objectForKey:AVVideoWidthKey] floatValue];
    CGFloat frameHeight = [[self.videoSettings objectForKey:AVVideoHeightKey] floatValue];
    
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    if (status != kCVReturnSuccess && pxbuffer == NULL) {
        [NSException raise:@"No Pixel Buffer" format:@"There was an error creating the pixel buffer."];
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 4 * frameWidth,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           (frameHeight - CGImageGetHeight(image)) / 2,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void)startRecording
{
    self.recording = YES;
    
    [self prepareCapture];
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    CGSize size = CGSizeMake(self.width, self.height);
    
    __block NSInteger nIndex = 0;
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES) {
            if (!self.recording) {
                break;
            }
            
            NSDate *start = [NSDate date];
            @autoreleasepool {
                if ([self.writerInput isReadyForMoreMediaData]) {
                    UIImage *viewImage = [TagNStoryRender takeSnapshotWithSize:size view:self.view];
                    
                    CVPixelBufferRef sampleBuffer = [self newPixelBufferFromCGImage:[viewImage CGImage]];
                    
                    if (sampleBuffer) {
                        if (nIndex == 0) {
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                        } else {
                            CMTime lastTime = CMTimeMake(nIndex - 1, self.frameTime.timescale);
                            CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                        }
                        CFRelease(sampleBuffer);
                        nIndex++;
                    }
                }
            }
            
            CGFloat processingSeconds = [[NSDate date] timeIntervalSinceDate:start];
            CGFloat delayRemaining = (1.0 / self.frameRate) - processingSeconds;
            
            [NSThread sleepForTimeInterval:delayRemaining];
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

- (void)stopRecording
{
    self.recording = NO;
}


#pragma mark - Static methods
+ (NSDictionary *)videoSettingsWithSize:(CGSize)size
{
    if ((int)size.width <= 0) {
        NSLog(@"Warning: video must have a positive width that is greater than zero.");
    }
    
    if ((int)size.width % 16 != 0 ) {
        NSLog(@"Warning: video width must be divisible by 16. To ensure video does not become warped, width is being rounded up to closest multiple of 16.");
        size.width = 16.0 * floor(size.width / 16.0);
    }
    
    NSDictionary *videoSettings = @{AVVideoCodecKey : AVVideoCodecH264,
                                    AVVideoWidthKey : [NSNumber numberWithInt:(int)size.width],
                                    AVVideoHeightKey : [NSNumber numberWithInt:(int)size.height]};
    
    return videoSettings;
}

+ (UIImage *)takeSnapshot
{
    UIWindow *window = [self findKeyWindow];
    
    CGSize windowSize = window.bounds.size;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(windowSize, NO, 1.0);
    }
    else {
        UIGraphicsBeginImageContext(windowSize);
    }
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)takeSnapshotWithSize:(CGSize)size
{
    UIImage *image = [self takeSnapshot];
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)takeSnapshotWithSize:(CGSize)size view:(UIView *)view
{
    CGSize viewSize = view.bounds.size;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    }
    else {
        UIGraphicsBeginImageContext(viewSize);
    }
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *rasterizedView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rasterizedView;
}

+ (NSData *)takeSnapshotGetJPEG
{
    return [self takeSnapshotGetJPEG:.7];
}

+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality
{
    return UIImageJPEGRepresentation([self takeSnapshot], quality);
}

+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality size:(CGSize)size
{
    return UIImageJPEGRepresentation([self takeSnapshotWithSize:size], quality);
}

+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality size:(CGSize)size view:(UIView *)view
{
    return UIImageJPEGRepresentation([self takeSnapshotWithSize:size view:view], quality);
}

+ (UIWindow *)findKeyWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (![NSStringFromClass([keyWindow class]) isEqualToString:@"UIWindow"]) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if ([NSStringFromClass([window class]) isEqualToString:@"UIWindow"]) {
                keyWindow = window;
                break;
            }
        }
    }
    return keyWindow;
}

@end
