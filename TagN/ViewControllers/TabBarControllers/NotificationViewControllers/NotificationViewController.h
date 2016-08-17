//
//  NotificationViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestNotificationTableCell.h"
#import "ImageNotificationTableCell.h"

@interface NotificationViewController : JHParallaxViewController<RequestNotificationTableCellDelegate, ImageNotificationTableCellDelegate> {
    NSMutableArray      *m_aryNewNotifications;
    NSMutableArray      *m_aryOldNotifications;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblNotification;

- (IBAction)onClickBtnSettings:(id)sender;

@end
