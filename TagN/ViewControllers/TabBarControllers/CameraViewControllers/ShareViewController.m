//
//  ShareViewController.m
//  TagN
//
//  Created by JH Lee on 2/8/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "ShareViewController.h"
#import "CoreDataImage.h"
#import "MemberHeaderView.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

#define FACEBOOK_SHARE_BUTTON_TAG       10
#define INSTAGRAM_SHARE_BUTTON_TAG      11
#define TWITTER_SHARE_BUTTON_TAG        12
#define TUMBLUR_SHARE_BUTTON_TAG        13

#define MEMBER_TABLE_CELL_HEIGHT        60
#define MEMBER_HEADER_VIEW_HEIGHT       30
#define USERNAME_LABEL_WIDTH            self.view.frame.size.width - 20

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
    
    self.m_btnNext.userInteractionEnabled = YES;
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
    
    m_aryShareButtonNames = @[
                              @"share_btnFacebookShare",
                              @"share_btnInstagramShare",
                              @"share_btnTwitterShare",
                              @"share_btnTumblrShare"
                              ];
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [self onRefresh:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblShare addSubview:refresh];
}

- (void)onRefresh:(UIRefreshControl *)refresh {
    [[WebService sharedInstance] getTagUsersWithId:[GlobalService sharedInstance].user_me.user_id
                                             TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id
                                           success:^(NSArray *aryCategories) {
                                               SVPROGRESSHUD_DISMISS;
                                               [refresh endRefreshing];
                                               m_aryTagUsers = [[NSMutableArray alloc] init];
                                               
                                               for(int nI = 0; nI < aryCategories.count; nI++) {
                                                   NSArray *aryUsers = aryCategories[nI];
                                                   
                                                   NSMutableArray *arySubTagUsers = [[NSMutableArray alloc] init];
                                                   for (int nJ = 0; nJ < aryUsers.count; nJ++) {
                                                       UserObj *objUser = aryUsers[nJ];

                                                       if(objUser.user_share_status == TAG_USER_STATUS_UNKNOWN) {
                                                           objUser.user_already_status = NO;
                                                       } else {
                                                           objUser.user_already_status = YES;
                                                       }
                                                                                                              
                                                       [arySubTagUsers addObject:objUser];
                                                   }
                                                   
                                                   [m_aryTagUsers addObject:arySubTagUsers];
                                               }
                                               
                                               self.m_txtSearch.text = @"";
                                               [self onClickBtnSearch:nil];
                                           }
                                           failure:^(NSString *strError) {
                                               SVPROGRESSHUD_ERROR(strError);
                                               [refresh endRefreshing];
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
    
    [self setUserNames];
    [self.m_tblShare reloadData];
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
    MemberTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberTableViewCell" owner:nil options:nil] objectAtIndex:0];
    
    UserObj *objUser = m_aryTmpUsers[indexPath.section][indexPath.row];
    
    [cell setViewsWithUserObj:objUser TagObj:[GlobalService sharedInstance].user_me.user_active_tag onIndexPath:indexPath];
    if(objUser.user_already_status) {
        cell.m_btnAction.alpha = 0.3f;
        cell.m_btnAction.userInteractionEnabled = NO;
    }
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark MemberTableViewCellDelegate
- (void)onClickBtnActioWithIndexPath:(NSIndexPath *)indexPath {
    UserObj *objUser = m_aryTmpUsers[indexPath.section][indexPath.row];
    if(objUser.user_share_status == TAG_USER_STATUS_UNKNOWN) {
        objUser.user_share_status = TAG_USER_STATUS_ACCEPTED;
    } else {
        objUser.user_share_status = TAG_USER_STATUS_UNKNOWN;
    }
    
    [self.m_tblShare reloadRowsAtIndexPaths:@[indexPath]
                           withRowAnimation:UITableViewRowAnimationNone];
    
    [self setUserNames];
}

- (void)setUserNames {
    //get checked user names
    NSMutableString *strUserNames = [[NSMutableString alloc] init];
    for(int nI = 0; nI < m_aryTmpUsers.count; nI++) {
        NSArray *aryRows = m_aryTmpUsers[nI];
        for(int nJ = 0; nJ < aryRows.count; nJ++) {
            UserObj *objUser = m_aryTmpUsers[nI][nJ];
            if(objUser.user_share_status == TAG_USER_STATUS_ACCEPTED && !objUser.user_already_status) {
                [strUserNames appendFormat:@"%@, ", objUser.user_name];
            }
        }
    }
    
    if(strUserNames.length > 0) {
        strUserNames = [[strUserNames substringToIndex:strUserNames.length - 2] mutableCopy];
        
        //get label height
        NSMutableAttributedString *strTmp = [[NSMutableAttributedString alloc] initWithString:strUserNames];
        [strTmp addAttribute:NSForegroundColorAttributeName value:TAGN_PANTONE_7477_COLOR
                       range:NSMakeRange(0, strTmp.length)];
        [strTmp addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Arial" size:COMMENT_FONT_SIZE]
                       range:NSMakeRange(0, strTmp.length)];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.m_constraintUserHeight.constant = [[GlobalService sharedInstance] labelHeightForText:strTmp withLabelWidth:USERNAME_LABEL_WIDTH];
            [self.view layoutIfNeeded];
        }];
        [self.m_lblUserNames setAttributedText:strTmp];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.m_constraintUserHeight.constant = 0;
            [self.view layoutIfNeeded];
        }];
        self.m_lblUserNames.text = @"";
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchDownNext:(id)sender {
    self.m_btnNext.backgroundColor = [UIColor clearColor];
    [self.m_btnNext setImage:[UIImage imageNamed:@"common_btnNext"] forState:UIControlStateNormal];
}

- (IBAction)onTouchUpNext:(id)sender {
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
    
    //get selected users
    NSMutableArray *arySelectedTagNUserIds = [[NSMutableArray alloc] init];
    
    for(int nI = 0; nI < m_aryTmpUsers.count; nI++) {
        NSArray *aryRows = m_aryTmpUsers[nI];
        for(int nJ = 0; nJ < aryRows.count; nJ++) {
            UserObj *objUser = m_aryTmpUsers[nI][nJ];
            if(objUser.user_share_status == TAG_USER_STATUS_ACCEPTED && !objUser.user_already_status) {
                [arySelectedTagNUserIds addObject:objUser.user_id];
            }
        }
    }
    
    //send share request to tagn user ids
    [self sendShareRequestToUsers:arySelectedTagNUserIds];
}

- (void)sendShareRequestToUsers:(NSArray *)user_ids {
    if(user_ids.count > 0) {
        NSMutableString *strUserIds = [[NSMutableString alloc] init];
        for(int nIndex = 0; nIndex < user_ids.count; nIndex++) {
            [strUserIds appendFormat:@"%d,", [user_ids[nIndex] intValue]];
        }
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] sendShareRequestFrom:[GlobalService sharedInstance].user_me.user_id
                                             FromUserName:[GlobalService sharedInstance].user_me.user_name
                                                  ToUsers:[strUserIds substringToIndex:strUserIds.length - 1]
                                                    TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id
                                              TagFullText:[GlobalService sharedInstance].user_me.user_active_tag.tag_text
                                                  success:^(NSArray *aryShareIds) {
                                                      SVPROGRESSHUD_DISMISS;
                                                      [self uploadImages];
                                                      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                  }
                                                  failure:^(NSString *strError) {
                                                      SVPROGRESSHUD_ERROR(strError);
                                                      [self uploadImages];
                                                      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                  }];
    } else {
        [self uploadImages];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)uploadImages {
    if(self.m_aryPhotos.count > 0) {
        NSMutableArray *aryImages = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < self.m_aryPhotos.count; nIndex++) {
            CoreDataImage *coreDataImage = [[CoreDataService sharedInstance] saveImageObjWith:self.m_aryPhotos[nIndex]
                                                                                        TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id];
            
            ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:coreDataImage];
            [aryImages addObject:objImage];
        }
        
        ImageInfoObj *objInfoObj = [[ImageInfoObj alloc] initWithTag:[GlobalService sharedInstance].user_me.user_active_tag
                                                              Images:aryImages];
        
        if([GlobalService sharedInstance].user_me.user_active_tag.tag_user_id.intValue
           == [GlobalService sharedInstance].user_me.user_id.intValue) {
            [[GlobalService sharedInstance].user_me addMyImageInfo:objInfoObj];
        }
        
        [[GlobalService sharedInstance].user_me addShareImageInfo:objInfoObj];
        
        if([GlobalService sharedInstance].is_internet_alive) {
            [[GlobalService sharedInstance].app_delegate startUploadService];
        }
        
        [GlobalService sharedInstance].tabbar_vc.selectedIndex = [GlobalService sharedInstance].tabbar_vc.m_nLastSelectedIndex;
    }
}

