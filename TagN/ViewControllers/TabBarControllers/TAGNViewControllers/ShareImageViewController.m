//
//  ShareImageViewController.m
//  TagN
//
//  Created by JH Lee on 2/17/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ShareImageViewController.h"
#import "TagNDetailHeaderView.h"
#import "MembersViewController.h"
#import "CommentViewController.h"
#import "LikesViewController.h"
#import "PhotoEditViewController.h"

@interface ShareImageViewController ()

@end

@implementation ShareImageViewController

#define TAGN_HEADERVIEW_HEIGHT      50
#define TABLE_CELL_HEIGHT           self.view.frame.size.width / 320 * 412
#define TABLE_CELL_VIEW_HEIGHT      90

#define COMMENT_LABEL_WIDTH         self.view.frame.size.width - 20

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TagObj *objTag = [[GlobalService sharedInstance].user_me getTagObjFromId:self.m_objImage.image_tag_id];
    if(objTag) {
        self.m_lblTitle.text = objTag.tag_text;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.m_tblImage reloadData];
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

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TAGN_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TagNDetailHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TagNDetailHeaderView" owner:nil options:nil] objectAtIndex:0];
    [headerView setViewWithImageObj:self.m_objImage];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float xRatio = self.view.frame.size.width / self.m_objImage.image_width.floatValue;
    CGFloat imgHeight = self.m_objImage.image_height.floatValue * xRatio;
    CGFloat lblCommentHeight = [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:self.m_objImage.image_last_2_comments]
                                                                   withLabelWidth:COMMENT_LABEL_WIDTH];
    
    return imgHeight + TABLE_CELL_VIEW_HEIGHT + lblCommentHeight;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagNDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TagNDetailTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithImageObj:self.m_objImage onSection:indexPath.section];
    [cell.m_lblComment setAttributedText:[[GlobalService sharedInstance] makeCommentsWithData:self.m_objImage.image_last_2_comments]];
    cell.m_constraintViewHeight.constant += [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:self.m_objImage.image_last_2_comments]
                                                                                withLabelWidth:COMMENT_LABEL_WIDTH];
    cell.delegate = self;
    cell.m_imgSelected.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.m_objImage.image_photo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PhotoEditViewController *photoEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditViewController"];
            photoEditVC.m_objImage = self.m_objImage;
            UINavigationController *photoEditNC = [[UINavigationController alloc] initWithRootViewController:photoEditVC];
            photoEditNC.navigationBarHidden = YES;
            [self presentViewController:photoEditNC animated:YES completion:nil];
        });
    } else {
        [self.view makeToast:TOAST_PHOTO_NOT_DOWNLOAD];
    }
}

#pragma mark - TagNDetailTableViewCellDelegate
- (void)onClickBtnLikeSelected:(BOOL)selected onSection:(NSInteger)nSection {
    NSInteger nImageLikes = self.m_objImage.image_likes.integerValue;
    
    if(selected) {
        nImageLikes++;
    } else {
        nImageLikes--;
    }
    
    [[WebService sharedInstance] updateUserLikeWithId:[GlobalService sharedInstance].user_me.user_id
                                             UserName:[GlobalService sharedInstance].user_me.user_name
                                              ImageId:self.m_objImage.image_id
                                           ImageTagId:self.m_objImage.image_tag_id
                                             Selected:selected
                                              success:^(NSString *strResult) {
                                                  NSLog(@"%@", strResult);
                                              }
                                              failure:^(NSString *strError) {
                                                  NSLog(@"%@", strError);
                                              }];
    
    self.m_objImage.image_likes = [NSNumber numberWithInteger:nImageLikes];
    self.m_objImage.image_is_like = [NSNumber numberWithBool:selected];
    
    [self.m_tblImage reloadData];
}

- (void)onClickBtnDownload:(NSInteger)nSection {
    if(self.m_objImage.image_photo) {
        UIImageWriteToSavedPhotosAlbum(self.m_objImage.image_photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        [self.view makeToast:@"The image has not been loaded yet :("];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self.view makeToast:@"Saved image successfully"];
    } else {
        [self.view makeToast:@"Failed to save image"];
    }
}

- (void)onClickBtnComment:(NSInteger)nSection {
    CommentViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentVC.m_objImage = self.m_objImage;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)onClickBtnLikes:(NSInteger)nSection {
    LikesViewController *likesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikesViewController"];
    likesVC.m_objImage = self.m_objImage;
    [self.navigationController pushViewController:likesVC animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
