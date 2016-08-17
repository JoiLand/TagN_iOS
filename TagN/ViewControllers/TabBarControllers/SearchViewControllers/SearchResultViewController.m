//
//  SearchResultViewController.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SearchResultViewController.h"
#import "TagNHeaderView.h"
#import "SearchResultTableViewCell.h"
#import "SearchYearTableViewCell.h"
#import "SearchMonthlyViewController.h"
#import "SearchDetailViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

#define TAGN_HEADERVIEW_HEIGHT          35

#define SEARCH_RESULT_CELL_HEIGHT       self.view.frame.size.width / 3
#define SEARCH_YEAR_CELL_HEIGHT         self.view.frame.size.width / 3 * 2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_bSelectedTag = YES;
    [self sortSearchImages];
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

- (void) sortSearchImages {
    m_aryTagPhotos = [[NSMutableArray alloc] init];
    m_aryTimePhotos = [[NSMutableArray alloc] init];
    
    NSMutableArray *aryTagTitles = [[NSMutableArray alloc] init];
    NSMutableArray *aryTimeTitles = [[NSMutableArray alloc] init];
    
    for(int nIndex = 0; nIndex < self.m_aryImages.count; nIndex++)
    {
        ImageObj *objImage = self.m_aryImages[nIndex];
        TagObj *objTag = [[GlobalService sharedInstance].user_me getTagObjFromId:objImage.image_tag_id];
        
        [aryTagTitles addObject:objTag.tag_text];
        [aryTimeTitles addObject:[self getYearFromDate:objImage.image_created_at]];
    }
    
    aryTagTitles = [[[[NSSet setWithArray:aryTagTitles] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    aryTimeTitles = [[[[NSSet setWithArray:aryTimeTitles] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    
    for(int nI = 0; nI < aryTagTitles.count; nI++)
    {
        NSMutableArray *arySectionTags = [[NSMutableArray alloc] init];
        
        for(int nJ = 0; nJ < self.m_aryImages.count; nJ++)
        {
            ImageObj *objImage = self.m_aryImages[nJ];
            TagObj *objTag = [[GlobalService sharedInstance].user_me getTagObjFromId:objImage.image_tag_id];
            
            if([aryTagTitles[nI] isEqualToString:objTag.tag_text]) {
                [arySectionTags addObject:objImage];
            }
        }
        
        [m_aryTagPhotos addObject:@{
                                    @"header"   : aryTagTitles[nI],
                                    @"contents" : arySectionTags
                                    }];
    }
    
    for(int nI = 0; nI < aryTimeTitles.count; nI++)
    {
        NSMutableArray *arySectionTags = [[NSMutableArray alloc] init];
        
        for(int nJ = 0; nJ < self.m_aryImages.count; nJ++)
        {
            ImageObj *objImage = self.m_aryImages[nJ];
            if([aryTimeTitles[nI] isEqualToString:[self getYearFromDate:objImage.image_created_at]]) {
                [arySectionTags addObject:objImage];
            }
        }
        
        [m_aryTimePhotos addObject:@{
                                     @"header"   : aryTimeTitles[nI],
                                     @"contents" : arySectionTags
                                     }];
    }
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nSections;
    
    if(tableView == self.m_tblTag) {
        nSections = m_aryTagPhotos.count;
    } else {
        nSections = m_aryTimePhotos.count;
    }
    
    return nSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return TAGN_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TagNHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TagNHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.m_btnShowDropDown.hidden = YES;
    if(tableView == self.m_tblTag) {
        headerView.m_lblTagFullText.text = m_aryTagPhotos[section][@"header"];
    } else {
        headerView.m_lblTagFullText.text =m_aryTimePhotos[section][@"header"];
    }
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblTag) {
        return SEARCH_RESULT_CELL_HEIGHT;
    } else {
        return SEARCH_YEAR_CELL_HEIGHT;
    }
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblTag) {
        SearchResultTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [cell setImagesWithImageArray:m_aryTagPhotos[indexPath.section][@"contents"]];
        
        return cell;
    } else {
        SearchYearTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchYearTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [cell setImagesWithImageArray:m_aryTimePhotos[indexPath.section][@"contents"]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblTag) {
        SearchDetailViewController *searchDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetailViewController"];
        searchDetailVC.m_dicPhotos = m_aryTagPhotos[indexPath.section];
        [self.navigationController pushViewController:searchDetailVC animated:YES];
    } else {
        SearchMonthlyViewController *searchMonthlyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchMonthlyViewController"];
        searchMonthlyVC.m_dicMonthlyPhoto = m_aryTimePhotos[indexPath.section];
        [self.navigationController pushViewController:searchMonthlyVC animated:YES];
    }
}

- (NSString *)getYearFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    
    return [NSString stringWithFormat:@"%d", (int)[components year]];
}

- (IBAction)onClickBtnTag:(id)sender {
    if(m_bSelectedTag) {
        return;
    }
    
    m_bSelectedTag = YES;
    self.m_btnTag.selected = YES;
    self.m_btnTime.selected = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.m_constraintMarkerX.constant = 0;
                         self.m_sclMain.contentOffset = CGPointMake(0, 0);
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)onClickBtnTime:(id)sender {
    if(!m_bSelectedTag) {
        return;
    }
    
    m_bSelectedTag = NO;
    
    self.m_btnTag.selected = NO;
    self.m_btnTime.selected = YES;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.m_constraintMarkerX.constant = self.m_btnTime.frame.origin.x;
                         self.m_sclMain.contentOffset = CGPointMake(self.view.frame.size.width, 0);
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.m_sclMain) {
        self.m_constraintMarkerX.constant = scrollView.contentOffset.x / 2;
        CGFloat width = scrollView.frame.size.width;
        int nPageNum = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
        
        if(nPageNum == 0) { //tag
            self.m_btnTag.selected = YES;
            self.m_btnTime.selected = NO;
            
            self.m_viewScroll = self.m_tblTag;
        } else {
            self.m_btnTag.selected = NO;
            self.m_btnTime.selected = YES;
            
            self.m_viewScroll = self.m_tblTime;
        }
    } else {
        [super scrollViewDidScroll:scrollView];
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
