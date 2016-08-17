//
//  SearchViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

#define SEARCH_TABLE_CELL_HEIGHT        44

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
    
    self.m_txtSearch.suggestions                          = [self getSuggestions];
    
    [self onRefreshTags:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshTags:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblTag addSubview:refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (NSArray *)getSuggestions {
    NSMutableArray *aryTags = [GlobalService sharedInstance].user_me.user_recent_tags;
    NSMutableArray *arySuggestions = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < aryTags.count; nIndex++) {
        TagObj *objTag = aryTags[nIndex];
        [arySuggestions addObject:objTag.tag_text];
    }
    
    arySuggestions = [[[[NSSet setWithArray:arySuggestions] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    return arySuggestions;
}

- (void)onRefreshTags:(UIRefreshControl *)refresh {
    NSMutableArray *aryImageInfos = [[GlobalService sharedInstance].user_me getMyAllImageInfos];
    
    //get most popular tags
    m_aryTags = [[NSMutableArray alloc] init];
    
    while(aryImageInfos.count > 0) {
        ImageInfoObj *objImageInfo = aryImageInfos[0];
        NSInteger nImageCount = objImageInfo.imageinfo_images.count;
        for(int nIndex = 1; nIndex < aryImageInfos.count; nIndex++) {
            ImageInfoObj *objTmpImageInfo = aryImageInfos[nIndex];
            if(objTmpImageInfo.imageinfo_images.count > nImageCount) {
                nImageCount = objTmpImageInfo.imageinfo_images.count;
                objImageInfo = objTmpImageInfo;
            }
        }
        
        [m_aryTags addObject:objImageInfo];
        [aryImageInfos removeObject:objImageInfo];
        
        if(m_aryTags.count == MOST_POPULAR_TAGS_COUNT) break;
    }
    
    [refresh endRefreshing];
    [self.m_tblTag reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.m_txtSearch.text = @"";
    [self onRefreshTags:nil];
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].size.height;
    
    self.m_constraintTableBottom.constant = keyboardY - [GlobalService sharedInstance].tabbar_vc.tabBar.frame.size.height;
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    self.m_constraintTableBottom.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickBtnSearch:nil];
    
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
    return m_aryTags.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SEARCH_TABLE_CELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfoObj *objImageInfo = m_aryTags[indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    cell.m_lblTagName.text = objImageInfo.imageinfo_tag.tag_text;
    cell.m_lblTagImages.text = [NSString stringWithFormat:@"%d images", (int)objImageInfo.imageinfo_images.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfoObj *objImageInfo = m_aryTags[indexPath.row];
    
    SearchResultViewController *searchResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    searchResultVC.m_aryImages = objImageInfo.imageinfo_images;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}

- (IBAction)onClickBtnSettings:(id)sender {
    if([GlobalService sharedInstance].sidemenu_vc.menuState == MFSideMenuStateClosed) {
        [[GlobalService sharedInstance].sidemenu_vc toggleLeftSideMenuCompletion:nil];
    } else {
        [GlobalService sharedInstance].sidemenu_vc.menuState = MFSideMenuStateClosed;
    }
}

- (IBAction)onClickBtnSearch:(id)sender {
    [self.m_txtSearch resignFirstResponder];
    
    if(self.m_txtSearch.text.length > 0) {
        NSMutableArray *aryImageInfos = [[GlobalService sharedInstance].user_me getMyAllImageInfos];
        
        NSMutableArray *aryImages = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < aryImageInfos.count; nIndex++) {
            ImageInfoObj *objImageInfo = aryImageInfos[nIndex];
            if([objImageInfo.imageinfo_tag.tag_text.lowercaseString containsString:self.m_txtSearch.text.lowercaseString]) {
                [aryImages addObjectsFromArray:objImageInfo.imageinfo_images];
            }
        }
        
        SearchResultViewController *searchResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
        searchResultVC.m_aryImages = aryImages;
        [self.navigationController pushViewController:searchResultVC animated:YES];
    }
}

@end
