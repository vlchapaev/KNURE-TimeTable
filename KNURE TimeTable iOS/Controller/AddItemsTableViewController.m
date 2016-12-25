//
//  AddItemsTableViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 01.05.2014.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import "AddItemsTableViewController.h"
#import "MBProgressHUD.h"
#import "Request.h"
#import "Item+CoreDataClass.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AddItemsTableViewController () <EventParserDelegate, UISearchBarDelegate, UISearchResultsUpdating, DZNEmptyDataSetSource, URLRequestDelegate>

@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray <NSIndexPath *>*selectedPaths;

@property (strong, nonatomic) NSString *requestAddress;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *datasource;
@property (assign, nonatomic) BOOL isFiltred;

@property (strong, nonnull) IBOutlet UISearchController *searchController;

@end

@implementation AddItemsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = NO;
    [self.searchController.searchBar sizeToFit];
    
    self.selectedItems = [[NSMutableArray alloc]init];
    
    [self getItemList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        for(NSDictionary *record in self.selectedItems) {
            Item *item = [Item MR_createEntityInContext:localContext];
            item.id = [NSNumber numberWithInteger:[record[@"id"] integerValue]];
            item.title = record[@"title"];
            item.last_update = nil;
            item.type = self.itemType;
            if ([[record allKeys] containsObject:@"full_name"]) {
                item.full_name = record[@"full_name"];
            }
        }
        [localContext MR_saveToPersistentStoreAndWait];
    }];
}

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

#pragma mark - Logic

- (void)getItemList {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [Request loadItemListOfType:self.itemType delegate:self];
}

#pragma mark - URLRequestDelegate

- (void)requestDidLoadItemList:(id)data ofType:(ItemType)itemType {
    [EventParser alignEncoding:data callBack:^(NSData *data) {
        if (data) {
            id itemList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [[EventParser sharedInstance] setDelegate:self];
            [[EventParser sharedInstance] parseItemList:itemList ofType:self.itemType];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:NSLocalizedString(@"ItemList_FailedToParseList", @"") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)requestDidFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestDidFinishLoading {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark - DZNEmptyDataSetSource

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;
}

#pragma mark - Events

- (IBAction)doneButtonTap {
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

#pragma mark - EventParserDelegate

- (void)didParseItemListWithResponse:(id)response sections:(NSArray *)sections {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.datasource = response;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltred) ? self.searchResults.count : self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Item"];
    }
    
    NSDictionary *record = (self.isFiltred) ? self.searchResults[indexPath.row] : self.datasource[indexPath.row];
    
    cell.textLabel.text = [record valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.textLabel.numberOfLines = 0;
    
    cell.accessoryType = ([self.selectedItems containsObject:record]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *record = (self.isFiltred) ? self.searchResults[indexPath.row] : self.datasource[indexPath.row];
    
    if (![self.selectedItems containsObject:record]) {
        [self.selectedItems addObject:record];
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
