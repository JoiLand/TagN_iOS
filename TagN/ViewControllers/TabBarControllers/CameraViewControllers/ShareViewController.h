//
//  ShareViewController.h
//  TagN
//
//  Created by JH Lee on 2/8/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <TMTumblrSDK/TMAPIClient.h>
#import "MemberTableViewCell.h"

@interface ShareViewController : UIViewController<UIDocumentInteractionControllerDelegate, MemberTableViewCellDelegate> {
    NSArray         *m_aryShareButtonNames;
    NSMutableArray  *m_aryTagUsers;
    NSMutableArray  *m_aryTmpUsers;
    NSMutableArray  *m_aryIndexTitles;
}

@property (nonatomic, retain) NSArray                   *m_aryPhotos;

@property (weak, nonatomic) IBOutlet UITextField        *m_txtSearch;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnNext;
@property (weak, nonatomic) IBOutlet UITableView        *m_tblShare;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblUsers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintUserHeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserNames;

- (IBAction)onClickBtnSearch:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onTouchDownNext:(id)sender;
- (IBAction)onTouchUpNext:(id)sender;

- (IBAction)onTouchUpBtnShare:(id)sender;

@end
