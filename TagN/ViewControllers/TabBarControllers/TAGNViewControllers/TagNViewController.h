//
//  TagNViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNHeaderView.h"
#import "TagNPopoverView.h"


@interface TagNViewController : JHParallaxViewController<TagNHeaderViewDelegate, TagNPopoverViewDelegate, UIAlertViewDelegate> {
    NSInteger               m_nSelectedSection;
    NSInteger               m_nCurrentPageNum;
    
    DXPopover               *m_viewPopover;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblShareTags;
@property (weak, nonatomic) IBOutlet UIButton *m_btnViewMoreTags;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_activityView;

- (IBAction)onClickBtnSetting:(id)sender;
- (IBAction)onClickBtnAddTag:(id)sender;
- (IBAction)onClickBtnViewMoreTags:(id)sender;

@end
