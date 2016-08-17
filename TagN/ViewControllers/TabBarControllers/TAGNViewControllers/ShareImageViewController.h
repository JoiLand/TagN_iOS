//
//  ShareImageViewController.h
//  TagN
//
//  Created by JH Lee on 2/17/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNDetailTableViewCell.h"

@interface ShareImageViewController : UIViewController<TagNDetailTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblImage;

@property (nonatomic, retain) ImageObj              *m_objImage;

- (IBAction)onClickBtnBack:(id)sender;

@end
