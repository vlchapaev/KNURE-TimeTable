//
//  ItemsTableViewController.m
//  KNURE TimeTable
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "AddItemsTableViewController.h"
#import "TimeTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "InitViewController.h"
#import "Item+CoreDataProperties.h"
#import "Lesson+CoreDataClass.h"
#import "NSDate+DateTools.h"
#import "Request.h"

@interface ItemsTableViewController() <NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, AddItemsTableViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ItemsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.headerTitle;
    
    self.tableView.emptyDataSetSource = self;
    
    [self setupFetchRequest];
}

- (CGSize)preferredContentSize {
    return CGSizeMake(400, 500);
}

#pragma mark - Setups

- (void)setupFetchRequest {
    NSFetchRequest *fetchRequest = [Item fetchRequest];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"type == %li", self.itemType];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"last_update" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    [[self.fetchedResultsController fetchRequest] setPredicate:filter];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections.firstObject numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
    }
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.detailTextLabel.text = (item.last_update) ? [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [item.last_update timeAgoSinceNow]] : NSLocalizedString(@"ItemList_Not_Updated", nil);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", item.id];
        NSArray <Lesson *>*lessons = [Lesson MR_findAllWithPredicate:filter];
        for(Lesson *lesson in lessons) {
            [lesson MR_deleteEntityInContext:localContext];
        }
        [item MR_deleteEntityInContext:localContext];
        [localContext MR_saveToPersistentStoreAndWait];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.accessoryView = indicator;
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [indicator startAnimating];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSURLRequest *request = [Request getTimetable:item.id ofType:self.itemType];
    [manager GET:request.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [[EventParser sharedInstance]parseTimeTable:responseObject itemID:item.id callBack:^{
            
            NSDate *lastUpdate = [NSDate date];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [lastUpdate timeAgoSinceNow]];
            
            NSDictionary *selecterItem = @{@"id": item.id, @"title": item.title, @"type": [NSNumber numberWithInt:self.itemType]};
            [[NSUserDefaults standardUserDefaults]setObject:selecterItem forKey:TimetableSelectedItem];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            item.last_update = lastUpdate;
            [[item managedObjectContext] MR_saveToPersistentStoreAndWait];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [[NSNotificationCenter defaultCenter]postNotificationName:TimetableDidUpdateDataNotification object:selecterItem];
            }
            
            [indicator stopAnimating];
            
        }];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        cell.detailTextLabel.text = NSLocalizedString(@"ItemList_FailedToUpdate", nil);
        [indicator stopAnimating];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    
    switch (self.itemType) {
        case ItemTypeGroup:
            text = NSLocalizedString(@"ItemList_NoGroups", nil);
            break;
            
        case ItemTypeTeacher:
            text = NSLocalizedString(@"ItemList_NoTeachers", nil);
            break;
            
        case ItemtypeAuditory:
            text = NSLocalizedString(@"ItemList_NoClassrooms", nil);
            break;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    
    switch (self.itemType) {
        case ItemTypeGroup:
            text = NSLocalizedString(@"ItemList_AddGroupsHint", nil);
            break;
            
        case ItemTypeTeacher:
            text = NSLocalizedString(@"ItemList_AddTeachersHint", nil);
            break;
            
        case ItemtypeAuditory:
            text = NSLocalizedString(@"ItemList_AddClassroomsHint", nil);
            break;
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddItems"]) {
        AddItemsTableViewController *controller = [segue destinationViewController];
        controller.itemType = self.itemType;
        controller.delegate = self;
    }
}

#pragma mark - AddItemsTableViewControllerDelegate

- (void)didSelectItem:(NSDictionary *)record ofType:(ItemType)type {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *item = [Item MR_createEntityInContext:localContext];
        item.id = [NSNumber numberWithInteger:[record[@"id"] integerValue]];
        item.title = record[@"title"];
        item.last_update = nil;
        item.type = type;
        if ([[record allKeys] containsObject:@"full_name"]) {
            item.full_name = record[@"full_name"];
        }
        [localContext MR_saveToPersistentStoreAndWait];
    }];
}

@end
