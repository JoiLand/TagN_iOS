//
//  CoreDataService.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataImage.h"

@interface CoreDataService : NSObject

+ (CoreDataService *) sharedInstance;

//save image which user created or edited on device
- (CoreDataImage *)saveImageObjWith:(ImageObj *)objImage
                              TagId:(NSNumber *)image_tag_id;

//save image and thumbnail server images
- (void)saveImageObj:(ImageObj *)objImage
           withImage:(UIImage *)image;

- (void)saveImageObj:(ImageObj *)objImage
      withThumbImage:(UIImage *)thumbImage;

//get images with tag_id, it is needed for MyTAGN and TAGN page
- (NSArray *)loadImagesWithTagId:(NSNumber *)image_tag_id;

//it is needed when app lunches to show unuploaded images
- (NSArray *)loadNotUploadedImages;


- (CoreDataImage *)getNotUploadedFirstImage;
- (void)rollbackAllUnuploadedImages;

//it is update image_id after finish to upload
- (void)updateCoreDataImage:(NSString *)image_url withId:(NSNumber *)image_id;

//delete images when user delete tag
- (void)deleteImagesWithTagID:(NSNumber *)tag_id;

//delete images when user select images to be deleted
- (void)deleteImagesWithImageIDs:(NSString *)image_ids;

//get image and thumbnail with url
- (UIImage *)getImageWithImageUrl:(NSString *)image_url;
- (UIImage *)getThumbImageWithImageUrl:(NSString *)image_thumb_url;

@end
