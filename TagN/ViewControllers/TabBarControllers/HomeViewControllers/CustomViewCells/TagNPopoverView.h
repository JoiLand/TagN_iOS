//
//  TagNPopoverView.h
//  TagN
//
//  Created by JH Lee on 5/25/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagNPopoverViewDelegate <NSObject>

- (void)onClickBtnAddPictureWithSection:(NSInteger)section;
- (void)onClickBtnMembersWithSection:(NSInteger)section;
- (void)onClickBtnDeleteImagesWithSection:(NSInteger)section;
- (void)onClickBtnDeleteTagWithSection:(NSInteger)section;
- (void)onClickBtnTagNStoryWithSection:(NSInteger)section;

@end

@interface TagNPopoverView : UIView

@property (weak, nonatomic) IBOutlet UIButton               *m_btnDropDownDeleteTag;

@property (nonatomic, readwrite) NSInteger                  m_nSection;
@property (nonatomic, retain) id<TagNPopoverViewDelegate>   delegate;

- (IBAction)onClickBtnDeleteTag:(id)sender;
- (IBAction)onClickBtnAddPicture:(id)sender;
- (IBAction)onClickBtnDeletePictures:(id)sender;
- (IBAction)onClickBtnMembers:(id)sender;
- (IBAction)onClickBtnTagNStory:(id)sender;

- (void)setViewsWithImageInfoObj:(ImageInfoObj *)objImageInfo onSection:(NSInteger)nSection;

@end
