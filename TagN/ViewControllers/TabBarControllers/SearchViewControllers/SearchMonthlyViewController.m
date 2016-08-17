//
//  SearchMonthlyViewController.m
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SearchMonthlyViewController.h"
#import "TagNHeaderView.h"
#import "SearchResultTableViewCell.h"
#import "SearchDetailViewController.h"

@interface SearchMonthlyViewController ()

@end

@implementation SearchMonthlyViewController

#define TAGN_HEADERVIEW_HEIGHT      35
#define SEARCH_TABLE_CELL_HEIGHT    self.view.frame.size.width / 3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_lblTitle.text = self.m_dicMonthlyPhoto[@"header"];
    
    [self sortMonthlyImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sortMonthlyImages {
    m_aryMonthlyPhotos = [[NSMutableArray alloc] init];
    
    NSMutableArray *aryMonthTitles = [[NSMutableArray alloc] init];
    NSArray *aryPhotos = self.m_dicMonthlyPhoto[@"contents"];
    
    for(int nIndex = 0; nIndex < aryPhotos.count; nIndex++)
    {
        ImageObj *objImage = aryPhotos[nIndex];
        [aryMonthTitles addObject:[self getMonthFromDate:objImage.image_created_at]];
    }
    
    aryMonthTitles = [[[[NSSet setWithArray:aryMonthTitles] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    
    for(int nI = 0; nI < aryMonthTitles.count; nI++)
    {
        NSMutableArray *arySectionTags = [[NSMutableArray alloc] init];
        
        for(int nJ = 0; nJ < aryPhotos.count; nJ++)
        {
            ImageObj *objImage = aryPhotos[nJ];
            if([aryMonthTitles[nI] isEqualToString:[self getMonthFromDate:objImage.image_created_at]]) {
                [arySectionTags addObject:objImage];
            }
        }
        
        NSString *strMonth = [NSString stringWithFormat:@"%@ %@",
                              [self getMonthStringFromInteger:[aryMonthTitles[nI] integerValue]],
                              self.m_dicMonthlyPhoto[@"header"]];
        
        [m_aryMonthlyPhotos addObject:@{
                                      @"header"   : strMonth,
                                      @"contents" : arySectionTags
                                      }];
    }
    

}

- (NSString *)getMonthFromDate:(NSDate *)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    
    return [NSString stringWithFormat:@"%d", (int)[components month]];
}

- (NSString *)getMonthStringFromInteger:(NSInteger)month {
    NSArray *aryMonthStrings = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    return aryMonthStrings[month - 1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return m_aryMonthlyPhotos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return TAGN_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TagNHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TagNHeaderView" owner:nil options:nil] objectAtIndex:0];
    headerView.m_btnShowDropDown.hidden = YES;
   
    headerView.m_lblTagFullText.text = m_aryMonthlyPhotos[section][@"header"];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SEARCH_TABLE_CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setImagesWithImageArray:m_aryMonthlyPhotos[indexPath.section][@"contents"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchDetailViewController *searchDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetailViewController"];
    searchDetailVC.m_dicPhotos = m_aryMonthlyPhotos[indexPath.section];
    [self.navigationController pushViewController:searchDetailVC animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
