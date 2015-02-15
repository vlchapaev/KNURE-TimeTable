//
//  TodayViewController.h
//  SkedEx
//
//  Created by Vlad Chapaev on 04.10.14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSDateFormatter *dmye;
    NSDateFormatter *formatter;
    NSDateFormatter *hourMinute;
    NSDate *today;
    
    NSArray *events;
    NSArray *subjects;
    NSArray *types;
    NSArray *currentDayEvents;
    
    NSDictionary *schedule;
    int widgetHeight;
}


@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;

@end
