//
//  NoteForm.m
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 04.12.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "NoteForm.h"
#import "ECSlidingViewController.h"

@interface NoteForm ()

@end

@implementation NoteForm
@synthesize noteField;
@synthesize noteDateField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    noteIdx = -1;
    notes = [[NSMutableArray alloc] init];
    dates = [[NSMutableArray alloc] init];
    notesX = [[NSMutableArray alloc] init];
    notesY = [[NSMutableArray alloc] init];
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
	self.noteDateField.text = [fullData valueForKey:@"CellDate"];
    datesRequest = [NSString stringWithFormat:@"%@%@",@"usrNoteDatesFor",[fullData valueForKey:@"ID"]];
    notesRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesFor",[fullData valueForKey:@"ID"]];
    XRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesXFor",[fullData valueForKey:@"ID"]];
    YRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesYFor",[fullData valueForKey:@"ID"]];
    if ([fullData valueForKeyPath:datesRequest] != nil) {
        dates = [[fullData valueForKeyPath:datesRequest] mutableCopy];
        notes = [[fullData valueForKeyPath:notesRequest] mutableCopy];
        notesX = [[fullData valueForKeyPath:XRequest] mutableCopy];
        notesY = [[fullData valueForKeyPath:YRequest] mutableCopy];
        if ([dates containsObject:self.noteDateField.text]) {
            noteIdx = [dates indexOfObject:self.noteDateField.text];
            self.noteField.text = [notes objectAtIndex:noteIdx];
        }
    }
}

- (void)exitView {
    UIViewController *mainForm = [self.storyboard instantiateViewControllerWithIdentifier:@"Расписание"];
    self.slidingViewController.topViewController = mainForm;
    [self.slidingViewController resetTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}*/

- (IBAction)Cancel:(id)sender {
    [self exitView];
}

- (IBAction)saveNote:(id)sender {
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
    if (noteIdx != -1) {
        [notes replaceObjectAtIndex:noteIdx withObject:self.noteField.text];
    }
    else {
        [dates addObject:self.noteDateField.text];
        [notes addObject:self.noteField.text];
        [notesX addObject:[fullData valueForKey:@"cellX"]];
        [notesY addObject:[fullData valueForKey:@"cellY"]];
        [fullData setValue:dates forKeyPath:datesRequest];
        [fullData setValue:notesX forKeyPath:XRequest];
        [fullData setValue:notesY forKeyPath:YRequest];
    }
    [fullData setValue:notes forKeyPath:notesRequest];
    [fullData synchronize];
    [self exitView];
}
@end
