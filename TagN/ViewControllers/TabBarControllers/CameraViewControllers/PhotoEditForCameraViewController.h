//
//  PhotoEditForCameraViewController.h
//  TagN
//
//  Created by JH Lee on 2/6/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CLImageEditor/CLImageEditor.h>

@interface PhotoEditForCameraViewController : UIViewController<CLImageEditorDelegate>

@property (nonatomic, retain) NSArray   *m_aryPhotos;

@property (weak, nonatomic) IBOutlet UILabel *m_lblActiveTag;
@property (weak, nonatomic) IBOutlet UIPageControl *m_ctrlPage;
@property (weak, nonatomic) IBOutlet UIScrollView *m_sclImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNext;
@property (weak, nonatomic) IBOutlet UIButton *m_btnChangeTag;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCamera;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnCamera:(id)sender;
- (IBAction)onClickBtnSettings:(id)sender;
- (IBAction)onTouchDownChangeTag:(id)sender;
- (IBAction)onTouchUpChangeTag:(id)sender;
- (IBAction)onTouchDownBtnNext:(id)sender;
- (IBAction)onTouchUpBtnNext:(id)sender;


@end
