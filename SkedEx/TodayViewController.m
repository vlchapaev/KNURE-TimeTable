//
//  TodayViewController.m
//  SkedEx
//
//  Created by Vlad Chapaev on 04.10.14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

@synthesize dateLabel, groupLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Shogunate.KNURE-Sked"];
    groupLabel.text = [sharedDefaults objectForKey:@"SkedEx_Name"];
    
    hourMinute = [[NSDateFormatter alloc]init];
    [hourMinute setDateFormat:@"HH:mm"];
    dmye = [[NSDateFormatter alloc]init];
    [dmye setDateFormat:@"dd.MM.yyyy, EEEE"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    today = [[NSDate alloc]init];
    dateLabel.text = [dmye stringFromDate:today];
    
    schedule = [sharedDefaults objectForKey:@"SkedEx_Schedule"];
    events = [schedule valueForKey:@"events"];
    subjects = [schedule valueForKey:@"subjects"];
    types = [schedule valueForKey:@"types"];
    
    currentDayEvents = [self getCurrentDayEvents:events];
    
    self.preferredContentSize = CGSizeMake(320, 90+(45*currentDayEvents.count));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentDayEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"SkedExCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    tableView.allowsSelection = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *startTime = (UILabel *)[cell viewWithTag:1];
    UILabel *endTime = (UILabel *)[cell viewWithTag:2];
    UILabel *lesson = (UILabel *)[cell viewWithTag:3];
    UILabel *lessonType = (UILabel *)[cell viewWithTag:4];
    
    startTime.text = [hourMinute stringFromDate:
                      [NSDate dateWithTimeIntervalSince1970:
                       [[[currentDayEvents objectAtIndex:indexPath.row]valueForKey:@"start_time"]doubleValue]]];
    endTime.text = [hourMinute stringFromDate:
                    [NSDate dateWithTimeIntervalSince1970:
                     [[[currentDayEvents objectAtIndex:indexPath.row]valueForKey:@"end_time"]doubleValue]]];
    lesson.text = [self getLessonByIndex:(int)indexPath.row];
    lesson.lineBreakMode = 5;
    lessonType.textColor = [self getCellColorBy:[[[currentDayEvents objectAtIndex:indexPath.row] valueForKey:@"type"]integerValue]];
    
    return cell;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - распаковка расписания

- (NSArray *)getCurrentDayEvents:(NSArray *)eventList {

    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *currentDate = [formatter stringFromDate:today];
    for(NSDictionary *record in eventList) {
        if([currentDate isEqualToString:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[record valueForKey:@"start_time"]doubleValue]]]]) {
            [result addObject:record];
        }
    }
    return result;
}

- (UIColor *)getCellColorBy:(NSInteger)type {
    switch (type) {
        case 0:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1];
            break;
        case 1:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:1 green:0.961 blue:0.835 alpha:1];
            break;
        case 10:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1];
            break;
        case 11:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1];
            break;
        case 12:
            return [UIColor colorWithRed:0.78 green:0.922 blue:0.769 alpha:1];
            break;
        case 20:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1];
            break;
        case 21:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1];
            break;
        case 22:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1];
            break;
        case 23:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1];
            break;
        case 24:
            return [UIColor colorWithRed:0.804 green:0.8 blue:1 alpha:1];
            break;
        case 30:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
            break;
        case 31:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
            break;
        case 40:
            return [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:0.3];
            break;
        case 41:
            return [UIColor colorWithRed:0.761 green:0.627 blue:0.722 alpha:1];
            break;
        case 50:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 51:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 52:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 53:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 54:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 55:
            return [UIColor colorWithRed:0.561 green:0.827 blue:0.988 alpha:1];
            break;
        case 60:
            return [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
            break;
        default:
            return [UIColor colorWithRed:1 green:0.859 blue:0.957 alpha:1];
            break;
    }
}

- (NSString *)getBriefByID:(NSInteger)ID from:(NSArray *)subjectsList shortName:(BOOL)isShort {
    for(NSArray *record in subjectsList) {
        if([[record valueForKey:@"id"]integerValue] == ID) {
            return (isShort)?[record valueForKey:@"brief"]:[record valueForKey:@"title"];
        }
    }
    return nil;
}

- (NSString *)getTypeNameByID:(NSInteger)typeID from:(NSArray *)typeList shortName:(BOOL)isShort {
    for(NSArray *record in typeList) {
        if([[record valueForKey:@"id"]integerValue] == typeID) {
            return (isShort)? [record valueForKey:@"short_name"]:[record valueForKey:@"full_name"];
        }
    }
    return nil;
}

- (NSString *)getLessonByIndex:(int)index {
    NSString *brief = [self getBriefByID:[[[currentDayEvents objectAtIndex:index]valueForKey:@"subject_id"]integerValue] from:subjects shortName:YES];
    NSString *typeName = [self getTypeNameByID:[[[currentDayEvents objectAtIndex:index]valueForKey:@"type"]integerValue] from:types shortName:YES];
    NSString *auditory = [[currentDayEvents objectAtIndex:index]valueForKey:@"auditory"];
    
    return [NSString stringWithFormat:@"%@ %@ %@", brief, typeName, auditory];
}

@end
