//
//  TagEditViewController.h
//  TagN
//
//  Created by JH Lee on 2/8/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TKAutoCompleteTextField/TKAutoCompleteTextField.h>

@interface TagEditViewController : UIViewController {
    TagObj                  *m_nSelectedTag;
}

@property (weak, nonatomic) IBOutlet UILabel                    *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIButton                   *m_btnNext;
@property (weak, nonatomic) IBOutlet TKAutoCompleteTextField    *m_txtInputTag;
@property (weak, nonatomic) IBOutlet UITableView *m_tblRecentTags;

@property (nonatomic, readwrite) BOOL                           m_isAdd;
@property (nonatomic, retain) NSArray                           *m_aryPhotos;

- (IBAction)onTouchDownNext:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onTouchUpNext:(id)sender;

@end
