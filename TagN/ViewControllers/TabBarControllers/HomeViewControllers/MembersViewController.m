//
//  MembersViewController.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "MembersViewController.h"
#import "MemberHeaderView.h"

@interface MembersViewController ()

@end

@implementation MembersViewController

#define MEMBER_TABLE_CELL_HEIGHT        60
#define MEMBER_HEADER_VIEW_HEIGHT       30

#define ALERT_REMOVE_SHARE_TAG          100
#define ALERT_REMOVE_ME_FROM_TAG        101
#define ALERT_REMOVE_USER_FROM_TAG      102

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *paddingView                                   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.m_txtSearch.leftView                             = paddingView;
    self.m_txtSearch.leftViewMode                         = UITextFieldViewModeAlways;
    
    self.m_txtSearch.layer.masksToBounds                  = YES;
    self.m_txtSearch.layer.cornerRadius                   = 5.f;
    self.m_txtSearch.layer.borderWidth                    = 2.f;
    self.m_txtSearch.layer.borderColor                    = TAGN_PANTONE_422_COLOR.CGColor;
    
    m_objTag = [GlobalService sharedInstance].user_me.user_active_tag;
    self.m_lblTitle.text = m_objTag.tag_text;
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [self onRefreshMembers:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshMembers:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblMember addSubview:refresh];
    
    if(m_objTag.tag_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {
        [self.m_btnDelete setTitle:@"Delete TAG" forState:UIControlStateNormal];
    } else {
        [self.m_btnDelete setTitle:@"Remove me from TAG" forState:UIControlStateNormal];
    }
    
    self.m_btnDelete.layer.borderColor = TAGN_PANTONE_7477_COLOR.CGColor;
}

- (void)onRefreshMembers:(UIRefreshControl *)refresh {
    [[WebService sharedInstance] getTagUsersWithId:[GlobalService sharedInstance].user_me.user_id
                                             TagId:m_objTag.tag_id
                                           success:^(NSArray *aryCategories) {
                                               [refresh endRefreshing];
                                               SVPROGRESSHUD_DISMISS;
                                               
                                               if(m_objTag.tag_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {
                                                   m_aryTagUsers = [aryCategories copy];
                                               } else {
                                                   m_aryTagUsers = [[NSMutableArray alloc] init];
                                                   for(int nI = 0; nI < aryCategories.count; nI++) {
                                                       NSArray *aryUsers = aryCategories[nI];
                                                       
                                                       NSMutableArray *arySubTagUsers = [[NSMutableArray alloc] init];
                                                       for (int nJ = 0; nJ < aryUsers.count; nJ++) {
                                                           UserObj *objUser = aryUsers[nJ];
                                                           
                                                           if(objUser.user_share_status == TAG_USER_STATUS_ACCEPTED) {
                                                               [arySubTagUsers addObject:objUser];
                                                           }
                                                       }
                                                       
                                                       [m_aryTagUsers addObject:arySubTagUsers];
                                                   }
                                               }
                                               
                                               self.m_txtSearch.text = @"";
                                               [self onClickBtnSearch:nil];
                                           }
                                           failure:^(NSString *strError) {
                                               [refresh endRefreshing];
                                               SVPROGRESSHUD_ERROR(strError);
                                           }];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickBtnSearch:nil];
    
    return YES;
}

