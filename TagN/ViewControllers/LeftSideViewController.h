//
//  LeftSideViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LeftSideViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;

//Account
- (IBAction)onClickBtnUpdateAccount:(id)sender;
- (IBAction)onClickBtnChangePassword:(id)sender;

//Settings
- (IBAction)onClickNotificationSettings:(id)sender;
- (IBAction)onClickBtnCellularDataUse:(id)sender;

//Support
- (IBAction)onClickBtnReportProblem:(id)sender;
- (IBAction)onClickBtnRateApp:(id)sender;
- (IBAction)onClickBtnPrivacyPolicy:(id)sender;
- (IBAction)onClickBtnHelp:(id)sender;

- (IBAction)onClickBtnSignout:(id)sender;

@end
