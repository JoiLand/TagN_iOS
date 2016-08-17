//
//  TagNDetailTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/13/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagNDetailTableViewCellDelegate <NSObject>

- (void)onClickBtnLikeSelected:(BOOL)selected onSection:(NSInteger)nSection;
- (void)onClickBtnComment:(NSInteger)nSection;
- (void)onClickBtnDownload:(NSInteger)nSection;
- (void)onClickBtnLikes:(NSInteger)nSection;

@end

@interface TagNDetailTableViewCell : UITableViewCell {
    NSInteger   m_nSection;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgUploadingStatus;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgSelected;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLike;
@property (weak, nonatomic) IBOutlet UIButton *m_btnDownload;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLikes;
@property (weak, nonatomic) IBOutlet UILabel *m_lblComment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewHeight;

@property (nonatomic, retain) id<TagNDetailTableViewCellDelegate> delegate;

- (IBAction)onClickBtnLike:(id)sender;
- (IBAction)onClickBtnComment:(id)sender;
- (IBAction)onClickBtnDownload:(id)sender;
- (IBAction)onClickBtnLikes:(id)sender;

- (void)setViewsWithImageObj:(ImageObj *)objImage onSection:(NSInteger)section;

@end
