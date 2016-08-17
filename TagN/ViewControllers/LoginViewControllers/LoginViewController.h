//
//  LoginViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TagNTextField.h"

@interface LoginViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TagNTextField  *m_txtUserEmail;
@property (weak, nonatomic) IBOutlet TagNTextField  *m_txtUserPass;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnForgotPassword;

- (IBAction)onClickBtnFBLogin:(id)sender;
- (IBAction)onClickBtnLogin:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnForgotPassword:(id)sender;

@end
