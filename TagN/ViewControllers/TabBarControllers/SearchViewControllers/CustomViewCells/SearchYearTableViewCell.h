//
//  SearchYearTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchYearTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto2;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto3;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto4;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto5;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto6;

- (void)setImagesWithImageArray:(NSArray *)aryImages;

@end
