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
#import "Item+CoreDataProperties.h"
#import "Request.h"
#import "EventParser.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ItemsTableViewController() <DZNEmptyDataSetSource>

@property (strong, nonatomic) NSMutableArray <Item *>* datasource;
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation ItemsTableViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsCell" bundle:nil] forCellReuseIdentifier:@"Item"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext MR_defaultContext];
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
    cell.lastUpdate.text = (item.last_update) ? [self.formatter stringFromDate:item.last_update] : @"Not updated";
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

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Нет групп";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Добавьте группы, чтобы вывести их расписание";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
