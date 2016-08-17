//
//  CameraViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoEditForCameraViewController.h"
#import <Photos/Photos.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLastestPicturesFromLibrary];
    
    [[GlobalService sharedInstance].tabbar_vc.m_filter addTarget:self.m_viewPreview];
    // init states
    m_bGrid = m_bFlash = NO;
    
    // init focus image
    self.m_imgFocus.alpha = 0.f;
    
    m_viewCameraGrid = [[CameraGridView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:m_viewCameraGrid aboveSubview:self.m_viewPreview];
    m_viewCameraGrid.alpha = 0.f;
    
    m_stillImageOutput = nil;
    for(int nIndex = 0; nIndex < [GlobalService sharedInstance].tabbar_vc.m_videoCamera.captureSession.outputs.count; nIndex++) {
        if([[GlobalService sharedInstance].tabbar_vc.m_videoCamera.captureSession.outputs[nIndex] isKindOfClass:[AVCaptureStillImageOutput class]]) {
            m_stillImageOutput = [GlobalService sharedInstance].tabbar_vc.m_videoCamera.captureSession.outputs[nIndex];
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    currentCameraScale = 1.f;
    beginCameraScale = 1.f;
    self.m_viewPreview.transform = CGAffineTransformMakeScale(currentCameraScale, currentCameraScale);
    
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera startCameraCapture];
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

# pragma mark - Get Image from library
-(void) getLastestPicturesFromLibrary {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         if ([group numberOfAssets] > 0)
         {
             [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0
                                  usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
              {
                  if(nil != alAsset) {
                      
                      if([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                          
                          NSURL *url= (NSURL*) [[alAsset defaultRepresentation] url];
                          
                          [library assetForURL:url
                                   resultBlock:^(ALAsset *asset) {
                                       UIImage *lastImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                                       [self.m_btnGallery setImage:lastImage forState:UIControlStateNormal];
                                   }
                                  failureBlock:^(NSError *error){
                                      NSLog(@"operation was not successfull!");
                                  }];
                      }
                  }
              }];
         }
     }
                         failureBlock: ^(NSError *error)
     {
         NSLog(@"No Photo");
     }];
}

- (IBAction)onClickBtnGrid:(id)sender {
    m_bGrid = !m_bGrid;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         m_viewCameraGrid.alpha = m_bGrid ? 1.f:0.f;
                     }];
}

- (IBAction)onClickBtnFlip:(id)sender {
    currentCameraScale = 1.f;
    beginCameraScale = 1.f;
    self.m_viewPreview.transform = CGAffineTransformMakeScale(currentCameraScale, currentCameraScale);
    
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera rotateCamera];
}

- (IBAction)onClickBtnFlash:(id)sender {
    m_bFlash = !m_bFlash;
    
    NSError *error = nil;
    if (![[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera lockForConfiguration:&error]
        || ![[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera isTorchModeSupported:AVCaptureTorchModeOn]) {
        
        NSLog(@"Error locking for configuration: %@", error);
        return;
    }
    
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera setTorchMode:m_bFlash ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera unlockForConfiguration];
}

- (IBAction)onClickBtnGallery:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    // request authorization status
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            picker.showsEmptyAlbums = NO;
            picker.showsNumberOfAssets = YES;
            picker.showsSelectionIndex = YES;
            
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}

- (IBAction)onClickBtnShot:(id)sender {
    if(m_stillImageOutput) {
        AVCaptureConnection *connection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:m_stillImageOutput.connections];
        if(connection) {
            [connection setVideoScaleAndCropFactor:currentCameraScale];
        }
    }
    
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera capturePhotoAsImageProcessedUpToFilter:[GlobalService sharedInstance].tabbar_vc.m_filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        ImageObj *objImage = [[ImageObj alloc] initWithId:@0
                                                   UserId:[GlobalService sharedInstance].user_me.user_id
                                                    Photo:processedImage];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        PhotoEditForCameraViewController *photoEditForCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditForCameraViewController"];
        photoEditForCameraVC.m_aryPhotos = @[objImage];
        [self.navigationController pushViewController:photoEditForCameraVC animated:NO];
    }];
}

