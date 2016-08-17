//
//  StoryShareViewController.m
//  TagN
//
//  Created by JH Lee on 5/26/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "StoryShareViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ALAssetsLibrary-CustomPhotoAlbum/ALAssetsLibrary+CustomPhotoAlbum.h>

@interface StoryShareViewController ()

@end

@implementation StoryShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishVideoPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:self.m_videoUrl];
    player.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.m_viewPreview.frame), CGRectGetHeight(self.m_viewPreview.frame));
    player.controlStyle = MPMovieControlStyleNone;
    [player prepareToPlay];
    [self.m_viewPreview addSubview:player.view];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)didFinishVideoPlay {
    self.m_btnPlay.hidden = NO;
}

- (IBAction)onClickBtnBack:(id)sender {
    [player stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnShare:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.m_videoUrl]
                                                                             applicationActivities:nil];
    NSArray *aryActivities = @[UIActivityTypePrint,
                               UIActivityTypeCopyToPasteboard,
                               UIActivityTypeAssignToContact,
                               UIActivityTypeAddToReadingList,
                               UIActivityTypePostToTencentWeibo,
                               UIActivityTypeAirDrop,
                               UIActivityTypeOpenInIBooks,
                               UIActivityTypeSaveToCameraRoll];
    activityVC.excludedActivityTypes = aryActivities;
    
    [activityVC setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        NSMutableString *messageString = [[NSMutableString alloc]initWithCapacity:0];
        
        if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToFacebook"])
        {
            [messageString appendString:@"Story posted to facebook"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToTwitter"])
        {
            [messageString appendString:@"Story posted to twitter"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToWeibo"])
        {
            [messageString appendString:@"Story posted to weibo"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.Message"])
        {
            [messageString appendString:@"Story sent via message"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.Mail"])
        {
            [messageString appendString:@"Story sent by email"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToFlickr"])
        {
            [messageString appendString:@"Story posted to flickr"];
        }
        else if ([activityType isEqualToString:@"com.apple.UIKit.activity.PostToVimeo"])
        {
            [messageString appendString:@"Story posted to vimeo"];
        }
        else
        {
            [messageString appendString:@"Story posted"];
        }
        
        if(completed) {
            [self.view makeToast:messageString duration:3.f position:CSToastPositionCenter];
        }
    }];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)onClickBtnNext:(id)sender {
    [player stop];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onClickBtnPlay:(id)sender {
    [player play];
    self.m_btnPlay.hidden = YES;
}

- (IBAction)onClickBtnSaveStory:(id)sender {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary saveVideo:self.m_videoUrl
                     toAlbum:APP_NAME
                  completion:^(NSURL *assetURL, NSError *error) {
                      [self.view makeToast:@"Story Saved" duration:3.f position:CSToastPositionCenter];
                  }
                     failure:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
}

@end
