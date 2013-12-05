//
//  NewSkedCell.h
//  KNURE-Sked
//
//  Created by Влад on 12/4/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewSkedCell : UIViewController <UIAlertViewDelegate> {
    IBOutlet UITextField *lesson;
    IBOutlet UITextView *note;
}
- (IBAction)goBack:(id)sender;
- (IBAction)done:(id)sender;
@end
NSString *lessonData;
NSString *noteData;