- (IBAction)onClickBtnSearch:(id)sender {
    [self.m_txtSearch resignFirstResponder];
    
    NSMutableArray *aryUsers = [[NSMutableArray alloc] init];
    
    if(self.m_txtSearch.text.length == 0) {
        for(int nIndex = 0; nIndex < [m_aryTagUsers[1] count]; nIndex++) {
            
            UserObj *objUser = m_aryTagUsers[1][nIndex];
            
            if(objUser.user_is_contact) {
                [aryUsers addObject:objUser];
            }
        }
    } else {
        for(int nIndex = 0; nIndex < [m_aryTagUsers[1] count]; nIndex++) {
            
            UserObj *objUser = m_aryTagUsers[1][nIndex];
            
            if([objUser.user_name.lowercaseString containsString:self.m_txtSearch.text.lowercaseString]
               || [objUser.user_username.lowercaseString containsString:self.m_txtSearch.text.lowercaseString]) {
                [aryUsers addObject:objUser];
            }
        }
    }
    
    m_aryIndexTitles = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < aryUsers.count; nIndex++)
    {
        UserObj *objUser = aryUsers[nIndex];
        [m_aryIndexTitles addObject:[objUser.user_name substringToIndex:1].uppercaseString];
    }
    
    m_aryIndexTitles = [[[[NSSet setWithArray:m_aryIndexTitles] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    
    m_aryTmpUsers = [[NSMutableArray alloc] init];
    for(int nI = 0; nI < m_aryIndexTitles.count; nI++)
    {
        NSMutableArray *arySectionUsers = [[NSMutableArray alloc] init];
        
        for(int nJ = 0; nJ < aryUsers.count; nJ++)
        {
            UserObj *objUser = aryUsers[nJ];
            if([m_aryIndexTitles[nI] isEqualToString:[objUser.user_name substringToIndex:1].uppercaseString]) {
                [arySectionUsers addObject:objUser];
                [aryUsers removeObject:objUser];
                nJ--;
            }
        }
        
        [m_aryTmpUsers addObject:arySectionUsers];
    }
    
    //add friends
    if([m_aryTagUsers[0] count] > 0) {
        [m_aryTmpUsers insertObject:m_aryTagUsers[0] atIndex:0];
        [m_aryIndexTitles insertObject:@"*" atIndex:0];
    }
    
    [self.m_tblMember reloadData];
}

- (IBAction)onClickBtnDelete:(id)sender {
    if(m_objTag.tag_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) { //Delete TAG
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete TAG"
                                                            message:@"Are you sure to delete this tag from your share TAGN?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = ALERT_REMOVE_SHARE_TAG;
        [alertView show];
    } else {    //Remove me from TAG
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove you from TAG"
                                                            message:@"Are you sure to remove you from this share tag?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = ALERT_REMOVE_ME_FROM_TAG;
        [alertView show];
    }
}

#pragma mark - TableView delegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return m_aryIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [m_aryIndexTitles indexOfObject:title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MEMBER_HEADER_VIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MemberHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MemberHeaderView" owner:nil options:nil] objectAtIndex:0];
    if([m_aryIndexTitles[section] isEqualToString:@"*"]) {
        headerView.m_lblTitle.text = @"Friends";
    } else {
        headerView.m_lblTitle.text = m_aryIndexTitles[section];
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_aryTmpUsers.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aryTmpUsers[section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MEMBER_TABLE_CELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserObj *objUser = m_aryTmpUsers[indexPath.section][indexPath.row];
    
    MemberTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithUserObj:objUser TagObj:m_objTag onIndexPath:indexPath];
    
    cell.delegate = self;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    UserObj *objUser = m_aryTmpUsers[indexPath.section][indexPath.row];
    
    if(objUser.user_share_status == TAG_USER_STATUS_PENDING) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        m_indexPath = indexPath;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cancel Share Request"
                                                            message:@"Are you sure you want to cancel this share request?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = ALERT_REMOVE_USER_FROM_TAG;
        [alertView show];
    }
}

#pragma mark MemberTableViewCellDelegate
- (void)onClickBtnActioWithIndexPath:(NSIndexPath *)indexPath {
    UserObj *objUser = m_aryTmpUsers[indexPath.section][indexPath.row];
    
    if(objUser.user_share_id.intValue == 0) {   //share request to unknown user
        objUser.user_share_status = TAG_USER_STATUS_PENDING;
        [self.m_tblMember reloadRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationNone];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] sendShareRequestFrom:[GlobalService sharedInstance].user_me.user_id
                                             FromUserName:[GlobalService sharedInstance].user_me.user_name
                                                  ToUsers:objUser.user_id.stringValue
                                                    TagId:m_objTag.tag_id
                                              TagFullText:m_objTag.tag_text
                                                  success:^(NSArray *aryShareIds) {
                                                      SVPROGRESSHUD_DISMISS;
                                                      
                                                      objUser.user_share_id = aryShareIds[0];
                                                      objUser.user_share_status = TAG_USER_STATUS_PENDING;
                                                      
                                                      [self.m_tblMember reloadRowsAtIndexPaths:@[indexPath]
                                                                              withRowAnimation:UITableViewRowAnimationNone];
                                                  }
                                                  failure:^(NSString *strError) {
                                                      objUser.user_share_status = TAG_USER_STATUS_UNKNOWN;
                                                      [self.m_tblMember reloadRowsAtIndexPaths:@[indexPath]
                                                                              withRowAnimation:UITableViewRowAnimationNone];
                                                      
                                                      SVPROGRESSHUD_ERROR(strError);
                                                  }];
    } else {    //unshare request to shared user
        m_indexPath = indexPath;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove User"
                                                            message:@"Are you sure to remove this user from your share tag?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = ALERT_REMOVE_USER_FROM_TAG;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if(alertView.tag == ALERT_REMOVE_USER_FROM_TAG) {
            UserObj *objUser = m_aryTmpUsers[m_indexPath.section][m_indexPath.row];
            
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] sendUnshareRequestFrom:[GlobalService sharedInstance].user_me.user_id
                                                   FromUserName:[GlobalService sharedInstance].user_me.user_name
                                                             To:objUser.user_id
                                                        ShareId:objUser.user_share_id
                                                    TagFullText:m_objTag.tag_text
                                                        success:^(NSString *strResult) {
                                                            SVPROGRESSHUD_DISMISS;
                                                            
                                                            objUser.user_share_id = @0;
                                                            objUser.user_share_status = TAG_USER_STATUS_UNKNOWN;
                                                            
                                                            [self.m_tblMember reloadRowsAtIndexPaths:@[m_indexPath]
                                                                                    withRowAnimation:UITableViewRowAnimationNone];
                                                        }
                                                        failure:^(NSString *strError) {
                                                            SVPROGRESSHUD_ERROR(strError);
                                                        }];
        } else if(alertView.tag == ALERT_REMOVE_SHARE_TAG) {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[JHImageService sharedInstance] deleteTagWithId:m_objTag.tag_id
                                                      UserId:[GlobalService sharedInstance].user_me.user_id
                                                     success:^(NSString *strResult) {
                                                         SVPROGRESSHUD_DISMISS;
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
                                                     failure:^(NSString *strError) {
                                                         SVPROGRESSHUD_ERROR(strError);
                                                     }];
        } else {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] sendUnshareMe:[GlobalService sharedInstance].user_me.user_id
                                               FromTag:m_objTag.tag_id
                                               success:^(NSString *strResult) {
                                                   SVPROGRESSHUD_DISMISS;
                                                   [[GlobalService sharedInstance].user_me deleteUserTagWithTagID:m_objTag.tag_id];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                               failure:^(NSString *strError) {
                                                   SVPROGRESSHUD_ERROR(strError);
                                               }];
        }
    }
}

@end
