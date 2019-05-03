////
////  AppDelegate.m
////  KNURE TimeTable
////
////  Created by Vladislav Chapaev on 24.10.2013.
////  Copyright (c) 2013 Vladislav Chapaev. All rights reserved.
////
//
//#import "AppDelegate.h"
//#import "EventParser.h"
//#import "Configuration.h"
//#import "Item.h"
//#import "Request.h"
//
//@implementation AppDelegate
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [EventParser initializeSharedStorage];
//    [[Configuration sharedInstance]setupTheme];
//    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:43200];
//    return YES;
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    UIBackgroundTaskIdentifier __block backgroundTask = [application beginBackgroundTaskWithName:@"TimetableBackgroundFetchIdentifier" expirationHandler:^{
//        // Clean up any unfinished task business by marking where you
//        // stopped or ending the task outright.
//        [application endBackgroundTask:backgroundTask];
//        backgroundTask = UIBackgroundTaskInvalid;
//    }];
//    
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // Do the work associated with the task, preferably in chunks.
//        
//        [application endBackgroundTask:backgroundTask];
//        backgroundTask = UIBackgroundTaskInvalid;
//    });
//}
//
//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    Item *selectedItem = [Item getSelectedItem];
//    if (selectedItem) {
//        [Request loadTimeTableForItem:selectedItem completion:^(id response) {
//            [[EventParser sharedInstance]parseTimeTable:response itemID:selectedItem.id callBack:^{
//                selectedItem.last_update = [NSDate date];
//                [selectedItem saveAsSelectedItem];
//                [[selectedItem managedObjectContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
//                    completionHandler(UIBackgroundFetchResultNewData);
//                }];
//            }];
//        } failure:^(NSError *error) {
//            completionHandler(UIBackgroundFetchResultFailed);
//        }];
//    }
//}
//
//@end
