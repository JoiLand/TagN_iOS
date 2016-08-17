//
//  TagNViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagNViewController.h"
#import "TagEditViewController.h"
#import "TagNDetailViewController.h"
#import "MyTagNTableViewCell.h"
#import "ImageSelectionViewController.h"

@interface TagNViewController ()

@end

@implementation TagNViewController

#define TAGN_HEADERVIEW_HEIGHT      35
#define MYTAGN_TABLEVIEWCELL_HEIGHT self.view.frame.size.width / 4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSharePhotos:)
                                                 name:NOTIFICATION_ADD_SHARE_PHOTOS
                                               object:nil];
    
    m_nSelectedSection = -1;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshShareTagN:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblShareTags addSubview:refresh];
    
    self.m_btnViewMoreTags.layer.borderColor = TAGN_PANTONE_7477_COLOR.CGColor;
    m_nCurrentPageNum = 1;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
        
        m_nSelectedSection = -1;
    }
}

- (void)onRefreshShareTagN:(UIRefreshControl *)refresh {
    m_nCurrentPageNum = 1;
    [[JHImageService sharedInstance] getShareTagNImagesWithId:[GlobalService sharedInstance].user_me.user_id
                                                      PageNum:m_nCurrentPageNum
                                                    PageCount:PAGE_COUNT
                                                      success:^(BOOL isMoreTags) {
                                                          if(isMoreTags) {
                                                              [self.m_btnViewMoreTags setTitle:@"View More TAGs" forState:UIControlStateNormal];
                                                              [self.m_btnViewMoreTags setUserInteractionEnabled:YES];
                                                          } else {
                                                              [self.m_btnViewMoreTags setTitle:@"No More TAGs" forState:UIControlStateNormal];
                                                              [self.m_btnViewMoreTags setUserInteractionEnabled:NO];
                                                          }
                                                          [refresh endRefreshing];
                                                          [self.m_tblShareTags reloadData];
                                                      }
                                                      failure:^(NSString *strError) {
                                                          [refresh endRefreshing];
                                                          NSLog(@"%@", strError);
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

- (void)addSharePhotos:(NSNotification *)notification {
    if(notification.userInfo[@"image_obj"]) {   //uploaded photo
        NSNumber *nTagId = notification.userInfo[@"image_obj"];
        for(int nIndex = 0; nIndex < [GlobalService sharedInstance].user_me.user_share_albums.count; nIndex++) {
            ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[nIndex];
            
            if(objImageInfo.imageinfo_tag.tag_id.intValue == nTagId.intValue) {
                [self.m_tblShareTags reloadSections:[NSIndexSet indexSetWithIndex:nIndex] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    } else {    // add photo
        [self.m_tblShareTags reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_tblShareTags reloadData];
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TAGN_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[section];
    
    TagNHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TagNHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.m_nSection = section;
    headerView.m_lblTagFullText.text = objImageInfo.imageinfo_tag.tag_text;
    headerView.delegate = self;
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [GlobalService sharedInstance].user_me.user_share_albums.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MYTAGN_TABLEVIEWCELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[indexPath.section];
    
    MyTagNTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTagNTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithImageInfoObj:objImageInfo onSection:indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[indexPath.section];
    [[GlobalService sharedInstance].user_me updateActiveTag:objImageInfo.imageinfo_tag];
    
    TagNDetailViewController *tagNDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagNDetailViewController"];
    tagNDetailVC.m_objImageInfo = objImageInfo;
    tagNDetailVC.m_bSelectionMode = NO;
    [self.navigationController pushViewController:tagNDetailVC animated:YES];
}

- (IBAction)onClickBtnAddTag:(id)sender {
    TagEditViewController *tagEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagEditViewController"];
    tagEditVC.m_isAdd = YES;
    UINavigationController *tagEditNC = [[UINavigationController alloc] initWithRootViewController:tagEditVC];
    tagEditNC.navigationBarHidden = YES;
    [self presentViewController:tagEditNC animated:YES completion:nil];
}

- (IBAction)onClickBtnViewMoreTags:(id)sender {
    m_nCurrentPageNum++;
    
    [self.m_btnViewMoreTags setTitle:@"" forState:UIControlStateNormal];
    [self.m_btnViewMoreTags setUserInteractionEnabled:NO];
    [self.m_activityView setAlpha:1.0f];
    
    [[JHImageService sharedInstance] getShareTagNImagesWithId:[GlobalService sharedInstance].user_me.user_id
                                                      PageNum:m_nCurrentPageNum
                                                    PageCount:PAGE_COUNT
                                                      success:^(BOOL isMoreTags) {
                                                          [self.m_activityView setAlpha:0.0f];
                                                          
                                                          if(isMoreTags) {
                                                              [self.m_btnViewMoreTags setTitle:@"View More TAGs" forState:UIControlStateNormal];
                                                              [self.m_btnViewMoreTags setUserInteractionEnabled:YES];
                                                          } else {
                                                              [self.m_btnViewMoreTags setTitle:@"No More TAGs" forState:UIControlStateNormal];
                                                              [self.m_btnViewMoreTags setUserInteractionEnabled:NO];
                                                          }
                                                          [self.m_tblShareTags reloadData];
                                                      }
                                                      failure:^(NSString *strError) {
                                                          NSLog(@"%@", strError);
                                                          [self.m_activityView setAlpha:0.0f];
                                                          
                                                          [self.m_btnViewMoreTags setTitle:@"View More TAGs" forState:UIControlStateNormal];
                                                          [self.m_btnViewMoreTags setUserInteractionEnabled:YES];
                                                      }];
}

- (IBAction)onClickBtnSetting:(id)sender {
    if([GlobalService sharedInstance].sidemenu_vc.menuState == MFSideMenuStateClosed) {
        [[GlobalService sharedInstance].sidemenu_vc toggleLeftSideMenuCompletion:nil];
    } else {
        [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    }
}

#pragma mark TagNHeaderViewDelegate
- (void)onClickBtnDropDown:(UIView *)sender onSection:(NSInteger)nSection {
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[nSection];
    
    TagNPopoverView *viewDropDown = [[[NSBundle mainBundle] loadNibNamed:@"TagNPopoverView" owner:nil options:nil] objectAtIndex:0];
    [viewDropDown setViewsWithImageInfoObj:objImageInfo onSection:nSection];
    viewDropDown.delegate = self;
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
    }
    
    if(m_nSelectedSection == nSection) {
        m_nSelectedSection = -1;
        m_viewPopover = nil;
    } else {
        m_nSelectedSection = nSection;
        m_viewPopover = [DXPopover popover];
        m_viewPopover.maskType = DXPopoverMaskTypeNone;
        m_viewPopover.cornerRadius = 8.f;
        m_viewPopover.arrowSize = CGSizeMake(15.f, 15.f);
        CGPoint startPoint = CGPointMake(CGRectGetWidth(sender.frame) - 30, CGRectGetMaxY(sender.frame));
        m_viewPopover.backgroundColor = [UIColor hx_colorWithHexString:@"2B5763" alpha:0.85f];
        [m_viewPopover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:viewDropDown inView:self.m_tblShareTags];
    }
}

#pragma mark TagNPopoverViewDelegate
- (void)onClickBtnAddPictureWithSection:(NSInteger)section {
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[section];
    [[GlobalService sharedInstance].user_me updateActiveTag:objImageInfo.imageinfo_tag];
    
    UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    UINavigationController *cameraNC = [[UINavigationController alloc] initWithRootViewController:cameraVC];
    cameraNC.navigationBarHidden = YES;
    [self presentViewController:cameraNC animated:NO completion:nil];
}

- (void)onClickBtnDeleteImagesWithSection:(NSInteger)section {
    [self hideDropDownMenu];
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[section];
    [[GlobalService sharedInstance].user_me updateActiveTag:objImageInfo.imageinfo_tag];
    
    TagNDetailViewController *tagNDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagNDetailViewController"];
    tagNDetailVC.m_objImageInfo = objImageInfo;
    tagNDetailVC.m_bSelectionMode = YES;
    [self.navigationController pushViewController:tagNDetailVC animated:YES];
}

- (void)onClickBtnDeleteTagWithSection:(NSInteger)section {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete TAG"
                                                    message:@"You are about to delete this entire TAG!\nAre you sure you want to delete this TAG?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)onClickBtnTagNStoryWithSection:(NSInteger)section {
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[section];
    [[GlobalService sharedInstance].user_me updateActiveTag:objImageInfo.imageinfo_tag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ImageSelectionViewController *imageSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageSelectionViewController"];
        imageSelectionVC.m_objImageInfo = objImageInfo;
        UINavigationController *photoEditNC = [[UINavigationController alloc] initWithRootViewController:imageSelectionVC];
        photoEditNC.navigationBarHidden = YES;
        [self presentViewController:photoEditNC animated:NO completion:nil];
    });
}

- (void)onClickBtnMembersWithSection:(NSInteger)section {
    ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[section];
    [[GlobalService sharedInstance].user_me updateActiveTag:objImageInfo.imageinfo_tag];
    [self hideDropDownMenu];
    
    UIViewController *membersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MembersViewController"];
    [self.navigationController pushViewController:membersVC animated:YES];
}

- (void)hideDropDownMenu {
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
        
        m_nSelectedSection = -1;
    }
}

#pragma mark - AlertView delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ImageInfoObj *objImageInfo = [GlobalService sharedInstance].user_me.user_share_albums[m_nSelectedSection];
        [self hideDropDownMenu];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[JHImageService sharedInstance] deleteTagWithId:objImageInfo.imageinfo_tag.tag_id
                                                  UserId:[GlobalService sharedInstance].user_me.user_id
                                                 success:^(NSString *strResult) {
                                                     SVPROGRESSHUD_DISMISS;
                                                     [self.m_tblShareTags reloadData];
                                                     m_nSelectedSection = -1;
                                                 }
                                                 failure:^(NSString *strError) {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }];
    }
}

@end
