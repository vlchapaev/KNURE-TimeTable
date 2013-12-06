//
//  NoteForm.h
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 04.12.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteForm : UIViewController 
@property (weak, nonatomic) IBOutlet UILabel *noteDateField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
- (IBAction)Cancel:(id)sender;
- (IBAction)saveNote:(id)sender;
@end
NSMutableArray *notesX;
NSMutableArray *notesY;
NSMutableArray *notes;
NSMutableArray *dates;
NSString *datesRequest;
NSString *notesRequest;
NSString *XRequest;
NSString *YRequest;
int noteIdx;
