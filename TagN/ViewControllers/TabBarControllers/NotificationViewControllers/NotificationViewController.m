//
//  NotificationViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "NotificationViewController.h"
#import "ResponseNotificationTableCell.h"
#import "ShareImageViewController.h"
#import "MemberHeaderView.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

#define NOTIFICATION_CELL_HEIGHT      60
#define NOTI_HEADER_VIEW_HEIGHT       30

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGetNotification)
                                                 name:NOTIFICATION_GET_NOTIFICATION
                                               object:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshNotification:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblNotification addSubview:refresh];
}

- (void)onRefreshNotification:(UIRefreshControl *)refresh {
    [[WebService sharedInstance] getAllNotificationsWithUserId:[GlobalService sharedInstance].user_me.user_id
                                                       success:^(NSArray *aryNotis) {
                                                           [refresh endRefreshing];
                                                           [GlobalService sharedInstance].user_me.user_notifications = [aryNotis mutableCopy];
                                                           [self reloadNotifications];
                                                       }
                                                       failure:^(NSString *strError) {
                                                           NSLog(@"%@", strError);
                                                           [refresh endRefreshing];
                                                       }];
}

- (void)onGetNotification {
    [self reloadNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GlobalService sharedInstance] setNotificationBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self reloadNotifications];
    
    if(m_aryNewNotifications.count > 0) {   //if exist new notifications
        [[WebService sharedInstance] markAllNotificationsAsRead:[GlobalService sharedInstance].user_me.user_id
                                                        success:^(NSString *strResult) {
                                                            NSLog(@"%@", strResult);
                                                            for(int nIndex = 0; nIndex < [GlobalService sharedInstance].user_me.user_notifications.count; nIndex++) {
                                                                NotiObj *objNoti = [GlobalService sharedInstance].user_me.user_notifications[nIndex];
                                                                objNoti.noti_is_read = YES;
                                                            }
                                                        }
                                                        failure:^(NSString *strError) {
                                                            NSLog(@"%@", strError);
                                                        }];
    }
}

