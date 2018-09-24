//
//  AddItemsTableViewController.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 01.05.2014.
//  Copyright (c) 2016 Vladislav Chapaev. All rights reserved.
//

#import "AddItemsTableViewController.h"
#import "MBProgressHUD.h"
#import "Request.h"
#import "Configuration.h"

@interface AddItemsTableViewController () <EventParserDelegate, UISearchBarDelegate, UISearchResultsUpdating, URLRequestDelegate>

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *datasource;
@property (assign, nonatomic) BOOL isFiltred;
@property (assign, nonatomic) BOOL isDarkTheme;

@property (strong, nonatomic) NSArray <Item *>*allItems;

@property (strong, nonnull) IBOutlet UISearchController *searchController;

@end

@implementation AddItemsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = NO;
    [self.searchController.searchBar sizeToFit];
    
    self.isDarkTheme = [Configuration isDarkTheme];
    self.allItems = [Item MR_findAllSortedBy:@"last_update" ascending:NO];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Item"];
    
    [self getItemList];
}

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

#pragma mark - Logic

- (void)getItemList {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [Request loadItemListOfType:self.itemType delegate:self];
}

#pragma mark - URLRequestDelegate

- (void)requestDidLoadItemList:(id)data ofType:(ItemType)itemType {
    [EventParser alignEncoding:data callBack:^(NSData *data) {
        NSError *error;
        id itemList = [NSJSONSerialization JSONObjectWithData:data
                                                      options:(NSJSONReadingMutableContainers |
                                                               NSJSONReadingMutableLeaves |
                                                               NSJSONReadingAllowFragments)
                                                        error:&error];
        if (!error) {
            [[EventParser sharedInstance] setDelegate:self];
            [[EventParser sharedInstance] parseItemList:itemList ofType:self.itemType];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@ \n\n %@", NSLocalizedString(@"ItemList_FailedToParseList", nil), error.debugDescription];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", nil)
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}

- (void)requestDidFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", nil) message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchForText:(NSString *)searchText scope:(NSString *)scope {
    self.isFiltred = (searchText.length > 0) ? YES : NO;
    NSString *mutatedString = [searchText stringByReplacingOccurrencesOfString:@"и" withString:@"і" options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)];
    mutatedString = [mutatedString stringByReplacingOccurrencesOfString:@"е" withString:@"є" options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)];
    mutatedString = [mutatedString stringByReplacingOccurrencesOfString:@"э" withString:@"е" options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchText.length)];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) OR (title CONTAINS[cd] %@)", searchText, mutatedString];
    self.searchResults = [self.datasource filteredArrayUsingPredicate:predicate];
}

#pragma mark - EventParserDelegate

- (void)didParseItemListWithResponse:(id)response sections:(NSArray *)sections {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.datasource = response;
    self.tableView.separatorColor = (self.isDarkTheme) ? ApplicationThemeDarkSeparatorColor : ApplicationThemeLightSeparatorColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltred) ? self.searchResults.count : self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    
    NSDictionary *record = (self.isFiltred) ? self.searchResults[indexPath.row] : self.datasource[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = YES;
    cell.textLabel.text = [record valueForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.textLabel.numberOfLines = 0;
    
    if ([[self.allItems valueForKey:@"id"]containsObject:[record valueForKey:@"id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.userInteractionEnabled = NO;
        cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
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
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.delegate didSelectItem:record ofType:self.itemType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
