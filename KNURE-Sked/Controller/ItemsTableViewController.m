//
//  GroupList.m
//  KNURE TimeTable iOS
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Vlad Chapaev. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "InitViewController.h"
#import "ItemTableViewCell.h"
#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
#import "Request.h"

@interface ItemsTableViewController() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableArray <Item *>* datasource;

@end

@implementation ItemsTableViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsCell" bundle:nil] forCellReuseIdentifier:@"Item"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *error = nil;
    self.datasource = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    [self.tableView reloadData];
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
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[Request getTimetable:item.id]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (data) {
                                                        [[EventParser sharedInstance]parseTimeTable:data callBack:^{
                                                            [cell.activityIndicator stopAnimating];
                                                        }];
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [cell.activityIndicator stopAnimating];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