- (IBAction)onTouchUpBtnShare:(id)sender {
    if(self.m_aryPhotos.count > 0) {
        UIButton *button = (UIButton *)sender;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled", m_aryShareButtonNames[button.tag - FACEBOOK_SHARE_BUTTON_TAG]]]
                forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        
        switch (button.tag) {
            case FACEBOOK_SHARE_BUTTON_TAG:
                [self shareWithFacebook];
                break;
                
            case INSTAGRAM_SHARE_BUTTON_TAG:
                [self shareWithInstagram];
                break;
                
            case TWITTER_SHARE_BUTTON_TAG:
                [self shareWithTwitter];
                break;
                
            case TUMBLUR_SHARE_BUTTON_TAG:
                [self shareWithTumblr];
                break;
                
            default:
                break;
        }
    }
}

- (void)shareWithFacebook {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbShareVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        ImageObj *objImage = self.m_aryPhotos[0];
        [fbShareVC addImage:objImage.image_photo];
        [fbShareVC setInitialText:APP_SHARE_TEXT];
        
        [fbShareVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:fbShareVC animated:YES completion:nil];
    } else {
        [self.view makeToast:@"Your device doesn't support facebook share now. Please login on your device settings."];
    }
}

- (void)shareWithTwitter {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterShareVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        ImageObj *objImage = self.m_aryPhotos[0];
        [twitterShareVC addImage:objImage.image_photo];
        [twitterShareVC setInitialText:APP_SHARE_TEXT];
        
        [twitterShareVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:twitterShareVC animated:YES completion:nil];
    } else {
        [self.view makeToast:@"Your device doesn't support twitter share now. Please login on your device settings."];
    }
}

