//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface ViewController : UIViewController {
    IBOutlet UILabel *currentTime;
    NSMutableData *receivedData;
    IBOutlet UIButton *btnSelect;
    NIDropDown *dropDown;
}

@property (strong, nonatomic) UIButton *menuBtn;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)selectClicked:(id)sender;
- (void)rel;
- (IBAction)getLastUpdate:(id)sender;

@end

