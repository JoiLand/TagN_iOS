//
//  LeftSideViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "LeftSideViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_lblUserName.text = [GlobalService sharedInstance].user_me.user_name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING([GlobalService sharedInstance].user_me.user_avatar_url)]];
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

#pragma mark - ACCOUNT
- (IBAction)onClickBtnUpdateAccount:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    UIViewController *updateAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateAccountViewController"];
    [self.navigationController pushViewController:updateAccountVC animated:YES];
}

- (IBAction)onClickBtnChangePassword:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    UIViewController *changePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePasswordVC animated:YES];
}

#pragma mark - SETTINGS
- (IBAction)onClickNotificationSettings:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    UIViewController *notificationSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationSettingsViewController"];
    [self.navigationController pushViewController:notificationSettingsVC animated:YES];
}

- (IBAction)onClickBtnCellularDataUse:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    UIViewController *networkSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NetworkSettingsViewController"];
    [self.navigationController pushViewController:networkSettingsVC animated:YES];
}

#pragma mark - SUPPORT
- (IBAction)onClickBtnReportProblem:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[@"help@tagn.info"]];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

#pragma mark - MFMailCompose delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnRateApp:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:APP_STORE_URL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
    }
}

- (IBAction)onClickBtnPrivacyPolicy:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PRIVACY_POLICY_LINK]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PRIVACY_POLICY_LINK]];
    }
}

- (IBAction)onClickBtnHelp:(id)sender {
    [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:HELP_LINK]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HELP_LINK]];
    }
}

- (IBAction)onClickBtnSignout:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Log Out"
                                message:@"Are you sure to log out now?"
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        
        [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
        
        [[WebService sharedInstance] logoutWithUserId:[GlobalService sharedInstance].user_me.user_id
                                              success:^(NSString *strResult) {
                                                  NSLog(@"%@", strResult);
                                              }
                                              failure:^(NSString *strError) {
                                                  NSLog(@"%@", strError);
                                              }];
        
        [[GlobalService sharedInstance] deleteMe];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
