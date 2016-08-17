//
//  HomeViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNHeaderView.h"
#import "TagNPopoverView.h"

@interface HomeViewController : JHParallaxViewController<TagNHeaderViewDelegate, TagNPopoverViewDelegate, UIAlertViewDelegate> {
    NSInteger               m_nSelectedSection;
    NSInteger               m_nCurrentPageNum;
    DXPopover               *m_viewPopover;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblMyTags;
@property (weak, nonatomic) IBOutlet UIButton *m_btnViewMoreTags;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_activityView;

- (IBAction)onClickBtnAddTag:(id)sender;
- (IBAction)onClickBtnSettings:(id)sender;
- (IBAction)onClickBtnViewMoreTags:(id)sender;

@end
