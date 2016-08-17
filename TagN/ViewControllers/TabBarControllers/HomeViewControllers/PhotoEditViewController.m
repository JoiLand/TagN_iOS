//
//  PhotoEditViewController.m
//  TagN
//
//  Created by JH Lee on 2/11/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "ShareViewController.h"

@interface PhotoEditViewController ()

@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_objTmpImage = [[ImageObj alloc] initWithDictionary:self.m_objImage.currentDictionary];
    self.m_lblTitle.text = [GlobalService sharedInstance].user_me.user_active_tag.tag_text;
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    
    [self.m_viewPhoto initViews:self.view.frame];
    [self.m_viewPhoto setImageWithImageObj:m_objTmpImage];
    
    if(self.m_objImage.image_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {
        self.m_btnNext.hidden = NO;
        self.m_btnEdit.hidden = NO;
    } else {
        self.m_btnNext.hidden = YES;
        self.m_btnEdit.hidden = YES;
    }
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnEdit:(id)sender{
    if(self.m_objImage.image_photo) {
        UIImage *curImage = self.m_objImage.image_photo;
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
    } else {
        [self.view makeToast:TOAST_PHOTO_NOT_DOWNLOAD];
    }
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [editor dismissViewControllerAnimated:YES completion:^{
        m_objTmpImage.image_photo = image;
        
        [self.m_viewPhoto setImageWithImageObj:m_objTmpImage];
    }];
}

- (IBAction)onTouchDownNext:(id)sender {
    self.m_btnNext.backgroundColor = [UIColor clearColor];
}

- (IBAction)onTouchUpNext:(id)sender {
    self.m_btnNext.backgroundColor = TAGN_PANTONE_368_COLOR;
    
    CoreDataImage *coreDataImage = [[CoreDataService sharedInstance] saveImageObjWith:m_objTmpImage
                                                                                TagId:[GlobalService sharedInstance].user_me.user_active_tag.tag_id];
    
    ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:coreDataImage];
    ImageInfoObj *objInfoObj = [[ImageInfoObj alloc] initWithTag:[GlobalService sharedInstance].user_me.user_active_tag
                                                          Images:@[objImage]];
    
    if([GlobalService sharedInstance].user_me.user_active_tag.tag_user_id.intValue
       == [GlobalService sharedInstance].user_me.user_id.intValue) {
        [[GlobalService sharedInstance].user_me addMyImageInfo:objInfoObj];
    }
    
    [[GlobalService sharedInstance].user_me addShareImageInfo:objInfoObj];
    
    if([GlobalService sharedInstance].is_internet_alive) {
        [[GlobalService sharedInstance].app_delegate startUploadService];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
