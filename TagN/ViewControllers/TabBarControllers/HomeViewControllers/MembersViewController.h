//
//  MembersViewController.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberTableViewCell.h"

@interface MembersViewController : UIViewController<UIAlertViewDelegate, MemberTableViewCellDelegate> {
    NSMutableArray  *m_aryTagUsers;
    NSMutableArray  *m_aryTmpUsers;
    NSMutableArray  *m_aryIndexTitles;
    
    NSIndexPath     *m_indexPath;
    TagObj          *m_objTag;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtSearch;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblMember;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnDelete;
@property (weak, nonatomic) IBOutlet UIView         *m_viewFooterView;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnSearch:(id)sender;
- (IBAction)onClickBtnDelete:(id)sender;


@end
