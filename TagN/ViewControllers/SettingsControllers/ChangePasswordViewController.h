//
//  ChangePasswordViewController.h
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNTextField.h"

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet TagNTextField *m_txtCurrentPass;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtNewPass;
@property (weak, nonatomic) IBOutlet TagNTextField *m_txtConfirmPass;

- (IBAction)onClickBtnChangePassword:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
