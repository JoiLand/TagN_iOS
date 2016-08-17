//
//  ImageOrderViewController.m
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ImageOrderViewController.h"
#import "HomeDetailCollectionViewCell.h"

#define COLLECTION_CELL_HEIGHT      self.view.frame.size.width / 3 - 2

@interface ImageOrderViewController ()

@end

@implementation ImageOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryTmpImages = [NSMutableArray arrayWithArray:self.m_aryImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view makeToast:@"Hold down for a moment to unlock the image"
                duration:3.f
                position:CSToastPositionCenter];
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
    return m_aryTmpImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(COLLECTION_CELL_HEIGHT, COLLECTION_CELL_HEIGHT);
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageObj *objImage = m_aryTmpImages[indexPath.row];
    
    HomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDetailCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    [cell setViewsWithImageObj:objImage];
    cell.m_imgSelected.hidden = YES;
    
    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    ImageObj *objImage = m_aryTmpImages[fromIndexPath.item];
    
    [m_aryTmpImages removeObjectAtIndex:fromIndexPath.item];
    [m_aryTmpImages insertObject:objImage atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_aryImages setArray:m_aryTmpImages];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
