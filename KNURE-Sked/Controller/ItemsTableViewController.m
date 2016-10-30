//
//  GroupList.m
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "InitViewController.h"
#import "ItemTableViewCell.h"
#import "AppDelegate.h"
#import "Item.h"

@interface ItemsTableViewController() 

@property (strong, nonatomic) NSArray<Item *>* datasource;

@end

@implementation ItemsTableViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsCell" bundle:nil] forCellReuseIdentifier:@"Item"];
    
    AppDelegate *appDelegate = [[AppDelegate alloc]init];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *error = nil;
    self.datasource = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh" attributes:nil];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

#pragma mark - Logic

- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refresh");
    [refreshControl endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    Item *item = self.datasource[indexPath.row];
    cell.itemName.text = item.title;
    //cell.lastUpdate.text = [item.last_update timeAgo];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Item *item = self.datasource[indexPath.row];
    [cell.activityIndicator startAnimating];
}

@end
