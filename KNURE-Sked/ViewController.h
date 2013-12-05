//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> {
    IBOutlet UILabel *timer;
    IBOutlet UIScrollView *mainSkedView;
    IBOutlet UIView *skedCell;
    IBOutlet UIView *newSkedCell;
    IBOutlet UIView *timeLineView;
    int standartScrollPosition;
    NSMutableArray *sorted;
    NSString *userAddLesson;
    NSString *userAddLessonText;
    NSString *userDeleteLesson;
    NSMutableArray *rects;
    NSMutableData *receivedData;
}

@property (strong, readwrite, nonatomic) REMenu *menu;
@property (strong, nonatomic) UIButton *toggleBtn;
@property (strong, nonatomic) UIButton *menuBtn;

- (void)getLastUpdate;
- (id)initWithCoder:(NSCoder*)aDecoder;
- (IBAction)goToNewCell:(id)sender;

@end

