//
//  TagNStoryRender.h
//  TagN
//
//  Created by JH Lee on 5/26/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TagNStoryRenderCompletion)(NSURL *fileURL);

@interface TagNStoryRender : NSObject

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *bufferAdapter;
@property (nonatomic, strong) NSDictionary *videoSettings;
@property (nonatomic, strong) NSMutableArray *frameBuffer;
@property (nonatomic, assign) CMTime frameTime;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat frameRate;
@property (nonatomic) CGFloat speed;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) TagNStoryRenderCompletion completionBlock;

- (void)createVideoFromImageURLs:(NSArray *)urls withCompletion:(TagNStoryRenderCompletion)completion;
- (void)createVideoFromImages:(NSArray *)images withCompletion:(TagNStoryRenderCompletion)completion;
- (void)createStoryFromImages:(NSArray *)images withCompletion:(TagNStoryRenderCompletion)completion;

- (void)startRecording;
- (void)stopRecording;

+ (NSDictionary *)videoSettingsWithSize:(CGSize)size;
+ (UIImage *)takeSnapshot;
+ (UIImage *)takeSnapshotWithSize:(CGSize)size;
+ (UIImage *)takeSnapshotWithSize:(CGSize)size view:(UIView *)view;
+ (NSData *)takeSnapshotGetJPEG;
+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality;
+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality size:(CGSize)size;
+ (NSData *)takeSnapshotGetJPEG:(CGFloat)quality size:(CGSize)size view:(UIView *)view;

@end