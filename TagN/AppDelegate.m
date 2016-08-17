//
//  AppDelegate.m
//  TagN
//
//  Created by Kevin Lee on 2/4/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AFNetworking/AFNetworking.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <OneSignal/OneSignal.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>
#import "ContactUserObj.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Facebook SDK config
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //SVProgressHUD config
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [GlobalService sharedInstance].app_delegate = self;
    
    //load saved user object
    UserMe *objMe = [[GlobalService sharedInstance] loadMe];
    if(objMe) {
        [GlobalService sharedInstance].user_me = objMe;
        [self startApplication:NO];
    }
    
    OneSignal *oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                              appId:ONESIGNAL_APP_ID
                                                 handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
                                                     NSLog(@"OneSignal Notification opened:\nMessage: %@", message);
                                                     [JDStatusBarNotification showWithStatus:message
                                                                                dismissAfter:5.f
                                                                                   styleName:JDStatusBarStyleSuccess];
                                                     
                                                     if (additionalData) {
                                                         [self didReceiveRemoteNotification:additionalData];
                                                     }
                                                 }];
    
    [oneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        NSLog(@"UserId:%@", userId);
        [GlobalService sharedInstance].user_device_token = userId;
    }];

    [self checkReachability];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //add notification on notification view controller
    if(userInfo[@"noti_id"] && ![userInfo[@"noti_id"] isEqual:[NSNull null]]) {
        [[WebService sharedInstance] getNotificationWithId:userInfo[@"noti_id"]
                                                   success:^(NotiObj *objNoti) {
                                                       
                                                       [self actionWithNotification:objNoti];
                                                       
                                                       [[GlobalService sharedInstance].user_me.user_notifications insertObject:objNoti atIndex:0];
                                                       NSInteger nNewNotiCount = 0;
                                                       for(int nIndex = 0; nIndex < [GlobalService sharedInstance].user_me.user_notifications.count; nIndex++) {
                                                           NotiObj *objNoti = [GlobalService sharedInstance].user_me.user_notifications[nIndex];
                                                           
                                                           if(objNoti.noti_is_read == NO && [[GlobalService sharedInstance] isAvailableNotification:objNoti]) {
                                                               nNewNotiCount++;
                                                           }
                                                       }
                                                       
                                                       [[GlobalService sharedInstance] setNotificationBadge:nNewNotiCount];
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_NOTIFICATION object:nil];
                                                   }
                                                   failure:^(NSString *strError) {
                                                       NSLog(@"Got error new notification from Push: %@", strError);
                                                   }];
    }
}

- (void)actionWithNotification:(NotiObj *)objNoti {
    switch (objNoti.noti_type) {
        case TAGN_PUSH_ACCEPT_SHARE:
            //share my tag with share_tag_id
            [[GlobalService sharedInstance].user_me shareMyImageInfoWithTagId:objNoti.noti_share_tag_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS object:nil];
            
            break;
            
        case TAGN_PUSH_UNSHARE_REQUEST:
        case TAGN_PUSH_REMOVE_SHARE_TAG:
            //remove share tag images from share album
            [[GlobalService sharedInstance].user_me deleteUserTagWithTagID:objNoti.noti_share_tag_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS object:nil];
            [self getAllNotifications];
            
            break;
            
        case TAGN_PUSH_REMOVE_PHOTO:
            //update share tag images with share_tag_id
            [[JHImageService sharedInstance] addShareTagWithTagId:objNoti.noti_share_tag_id
                                                          success:^(NSString *strResult) {
                                                              NSLog(@"%@", strResult);
                                                          }
                                                          failure:^(NSString *strError) {
                                                              NSLog(@"%@", strError);
                                                          }];
            
            break;
            
        case TAGN_PUSH_UPLOAD_PHOTO:
        case TAGN_PUSH_ADD_COMMENT:
        case TAGN_PUSH_REMOVE_COMMENT:
        case TAGN_PUSH_LIKED_IMAGE:
        case TAGN_PUSH_DISLIKED_IMAGE:
            //get new ImageObj from server
            [[JHImageService sharedInstance] updateImageWithImageId:objNoti.noti_share_image_id
                                                             UserId:[GlobalService sharedInstance].user_me.user_id
                                                            success:^(NSString *strResult) {
                                                                NSLog(@"%@", strResult);
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_NOTIFICATION object:nil];
                                                            }
                                                            failure:^(NSString *strError) {
                                                                NSLog(@"%@", strError);
                                                            }];
            break;
            
        default:
            break;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.joiland.TagN" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TagN" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TagN.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Custom Methods
- (void)startApplication:(BOOL)animated {
    
    [self getAllTagNImages];
    [self getAllNotifications];
    [self getAllContacts];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    UIViewController *sideMenuVC = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    [navController pushViewController:sideMenuVC animated:animated];
}

- (void)startUploadService {
    //create image upload thread
    if(m_uploaderTimer)
        return;
    
    m_uploaderTimer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                       target:self
                                                     selector:@selector(uploadImage)
                                                     userInfo:nil
                                                      repeats:YES];
    [self uploadImage];
}

