//
//  SearchDetailViewController.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagNDetailTableViewCell.h"

@interface SearchDetailViewController : JHParallaxViewController<TagNDetailTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *m_tblPhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cltPhoto;
@property (weak, nonatomic) IBOutlet UIButton *m_btnShowType;

@property (nonatomic, retain) NSDictionary          *m_dicPhotos;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnShowType:(id)sender;

@end
