//
//  ChangePasswordViewController.m
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickBtnChangePassword:(id)sender {
    [self.m_txtCurrentPass resignFirstResponder];
    [self.m_txtNewPass resignFirstResponder];
    [self.m_txtConfirmPass resignFirstResponder];
    
    if([self validateChangePassword]) {
        NSString *strCureentPass = [self.m_txtCurrentPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *strNewPass = [self.m_txtNewPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] changePassword:[GlobalService sharedInstance].user_me.user_id
                                        CurrentPass:strCureentPass
                                            NewPass:strNewPass
                                            success:^(NSString *strResult) {
                                                SVPROGRESSHUD_SUCCESS(strResult);
                                            }
                                            failure:^(NSString *strError) {
                                                SVPROGRESSHUD_ERROR(strError);
                                            }];
    }
}

- (BOOL)validateChangePassword {
    
    NSString *strCureentPass = [self.m_txtCurrentPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strNewPass = [self.m_txtNewPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strConfirmPass = [self.m_txtConfirmPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    if (strCureentPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD];
        
        bResult = NO;
    }else if (strNewPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD];
        
        bResult = NO;
    } else if(![strConfirmPass isEqualToString:strNewPass]) {
        [self.view makeToast:TOAST_MISMATCH_PASSWORD];
        
        bResult = NO;
    }
    
    return bResult;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
