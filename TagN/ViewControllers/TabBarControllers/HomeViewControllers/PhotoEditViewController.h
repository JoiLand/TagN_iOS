//
//  PhotoEditViewController.h
//  TagN
//
//  Created by JH Lee on 2/11/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CLImageEditor/CLImageEditor.h>
#import "TagNPhotoView.h"

@interface PhotoEditViewController : UIViewController<CLImageEditorDelegate> {
    ImageObj            *m_objTmpImage;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnNext;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnEdit;
@property (weak, nonatomic) IBOutlet TagNPhotoView  *m_viewPhoto;

@property (nonatomic, retain) ImageObj              *m_objImage;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnEdit:(id)sender;
- (IBAction)onTouchDownNext:(id)sender;
- (IBAction)onTouchUpNext:(id)sender;

@end
