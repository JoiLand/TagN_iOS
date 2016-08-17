//
//  HomeDetailViewController.h
//  TagN
//
//  Created by JH Lee on 2/10/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNDetailTableViewCell.h"
#import "TagNPopoverView.h"

@interface HomeDetailViewController : JHParallaxViewController<UIAlertViewDelegate, TagNDetailTableViewCellDelegate, TagNPopoverViewDelegate> {
    NSMutableArray          *m_arySelected;
    BOOL                    m_auto_scroll;
    
    DXPopover               *m_viewPopover;
}

@property (weak, nonatomic) IBOutlet UIButton           *m_btnShowType;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITableView        *m_tblPhoto;
@property (weak, nonatomic) IBOutlet UICollectionView   *m_cltPhoto;

@property (weak, nonatomic) IBOutlet UILabel            *m_lblSelectedPhotos;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnCancel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintMenuY;

@property (nonatomic, readwrite) ImageInfoObj           *m_objImageInfo;
@property (nonatomic, readwrite) BOOL                   m_bSelectionMode;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnShowType:(id)sender;
- (IBAction)onClickBtnShowDropDown:(id)sender;

- (IBAction)onClickBtnMenuDelete:(id)sender;
- (IBAction)onClickBtnMenuCancel:(id)sender;

@end