- (void)reloadNotifications {
    m_aryNewNotifications = [[NSMutableArray alloc] init];
    m_aryOldNotifications = [[NSMutableArray alloc] init];
    
    for(int nIndex = 0; nIndex < [GlobalService sharedInstance].user_me.user_notifications.count; nIndex++) {
        NotiObj *objNoti = [GlobalService sharedInstance].user_me.user_notifications[nIndex];
        
        //check user notificaiton settings
        if([[GlobalService sharedInstance] isAvailableNotification:objNoti]) {
            if(objNoti.noti_is_read) {
                [m_aryOldNotifications addObject:objNoti];
            } else {
                [m_aryNewNotifications addObject:objNoti];
            }
        }
    }
    
    [self.m_tblNotification reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(m_aryNewNotifications.count > 0) {
        return NOTI_HEADER_VIEW_HEIGHT;
    } else {
        return 0.1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MemberHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MemberHeaderView" owner:nil options:nil] objectAtIndex:0];
    if(section == 0) {
        headerView.m_lblTitle.text = @"New";
    } else {
        headerView.m_lblTitle.text = @"Previous";
    }
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return m_aryNewNotifications.count;
    } else {
        return m_aryOldNotifications.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NOTIFICATION_CELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotiObj *objNoti;
    
    if(indexPath.section == 0) {
        objNoti = m_aryNewNotifications[indexPath.row];
    } else {
        objNoti = m_aryOldNotifications[indexPath.row];
    }
    
    if(objNoti.noti_type == TAGN_PUSH_SHARE_REQUEST) {
        RequestNotificationTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestNotificationTableCell" owner:nil options:nil] objectAtIndex:0];
        [cell setViewsWithNotiObj:objNoti onIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    } else if(objNoti.noti_type == TAGN_PUSH_UPLOAD_PHOTO
              || objNoti.noti_type == TAGN_PUSH_LIKED_IMAGE
              || objNoti.noti_type == TAGN_PUSH_DISLIKED_IMAGE
              || objNoti.noti_type == TAGN_PUSH_ADD_COMMENT
              || objNoti.noti_type == TAGN_PUSH_REMOVE_COMMENT) {
        ImageNotificationTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageNotificationTableCell" owner:nil options:nil] objectAtIndex:0];
        [cell setViewsWithNotiObj:objNoti];
        cell.delegate = self;
        
        return cell;
    } else {
        ResponseNotificationTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ResponseNotificationTableCell" owner:nil options:nil] objectAtIndex:0];
        [cell setViewsWithNotiObj:objNoti];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NotiObj *objNoti;
    
    if(indexPath.section == 0) {
        objNoti = m_aryNewNotifications[indexPath.row];
    } else {
        objNoti = m_aryOldNotifications[indexPath.row];
    }
    
    if(objNoti.noti_type == TAGN_PUSH_SHARE_REQUEST) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        SVPROGRESSHUD_PLEASE_WAIT;
        NotiObj *objNoti;
        
        if(indexPath.section == 0) {
            objNoti = m_aryNewNotifications[indexPath.row];
            [m_aryNewNotifications removeObject:objNoti];
        } else {
            objNoti = m_aryOldNotifications[indexPath.row];
            [m_aryOldNotifications removeObject:objNoti];
        }
        
        [[WebService sharedInstance] removeNotificationWithId:objNoti.noti_id
                                                      success:^(NSString *strResult) {
                                                          SVPROGRESSHUD_DISMISS;
                                                          [[GlobalService sharedInstance].user_me.user_notifications removeObject:objNoti];
                                                          [self.m_tblNotification deleteRowsAtIndexPaths:@[indexPath]
                                                                                        withRowAnimation:UITableViewRowAnimationBottom];
                                                      }
                                                      failure:^(NSString *strError) {
                                                          SVPROGRESSHUD_ERROR(strError);
                                                      }];
    }
}

#pragma mark RequestNotificationTableCellDelegate
- (void)onClickBtnAccpet:(NSIndexPath *)indexPath {
    NotiObj *objNoti;
    
    if(indexPath.section == 0) {
        objNoti = m_aryNewNotifications[indexPath.row];
        [m_aryNewNotifications removeObject:objNoti];
    } else {
        objNoti = m_aryOldNotifications[indexPath.row];
        [m_aryOldNotifications removeObject:objNoti];
    }
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] sendShareResponseWithId:objNoti.noti_share_id
                                                  Status:TAG_USER_STATUS_ACCEPTED
                                            FromUserName:[GlobalService sharedInstance].user_me.user_name
                                                 success:^(NSString *strResult) {
                                                     //remove notification
                                                     [[WebService sharedInstance] removeNotificationWithId:objNoti.noti_id
                                                                                                   success:^(NSString *strResult) {
                                                                                                       SVPROGRESSHUD_DISMISS;
                                                                                                       [[GlobalService sharedInstance].user_me.user_notifications removeObject:objNoti];
                                                                                                       [self.m_tblNotification deleteRowsAtIndexPaths:@[indexPath]
                                                                                                                                     withRowAnimation:UITableViewRowAnimationBottom];
                                                                                                       
                                                                                                       //get share tag image and add to share album
                                                                                                       [[JHImageService sharedInstance] addShareTagWithTagId:objNoti.noti_share_tag_id
                                                                                                                                                     success:^(NSString *strResult) {
                                                                                                                                                         NSLog(@"%@", strResult);
                                                                                                                                                     }
                                                                                                                                                     failure:^(NSString *strError) {
                                                                                                                                                         NSLog(@"%@", strError);
                                                                                                                                                     }];
                                                                                                   }
                                                                                                   failure:^(NSString *strError) {
                                                                                                       SVPROGRESSHUD_ERROR(strError);
                                                                                                   }];
                                                     
                                                 }
                                                 failure:^(NSString *strError) {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }];
}

- (void)onClickBtnDecline:(NSIndexPath *)indexPath {
    NotiObj *objNoti;
    
    if(indexPath.section == 0) {
        objNoti = m_aryNewNotifications[indexPath.row];
        [m_aryNewNotifications removeObject:objNoti];
    } else {
        objNoti = m_aryOldNotifications[indexPath.row];
        [m_aryOldNotifications removeObject:objNoti];
    }
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] sendShareResponseWithId:objNoti.noti_share_id
                                                  Status:TAG_USER_STATUS_REJECTED
                                            FromUserName:[GlobalService sharedInstance].user_me.user_name
                                                 success:^(NSString *strResult) {
                                                     [[WebService sharedInstance] removeNotificationWithId:objNoti.noti_id
                                                                                                   success:^(NSString *strResult) {
                                                                                                       SVPROGRESSHUD_DISMISS;
                                                                                                       [[GlobalService sharedInstance].user_me.user_notifications removeObject:objNoti];
                                                                                                       [self.m_tblNotification deleteRowsAtIndexPaths:@[indexPath]
                                                                                                                                     withRowAnimation:UITableViewRowAnimationBottom];
                                                                                                   }
                                                                                                   failure:^(NSString *strError) {
                                                                                                       SVPROGRESSHUD_ERROR(strError);
                                                                                                   }];
                                                     
                                                 }
                                                 failure:^(NSString *strError) {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }];
}

#pragma mark ImageNotificationTableCellDelegate
- (void)onTapImage:(ImageObj *)objImage {
    if(objImage) {
        ShareImageViewController *shareImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareImageViewController"];
        shareImageVC.m_objImage = objImage;
        [self.navigationController pushViewController:shareImageVC animated:YES];
    } else {
        [self.view makeToast:TOAST_REMOVED_IMAGE];
    }
}

- (IBAction)onClickBtnSettings:(id)sender {
    if([GlobalService sharedInstance].sidemenu_vc.menuState == MFSideMenuStateClosed) {
        [[GlobalService sharedInstance].sidemenu_vc toggleLeftSideMenuCompletion:nil];
    } else {
        [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    }
}

@end
