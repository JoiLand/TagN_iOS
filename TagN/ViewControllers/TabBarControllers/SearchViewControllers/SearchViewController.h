//
//  SearchViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TKAutoCompleteTextField/TKAutoCompleteTextField.h>

@interface SearchViewController : UIViewController {
    NSMutableArray      *m_aryTags;
}

@property (weak, nonatomic) IBOutlet TKAutoCompleteTextField *m_txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *m_tblTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintTableBottom;

- (IBAction)onClickBtnSettings:(id)sender;
- (IBAction)onClickBtnSearch:(id)sender;

@end
