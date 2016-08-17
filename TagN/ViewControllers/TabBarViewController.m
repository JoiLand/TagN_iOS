//
//  TabBarViewController.m
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "TabBarViewController.h"

#import <RDVTabBarController/RDVTabBarItem.h>

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *tagnNC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagNNavigationController"];
    UINavigationController *homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraRootViewController"];
    UINavigationController *notificationNC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationNavigationController"];
    UINavigationController *searchNC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchNavigationController"];
    
    self.viewControllers = @[tagnNC, homeNC, cameraVC, notificationNC, searchNC];
    
    NSArray *aryTabItemImages = @[@"Share", @"Private", @"Filter", @"Notification", @"Search"];
    
    UIImage *imgBg = [UIImage imageNamed:@"tabbar_bg"];
    UIImage *imgBg1 = [UIImage imageNamed:@"tabbar_bg1"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items])
    {
        [item setBackgroundSelectedImage:imgBg1 withUnselectedImage:imgBg];
        
        UIImage *imgNormal = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_icon%@Normal", [aryTabItemImages objectAtIndex:index]]];
        UIImage *imgSelected = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_icon%@Selected", [aryTabItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:imgSelected withFinishedUnselectedImage:imgNormal];
        
        if(index == NOTIFICATION_TABBAR_INDEX) {
            item.badgePositionAdjustment = UIOffsetMake(-20, 0);
        }
        
        index ++;
    }
    
    self.m_nLastSelectedIndex = 0;
    
    [GlobalService sharedInstance].tabbar_vc = self;
    [GlobalService sharedInstance].tabbar_vc.delegate = self;
    
    //camera settings
    self.m_videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.m_videoCamera.outputImageOrientation = UIDeviceOrientationPortrait;
    self.m_filter = [[GPUImageFilter alloc] init];
    [self.m_videoCamera addTarget:self.m_filter];
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

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {    
    if(index == TAGN_TABBAR_INDEX
       || index == MYTAGN_TABBAR_INDEX) {
        
        UINavigationController *navVC = self.viewControllers[index];
        [navVC popToRootViewControllerAnimated:NO];
        
        self.m_nLastSelectedIndex = index;
        
        return YES;
    }else if(index == CAMERA_TABBAR_INDEX) {
        UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
        UINavigationController *cameraNC = [[UINavigationController alloc] initWithRootViewController:cameraVC];
        cameraNC.navigationBarHidden = YES;
        [self presentViewController:cameraNC animated:NO completion:nil];
        return NO;
    } else if(index == SEARCH_TABBAR_INDEX
              || index == NOTIFICATION_TABBAR_INDEX) {
        UINavigationController *navVC = self.viewControllers[index];
        [navVC popToRootViewControllerAnimated:NO];
    }
    
    return YES;
}

@end
