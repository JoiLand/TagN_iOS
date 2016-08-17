//
//  CoreDataService.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "CoreDataService.h"

@implementation CoreDataService

static CoreDataService *_coreDataService = nil;

+ (CoreDataService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_coreDataService == nil) {
            _coreDataService = [[self alloc] init]; // assignment not done here
        }
    });
    return _coreDataService;
}

- (CoreDataImage *)saveImageObjWith:(ImageObj *)objImage
                              TagId:(NSNumber *)image_tag_id {
    
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    CoreDataImage *myImage;
    if(objImage.image_id.intValue == 0) {   //new image
        
        myImage = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataImage"
                                                inManagedObjectContext:objContext];
        
        myImage.image_id = objImage.image_id;
        myImage.image_user_id = objImage.image_user_id;
        myImage.image_tag_id = image_tag_id;
        myImage.image_url = [[GlobalService sharedInstance] makeMyImageUrlWithTagId:image_tag_id];
        myImage.image_data = UIImageJPEGRepresentation(objImage.image_photo, 0.5f);
        myImage.image_width = [NSNumber numberWithFloat:objImage.image_photo.size.width];
        myImage.image_height = [NSNumber numberWithFloat:objImage.image_photo.size.height];
        myImage.image_thumb_url = [[GlobalService sharedInstance] makeMyThumbImageUrlWithTagId:image_tag_id];
        myImage.image_thumb_data = UIImageJPEGRepresentation([objImage.image_photo resizedImageWithMinimumSize:AVATAR_IMAGE_SIZE], 0.5f);
        myImage.image_created_at = [NSDate date];
        myImage.image_is_processing = [NSNumber numberWithBool:NO];
        myImage.image_is_uploaded = [NSNumber numberWithBool:NO];
    } else {    //edit image
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                                  inManagedObjectContext:objContext];
        [fetchRequest setEntity:entity];
        
        //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
        //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
        //If you exchanged same with deleted card, you need not to save all information again for him.
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_id = %d", objImage.image_id.intValue];
        [fetchRequest setPredicate:predicate];
        
        NSArray *aryCoreDataMyImages = [objContext executeFetchRequest:fetchRequest error:nil];
        if(aryCoreDataMyImages.count > 0) {
            myImage = aryCoreDataMyImages[0];
            
            myImage.image_url = [[GlobalService sharedInstance] makeMyImageUrlWithTagId:image_tag_id];
            myImage.image_data = UIImageJPEGRepresentation(objImage.image_photo, 0.5f);
            myImage.image_width = [NSNumber numberWithFloat:objImage.image_photo.size.width];
            myImage.image_height = [NSNumber numberWithFloat:objImage.image_photo.size.height];
            myImage.image_thumb_url = [[GlobalService sharedInstance] makeMyThumbImageUrlWithTagId:image_tag_id];
            myImage.image_thumb_data = UIImageJPEGRepresentation([objImage.image_photo resizedImageWithMinimumSize:AVATAR_IMAGE_SIZE], 0.5f);
            myImage.image_created_at = [NSDate date];
            myImage.image_is_processing = [NSNumber numberWithBool:NO];
            myImage.image_is_uploaded = [NSNumber numberWithBool:NO];
        }
    }
    NSError *error;
    if (![objContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return myImage;
}

- (NSArray *)loadImagesWithTagId:(NSNumber *)image_tag_id {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_tag_id = %d", image_tag_id.intValue];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"image_created_at" ascending:NO]]];
    [fetchRequest setFetchLimit:4];
    [fetchRequest setPropertiesToFetch:@[@"image_thumb_url", @"image_thumb_data"]];
    
    NSArray *aryCoreDataMyImages = [objContext executeFetchRequest:fetchRequest error:nil];
    
    return aryCoreDataMyImages;
}

- (NSArray *)loadNotUploadedImages {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_is_uploaded = false and image_user_id = %d", [GlobalService sharedInstance].user_me.user_id.intValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    for(int nIndex = 0; nIndex < aryCoreDataImages.count; nIndex++) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[nIndex];
        objCoreDataImage.image_is_processing = [NSNumber numberWithBool:NO];
    }
    
    NSError *error;
    if (![objContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return aryCoreDataImages;
}

- (CoreDataImage *)getNotUploadedFirstImage {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_is_uploaded = false and image_is_processing = false and image_user_id = %d", [GlobalService sharedInstance].user_me.user_id.intValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    if(aryCoreDataImages.count > 0) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[0];
        objCoreDataImage.image_is_processing = [NSNumber numberWithBool:YES];
        
        NSError *error;
        if (![objContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        return objCoreDataImage;
    } else {
        return nil;
    }
}

- (void)rollbackAllUnuploadedImages {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_is_uploaded = false and image_user_id = %d", [GlobalService sharedInstance].user_me.user_id.intValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    for(int nIndex = 0; nIndex < aryCoreDataImages.count; nIndex++) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[nIndex];
        objCoreDataImage.image_is_processing = [NSNumber numberWithBool:NO];
    }
    
    NSError *error;
    if (![objContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return;
}

- (void)updateCoreDataImage:(NSString *)image_url withId:(NSNumber *)image_id {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(image_url = %@)", image_url];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    if(aryCoreDataImages.count > 0) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[0];
        objCoreDataImage.image_id = image_id;
        objCoreDataImage.image_is_uploaded = [NSNumber numberWithBool:YES];
        
        NSError *error;
        if (![objContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

- (void)saveImageObj:(ImageObj *)objImage
           withImage:(UIImage *)image {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    [objContext performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                                  inManagedObjectContext:objContext];
        [fetchRequest setEntity:entity];
        
        //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
        //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
        //If you exchanged same with deleted card, you need not to save all information again for him.
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_id = %d", objImage.image_id.intValue];
        [fetchRequest setPredicate:predicate];
        
        NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
        CoreDataImage *objCoreDataImage;
        if(aryCoreDataImages.count > 0) {
            objCoreDataImage = aryCoreDataImages[0];
            objCoreDataImage.image_data = UIImageJPEGRepresentation(image, 1.f);
            objCoreDataImage.image_width = [NSNumber numberWithFloat:image.size.width];
            objCoreDataImage.image_height = [NSNumber numberWithFloat:image.size.height];
        } else {
            NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
            
            objCoreDataImage = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataImage"
                                                             inManagedObjectContext:objContext];
            
            objCoreDataImage.image_id = objImage.image_id;
            objCoreDataImage.image_user_id = objImage.image_user_id;
            objCoreDataImage.image_tag_id = objImage.image_tag_id;
            objCoreDataImage.image_url = objImage.image_url;
            objCoreDataImage.image_data = UIImageJPEGRepresentation(image, 1.f);
            objCoreDataImage.image_width = [NSNumber numberWithFloat:image.size.width];
            objCoreDataImage.image_height = [NSNumber numberWithFloat:image.size.height];
            objCoreDataImage.image_thumb_url = objImage.image_thumb_url;
            objCoreDataImage.image_thumb_data = nil;
            objCoreDataImage.image_created_at = [NSDate date];
            objCoreDataImage.image_is_processing = [NSNumber numberWithBool:YES];
            objCoreDataImage.image_is_uploaded = [NSNumber numberWithBool:YES];
        }
        
        NSError *error;
        if (![objContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
}

- (void)saveImageObj:(ImageObj *)objImage
      withThumbImage:(UIImage *)thumbImage {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    [objContext performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                                  inManagedObjectContext:objContext];
        [fetchRequest setEntity:entity];
        
        //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
        //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
        //If you exchanged same with deleted card, you need not to save all information again for him.
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_id = %d", objImage.image_id.intValue];
        [fetchRequest setPredicate:predicate];
        
        NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
        CoreDataImage *objCoreDataImage;
        if(aryCoreDataImages.count > 0) {
            objCoreDataImage = aryCoreDataImages[0];
            objCoreDataImage.image_thumb_data = UIImageJPEGRepresentation(thumbImage, 1.f);
        } else {
            NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
            
            objCoreDataImage = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataImage"
                                                             inManagedObjectContext:objContext];
            
            objCoreDataImage.image_id = objImage.image_id;
            objCoreDataImage.image_user_id = objImage.image_user_id;
            objCoreDataImage.image_tag_id = objImage.image_tag_id;
            objCoreDataImage.image_url = objImage.image_url;
            objCoreDataImage.image_data = nil;
            objCoreDataImage.image_thumb_url = objImage.image_thumb_url;
            objCoreDataImage.image_thumb_data = UIImageJPEGRepresentation(thumbImage, 1.f);
            objCoreDataImage.image_created_at = [NSDate date];
            objCoreDataImage.image_is_processing = [NSNumber numberWithBool:YES];
            objCoreDataImage.image_is_uploaded = [NSNumber numberWithBool:YES];
        }
        
        NSError *error;
        if (![objContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
}

- (void)deleteImagesWithTagID:(NSNumber *)tag_id {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_tag_id = %d", tag_id.intValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    for(CoreDataImage *objCoreDataImage in aryCoreDataImages) {
        [objContext deleteObject:objCoreDataImage];
    }
}

- (void)deleteImagesWithImageIDs:(NSString *)image_ids {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    //HK Comment: checking for delete is not needed. User_ID should be a auto increase number
    //Answer: When you delete the exchanged card, it is removed from local db. (NOTE: when exchange card, not share contacts.)
    //If you exchanged same with deleted card, you need not to save all information again for him.
    
    NSArray *aryImageIDs = [image_ids componentsSeparatedByString:@","];
    for(NSString *image_id in aryImageIDs) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image_id = %d", image_id.intValue];
        [fetchRequest setPredicate:predicate];
        
        NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
        for(CoreDataImage *objCoreDataImage in aryCoreDataImages) {
            [objContext deleteObject:objCoreDataImage];
        }
    }
}

- (UIImage *)getImageWithImageUrl:(NSString *)image_url {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(image_url = %@)", image_url];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    UIImage *image = nil;
    if(aryCoreDataImages.count > 0) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[0];
        if(objCoreDataImage.image_data) {
            image = [UIImage imageWithData:objCoreDataImage.image_data];
        }
    }
    
    return image;
}

- (UIImage *)getThumbImageWithImageUrl:(NSString *)image_thumb_url {
    NSManagedObjectContext *objContext = [GlobalService sharedInstance].app_delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataImage"
                                              inManagedObjectContext:objContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(image_thumb_url = %@)", image_thumb_url];
    [fetchRequest setPredicate:predicate];
    
    NSArray *aryCoreDataImages = [objContext executeFetchRequest:fetchRequest error:nil];
    UIImage *image = nil;
    if(aryCoreDataImages.count > 0) {
        CoreDataImage *objCoreDataImage = aryCoreDataImages[0];
        if(objCoreDataImage.image_thumb_data) {
            image = [UIImage imageWithData:objCoreDataImage.image_thumb_data];
        }
    }
    
    return image;
}

@end
