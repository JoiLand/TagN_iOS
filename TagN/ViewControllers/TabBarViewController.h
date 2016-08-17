//
//  TabBarViewController.h
//  TagN
//
//  Created by Kevin Lee on 2/5/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <RDVTabBarController/RDVTabBarController.h>
#import <GPUImage/GPUImage.h>

#define TAGN_TABBAR_INDEX           0
#define MYTAGN_TABBAR_INDEX         1
#define CAMERA_TABBAR_INDEX         2
#define NOTIFICATION_TABBAR_INDEX   3
#define SEARCH_TABBAR_INDEX         4

@interface TabBarViewController : RDVTabBarController<RDVTabBarControllerDelegate>

@property (nonatomic, readwrite) NSInteger                  m_nLastSelectedIndex;

@property (nonatomic, retain) GPUImageStillCamera           *m_videoCamera;
@property (nonatomic, retain) GPUImageFilter                *m_filter;


@end
