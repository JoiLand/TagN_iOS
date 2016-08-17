//
//  SearchDetailViewController.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "TagNDetailHeaderView.h"
#import "CommentViewController.h"
#import "HomeDetailCollectionViewCell.h"
#import "ShareImageViewController.h"
#import "LikesViewController.h"
#import "PhotoEditViewController.h"

@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController

#define TAGN_HEADERVIEW_HEIGHT      50
#define TABLE_CELL_HEIGHT           self.view.frame.size.width / 320 * 412
#define TABLE_CELL_VIEW_HEIGHT      90
#define COLLECTION_CELL_HEIGHT      self.view.frame.size.width / 3 - 2

#define COMMENT_LABEL_WIDTH         self.view.frame.size.width - 20

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblPhoto.hidden = YES;
    self.m_cltPhoto.hidden = NO;
    
    self.m_viewScroll = self.m_cltPhoto;
    
    self.m_lblTitle.text = self.m_dicPhotos[@"header"];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_tblPhoto reloadData];
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TAGN_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ImageObj *objImage = self.m_dicPhotos[@"contents"][section];
    
    TagNDetailHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TagNDetailHeaderView" owner:nil options:nil] objectAtIndex:0];
    [headerView setViewWithImageObj:objImage];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.m_dicPhotos[@"contents"] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_dicPhotos[@"contents"][indexPath.section];
    
    float xRatio = self.view.frame.size.width / objImage.image_width.floatValue;
    CGFloat imgHeight = objImage.image_height.floatValue * xRatio;
    CGFloat lblCommentHeight = [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]
                                                                   withLabelWidth:COMMENT_LABEL_WIDTH];
    
    return imgHeight + TABLE_CELL_VIEW_HEIGHT + lblCommentHeight;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_dicPhotos[@"contents"][indexPath.section];
    
    TagNDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TagNDetailTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithImageObj:objImage onSection:indexPath.section];
    [cell.m_lblComment setAttributedText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]];
    cell.m_constraintViewHeight.constant += [[GlobalService sharedInstance] labelHeightForText:[[GlobalService sharedInstance] makeCommentsWithData:objImage.image_last_2_comments]
                                                                                withLabelWidth:COMMENT_LABEL_WIDTH];
    cell.delegate = self;
    
    cell.m_imgSelected.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageObj *objImage = self.m_dicPhotos[@"contents"][indexPath.section];
    
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

#pragma mark - TagNDetailTableViewCellDelegate
- (void)onClickBtnLikeSelected:(BOOL)selected onSection:(NSInteger)nSection {
    ImageObj *objImage = self.m_dicPhotos[@"contents"][nSection];
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
    
    [self.m_tblPhoto reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:nSection]]
                           withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)onClickBtnDownload:(NSInteger)nSection {
    ImageObj *objImage = self.m_dicPhotos[@"contents"][nSection];
    if(objImage.image_photo) {
        UIImageWriteToSavedPhotosAlbum(objImage.image_photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
    ImageObj *objImage = self.m_dicPhotos[@"contents"][nSection];
    
    CommentViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentVC.m_objImage = objImage;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)onClickBtnLikes:(NSInteger)nSection {
    ImageObj *objImage = self.m_dicPhotos[@"contents"][nSection];
    
    LikesViewController *likesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikesViewController"];
    likesVC.m_objImage = objImage;
    [self.navigationController pushViewController:likesVC animated:YES];
}

#pragma mark - CollectionView delegate

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.m_dicPhotos[@"contents"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(COLLECTION_CELL_HEIGHT, COLLECTION_CELL_HEIGHT);
}

#pragma mark - CollectionView datasource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageObj *objImage = self.m_dicPhotos[@"contents"][indexPath.row];
    
    HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    [cell setViewsWithImageObj:objImage];
    
    cell.m_imgSelected.hidden = YES;
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_dicPhotos[@"contents"][indexPath.row];
    ShareImageViewController *shareImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareImageViewController"];
    shareImageVC.m_objImage = objImage;
    [self.navigationController pushViewController:shareImageVC animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnShowType:(id)sender {
    self.m_btnShowType.selected = !self.m_btnShowType.selected;
    if(self.m_btnShowType.selected) {
        self.m_tblPhoto.hidden = NO;
        self.m_cltPhoto.hidden = YES;
        
        self.m_viewScroll = self.m_tblPhoto;
    } else {
        self.m_tblPhoto.hidden = YES;
        self.m_cltPhoto.hidden = NO;
        
        self.m_viewScroll = self.m_cltPhoto;
    }
}

@end
