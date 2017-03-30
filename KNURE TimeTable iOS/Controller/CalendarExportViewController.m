//
//  CalendarExportViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 20.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import "CalendarExportViewController.h"
#import "ItemsTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Item+CoreDataProperties.h"
#import "Configuration.h"

@interface CalendarExportViewController () <NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, ItemsTableViewCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL hideHint;

@end

@implementation CalendarExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    
    [self.tableView registerClass:ItemsTableViewCell.class forCellReuseIdentifier:@"Item"];
    
    self.hideHint = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationHideHint];
    
    [self setupFetchRequest];
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            [self calendarExportDidFinishWithError:error];
        }
    }];
    
}

#pragma mark - Setups

- (void)setupFetchRequest {
    NSFetchRequest *fetchRequest = [Item fetchRequest];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"last_update" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    
    [[self.fetchedResultsController fetchRequest] setPredicate:nil];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    if ([self.fetchedResultsController.sections.firstObject numberOfObjects] < 1) {
        self.hideHint = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections.firstObject numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    cell.item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (!self.hideHint) ? NSLocalizedString(@"Settings_CalendarHint1", nil) : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (!self.hideHint) ? NSLocalizedString(@"Settings_CalendarHint2", nil) : nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Settings_CalendarExport_SheetTitle", nil) message:NSLocalizedString(@"Settings_CalendarExport_SheetMessage", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *today = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings_CalendarExport_Today", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cell exportToCalendar:item inRange:CalendarExportRangeToday];
    }];
    
    UIAlertAction *tomorrow = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings_CalendarExport_Tomorrow", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cell exportToCalendar:item inRange:CalendarExportRangeTomorrow];
    }];
    
    UIAlertAction *thisWeek = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings_CalendarExport_ThisWeek", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cell exportToCalendar:item inRange:CalendarExportRangeThisWeek];
    }];
    
    UIAlertAction *nextWeek = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings_CalendarExport_NextWeek", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cell exportToCalendar:item inRange:CalendarExportRangeNextWeek];
    }];
    
    UIAlertAction *full = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings_CalendarExport_Full", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [cell exportToCalendar:item inRange:CalendarExportRangeFull];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:today];
    [alertController addAction:tomorrow];
    [alertController addAction:thisWeek];
    [alertController addAction:nextWeek];
    [alertController addAction:full];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ItemsTableViewCellDelegate

- (void)calendarExportDidFinishWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", nil) message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"Settings_CalendarExport_NoItems", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"Settings_CalendarExport_NoItemsMessage", nil);
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
