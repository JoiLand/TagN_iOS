//
//  UpdateAccountViewController.m
//  TagN
//
//  Created by JH Lee on 2/7/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "UpdateAccountViewController.h"

@interface UpdateAccountViewController ()

@end

@implementation UpdateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING([GlobalService sharedInstance].user_me.user_avatar_url)]];
    
    [self initViews];
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

- (void) initViews {
    self.m_txtName.text = [GlobalService sharedInstance].user_me.user_name;
    self.m_txtUserName.text = [GlobalService sharedInstance].user_me.user_username;
    self.m_txtEmail.text = [GlobalService sharedInstance].user_me.user_email;
    self.m_txtPhone.text = [GlobalService sharedInstance].user_me.user_phone;
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

- (IBAction)onClickBtnUpdate:(id)sender {
    if([self validateUpdate]) {
        UserMe *tmpUser = [GlobalService sharedInstance].user_me;
        tmpUser.user_name = self.m_txtName.text;
        tmpUser.user_username = self.m_txtUserName.text;
        tmpUser.user_phone = self.m_txtPhone.text;

        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updateUser:tmpUser
                                     UserAvatar:m_hasAvatar ? self.m_imgAvatar.image : nil
                                        success:^(UserMe *objMe) {
                                            SVPROGRESSHUD_DISMISS;
                                            tmpUser.user_avatar_url = objMe.user_avatar_url;
                                            [[GlobalService sharedInstance] saveMe:tmpUser];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateUpdate {
    BOOL bResult = YES;
    
    if(self.m_txtUserName.text.length == 0) {
        [self.view makeToast:TOAST_NO_USER_NAME];
        
        bResult = NO;
    } else if(self.m_txtUserName.text.length == 0) {
        [self.view makeToast:TOAST_NO_USER_NAME];
        
        bResult = NO;
    } else if (self.m_txtPhone.text.length > 0 && ![self.m_txtPhone containsValidNumber]) {
        [self.view makeToast:TOAST_INVALID_PHONE_NUMBER];
        
        bResult = NO;
    }
    
    return bResult;
}

@end
