//
//  CameraViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "CameraGridView.h"

@interface CameraViewController : UIViewController<CTAssetsPickerControllerDelegate> {
    AVCaptureStillImageOutput       *m_stillImageOutput;
    
    CameraGridView                  *m_viewCameraGrid;
    
    BOOL                            m_bFlash;
    BOOL                            m_bGrid;
    CGFloat                         beginCameraScale;
    CGFloat                         currentCameraScale;
}

@property (weak, nonatomic) IBOutlet GPUImageView *m_viewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgFocus;
@property (weak, nonatomic) IBOutlet UIButton *m_btnGallery;

- (IBAction)onClickBtnGrid:(id)sender;
- (IBAction)onClickBtnFlip:(id)sender;
- (IBAction)onClickBtnFlash:(id)sender;
- (IBAction)onClickBtnGallery:(id)sender;
- (IBAction)onClickBtnShot:(id)sender;
- (IBAction)onClickBtnClose:(id)sender;
- (IBAction)onTapPreviewForCameraExpose:(id)sender;
- (IBAction)onPinchPreviewForCameraZoom:(id)sender;

@end
