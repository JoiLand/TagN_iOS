//
//  HomeDetailViewController.m
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "HomeDetailCollectionViewCell.h"
#import "TagNDetailHeaderView.h"
#import "CommentViewController.h"
#import "LikesViewController.h"
#import "PhotoEditViewController.h"
#import "ImageSelectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ALAssetsLibrary-CustomPhotoAlbum/ALAssetsLibrary+CustomPhotoAlbum.h>

@interface HomeDetailViewController ()

@end

@implementation HomeDetailViewController

#define TABLE_CELL_HEIGHT           self.view.frame.size.width / 320 * 412
#define TABLE_CELL_VIEW_HEIGHT      90
#define COLLECTION_CELL_HEIGHT      self.view.frame.size.width / 3 - 2

#define COMMENT_LABEL_WIDTH         self.view.frame.size.width - 20

#define DELETE_TAG_ALERT_INDEXES    10
#define DELETE_IMAGES_ALERT_INDEXES 11

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblPhoto.alpha = 0.f;
    self.m_cltPhoto.alpha = 1.f;
    
    self.m_viewScroll = self.m_cltPhoto;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addMyPhotos:)
                                                 name:NOTIFICATION_ADD_MY_PHOTOS
                                               object:nil];
    
    self.m_btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
        
    m_auto_scroll = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.m_lblTitle.text = self.m_objImageInfo.imageinfo_tag.tag_text;
    
    [self visibleMenu:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    }
}

- (void)addMyPhotos:(NSNotification *)notification {
    if(notification.userInfo[@"image_obj"]) {   //uploaded photo
        NSNumber *nTagId = notification.userInfo[@"image_obj"];
        
        if(self.m_objImageInfo.imageinfo_tag.tag_id.intValue == nTagId.intValue) {
            [self.m_tblPhoto reloadData];
            [self.m_cltPhoto reloadData];
        }
    }
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_objImageInfo.imageinfo_images.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    
    float xRatio = self.view.frame.size.width / objImage.image_width.floatValue;
    CGFloat imgHeight = objImage.image_height.floatValue * xRatio;
    CGFloat lblCommentHeight = [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]
                                                                   withLabelWidth:COMMENT_LABEL_WIDTH];
    
    return imgHeight + TABLE_CELL_VIEW_HEIGHT + lblCommentHeight;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    
    TagNDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TagNDetailTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithImageObj:objImage onSection:indexPath.row];
    [cell.m_lblComment setAttributedText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]];
    cell.m_constraintViewHeight.constant += [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]
                                                                                withLabelWidth:COMMENT_LABEL_WIDTH];
    cell.delegate = self;
    
    if(self.m_bSelectionMode
       && objImage.image_is_uploaded.boolValue) {
           cell.m_imgSelected.hidden = NO;
           
           if([m_arySelected[indexPath.row] boolValue]) {
               cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageSelected"];
           } else {
               cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageBlank"];
           }
       } else {
           cell.m_imgSelected.hidden = YES;
       }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    if(objImage.image_is_uploaded.boolValue) {
        
        if(self.m_bSelectionMode) {
            [m_arySelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![m_arySelected[indexPath.row] boolValue]]];
            
            [self.m_cltPhoto reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            [self.m_tblPhoto reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationNone];
            [self setMenuViews];
        } else {
            if(objImage.image_photo) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PhotoEditViewController *photoEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditViewController"];
                    photoEditVC.m_objImage = objImage;
                    UINavigationController *photoEditNC = [[UINavigationController alloc] initWithRootViewController:photoEditVC];
                    photoEditNC.navigationBarHidden = YES;
                    [self presentViewController:photoEditNC animated:YES completion:nil];
                });
            } else {
                [self.view makeToast:TOAST_PHOTO_NOT_DOWNLOAD];
            }
        }
    }
}

#pragma mark - CollectionView delegate

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.m_objImageInfo.imageinfo_images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(COLLECTION_CELL_HEIGHT, COLLECTION_CELL_HEIGHT);
}

