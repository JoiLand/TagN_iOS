//
//  StoryPreviewViewController.h
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNStoryRender.h"

@interface StoryPreviewViewController : UIViewController {
    NSInteger       m_nSelectedQueue;
    NSInteger       m_nSelectedFilter;
    NSArray         *m_aryFilterNames;
    
    float           m_fSpeed;
    BOOL            m_isPlay;
    
    TagNStoryRender *render;
}

@property (nonatomic, retain) NSMutableArray       *m_aryImages;

@property (weak, nonatomic) IBOutlet UIView *m_viewPreview;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cltImageQueue;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cltFilter;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (weak, nonatomic) IBOutlet UISlider *m_swtSpeed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintMenuBottom;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSpeed;
@property (weak, nonatomic) IBOutlet UIButton *m_btnTransition;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnReorder:(id)sender;
- (IBAction)onClickBtnChangeSpeed:(id)sender;
- (IBAction)onClickBtnChangeTransition:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnPlay:(id)sender;
- (IBAction)onChangeSpeed:(id)sender;

@end
