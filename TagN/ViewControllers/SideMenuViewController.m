//
//  SideMenuViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

#define SIDEMENU_WIDTH     200

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //side menu config
    UIViewController *tabBC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    UIViewController *leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftSideViewController"];
    
    self.centerViewController = tabBC;
    self.leftMenuViewController = leftVC;
    self.leftMenuWidth = SIDEMENU_WIDTH;

    self.panMode = MFSideMenuPanModeNone;
    
    [GlobalService sharedInstance].sidemenu_vc = self;
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

@end
