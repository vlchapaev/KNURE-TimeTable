//
//  ViewController.h
//  KNURE-Sked
//
//  Created by Влад on 10/24/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UITextView *lessonsDataTextField;
    NSMutableData *receivedData;
    IBOutlet UILabel *currntTime;
}

- (IBAction)getLastUpdate:(id)sender;

@end

