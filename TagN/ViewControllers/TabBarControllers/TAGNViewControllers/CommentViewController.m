//
//  CommentViewController.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

#define COMMENT_LABEL_WIDTH         self.view.frame.size.width - 70
#define COMMENT_TABLE_CELL_HEIDHT   50

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *paddingView                                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.m_txtInput.leftView                             = paddingView;
    self.m_txtInput.leftViewMode                         = UITextFieldViewModeAlways;
    
    self.m_txtInput.layer.masksToBounds                  = YES;
    self.m_txtInput.layer.cornerRadius                   = 5.f;
    
    [self.m_txtInput becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    m_aryComments = [self.m_objImage.image_last_2_comments mutableCopy];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshComment:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblComment addSubview:refresh];
    
    [self onRefreshComment:nil];
}

- (void)onRefreshComment:(UIRefreshControl *)refresh {
    [[WebService sharedInstance] getImageComments:self.m_objImage.image_id
                                           UserId:[GlobalService sharedInstance].user_me.user_id
                                          success:^(NSArray *aryComments) {
                                              [refresh endRefreshing];
                                              m_aryComments = [aryComments mutableCopy];
                                              [self.m_tblComment reloadData];
                                              [self scrollToBottomWithAnimated:YES];
                                          }
                                          failure:^(NSString *strError) {
                                              [refresh endRefreshing];
                                              NSLog(@"%@", strError);
                                          }];
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].size.height;
    
    self.m_constraintViewBottom.constant = keyboardY - [GlobalService sharedInstance].tabbar_vc.tabBar.frame.size.height;
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    self.m_constraintViewBottom.constant = 0;
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_aryComments.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentObj *objComment = m_aryComments[indexPath.row];
    
    CGFloat lblCommentHeight = [self labelHeightForText:[self makeCommentsWithData:objComment.comment_string]];
    if(lblCommentHeight > 20) {
        return COMMENT_TABLE_CELL_HEIDHT + lblCommentHeight - 20;
    } else {
        return COMMENT_TABLE_CELL_HEIDHT;
    }
}

- (NSAttributedString *)makeCommentsWithData:(NSString *)strComment {
    
    NSMutableAttributedString *strTmp = [[NSMutableAttributedString alloc] init];
    [strTmp appendAttributedString:[[NSAttributedString alloc] initWithString:strComment]];
    [strTmp addAttribute:NSForegroundColorAttributeName value:TAGN_PANTONE_423_COLOR
                   range:NSMakeRange(0, strComment.length)];
    [strTmp addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:COMMENT_FONT_SIZE]
                   range:NSMakeRange(0, strComment.length)];
    
    return strTmp;
}

- (CGFloat)labelHeightForText:(NSAttributedString *)txt
{
    CGFloat maxWidth = COMMENT_LABEL_WIDTH;
    CGFloat maxHeight = 1000;
    
    CGSize stringSize;
    
    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    
    return roundf(stringSize.height);
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentObj *objComment = m_aryComments[indexPath.row];
    
    CommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithCommentObj:objComment];
    
    [cell.m_lblComment setAttributedText:[self makeCommentsWithData:objComment.comment_string]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentObj *objComment = m_aryComments[indexPath.row];
    
    if(objComment.comment_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Comment"
                                                            message:@"Are you sure to delete this comment now?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = indexPath.row;
        [alertView show];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        CommentObj *objComment = m_aryComments[alertView.tag];
        [m_aryComments removeObjectAtIndex:alertView.tag];
        [self.m_tblComment deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationFade];
        
        [self scrollToBottomWithAnimated:YES];
        [self makeLast2Comments];
        
        [[WebService sharedInstance] removeCommentWithCommentId:objComment.comment_id
                                                        success:^(NSString *strResult) {
                                                            NSLog(@"%@", strResult);
                                                        }
                                                        failure:^(NSString *strError) {
                                                            NSLog(@"%@", strError);
                                                        }];
    }
}

- (IBAction)onClickBtnSend:(id)sender {
    if(self.m_txtInput.text.length > 0) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] addCommentWithUserId:[GlobalService sharedInstance].user_me.user_id
                                                  ImageId:self.m_objImage.image_id
                                                   String:self.m_txtInput.text
                                                  success:^(CommentObj *objComment) {
                                                      SVPROGRESSHUD_DISMISS;
                                                      self.m_txtInput.text = @"";
                                                      [m_aryComments addObject:objComment];
                                                      [self.m_tblComment insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:m_aryComments.count - 1 inSection:0]]
                                                                               withRowAnimation:UITableViewRowAnimationNone];
                                                      [self scrollToBottomWithAnimated:YES];
                                                      [self makeLast2Comments];
                                                  }
                                                  failure:^(NSString *strError) {
                                                      SVPROGRESSHUD_ERROR(strError);
                                                  }];
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    if(m_aryComments.count == 0) {
        return;
    }
    [self.m_tblComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:m_aryComments.count - 1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:animated];
}

- (void)makeLast2Comments {
    switch (m_aryComments.count) {
        case 0:
            self.m_objImage.image_last_2_comments = @[];
            break;
            
        case 1:
            self.m_objImage.image_last_2_comments = @[m_aryComments[0]];
            break;
            
        default:
            self.m_objImage.image_last_2_comments = @[
                                                      m_aryComments[m_aryComments.count - 2],
                                                      m_aryComments[m_aryComments.count - 1]
                                                      ];
            break;
    }
}

@end
