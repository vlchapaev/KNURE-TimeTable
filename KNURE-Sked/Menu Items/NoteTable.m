//
//  NoteTable.m
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 03.12.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "NoteTable.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"

@interface NoteTable ()
@property (strong, nonatomic) NSMutableArray *notesTable;
@end

@implementation NoteTable
@synthesize menuBtn;
@synthesize notesTable;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
    datesRequest = [NSString stringWithFormat:@"%@%@",@"usrNoteDatesFor",[fullData valueForKey:@"ID"]];
    notesRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesFor",[fullData valueForKey:@"ID"]];
    XRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesXFor",[fullData valueForKey:@"ID"]];
    YRequest = [NSString stringWithFormat:@"%@%@",@"usrNotesYFor",[fullData valueForKey:@"ID"]];
    notes = [[NSMutableArray alloc] init];
    if ([fullData valueForKeyPath:datesRequest] != nil) {
        dates = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:datesRequest] mutableCopy];
        notes = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:notesRequest] mutableCopy];
        notesX = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:XRequest] mutableCopy];
        notesY = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:YRequest] mutableCopy];
    }
    notesTable = [[NSMutableArray alloc] initWithArray:notes];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[TabsViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(13, 30, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dates objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}


// Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
 
 
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     [dates removeObjectAtIndex:indexPath.row];
     [notes removeObjectAtIndex:indexPath.row];
     [notesX removeObjectAtIndex:indexPath.row];
     [notesY removeObjectAtIndex:indexPath.row];
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView beginUpdates];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 [tableView endUpdates];
 }
 [self.tableView reloadData];
 /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   */
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
    [fullData setValue:cell.textLabel.text forKey:@"CellDate"];
    [fullData setValue:[notesX objectAtIndex:indexPath.row] forKey:@"cellX"];
    [fullData setValue:[notesY objectAtIndex:indexPath.row] forKey:@"cellY"];
    UIViewController *topNoteForm = [self.storyboard instantiateViewControllerWithIdentifier:@"Заметка"];
    self.slidingViewController.topViewController = topNoteForm;
    [self.slidingViewController resetTopView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void) viewWillDisappear:(BOOL)animated {
    NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
    [fullData setValue:dates forKeyPath:datesRequest];
    [fullData setValue:notes forKeyPath:notesRequest];
    [fullData setValue:notesX forKeyPath:XRequest];
    [fullData setValue:notesY forKeyPath:YRequest];
    [fullData synchronize];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}

@end
