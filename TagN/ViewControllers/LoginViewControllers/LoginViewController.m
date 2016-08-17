//
//  LoginViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "LoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <SHEmailValidator/SHEmailValidator.h>

#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_btnForgotPassword.layer.borderColor = [UIColor whiteColor].CGColor;
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

- (IBAction)onClickBtnFBLogin:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",
                                      @"user_friends",
                                      @"email"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                [self getResultFromFBSDK:result error:error];
                            }];
}

- (void)getResultFromFBSDK:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (error) {
        // Process error
    } else if (result.isCancelled) {
        // Handle cancellations
    } else {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"email"]) {
            // Do work
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", user);
                         
                         NSString *user_email = user[@"email"];
                         NSString *user_id = user[@"id"];
                         
                         SVPROGRESSHUD_PLEASE_WAIT;
                         [[WebService sharedInstance] fbloginWithName:user[@"name"]
                                                             UserName:user[@"name"]
                                                             UserPass:user_id
                                                            UserEmail:user_email.length > 0 ? user_email : user_id
                                                        UserAvatarUrl:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user_id]
                                                            UserPhone:@""
                                                              success:^(UserMe *objMe) {
                                                                  SVPROGRESSHUD_DISMISS;
                                                                  [[GlobalService sharedInstance] saveMe:objMe];
                                                                  
                                                                  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                                                  [appDelegate startApplication:YES];
                                                              }
                                                              failure:^(NSString *strError) {
                                                                  SVPROGRESSHUD_ERROR(strError);
                                                              }];
                     } else {
                         NSLog(@"%@", error.description);
                     }
                 }];
            }
            
        }
    }
}

- (IBAction)onClickBtnLogin:(id)sender {
    if([self validateLogIn]) {
        
        [self.m_txtUserEmail resignFirstResponder];
        [self.m_txtUserPass resignFirstResponder];
        
        NSString *strEmail = self.m_txtUserEmail.text;
        NSString *strPass = [self.m_txtUserPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] loginWithUserEmail:strEmail
                                               UserPass:strPass
                                                success:^(UserMe *objMe) {
                                                    SVPROGRESSHUD_DISMISS;
                                                    [[GlobalService sharedInstance] saveMe:objMe];
                                                    
                                                    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                                    [appDelegate startApplication:YES];
                                                }
                                                failure:^(NSString *strError) {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }];
    }
}

- (BOOL)validateLogIn {
    
    NSString *strEmail = self.m_txtUserEmail.text;
    NSString *strPass = [self.m_txtUserPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    NSError *error = nil;
    if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS];
        
        bResult = NO;
    } else if (strPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD];
        
        bResult = NO;
    }
    
    return bResult;
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnForgotPassword:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot your password"
                                                        message:@"Pleaes input your email."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Send", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        NSString *strEmail = [alertView textFieldAtIndex:0].text;
        
        NSError *error;
        if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
            [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS];
        } else {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] forgotPasswordWithUserEmail:strEmail
                                                             success:^(NSString *strResult) {
                                                                 SVPROGRESSHUD_SUCCESS(strResult);
                                                             }
                                                             failure:^(NSString *strError) {
                                                                 SVPROGRESSHUD_ERROR(strError);
                                                             }];
        }
    }
}

@end
