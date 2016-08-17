//
//  MemberTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberTableViewCellDelegate <NSObject>

- (void)onClickBtnActioWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MemberTableViewCell : UITableViewCell {
    NSIndexPath     *m_indexPath;
}

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAction;
@property (weak, nonatomic) IBOutlet UILabel *m_lblState;
@property (weak, nonatomic) IBOutlet UIImageView *m_iconContact;

@property (nonatomic, retain) id<MemberTableViewCellDelegate> delegate;

- (IBAction)onTouchUpBtnAction:(id)sender;
- (void)setViewsWithUserObj:(UserObj *)objUser TagObj:(TagObj *)objTag onIndexPath:(NSIndexPath *)indexPath;

@end
