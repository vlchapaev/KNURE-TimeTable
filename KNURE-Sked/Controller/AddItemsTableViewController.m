//
//  AddItemViewController.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import "AddItemsTableViewController.h"
#import "ItemsTableViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Item.h"

@interface AddItemsTableViewController () <EventParserDelegate, UISearchBarDelegate, UISearchResultsUpdating, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray <NSIndexPath *>*selectedPaths;

@property (strong, nonatomic) NSArray *allResults;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *datasource;
@property (assign, nonatomic) BOOL isFiltred;

@property (strong, nonnull) IBOutlet UISearchController *searchController;

@end

@implementation AddItemsTableViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = NO;
    [self.searchController.searchBar sizeToFit];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Item"];
    /*
    AppDelegate *appDelegate = [[AppDelegate alloc]init];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    NSError *error = nil;
    self.selectedItems = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    */
    
    [self getItemList];
}

#pragma mark - Logic

- (void)getItemList {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    switch (_itemType) {
        case ItemTypeGroup:
            [NSURLConnection connectionWithRequest:[Request getGroupList] delegate:self];
            break;
            
        case ItemTypeTeacher:
            [NSURLConnection connectionWithRequest:[Request getTeacherList] delegate:self];
            break;
            
        case ItemtypeAuditory:
            [NSURLConnection connectionWithRequest:[Request getAuditoryList] delegate:self];
            break;
    }
}

#pragma mark - Events

- (IBAction)doneButtonTap {
    AppDelegate *appDelegate = [[AppDelegate alloc]init];
    for(NSDictionary *record in self.selectedItems) {
        Item *item = [[Item alloc]initWithContext:appDelegate.persistentContainer.viewContext];
        item.id = [record[@"id"] integerValue];
        item.title = record[@"title"];
        
        if (item.managedObjectContext.hasChanges) {
            NSError *error;
            if (![item.managedObjectContext save:&error]) {
                NSLog(@"Problem saving changes: %@", error);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchForText:(NSString *)searchText scope:(NSString *)scope {
    self.isFiltred = (searchText.length > 0) ? YES : NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
    self.searchResults = [self.datasource filteredArrayUsingPredicate:predicate];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc]init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [EventParser alignEncoding:self.responseData callBack:^(NSData *data) {
        if (data) {
            self.allResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [[EventParser sharedInstance] setDelegate:self];
            [[EventParser sharedInstance] parseItemList:self.allResults ofType:self.itemType];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:@"Failed to parse timetable" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - EventParserDelegate

- (void)didParseItemListWithResponse:(id)response sections:(NSArray *)sections {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.datasource = response;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltred) ? self.searchResults.count : self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    
    NSDictionary *record = (self.isFiltred) ? self.searchResults[indexPath.row] : self.datasource[indexPath.row];
    
    cell.textLabel.text = [record valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    
    cell.accessoryType = ([self.selectedItems containsObject:record]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *record = (self.isFiltred) ? self.searchResults[indexPath.row] : self.datasource[indexPath.row];
    NSLog(@"%@", record);
    
    if (![self.selectedItems containsObject:record]) {
        [self.selectedItems addObject:record];
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
