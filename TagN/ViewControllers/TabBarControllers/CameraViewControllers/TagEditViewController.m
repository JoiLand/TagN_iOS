//
//  TagEditViewController.m
//  TagN
//
//  Created by JH Lee on 2/8/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TagEditViewController.h"

#import "SearchTableViewCell.h"
#import "ShareViewController.h"

@interface TagEditViewController ()

@end

@implementation TagEditViewController

#define SEARCH_TABLE_CELL_HEIGHT        44

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.m_isAdd) {
        self.m_lblTitle.text = @"Add Tag";
    } else {
        self.m_lblTitle.text = @"Change Tag";
    }
    
    self.m_btnNext.userInteractionEnabled = NO;
    
    UIView *paddingView                                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.m_txtInputTag.leftView                             = paddingView;
    self.m_txtInputTag.leftViewMode                         = UITextFieldViewModeAlways;
    
    self.m_txtInputTag.layer.masksToBounds                  = YES;
    self.m_txtInputTag.layer.cornerRadius                   = 5.f;
    self.m_txtInputTag.layer.borderWidth                    = 2.f;
    self.m_txtInputTag.layer.borderColor                    = TAGN_PANTONE_422_COLOR.CGColor;
    
    self.m_txtInputTag.suggestions                          = [self getSuggestions];
    [self.m_txtInputTag becomeFirstResponder];
}

- (NSArray *)getSuggestions {
    NSMutableArray *arySuggestions = [[NSMutableArray alloc] init];
    NSArray *aryRecentTags = [GlobalService sharedInstance].user_me.user_recent_tags;
    
    for(int nIndex = 0; nIndex < aryRecentTags.count; nIndex++) {
        TagObj *objTag = aryRecentTags[nIndex];
        [arySuggestions addObject:objTag.tag_text];
    }
    
    arySuggestions = [[[[NSSet setWithArray:arySuggestions] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    return arySuggestions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.location == 0 && range.length == 1 && [string isEqualToString:@""]) {
        self.m_btnNext.userInteractionEnabled = NO;
        [self.m_btnNext setImage:[UIImage imageNamed:@"common_btnNext"] forState:UIControlStateNormal];
        self.m_btnNext.backgroundColor = [UIColor clearColor];
    } else {
        self.m_btnNext.userInteractionEnabled = YES;
        [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
        self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    }
    
    return YES;
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
    return [GlobalService sharedInstance].user_me.user_recent_tags.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SEARCH_TABLE_CELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagObj *objTag = [GlobalService sharedInstance].user_me.user_recent_tags[indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    cell.m_lblTagName.text = objTag.tag_text;
    cell.m_lblTagImages.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagObj *objTag = [GlobalService sharedInstance].user_me.user_recent_tags[indexPath.row];
    
    self.m_txtInputTag.text = objTag.tag_text;
    m_nSelectedTag = objTag;
    
    self.m_btnNext.userInteractionEnabled = YES;
    [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[GlobalService sharedInstance].user_me removeUserRecentTag:indexPath.row];
        [self.m_tblRecentTags deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)onTouchDownNext:(id)sender {
    self.m_btnNext.backgroundColor = [UIColor clearColor];
    [self.m_btnNext setImage:[UIImage imageNamed:@"common_btnNext"] forState:UIControlStateNormal];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.m_txtInputTag resignFirstResponder];
    if(self.m_isAdd) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onTouchUpNext:(id)sender {
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    [self.m_btnNext setImage:[UIImage imageNamed:@"camera_btnNext"] forState:UIControlStateNormal];
    
    if(m_nSelectedTag) {
        [[GlobalService sharedInstance].user_me updateActiveTag:m_nSelectedTag];
        
        ShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
        shareVC.m_aryPhotos = self.m_aryPhotos;
        [self.navigationController pushViewController:shareVC animated:YES];
    } else {
        if(self.m_txtInputTag.text.length > 0) {
            
            BOOL isExist = NO;
            NSArray *aryRecentTags = [GlobalService sharedInstance].user_me.user_recent_tags;
            for(int nIndex = 0; nIndex < aryRecentTags.count; nIndex++) {
                TagObj *objTag = aryRecentTags[nIndex];
                if([objTag.tag_text isEqualToString:self.m_txtInputTag.text]) {
                    isExist = YES;
                    [[GlobalService sharedInstance].user_me updateActiveTag:objTag];
                    break;
                }
            }
            
            if(isExist) {
                ShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
                shareVC.m_aryPhotos = self.m_aryPhotos;
                [self.navigationController pushViewController:shareVC animated:YES];
            } else {
                
                SVPROGRESSHUD_PLEASE_WAIT;
                [[JHImageService sharedInstance] addTagWithUserId:[GlobalService sharedInstance].user_me.user_id
                                                             Text:self.m_txtInputTag.text
                                                          success:^(NSString *strResult) {
                                                              SVPROGRESSHUD_DISMISS;
                                                              ShareViewController *shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
                                                              shareVC.m_aryPhotos = self.m_aryPhotos;
                                                              [self.navigationController pushViewController:shareVC animated:YES];
                                                          }
                                                          failure:^(NSString *strError) {
                                                              SVPROGRESSHUD_ERROR(strError);
                                                          }];
            }
        }
    }
}

@end
