//
//  NetworkSettingsViewController.m
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "NetworkSettingsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface NetworkSettingsViewController ()

@end

@implementation NetworkSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_btnUseCellularData.selected = [GlobalService sharedInstance].user_me.user_settings.use_cellular_data;
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

- (IBAction)onClickBtnUseCellularData:(id)sender {
    [GlobalService sharedInstance].user_me.user_settings.use_cellular_data = ![GlobalService sharedInstance].user_me.user_settings.use_cellular_data;
    self.m_btnUseCellularData.selected = [GlobalService sharedInstance].user_me.user_settings.use_cellular_data;
    
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        if([GlobalService sharedInstance].user_me.user_settings.use_cellular_data) {
            [JDStatusBarNotification dismissAnimated:YES];
            
            [GlobalService sharedInstance].is_internet_alive = YES;
        } else {
            [JDStatusBarNotification showWithStatus:JDSTATUS_NOTIFICATION_NO_INTERNET
                                          styleName:JDStatusBarStyleError];
            
            [[CoreDataService sharedInstance] rollbackAllUnuploadedImages];
            [GlobalService sharedInstance].is_internet_alive = NO;
        }
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [[GlobalService sharedInstance] saveMySettings];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
