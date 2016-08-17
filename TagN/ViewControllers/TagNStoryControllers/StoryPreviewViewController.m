//
//  StoryPreviewViewController.m
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "StoryPreviewViewController.h"
#import "ImageOrderViewController.h"
#import "HomeDetailCollectionViewCell.h"
#import <YLGIFImage/YLImageView.h>
#import <YLGIFImage/YLGIFImage.h>
#import "StoryShareViewController.h"
#import <GPUImage/GPUImage.h>

#define COLLECTION_CELL_HEIGHT          40
#define MAX_FRAME_SEC                   3.f

@interface StoryPreviewViewController ()

@end

@implementation StoryPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_nSelectedFilter = 0;
    m_aryFilterNames = @[
                         [[GPUImageFilter alloc] init],
                         [[GPUImageGammaFilter alloc] init],
                         [[GPUImagePinchDistortionFilter alloc] init],
                         [[GPUImageGaussianBlurPositionFilter alloc] init],
                         [[GPUImageGrayscaleFilter alloc] init],
                         [[GPUImagePixellateFilter alloc] init],
                         [[GPUImageSketchFilter alloc] init]
                         ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    m_fSpeed = 1.5f;
    self.m_swtSpeed.value = (MAX_FRAME_SEC - m_fSpeed) * 10;
    
    m_nSelectedQueue = 0;
    m_isPlay = NO;
    self.m_btnPlay.hidden = NO;
    
    for(UIView *view in self.m_viewPreview.subviews) {
        [view removeFromSuperview];
    }
    
    for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++) {
        ImageObj *objImage = self.m_aryImages[nIndex];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        NSString *strMagick = [NSString stringWithFormat:@"%dx%d", (int)CGRectGetWidth(self.view.frame), (int)CGRectGetHeight(self.view.frame)];
        imageView.image = [objImage.image_photo resizedImageByMagick:strMagick];
        
        imageView.tag = 10 + nIndex;
        imageView.alpha = 0.f;
        [self.m_viewPreview insertSubview:imageView atIndex:0];
    }
    
    UIImageView *firstView = [self.m_viewPreview viewWithTag:10 + m_nSelectedQueue];
    firstView.alpha = 1.f;
    
    [self.m_cltImageQueue reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - CollectionView delegate

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.m_cltImageQueue) {
        return self.m_aryImages.count + 1;
    } else {
        return m_aryFilterNames.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.m_cltImageQueue) {
        if(indexPath.item == self.m_aryImages.count) {
            return CGSizeMake(COLLECTION_CELL_HEIGHT * 3, COLLECTION_CELL_HEIGHT);
        } else {
            return CGSizeMake(COLLECTION_CELL_HEIGHT, COLLECTION_CELL_HEIGHT);
        }
    } else {
        return CGSizeMake(COLLECTION_CELL_HEIGHT * 1.5f, COLLECTION_CELL_HEIGHT * 1.5f);
    }
}

#pragma mark - CollectionView datasource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.m_cltImageQueue) {
        if(indexPath.item < self.m_aryImages.count) {
            HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                           forIndexPath:indexPath];
            
            UIImageView *imageView = [self.m_viewPreview viewWithTag:10 + indexPath.item];
            
            if(imageView) {
                cell.m_imgPhoto.layer.masksToBounds = YES;
                cell.m_imgPhoto.layer.borderWidth = 3.f;
                
                if(m_nSelectedQueue == indexPath.item) {
                    cell.m_imgPhoto.layer.borderColor = [UIColor redColor].CGColor;
                } else {
                    cell.m_imgPhoto.layer.borderColor = [UIColor clearColor].CGColor;
                }
                
                
                cell.m_imgPhoto.image = imageView.image;
                cell.m_imgSelected.hidden = YES;
            }
            
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCollectionViewCell"
                                                                                   forIndexPath:indexPath];
            
            return cell;
        }
    } else {
        
        HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                       forIndexPath:indexPath];
        
        cell.m_imgPhoto.layer.masksToBounds = YES;
        cell.m_imgPhoto.layer.borderWidth = 3.f;
        
        if(m_nSelectedFilter == indexPath.item) {
            cell.m_imgPhoto.layer.borderColor = [UIColor redColor].CGColor;
        } else {
            cell.m_imgPhoto.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        ImageObj *objImage = self.m_aryImages[0];
        [cell.m_imgPhoto setImageThumbWithObj:objImage withPlaceholder:IMAGE_PLACEHOLDER_URL_STRING];
        UIImage *quickFilteredImage = [m_aryFilterNames[indexPath.item] imageByFilteringImage:cell.m_imgPhoto.image];
        cell.m_imgPhoto.image = quickFilteredImage;
        
        return cell;
    }
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.m_cltImageQueue) {
        if(indexPath.item < self.m_aryImages.count) {
            m_nSelectedQueue = indexPath.item;
            
            for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++) {
                UIScrollView *scrollView = [self.m_viewPreview viewWithTag:10 + nIndex];
                scrollView.alpha = 0.f;
            }
            
            UIScrollView *scrollView = [self.m_viewPreview viewWithTag:10 + m_nSelectedQueue];
            scrollView.alpha = 1.f;
            
            m_isPlay = NO;
            self.m_btnPlay.hidden = NO;
            
            [self.m_cltImageQueue reloadData];
        }
    } else {
        m_nSelectedFilter = indexPath.item;
        [self.m_cltFilter reloadData];
        
        for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++) {
            ImageObj *objImage = self.m_aryImages[nIndex];
            
            UIImageView *imageView = [self.m_viewPreview viewWithTag:10 + nIndex];
            
            NSString *strMagick = [NSString stringWithFormat:@"%dx%d", (int)CGRectGetWidth(self.view.frame), (int)CGRectGetHeight(self.view.frame)];
            UIImage *image = [objImage.image_photo resizedImageByMagick:strMagick];
            
            GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            
            [stillImageSource addTarget:m_aryFilterNames[m_nSelectedFilter]];
            [m_aryFilterNames[m_nSelectedFilter] useNextFrameForImageCapture];
            [stillImageSource processImage];
            
            imageView.image = [m_aryFilterNames[m_nSelectedFilter] imageFromCurrentFramebuffer];
        }
        
        [self.m_cltImageQueue reloadData];
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnReorder:(id)sender {
    ImageOrderViewController *imageOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageOrderViewController"];
    imageOrderVC.m_aryImages = self.m_aryImages;
    [self.navigationController pushViewController:imageOrderVC animated:YES];
}

