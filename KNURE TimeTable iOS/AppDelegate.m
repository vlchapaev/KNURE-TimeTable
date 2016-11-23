//
//  AppDelegate.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import "AppDelegate.h"
#import "TabletTimeTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataStorage"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        TabletTimeTableViewController *controller = [[TabletTimeTableViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
        navigationController.navigationBar.translucent = NO;
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
    }
    return YES;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
