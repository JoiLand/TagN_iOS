//
//  ImageSelectionViewController.m
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageSelectionViewController.h"
#import "HomeDetailCollectionViewCell.h"
#import "StoryPreviewViewController.h"

#define COLLECTION_CELL_HEIGHT      self.view.frame.size.width / 3 - 2

@interface ImageSelectionViewController ()

@end

@implementation ImageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_arySelected = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < self.m_objImageInfo.imageinfo_images.count; nIndex++) {
        [m_arySelected addObject:[NSNumber numberWithBool:NO]];
    }
    
    self.m_btnSelectAll.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.m_lblTitle.text = self.m_objImageInfo.imageinfo_tag.tag_text;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setMenuViews];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.m_objImageInfo.imageinfo_images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(COLLECTION_CELL_HEIGHT, COLLECTION_CELL_HEIGHT);
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    
    HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    [cell.m_imgPhoto setImageWithObj:objImage withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
    if(objImage.image_is_uploaded) {
        cell.m_imgUploadingStatus.alpha = 0.f;
    } else {
        cell.m_imgUploadingStatus.alpha = 0.7f;
    }
    cell.m_imgSelected.hidden = NO;
    
    if([m_arySelected[indexPath.row] boolValue]) {
        cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageSelected"];
    } else {
        cell.m_imgSelected.image = [UIImage imageNamed:@"common_iconImageBlank"];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageObj *objImage = self.m_objImageInfo.imageinfo_images[indexPath.row];
    
    if([self isOverMaxLimitImageSize]) {
        [self.view makeToast:TOAST_OVER_STORY_IMAGES(STORY_MAX_IMAGES) duration:3.f position:CSToastPositionCenter];
    } else {
        if(objImage.image_is_uploaded.boolValue && objImage.image_photo) {
            [m_arySelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![m_arySelected[indexPath.row] boolValue]]];
            [self.m_cltPhoto reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            [self setMenuViews];
        }
    }
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
            self.m_lblStatus.text = @"No Selected Photos";
            break;
            
        case 1:
            self.m_lblStatus.text = @"1 Photo Selected";
            break;
            
        default:
            self.m_lblStatus.text = [NSString stringWithFormat:@"%d Photos Selected", (int)nSelectedPhotos];
            break;
    }
    
    if(nSelectedPhotos == 0) {
        self.m_btnNext.backgroundColor = [UIColor clearColor];
        [self.m_btnNext setImage:[UIImage imageNamed:@"common_btnNext"] forState:UIControlStateNormal];
        self.m_btnNext.userInteractionEnabled = NO;
    } else {
        self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
        [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
        self.m_btnNext.userInteractionEnabled = YES;
    }
}

- (BOOL)isOverMaxLimitImageSize {
    NSInteger nImageCount = 0;
    for(NSNumber *bSelected in m_arySelected) {
        if(bSelected.boolValue) {
            nImageCount++;
        }
    }
    
    if(nImageCount > STORY_MAX_IMAGES) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onClickBtnNext:(id)sender {
    NSMutableArray *arySelectedImages = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < self.m_objImageInfo.imageinfo_images.count; nIndex++) {
        if([m_arySelected[nIndex] boolValue]) {
            [arySelectedImages addObject:self.m_objImageInfo.imageinfo_images[nIndex]];
        }
    }
    
    if(arySelectedImages.count == 0) {
        [self.view makeToast:TOAST_NO_SELECTED_PHOTO duration:3.f position:CSToastPositionCenter];
    } else {
        StoryPreviewViewController *storyPreviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPreviewViewController"];
        storyPreviewVC.m_aryImages = arySelectedImages;
        [self.navigationController pushViewController:storyPreviewVC animated:YES];
    }
}

- (IBAction)onClickBtnSelectAll:(id)sender {
    self.m_btnSelectAll.selected = !self.m_btnSelectAll.selected;
    
    if(self.m_btnSelectAll.selected) {
        NSInteger nMaxImages = STORY_MAX_IMAGES > self.m_objImageInfo.imageinfo_images.count? self.m_objImageInfo.imageinfo_images.count:STORY_MAX_IMAGES;
        for(int nIndex = 0; nIndex < nMaxImages; nIndex++) {
            ImageObj *objImage = self.m_objImageInfo.imageinfo_images[nIndex];
            if(objImage.image_is_uploaded.boolValue && objImage.image_photo) {
                [m_arySelected replaceObjectAtIndex:nIndex withObject:[NSNumber numberWithBool:YES]];
            }
        }
    } else {
        for(int nIndex = 0; nIndex < m_arySelected.count; nIndex++) {
            [m_arySelected replaceObjectAtIndex:nIndex withObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self setMenuViews];
    [self.m_cltPhoto reloadData];
}

@end
