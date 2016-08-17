//
//  AppDelegate.h
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GPUImage/GPUImage.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSTimer     *m_uploaderTimer;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//custom methods
- (void)startApplication:(BOOL)animated;
- (void)startUploadService;

@end

