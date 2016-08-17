//
//  LikesViewController.m
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "LikesViewController.h"
#import "LikerTableViewCell.h"

@interface LikesViewController ()

@end

@implementation LikesViewController

#define LIKER_TABLE_CELL_HEIGHT         50

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [self onRefreshLikers:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshLikers:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblLiker addSubview:refresh];
}

- (void)onRefreshLikers:(UIRefreshControl *)refresh {
    [[WebService sharedInstance] getImageLikers:self.m_objImage.image_id
                                         UserId:[GlobalService sharedInstance].user_me.user_id
                                        success:^(NSArray *aryLikers) {
                                            SVPROGRESSHUD_DISMISS;
                                            [refresh endRefreshing];
                                            
                                            m_aryLikers = aryLikers;
                                            [self.m_tblLiker reloadData];
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

#pragma mark - TableView delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_aryLikers.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LIKER_TABLE_CELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageLikerObj *objImageLiker = m_aryLikers[indexPath.row];
    
    LikerTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"LikerTableViewCell" owner:nil options:nil] objectAtIndex:0];
    [cell setViewsWithImageLikerObj:objImageLiker];
    
    return cell;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
