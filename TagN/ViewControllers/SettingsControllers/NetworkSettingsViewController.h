//
//  NetworkSettingsViewController.h
//  TagN
//
//  Created by JH Lee on 2/20/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *m_btnUseCellularData;

- (IBAction)onClickBtnUseCellularData:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
