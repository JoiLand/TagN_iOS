//
//  NotificationSettingsViewController.h
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *m_btnRemoveShare;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRemoveTag;
@property (weak, nonatomic) IBOutlet UIButton *m_btnUploadImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRemoveImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLikeImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCommentImage;

- (IBAction)onClickBtnRemoveShare:(id)sender;
- (IBAction)onClickBtnRemoveTag:(id)sender;
- (IBAction)onClickBtnUploadImage:(id)sender;
- (IBAction)onClickBtnRemoveImage:(id)sender;
- (IBAction)onClickBtnLikeImage:(id)sender;
- (IBAction)onClickBtnCommentImage:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
