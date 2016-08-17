//
//  ImageOrderViewController.h
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "JHParallaxViewController.h"
#import <LXReorderableCollectionViewFlowLayout/LXReorderableCollectionViewFlowLayout.h>

@interface ImageOrderViewController : JHParallaxViewController<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout> {
    NSMutableArray      *m_aryTmpImages;
}

@property (weak, nonatomic) IBOutlet UICollectionView *m_ctlPhoto;

@property (nonatomic, retain) NSMutableArray       *m_aryImages;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;

@end
