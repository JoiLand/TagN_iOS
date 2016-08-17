//
//  CameraGridView.h
//  TagN
//
//  Created by JH Lee on 2/23/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraGridView : UIView

/**
 *  The line width of a line. Default value is 1.0.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  The number of the grid's columns. Default value is 2.
 */
@property (nonatomic, assign) NSUInteger numberOfColumns;

/**
 *  The number of the grid's rows. Default value is 2.
 */
@property (nonatomic, assign) NSUInteger numberOfRows;

@end