#pragma mark - CollectionView datasource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    
    HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    [cell setViewsWithImageObj:objImage];
    
    if(self.m_bSelectionMode && objImage.image_is_uploaded.boolValue) {
        cell.m_imgSelected.hidden = NO;
        
        if([m_arySelected[indexPath.row] boolValue]) {
            cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageSelected"];
        } else {
            cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageBlank"];
        }
    } else {
        cell.m_imgSelected.hidden = YES;
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    if(objImage.image_is_uploaded.boolValue) {
        if(self.m_bSelectionMode){
            [m_arySelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![m_arySelected[indexPath.row] boolValue]]];
            
            [self.m_cltPhoto reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            [self.m_tblPhoto reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationNone];
            [self setMenuViews];
        } else {
            m_auto_scroll = NO;
            [self onClickBtnShowType:nil];
            [self.m_tblPhoto scrollToRowAtIndexPath:indexPath
                                   atScrollPosition:UITableViewScrollPositionMiddle
                                           animated:NO];
        }
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnShowType:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.m_btnShowType.selected = !self.m_btnShowType.selected;
        if(self.m_btnShowType.selected) {
            self.m_tblPhoto.alpha = 1.f;
            self.m_cltPhoto.alpha = 0.f;
            
            self.m_viewScroll = self.m_tblPhoto;
        } else {
            self.m_tblPhoto.alpha = 0.f;
            self.m_cltPhoto.alpha = 1.f;
            
            self.m_viewScroll = self.m_cltPhoto;
        }
    }];
}

- (IBAction)onClickBtnShowDropDown:(id)sender {
    TagNPopoverView *viewDropDown = [[[NSBundle mainBundle] loadNibNamed:@"TagNPopoverView" owner:nil options:nil] objectAtIndex:0];
    [viewDropDown setViewsWithImageInfoObj:self.m_objImageInfo onSection:0];
    viewDropDown.delegate = self;
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    } else {
        m_viewPopover = [DXPopover popover];
        m_viewPopover.backgroundColor = [UIColor hx_colorWithHexString:@"2B5763" alpha:0.85f];
        m_viewPopover.maskType = DXPopoverMaskTypeNone;
        m_viewPopover.cornerRadius = 8.f;
        m_viewPopover.arrowSize = CGSizeMake(15.f, 15.f);
        [m_viewPopover showAtView:sender withContentView:viewDropDown inView:self.view];
    }
}

#pragma mark TagNPopoverViewDelegate
- (void)onClickBtnAddPictureWithSection:(NSInteger)section {
    [self hideDropDownMenu];
    
    [[GlobalService sharedInstance].user_me updateActiveTag:self.m_objImageInfo.imageinfo_tag];
    
    UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    UINavigationController *cameraNC = [[UINavigationController alloc] initWithRootViewController:cameraVC];
    cameraNC.navigationBarHidden = YES;
    [self presentViewController:cameraNC animated:NO completion:nil];
}

- (void)onClickBtnDeleteImagesWithSection:(NSInteger)section {
    [self hideDropDownMenu];
    
    self.m_bSelectionMode = YES;
    [self visibleMenu:YES];
}

- (void)onClickBtnDeleteTagWithSection:(NSInteger)section {
    [self hideDropDownMenu];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete TAG"
                                                    message:@"You are about to delete this entire TAG!\nAre you sure you want to delete this TAG?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = DELETE_TAG_ALERT_INDEXES;
    
    [alert show];
}

- (void)onClickBtnMembersWithSection:(NSInteger)section {
    [self hideDropDownMenu];
    
    UIViewController *membersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MembersViewController"];
    [self.navigationController pushViewController:membersVC animated:YES];
}

- (void)onClickBtnTagNStoryWithSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        ImageSelectionViewController *imageSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageSelectionViewController"];
        imageSelectionVC.m_objImageInfo = self.m_objImageInfo;
        UINavigationController *photoEditNC = [[UINavigationController alloc] initWithRootViewController:imageSelectionVC];
        photoEditNC.navigationBarHidden = YES;
        [self presentViewController:photoEditNC animated:NO completion:nil];
    });
}

- (void)hideDropDownMenu {
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    }
}

- (void)visibleMenu:(BOOL)animated {
    if(self.m_bSelectionMode) {
        m_arySelected = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < self.m_objImageInfo.imageinfo_images.count; nIndex++) {
            [m_arySelected addObject:[NSNumber numberWithBool:NO]];
        }
        
        [self setMenuViews];
        
        if(animated) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.m_constraintMenuY.constant = 0;
                                 
                                 [self.view layoutIfNeeded];
                             }];
        } else {
            self.m_constraintMenuY.constant = 0;
        }
    } else {
        if(animated) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.m_constraintMenuY.constant = -50;
                                 [self.view layoutIfNeeded];
                             }];
        } else {
            self.m_constraintMenuY.constant = -50;
        }
    }
    
    [self.m_cltPhoto reloadData];
    [self.m_tblPhoto reloadData];
}

- (void)setMenuViews {
    NSInteger nSelectedPhotos = 0;
    for(int nIndex = 0; nIndex < m_arySelected.count; nIndex++) {
        if([m_arySelected[nIndex] boolValue]) {
            nSelectedPhotos++;
        }
    }
    
    switch (nSelectedPhotos) {
        case 0:
            self.m_lblSelectedPhotos.text = @"No Selected Photos";
            break;
            
        case 1:
            self.m_lblSelectedPhotos.text = @"1 Photo Selected";
            break;
            
        default:
            self.m_lblSelectedPhotos.text = [NSString stringWithFormat:@"%d Photos Selected", (int)nSelectedPhotos];
            break;
    }
}

