//
//  PhotoEditForCameraViewController.m
//  TagN
//
//  Created by JH Lee on 2/6/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "PhotoEditForCameraViewController.h"
#import "TagEditViewController.h"
#import "ShareViewController.h"

@interface PhotoEditForCameraViewController ()

@end

@implementation PhotoEditForCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_ctrlPage.currentPage = 0;
    
    [self initViews];
}

- (void) initViews {
    //init scroll view
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    //remove all subviews
    for (UIView *imgView in self.m_sclImage.subviews) {
        [imgView removeFromSuperview];
    }

    for(int nIndex = 0; nIndex < self.m_aryPhotos.count; nIndex++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(nIndex * width, 0, width, height)];
        
        ImageObj *objImage = self.m_aryPhotos[nIndex];
        
        imgView.image = objImage.image_photo;
        imgView.backgroundColor = [UIColor blackColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.m_sclImage addSubview:imgView];
    }
    
    if(self.m_aryPhotos.count > 1) {
        self.m_ctrlPage.hidden = NO;
        self.m_ctrlPage.numberOfPages = self.m_aryPhotos.count;
    } else {
        self.m_ctrlPage.hidden = YES;
    }
    
    self.m_sclImage.contentSize = CGSizeMake(width * self.m_aryPhotos.count, height);
    [self.m_sclImage setContentOffset:CGPointMake(self.m_ctrlPage.currentPage * width, 0) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([GlobalService sharedInstance].user_me.user_active_tag.tag_id.intValue > 0) {
        self.m_lblActiveTag.text = [GlobalService sharedInstance].user_me.user_active_tag.tag_text;
        self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
        self.m_btnNext.userInteractionEnabled = YES;
        self.m_btnCamera.enabled = YES;
    } else {
        self.m_lblActiveTag.text = @"No Active Tag";
        self.m_btnNext.backgroundColor = [UIColor clearColor];
        self.m_btnNext.userInteractionEnabled = NO;
        self.m_btnCamera.enabled = NO;
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    int nPageNum = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
    
    self.m_ctrlPage.currentPage = nPageNum;
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnCamera:(id)sender {
    NSMutableArray *aryImages = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < self.m_aryPhotos.count; nIndex++) {
        CoreDataImage *coreDataImage = [[CoreDataService sharedInstance] saveImageObjWith:self.m_aryPhotos[nIndex]
                                                                                    TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id];
        
        ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:coreDataImage];
        [aryImages addObject:objImage];
    }
    
    ImageInfoObj *objInfoObj = [[ImageInfoObj alloc] initWithTag:[GlobalService sharedInstance].user_me.user_active_tag
                                                          Images:aryImages];
    
    if([GlobalService sharedInstance].user_me.user_active_tag.tag_user_id.intValue
       == [GlobalService sharedInstance].user_me.user_id.intValue) {
        [[GlobalService sharedInstance].user_me addMyImageInfo:objInfoObj];
    }
    
    [[GlobalService sharedInstance].user_me addShareImageInfo:objInfoObj];
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [[GlobalService sharedInstance].app_delegate startUploadService];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)onClickBtnSettings:(id)sender {
    ImageObj *objImage = self.m_aryPhotos[self.m_ctrlPage.currentPage];
    
    UIImage *curImage = objImage.image_photo;
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:curImage delegate:self];
    
    CLImageToolInfo *tool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
    tool.available = NO;
    
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLSplashTool" recursive:YES];
    tool.available = NO;
    
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:YES];
    tool.available = NO;
    
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLResizeTool" recursive:YES];
    tool.available = NO;
    
    [self presentViewController:editor animated:YES completion:nil];
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *aryImages = [self.m_aryPhotos mutableCopy];
        ImageObj *objImage = self.m_aryPhotos[self.m_ctrlPage.currentPage];
        objImage.image_photo = image;
        
        [aryImages replaceObjectAtIndex:self.m_ctrlPage.currentPage withObject:objImage];
        self.m_aryPhotos = [aryImages copy];
        [self initViews];
    }];
}

- (IBAction)onTouchDownChangeTag:(id)sender {
//    self.m_btnChangeTag.backgroundColor = [UIColor clearColor];
//    [self.m_btnChangeTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)onTouchUpChangeTag:(id)sender {
//    self.m_btnChangeTag.backgroundColor = TAGN_PANTONE_394_COLOR;
//    [self.m_btnChangeTag setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    TagEditViewController *tagEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagEditViewController"];
    tagEditVC.m_isAdd = NO;
    tagEditVC.m_aryPhotos = self.m_aryPhotos;
    [self.navigationController pushViewController:tagEditVC animated:YES];
}

- (IBAction)onTouchDownBtnNext:(id)sender {
    self.m_btnNext.backgroundColor = [UIColor clearColor];
}

- (IBAction)onTouchUpBtnNext:(id)sender {
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    
    NSMutableArray *aryImages = [[NSMutableArray alloc] init];
    for(int nIndex = 0; nIndex < self.m_aryPhotos.count; nIndex++) {
        CoreDataImage *coreDataImage = [[CoreDataService sharedInstance] saveImageObjWith:self.m_aryPhotos[nIndex]
                                                                                    TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id];
        
        ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:coreDataImage];
        [aryImages addObject:objImage];
    }
    
    ImageInfoObj *objInfoObj = [[ImageInfoObj alloc] initWithTag:[GlobalService sharedInstance].user_me.user_active_tag
                                                          Images:aryImages];
    
    if([GlobalService sharedInstance].user_me.user_active_tag.tag_user_id.intValue
       == [GlobalService sharedInstance].user_me.user_id.intValue) {
        [[GlobalService sharedInstance].user_me addMyImageInfo:objInfoObj];
    }
    
    [[GlobalService sharedInstance].user_me addShareImageInfo:objInfoObj];
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [[GlobalService sharedInstance].app_delegate startUploadService];
    }
    
    [GlobalService sharedInstance].tabbar_vc.selectedIndex = [GlobalService sharedInstance].tabbar_vc.m_nLastSelectedIndex;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
