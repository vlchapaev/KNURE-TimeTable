//
//  PopoverComboBoxViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 26.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "PopoverComboBoxViewController.h"

@interface PopoverComboBoxViewController ()

@property (strong, nonatomic) NSArray <Item *>* datasource;

@end

@implementation PopoverComboBoxViewController

- (instancetype)initWithDelegate:(id)delegate {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.delegate = delegate;
        self.datasource = [Item MR_findAllSortedBy:@"last_update" ascending:NO];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.preferredContentSize = CGSizeMake(400, self.tableView.contentSize.height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.datasource[indexPath.row].title;
    cell.backgroundColor = [UIColor clearColor];
    if (self.selectedItemID == [self.datasource[indexPath.row].id integerValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Item *item = self.datasource[indexPath.row];
    NSDictionary *selectedItem = @{@"id": item.id, @"title": item.title, @"type": [NSNumber numberWithInt:item.type]};
    [self.delegate didSelectComboboxItemWithParameters:selectedItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