- (IBAction)onClickBtnMenuDelete:(id)sender {
    NSInteger nSelectedImages = 0;
    for(int nIndex = 0; nIndex < self.m_objImageInfo.imageinfo_images.count; nIndex++) {
        if([m_arySelected[nIndex] boolValue]) {
            nSelectedImages++;
        }
    }
    
    if(nSelectedImages > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Are you sure you want to delete selected images?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = DELETE_IMAGES_ALERT_INDEXES;
        
        [alert show];
    }
}

- (IBAction)onClickBtnMenuCancel:(id)sender {
    self.m_bSelectionMode = NO;
    [self visibleMenu:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if(alertView.tag == DELETE_TAG_ALERT_INDEXES) {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[JHImageService sharedInstance] deleteTagWithId:self.m_objImageInfo.imageinfo_tag.tag_id
                                                      UserId:[GlobalService sharedInstance].user_me.user_id
                                                     success:^(NSString *strResult) {
                                                         SVPROGRESSHUD_DISMISS;
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                     failure:^(NSString *strError) {
                                                         SVPROGRESSHUD_ERROR(strError);
                                                     }];
        } else {
            NSString *strImageIds = @"";
            for(int nIndex = 0; nIndex < self.m_objImageInfo.imageinfo_images.count; nIndex++) {
                ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nIndex];
                if([m_arySelected[nIndex] boolValue]) {
                    strImageIds = [NSString stringWithFormat:@"%@,%d", strImageIds, objImage.image_id.intValue];
                }
            }
            
            if(strImageIds.length > 0) {
                strImageIds = [strImageIds substringFromIndex:1];
            }
            
            SVPROGRESSHUD_PLEASE_WAIT;
            [[JHImageService sharedInstance] deleteImagesWithIds:strImageIds
                                                          UserId:[GlobalService sharedInstance].user_me.user_id
                                                        UserName:[GlobalService sharedInstance].user_me.user_name
                                                           TagId:self.m_objImageInfo.imageinfo_tag.tag_id
                                                         success:^(NSString *strResult) {
                                                             SVPROGRESSHUD_DISMISS;
                                                             
                                                             self.m_bSelectionMode = NO;
                                                             [self visibleMenu:YES];
                                                         }
                                                         failure:^(NSString *strError) {
                                                             SVPROGRESSHUD_ERROR(strError);
                                                         }];
        }
    }
}

#pragma mark - TagNDetailTableViewCellDelegate
- (void)onClickBtnLikeSelected:(BOOL)selected onSection:(NSInteger)nSection {
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nSection];
    NSInteger nImageLikes = objImage.image_likes.integerValue;
    
    if(selected) {
        nImageLikes++;
    } else {
        nImageLikes--;
    }
    
    [[WebService sharedInstance] updateUserLikeWithId:[GlobalService sharedInstance].user_me.user_id
                                             UserName:[GlobalService sharedInstance].user_me.user_name
                                              ImageId:objImage.image_id
                                           ImageTagId:objImage.image_tag_id
                                             Selected:selected
                                              success:^(NSString *strResult) {
                                                  NSLog(@"%@", strResult);
                                              }
                                              failure:^(NSString *strError) {
                                                  NSLog(@"%@", strError);
                                              }];
    
    objImage.image_likes = [NSNumber numberWithInteger:nImageLikes];
    objImage.image_is_like = [NSNumber numberWithBool:selected];
    
    [self.m_tblPhoto reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nSection inSection:0]]
                           withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)onClickBtnDownload:(NSInteger)nSection {
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nSection];
    if(objImage.image_photo) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary  saveImage:objImage.image_photo
                          toAlbum:APP_NAME
                       completion:^(NSURL *assetURL, NSError *error) {
                           [self.view makeToast:@"Saved image successfully"];
                       }
                          failure:^(NSError *error) {
                              [self.view makeToast:@"Failed to save image"];
                          }];

    } else {
        [self.view makeToast:TOAST_PHOTO_NOT_DOWNLOAD];
    }
}

- (void)onClickBtnComment:(NSInteger)nSection {
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nSection];
    
    CommentViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentVC.m_objImage = objImage;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)onClickBtnLikes:(NSInteger)nSection {
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nSection];
    
    LikesViewController *likesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikesViewController"];
    likesVC.m_objImage = objImage;
    [self.navigationController pushViewController:likesVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(m_auto_scroll) {
        [super scrollViewDidScroll:scrollView];
    } else {
        m_auto_scroll = YES;
    }
}

@end
