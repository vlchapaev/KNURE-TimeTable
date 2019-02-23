////
////  TodayViewController.m
////  KNURE TimeTable iOS TomorrowExtension
////
////  Created by Vladislav Chapaev on 04.04.17.
////  Copyright © 2017 Vladislav Chapaev. All rights reserved.
////
//
//#import "TomorrowViewController.h"
//#import "Configuration.h"
//
//@interface TomorrowViewController () <NCWidgetProviding>
//
//@end
//
//@implementation TomorrowViewController
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    return [super initWithCoder:aDecoder];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Shogunate.KNURE-Sked"];
//    NSDictionary *selectedItem = [sharedDefaults valueForKey:TimetableSelectedItem];
//    if (selectedItem) {
//        NSDateComponents *endDateComponents = [[NSDateComponents alloc]init];
//        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//        NSDateComponents *startDateComponent = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
//        startDateComponent.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
//
//        startDateComponent.day += 1;
//        NSDate *startDate = [calendar dateFromComponents:startDateComponent];
//        endDateComponents.day = 1;
//        NSDate *endDate = [calendar dateByAddingComponents:endDateComponents toDate:startDate options:0];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item_id == %@ AND ((start_time >= %@) AND (end_time <= %@)) AND isDummy == NO", selectedItem[@"id"], startDate, endDate];
//        
//        [super setupFetchRequestWithPredicate:predicate];
//    }
//}
//
//
//@end
