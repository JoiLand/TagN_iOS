//
//  CoreDataImage+CoreDataProperties.h
//  
//
//  Created by JH Lee on 2/9/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreDataImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *image_created_at;
@property (nullable, nonatomic, retain) NSData *image_thumb_data;
@property (nullable, nonatomic, retain) NSString *image_thumb_url;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, retain) NSString *image_url;
@property (nullable, nonatomic, retain) NSNumber *image_tag_id;
@property (nullable, nonatomic, retain) NSNumber *image_id;
@property (nullable, nonatomic, retain) NSNumber *image_user_id;
@property (nullable, nonatomic, retain) NSNumber *image_is_processing;
@property (nullable, nonatomic, retain) NSNumber *image_is_uploaded;
@property (nullable, nonatomic, retain) NSNumber *image_width;
@property (nullable, nonatomic, retain) NSNumber *image_height;

@end

NS_ASSUME_NONNULL_END