- (IBAction)onClickBtnClose:(id)sender {
    [[GlobalService sharedInstance].tabbar_vc.m_videoCamera stopCameraCapture];
    [GlobalService sharedInstance].tabbar_vc.selectedIndex = [GlobalService sharedInstance].tabbar_vc.m_nLastSelectedIndex;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onTapPreviewForCameraExpose:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint tapPoint = [tap locationInView:self.m_viewPreview];
    
    if([[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera isFocusPointOfInterestSupported] && [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error;
        if([[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera lockForConfiguration:&error]) {
            
            [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera setFocusPointOfInterest :tapPoint];
            [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera setFocusMode :AVCaptureFocusModeAutoFocus];
            
            if([[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera isExposurePointOfInterestSupported]) {
                
                [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera setExposurePointOfInterest:tapPoint];
                [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            
            self.m_imgFocus.center = tapPoint;
            self.m_imgFocus.transform = CGAffineTransformMakeScale(2.f, 2.f);
            self.m_imgFocus.alpha = 1.0f;
            
            [UIView animateWithDuration:0.3f
                             animations:^(void) {
                                 self.m_imgFocus.transform = CGAffineTransformMakeScale(1.f, 1.f);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.3f
                                                      animations:^(void) {
                                                          self.m_imgFocus.alpha = 0.0f;
                                                      } ];
                                 }
                             }];
            
            [[GlobalService sharedInstance].tabbar_vc.m_videoCamera.inputCamera unlockForConfiguration];
        }
    }
}

- (IBAction)onPinchPreviewForCameraZoom:(id)sender {
    
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)sender;
    if(pinch.state == UIGestureRecognizerStateEnded) {
        beginCameraScale = currentCameraScale;
    } else {
        currentCameraScale = beginCameraScale * pinch.scale;
        
        CGFloat fMaxScale = [self cameraMaxScale];
        if (currentCameraScale < 1.f) {
            currentCameraScale = 1.f;
        } else if(currentCameraScale > fMaxScale) {
            currentCameraScale = fMaxScale;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025f];
        self.m_viewPreview.transform = CGAffineTransformMakeScale(currentCameraScale, currentCameraScale);
        [CATransaction commit];
    }
}

- (CGFloat)cameraMaxScale {
    AVCaptureConnection *connection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:m_stillImageOutput.connections];
    if(connection) {
        return connection.videoMaxScaleAndCropFactor > 5 ? 5 : connection.videoMaxScaleAndCropFactor;
    }
    
    return 1.f;
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    AVCaptureConnection *videoConnection = nil;
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [port.mediaType isEqual:mediaType] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    return videoConnection;
}

#pragma - mark CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    
    NSMutableArray *aryImages = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < assets.count; nIndex++) {
        [manager requestImageForAsset:assets[nIndex]
                           targetSize:PHOTO_IMAGE_SIZE
                          contentMode:PHImageContentModeAspectFit
                              options:option
                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            UIGraphicsBeginImageContextWithOptions(result.size, NO, result.scale);
                            {
                                [result drawAtPoint:CGPointMake(0, 0)];
                                result = UIGraphicsGetImageFromCurrentImageContext();
                            }
                            UIGraphicsEndImageContext();
                            
                            ImageObj *objImage = [[ImageObj alloc] initWithId:@0
                                                                       UserId:[GlobalService sharedInstance].user_me.user_id
                                                                        Photo:result];
                            [aryImages addObject:objImage];
                        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        // assets contains PHAsset objects.
        PhotoEditForCameraViewController *photoEditForCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditForCameraViewController"];
        photoEditForCameraVC.m_aryPhotos = aryImages;
        [self.navigationController pushViewController:photoEditForCameraVC animated:NO];
    }];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    // Allow 10 assets to be picked
    return (picker.selectedAssets.count < 10);
}

@end
