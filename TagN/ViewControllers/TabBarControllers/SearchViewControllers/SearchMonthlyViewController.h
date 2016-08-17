//
//  SearchMonthlyViewController.h
//  TagN
//
//  Created by JH Lee on 2/14/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMonthlyViewController : JHParallaxViewController {
    NSMutableArray      *m_aryMonthlyPhotos;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblMonthlyPhoto;
@property (nonatomic, retain) NSDictionary          *m_dicMonthlyPhoto;

- (IBAction)onClickBtnBack:(id)sender;

@end
