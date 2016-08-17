//
//  MyTagNTableViewCell.h
//  TagN
//
//  Created by JH Lee on 2/9/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTagNTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgFirstPhoto;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgFirstStatus;

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgSecondPhoto;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgSecondStatus;

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgThirdPhoto;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgThirdStatus;

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgForthPhoto;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgForthStatus;

- (void)setViewsWithImageInfoObj:(ImageInfoObj *)objImageInfo onSection:(NSInteger)nSection;

@end
