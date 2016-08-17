//
//  ImageNotificationTableCell.h
//  TagN
//
//  Created by JH Lee on 2/17/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageNotificationTableCellDelegate <NSObject>

- (void)onTapImage:(ImageObj *)objImage;

@end

@interface ImageNotificationTableCell : UITableViewCell{
    ImageObj             *m_objImage;
}


@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblString;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;

@property (nonatomic, retain) id<ImageNotificationTableCellDelegate> delegate;

- (IBAction)onTapImage:(id)sender;
- (void)setViewsWithNotiObj:(NotiObj *)objNoti;

@end
