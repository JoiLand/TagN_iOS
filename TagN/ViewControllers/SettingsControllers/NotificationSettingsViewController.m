//
//  NotificationSettingsViewController.m
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "NotificationSettingsViewController.h"

@interface NotificationSettingsViewController ()

@end

@implementation NotificationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_btnRemoveShare.selected = [GlobalService sharedInstance].user_me.user_settings.show_unshare_noti;
    self.m_btnRemoveTag.selected = [GlobalService sharedInstance].user_me.user_settings.show_remove_tag_noti;
    self.m_btnUploadImage.selected = [GlobalService sharedInstance].user_me.user_settings.show_upload_image_noti;
    self.m_btnRemoveImage.selected = [GlobalService sharedInstance].user_me.user_settings.show_remove_image_noti;
    self.m_btnLikeImage.selected = [GlobalService sharedInstance].user_me.user_settings.show_like_noti;
    self.m_btnCommentImage.selected = [GlobalService sharedInstance].user_me.user_settings.show_comment_noti;
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

- (IBAction)onClickBtnRemoveShare:(id)sender {
    self.m_btnRemoveShare.selected = !self.m_btnRemoveShare.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_unshare_noti = self.m_btnRemoveShare.selected;
}

- (IBAction)onClickBtnRemoveTag:(id)sender {
    self.m_btnRemoveTag.selected = !self.m_btnRemoveTag.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_remove_tag_noti = self.m_btnRemoveTag.selected;
}

- (IBAction)onClickBtnUploadImage:(id)sender {
    self.m_btnUploadImage.selected = !self.m_btnUploadImage.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_upload_image_noti = self.m_btnUploadImage.selected;
}

- (IBAction)onClickBtnRemoveImage:(id)sender {
    self.m_btnRemoveImage.selected = !self.m_btnRemoveImage.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_remove_image_noti = self.m_btnRemoveImage.selected;
}

- (IBAction)onClickBtnLikeImage:(id)sender {
    self.m_btnLikeImage.selected = !self.m_btnLikeImage.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_like_noti = self.m_btnLikeImage.selected;
}

- (IBAction)onClickBtnCommentImage:(id)sender {
    self.m_btnCommentImage.selected = !self.m_btnCommentImage.selected;
    [GlobalService sharedInstance].user_me.user_settings.show_comment_noti = self.m_btnCommentImage.selected;
}

- (IBAction)onClickBtnBack:(id)sender {
    [[GlobalService sharedInstance] saveMySettings];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
