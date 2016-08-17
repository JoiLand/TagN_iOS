//
//  RequestNotificationTableCell.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestNotificationTableCellDelegate <NSObject>

- (void)onClickBtnAccpet:(NSIndexPath *)indexPath;
- (void)onClickBtnDecline:(NSIndexPath *)indexPath;

@end

@interface RequestNotificationTableCell : UITableViewCell {
    NSIndexPath             *m_indexPath;
}

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblString;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

@property (nonatomic, retain) id<RequestNotificationTableCellDelegate> delegate;

- (IBAction)onClickBtnAccept:(id)sender;
- (IBAction)onClickBtnDecline:(id)sender;

- (void)setViewsWithNotiObj:(NotiObj *)objNoti onIndexPath:(NSIndexPath *)indexPath;

@end
