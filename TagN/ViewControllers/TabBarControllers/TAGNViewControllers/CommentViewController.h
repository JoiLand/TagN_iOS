//
//  CommentViewController.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : JHParallaxViewController<UIAlertViewDelegate> {
    NSMutableArray    *m_aryComments;
}

@property (weak, nonatomic) IBOutlet UITextField *m_txtInput;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewBottom;
@property (weak, nonatomic) IBOutlet UITableView *m_tblComment;

@property (nonatomic, retain) ImageObj  *m_objImage;

- (IBAction)onClickBtnSend:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
