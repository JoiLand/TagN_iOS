//
//  SearchResultTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto2;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto3;

- (void)setImagesWithImageArray:(NSArray *)aryImages;

@end
