//
//  ImageSelectionViewController.h
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "JHParallaxViewController.h"

@interface ImageSelectionViewController : JHParallaxViewController {
    NSMutableArray          *m_arySelected;
}

@property (weak, nonatomic) IBOutlet UICollectionView   *m_cltPhoto;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblStatus;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnSelectAll;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNext;

@property (nonatomic, readwrite) ImageInfoObj           *m_objImageInfo;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnSelectAll:(id)sender;

@end