- (void)shareWithInstagram {
    ImageObj *objImage = self.m_aryPhotos[0];
    UIImage *screenShot = objImage.image_photo;
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/post.ig"];
    [UIImagePNGRepresentation(screenShot) writeToFile:savePath atomically:YES];
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/post.ig"];
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
    
    UIDocumentInteractionController   *dic;
    dic.UTI = @"com.instagram.exclusivegram";  //@"com.instagram.photo";
    dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [dic presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    } else {
        NSLog(@"No Instagram Found");
        SVPROGRESSHUD_ERROR(@"No Instagram Found");
    }
}

#pragma mark - UIDocuments delegate

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

- (void)shareWithTumblr {
    
    ImageObj *objImage = self.m_aryPhotos[0];
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [self initTumblr];
    
    [[TMAPIClient sharedInstance] userInfo:^ (id result, NSError *error) {
        if (!error) {
            NSDictionary *dicUserInfo = [NSDictionary dictionaryWithDictionary:result];
            NSLog(@"Tumblr user info : %@", dicUserInfo);
            
            NSString *strUserName = dicUserInfo[@"user"][@"name"];
            strUserName = [strUserName stringByAppendingString:APP_SHARE_TEXT];
            
            NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/post.ig"];
            [UIImagePNGRepresentation(objImage.image_photo) writeToFile:savePath atomically:YES];
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/post.ig"];
            
            [[TMAPIClient sharedInstance] photo:strUserName
                                  filePathArray:@[jpgPath]
                               contentTypeArray:@[@"image/png"]
                                  fileNameArray:@[@"share_imgPhoto"]
                                     parameters:nil
                                       callback:^(id response, NSError *error) {
                                           if (error) {
                                               NSLog(@"Error posting to Tumblr");
                                               SVPROGRESSHUD_ERROR(@"Error posting to Tumblr");
                                           } else {
                                               NSLog(@"Posted to Tumblr");
                                               SVPROGRESSHUD_SUCCESS(@"Posted to Tumblr");
                                           }
                                       }];
        } else {
            SVPROGRESSHUD_ERROR(error.localizedDescription);
        }
    }];
}

- (void) initTumblr
{
    [TMAPIClient sharedInstance].OAuthConsumerKey = TUMBLR_CUSTOMER_KEY;
    [TMAPIClient sharedInstance].OAuthConsumerSecret = TUMBLR_CUSTOMER_SECRET;
    [TMAPIClient sharedInstance].OAuthToken = TUMBLR_CUSTOMER_TOKEN;
    [TMAPIClient sharedInstance].OAuthTokenSecret = TUMBLR_CUSTOMER_TOKEN_SECRET;
}

@end