- (IBAction)onClickBtnChangeSpeed:(id)sender {
    UIButton *btnSpeed = (UIButton *)sender;
    btnSpeed.selected = !btnSpeed.selected;
    
    [UIView animateWithDuration:0.3f animations:^{
        if(btnSpeed.selected) {
            self.m_btnTransition.selected = NO;
            self.m_constraintMenuBottom.constant = 64.f;
            
            self.m_swtSpeed.hidden = NO;
            self.m_cltFilter.hidden = YES;
            
        } else {
            self.m_constraintMenuBottom.constant = 0;
        }
        
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onClickBtnChangeTransition:(id)sender {
    UIButton *btnTransition = (UIButton *)sender;
    btnTransition.selected = !btnTransition.selected;
    
    [UIView animateWithDuration:0.3f animations:^{
        if(btnTransition.selected) {
            self.m_btnSpeed.selected = NO;
            self.m_constraintMenuBottom.constant = 64.f;
            
            self.m_swtSpeed.hidden = YES;
            self.m_cltFilter.hidden = NO;
            
        } else {
            self.m_constraintMenuBottom.constant = 0;
        }
        
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onClickBtnNext:(id)sender {
    // start render video
    [SVProgressHUD showWithStatus:@"Rendering Story..."];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *aryImages = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++) {
            UIImageView *imageView = [self.m_viewPreview viewWithTag:10 + nIndex];
            [aryImages addObject:imageView.image];
        }
        
        render = [[TagNStoryRender alloc] init];
        render.speed = m_fSpeed;
        [render createStoryFromImages:aryImages
                       withCompletion:^(NSURL *fileURL) {
                           SVPROGRESSHUD_DISMISS;
                           render = nil;
                           
                           //for test, save video on camera roll
                           StoryShareViewController *storyShareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryShareViewController"];
                           storyShareVC.m_videoUrl = fileURL;
                           [self.navigationController pushViewController:storyShareVC animated:YES];
                       }];
    });
}

- (IBAction)onClickBtnPlay:(id)sender {
    m_isPlay = !m_isPlay;
    
    if(m_isPlay) {
        self.m_btnPlay.hidden = YES;
        [self performSelector:@selector(moveToNextPhoto) withObject:nil afterDelay:m_fSpeed];
    } else {
        self.m_btnPlay.hidden = NO;
    }
}

- (void)moveToNextPhoto {
    if(m_isPlay) {
        if(m_nSelectedQueue < self.m_aryImages.count - 1) {
            
            UIImageView *fromView = [self.m_viewPreview viewWithTag:10 + m_nSelectedQueue];
            UIImageView *toView = [self.m_viewPreview viewWithTag:10 + (m_nSelectedQueue + 1)];
            
            fromView.alpha = 0.f;
            toView.alpha = 1.f;
            
            m_nSelectedQueue++;
            
            [self.m_cltImageQueue reloadData];
            
            NSInteger nScrollPosition = 0;
            if(m_nSelectedQueue > 3) {
                nScrollPosition = m_nSelectedQueue - 3;
            }
            
            [self.m_cltImageQueue scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nScrollPosition inSection:0]
                                         atScrollPosition:UICollectionViewScrollPositionLeft
                                                 animated:YES];
            
            [self performSelector:@selector(moveToNextPhoto) withObject:nil afterDelay:m_fSpeed];
        } else {
            m_isPlay = NO;
            self.m_btnPlay.hidden = NO;
            m_nSelectedQueue = 0;
            
            [self.m_cltImageQueue reloadData];
            [self.m_cltImageQueue scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                         atScrollPosition:UICollectionViewScrollPositionLeft
                                                 animated:NO];
            
            for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++) {
                UIImageView *imageView = [self.m_viewPreview viewWithTag:10 + nIndex];
                imageView.alpha = 0.f;
            }
            
            UIImageView *imageView = [self.m_viewPreview viewWithTag:10 + m_nSelectedQueue];
            imageView.alpha = 1.f;
        }
    }
}

- (IBAction)onChangeSpeed:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    m_fSpeed = MAX_FRAME_SEC - slider.value / 10.f + 0.1f;
}

@end
