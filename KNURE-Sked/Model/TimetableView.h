//
//  ScheduleView.h
//  Inh_test2
//
//  Created by Vlad Chapaev on 22.03.16.
//  Copyright © 2016 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableViewCell.h"

@interface TimetableView : UIScrollView



@end

@protocol TimetableViewDataSource <NSObject>

@required

- (int)numberOfCellsInTimetableView:(TimetableView *)timetableView;
- (TimetableViewCell *)timetableView:(TimetableView *)timetableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
