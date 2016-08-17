//
//  ResponseNotificationTableCell.h
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseNotificationTableCell : UITableViewCell {
    NSNumber    *m_share_id;
}

@property (weak, nonatomic) IBOutlet TagNImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblString;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

- (void)setViewsWithNotiObj:(NotiObj *)objNoti;

@end
