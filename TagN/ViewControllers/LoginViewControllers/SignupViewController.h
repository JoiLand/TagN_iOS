//
//  SignupViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOCropViewController/TOCropViewController.h>

#import "TagNTextField.h"
#import "TagNPhoneNumberField.h"

@interface SignupViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, TOCropViewControllerDelegate> {
    BOOL                            m_hasAvatar;
    UIPopoverController             *m_popoverController;
}

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtName;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet TagNPhoneNumberField *m_txtPhoneNumber;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtPass;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtConfirmPass;

- (IBAction)onClickBtnSignup:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
