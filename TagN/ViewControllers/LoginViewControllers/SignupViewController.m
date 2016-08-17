//
//  SignupViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SignupViewController.h"

#import <SHEmailValidator/SHEmailValidator.h>
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onTapImageAvatar)];
    [self.m_imgAvatar addGestureRecognizer:tap];
    
    m_hasAvatar = NO;
}

- (void)onTapImageAvatar {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Take your avatar from..."
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              picker.delegate = self;
                                                              
                                                              [self presentViewController:picker animated:YES completion:nil];
                                                          }
                                                          
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Image Gallary"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                          imagePicker.delegate = self;
                                                          if(m_popoverController != nil) {
                                                              [m_popoverController dismissPopoverAnimated:YES];
                                                              m_popoverController = nil;
                                                          }
                                                          
                                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                              imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                                                                  m_popoverController.delegate = self;
                                                                  [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                                                                       inView:self.view
                                                                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                                                     animated:YES];
                                                              } else {
                                                                  
                                                                  [self presentViewController:imagePicker animated:YES completion:nil];
                                                              }
                                                          }
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgUserAvatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [self openEditor:imgUserAvatar];
    }];
}

# pragma mark - Open Crop View Controller

- (void) openEditor:(UIImage *) editImage {
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:editImage];
    cropViewController.delegate = self;
    cropViewController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
    cropViewController.aspectRatioLocked = YES;
    [self presentViewController:cropViewController animated:NO completion:nil];
}

#pragma mark - TOCropViewController Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:^(void) {
        m_hasAvatar = YES;
        self.m_imgAvatar.image = [image resizedImageWithMinimumSize:AVATAR_IMAGE_SIZE];
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)onClickBtnSignup:(id)sender {
    if([self validateSignup]) {
        
        [self.m_txtName resignFirstResponder];
        [self.m_txtUserName resignFirstResponder];
        [self.m_txtEmail resignFirstResponder];
        [self.m_txtPhoneNumber resignFirstResponder];
        [self.m_txtPass resignFirstResponder];
        [self.m_txtConfirmPass resignFirstResponder];
                
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] signupWithName:self.m_txtName.text
                                           UserName:self.m_txtUserName.text
                                          UserEmail:self.m_txtEmail.text
                                          UserPhone:self.m_txtPhoneNumber.text
                                           UserPass:self.m_txtPass.text
                                         UserAvatar:m_hasAvatar ? self.m_imgAvatar.image : nil
                                            success:^(UserMe *objMe) {
                                                SVPROGRESSHUD_DISMISS;
                                                [[GlobalService sharedInstance] saveMe:objMe];
                                                
                                                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                                                [appDelegate startApplication:YES];
                                            }
                                            failure:^(NSString *strError) {
                                                SVPROGRESSHUD_ERROR(strError);
                                            }
                                           progress:^(double fProgress) {
                                               if(m_hasAvatar) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       SVPROGRESSHUD_PROGRESS(fProgress);
                                                   });
                                               }
                                           }];
        
    }
}

- (BOOL)validateSignup {
    
    NSString *strEmail = self.m_txtEmail.text;
    NSString *strPass = [self.m_txtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strConfirmPass = [self.m_txtConfirmPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    NSError *error = nil;
    if(self.m_txtUserName.text.length == 0) {
        [self.view makeToast:TOAST_NO_USER_NAME];
        
        bResult = NO;
    } else if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS];
        
        bResult = NO;
    } else if (self.m_txtPhoneNumber.text.length > 0 && ![self.m_txtPhoneNumber containsValidNumber]) {
        [self.view makeToast:TOAST_INVALID_PHONE_NUMBER];
        
        bResult = NO;
    }else if (strPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD];
        
        bResult = NO;
    } else if(![strConfirmPass isEqualToString:strPass]) {
        [self.view makeToast:TOAST_MISMATCH_PASSWORD];
        
        bResult = NO;
    }
    
    return bResult;
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