- (void)stopUploadService {
    [[CoreDataService sharedInstance] rollbackAllUnuploadedImages];
    [m_uploaderTimer invalidate];
    m_uploaderTimer = nil;
}

- (void)uploadImage {
    CoreDataImage *objCoreDataImage = [[CoreDataService sharedInstance] getNotUploadedFirstImage];
    
    if(objCoreDataImage) {
        ImageObj *objImage = [[ImageObj alloc] initWithCoreDataImage:objCoreDataImage];
        [[WebService sharedInstance] uploadImageObj:objImage
                                           WithData:objCoreDataImage.image_data
                                            success:^(NSNumber *nImageId) {
                                                [[CoreDataService sharedInstance] updateCoreDataImage:objImage.image_url
                                                                                               withId:nImageId];
                                                
                                                objImage.image_id = nImageId;
                                                objImage.image_is_uploaded = [NSNumber numberWithBool:YES];
                                                [[GlobalService sharedInstance].user_me updateMyImageInfoWith:objImage];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_MY_PHOTOS
                                                                                                    object:nil
                                                                                                  userInfo:@{@"image_obj": objImage.image_tag_id}];
                                                
                                                [[GlobalService sharedInstance].user_me updateShareImageInfoWith:objImage];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SHARE_PHOTOS
                                                                                                    object:nil
                                                                                                  userInfo:@{@"image_obj": objImage.image_tag_id}];
                                                
                                                NSLog(@"Uploaded Image - %d", nImageId.intValue);
                                                
                                            }
                                            failure:^(NSString *strError) {
                                                NSLog(@"Failed to upload image");
                                            }];
    } else {
        [self stopUploadService];
    }
}

- (void)getAllNotifications {
    [[WebService sharedInstance] getAllNotificationsWithUserId:[GlobalService sharedInstance].user_me.user_id
                                                       success:^(NSArray *aryNotis) {
                                                           NSLog(@"Get All Notifications");
                                                           [GlobalService sharedInstance].user_me.user_notifications = [aryNotis mutableCopy];
                                                           NSInteger nNewNotiCount = 0;
                                                           for(int nIndex = 0; nIndex < aryNotis.count; nIndex++) {
                                                               NotiObj *objNoti = aryNotis[nIndex];
                                                               
                                                               if(objNoti.noti_is_read == NO && [[GlobalService sharedInstance] isAvailableNotification:objNoti]) {
                                                                   nNewNotiCount++;
                                                               }
                                                           }
                                                           
                                                           [[GlobalService sharedInstance] setNotificationBadge:nNewNotiCount];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_NOTIFICATION object:nil];
                                                       }
                                                       failure:^(NSString *strError) {
                                                           NSLog(@"%@", strError);
                                                       }];
}

