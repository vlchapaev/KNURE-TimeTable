//
//  Settings.h
//  KNURE-Sked
//
//  Created by Влад on 11/2/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController {
    IBOutlet UISwitch *emptyDays;
    BOOL showDays;
}
- (IBAction)showEmptyDays;
@property (strong, nonatomic) UIButton *menuBtn;
@end
