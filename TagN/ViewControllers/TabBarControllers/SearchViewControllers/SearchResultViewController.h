//
//  SearchResultViewController.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : JHParallaxViewController {
    BOOL                m_bSelectedTag;
    NSMutableArray      *m_aryTagPhotos;
    NSMutableArray      *m_aryTimePhotos;
}

@property (weak, nonatomic) IBOutlet UIButton *m_btnTag;
@property (weak, nonatomic) IBOutlet UIButton *m_btnTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintMarkerX;
@property (weak, nonatomic) IBOutlet UITableView *m_tblTag;
@property (weak, nonatomic) IBOutlet UITableView *m_tblTime;
@property (weak, nonatomic) IBOutlet UIScrollView *m_sclMain;

@property (nonatomic, retain) NSArray       *m_aryImages;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnTime:(id)sender;
- (IBAction)onClickBtnTag:(id)sender;

@end