- (void)getAllTagNImages {
    SVPROGRESSHUD_PLEASE_WAIT;
    [[JHImageService sharedInstance] getAllTagNImagesWithId:[GlobalService sharedInstance].user_me.user_id
                                                    success:^(NSString *strResult) {
                                                        SVPROGRESSHUD_DISMISS;
                                                        NSLog(@"%@", strResult);
                                                    }
                                                    failure:^(NSString *strError) {
                                                        SVPROGRESSHUD_ERROR(strError);
                                                    }];
}

- (void)checkReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [JDStatusBarNotification showWithStatus:JDSTATUS_NOTIFICATION_NO_INTERNET
                                              styleName:JDStatusBarStyleError];
                
                [[CoreDataService sharedInstance] rollbackAllUnuploadedImages];
                [GlobalService sharedInstance].is_internet_alive = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [JDStatusBarNotification dismissAnimated:YES];
                
                [GlobalService sharedInstance].is_internet_alive = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if(![GlobalService sharedInstance].user_me
                   || [GlobalService sharedInstance].user_me.user_settings.use_cellular_data) {
                    [JDStatusBarNotification dismissAnimated:YES];
                    
                    [GlobalService sharedInstance].is_internet_alive = YES;
                } else {
                    [JDStatusBarNotification showWithStatus:JDSTATUS_NOTIFICATION_NO_INTERNET
                                                  styleName:JDStatusBarStyleError];
                    
                    [[CoreDataService sharedInstance] rollbackAllUnuploadedImages];
                    [GlobalService sharedInstance].is_internet_alive = NO;
                }
                break;
                
            default:
                break;
        }
        
        if([GlobalService sharedInstance].is_internet_alive) {
            [self startUploadService];
        } else {
            [self stopUploadService];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) getAllContacts {
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                NSLog(@"Access Denied");
            }
        });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        if (addressBook != nil) {
            
            NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            NSMutableArray *aryContacts = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [allContacts count]; i++) {
                
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                UIImage *avatar = nil;
                if(ABPersonHasImageData(contactPerson)) {
                    avatar = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail)];
                }
                
                // to set contact name
                NSString *firstName = (__bridge NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                
                if (lastName == nil || [lastName isEqual:[NSNull null]]) {
                    lastName = @"";
                }
                if (firstName == nil || [firstName isEqual:[NSNull null]]) {
                    firstName = @"";
                }
                
                if ([firstName isEqualToString:@""] && [lastName isEqualToString:@""]) {
                    
                    continue;
                }
                
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
                //get Email addresses
                ABMultiValueRef multiEmails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                NSMutableArray *aryEmails = [[NSMutableArray alloc] init];
                for(CFIndex i = 0; i < ABMultiValueGetCount(multiEmails); i++) {
                    NSString *strEmail = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(multiEmails, i);
                    [aryEmails addObject:strEmail];
                }
                
                if(aryEmails.count == 0) {
                    continue;
                }
                
                //get Phone Numbers
                ABMultiValueRef multiPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                NSMutableArray *aryPhones = [[NSMutableArray alloc] init];
                for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
                    
                    NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NBPhoneNumber *number = [[NBPhoneNumberUtil sharedInstance] parse:phoneNumber
                                                                        defaultRegion:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
                                                                                error:nil];
                    if([[NBPhoneNumberUtil sharedInstance] isValidNumber:number]) {
                        [aryPhones addObject:[[NBPhoneNumberUtil sharedInstance] format:number
                                                                           numberFormat:NBEPhoneNumberFormatE164
                                                                                  error:nil]];
                    }
                }
                
                [aryContacts addObject:[[ContactUserObj alloc] initWithAvatar:avatar
                                                                         Name:fullName
                                                                       Emails:aryEmails
                                                                       Phones:aryPhones]];
                
            }
            
            [GlobalService sharedInstance].user_contacts = [aryContacts copy];
        }
    } else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        
        NSLog(@"Cannot fetch Contacts :( ");
    }
    
    CFRelease(addressBook);
}

@end
