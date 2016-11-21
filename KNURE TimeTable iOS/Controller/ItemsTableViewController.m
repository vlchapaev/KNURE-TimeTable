//
//  ItemsTableViewController.m
//  KNURE TimeTable iOS
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
#import "Request.h"

@interface ItemsTableViewController() <DZNEmptyDataSetSource>

@property (strong, nonatomic) NSMutableArray <Item *>* datasource;
@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation ItemsTableViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.headerTitle;
    
    self.formatter = [[NSDateFormatter alloc]init];
    [self.formatter setTimeStyle:NSDateFormatterLongStyle];
    
    self.tableView.emptyDataSetSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"type == %i", self.itemType];
    self.datasource = [[Item MR_findAllWithPredicate:filter] mutableCopy];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Item"];
    }
    Item *item = self.datasource[indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.detailTextLabel.text = (item.last_update) ? [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [self.formatter stringFromDate:item.last_update]] : NSLocalizedString(@"ItemList_Not_Updated", nil);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *item = self.datasource[indexPath.row];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", item.id];
        NSArray <Lesson *>*lessons = [Lesson MR_findAllWithPredicate:filter];
        for(Lesson *lesson in lessons) {
            [lesson MR_deleteEntityInContext:localContext];
        }
        [item MR_deleteEntityInContext:localContext];
        [localContext MR_saveToPersistentStoreAndWait];
    }];
    
    [self.datasource removeObjectAtIndex:indexPath.row];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    Item *item = self.datasource[indexPath.row];
    [indicator startAnimating];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[Request getTimetable:item.id ofType:self.itemType]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (data) {
                                                        [[EventParser sharedInstance]parseTimeTable:data itemID:item.id callBack:^{
                                                            
                                                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"ItemList_Updated", nil), [self.formatter stringFromDate:[NSDate date]]];
                                                            
                                                            [[NSUserDefaults standardUserDefaults]setObject:@{@"id": item.id, @"title": item.title} forKey:TimetableSelectedItem];
                                                            [[NSUserDefaults standardUserDefaults]synchronize];
                                                            
                                                            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                                                                Item *newItem = [Item MR_createEntityInContext:localContext];
                                                                newItem.id = item.id;
                                                                newItem.title = item.title;
                                                                newItem.full_name = item.full_name;
                                                                newItem.type = item.type;
                                                                newItem.last_update = [NSDate date];
                                                                [item MR_deleteEntityInContext:localContext];
                                                                [self.datasource replaceObjectAtIndex:indexPath.row withObject:newItem];
                                                                [localContext MR_saveToPersistentStoreAndWait];
                                                            }];
                                                            
                                                            [indicator stopAnimating];
                                                        }];
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            cell.detailTextLabel.text = @"Не удалось обновить расписание";
                                                            [indicator stopAnimating];
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
    NSString *text = @"Нажмите значок + чтобы добавить группы, преподавателей или аудитории, расписание которых необходимо отобразить.";
    
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
    }
}

@end
