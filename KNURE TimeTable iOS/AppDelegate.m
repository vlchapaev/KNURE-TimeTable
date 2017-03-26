//
//  AppDelegate.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import "AppDelegate.h"
#import "EventParser.h"
#import "Configuration.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [EventParser initializeSharedStorage];
    [[Configuration sharedInstance]setupTheme];
    return YES;
}

@end
