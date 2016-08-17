//
//  StoryShareViewController.h
//  TagN
//
//  Created by JH Lee on 5/26/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface StoryShareViewController : UIViewController {
    MPMoviePlayerController     *player;
}

@property (weak, nonatomic) IBOutlet UIView *m_viewPreview;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (nonatomic, retain) NSURL      *m_videoUrl;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnShare:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnPlay:(id)sender;
- (IBAction)onClickBtnSaveStory:(id)sender;

@end
