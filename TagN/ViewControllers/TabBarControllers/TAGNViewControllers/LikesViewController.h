//
//  LikesViewController.h
//  TagN
//
//  Created by JH Lee on 2/15/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikesViewController : JHParallaxViewController{
    NSArray     *m_aryLikers;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblLiker;
@property (nonatomic, retain) ImageObj      *m_objImage;

- (IBAction)onClickBtnBack:(id)sender;
@end
