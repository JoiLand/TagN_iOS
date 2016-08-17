//
//  UpdateAccountViewController.h
//  TagN
//
//  Created by JH Lee on 2/7/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOCropViewController/TOCropViewController.h>

#import "TagNTextField.h"
#import "TagNPhoneNumberField.h"

@interface UpdateAccountViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, TOCropViewControllerDelegate> {
    BOOL                            m_hasAvatar;
    UIPopoverController             *m_popoverController;
}

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtName;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet TagNPhoneNumberField *m_txtPhone;

- (IBAction)onClickBtnUpdate:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
