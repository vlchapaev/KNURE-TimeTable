//
//  PopoverComboBoxViewController.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 26.11.16.
//  Copyright © 2016 Vladislav Chapaev. All rights reserved.
//

#import "PopoverComboBoxViewController.h"
#import "Configuration.h"

@interface PopoverComboBoxViewController ()

@property (strong, nonatomic) NSArray <Item *>* datasource;
@property (assign, nonatomic) BOOL isDarkTheme;

@end

@implementation PopoverComboBoxViewController

- (instancetype)initWithDelegate:(id)delegate {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.delegate = delegate;
        self.datasource = [Item MR_findAllSortedBy:@"last_update" ascending:NO];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.isDarkTheme = [Configuration isDarkTheme];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.tableView.backgroundColor = [UIColor clearColor];
        }
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
    cell.textLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
    cell.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
    if (self.selectedItemID == [self.datasource[indexPath.row].id integerValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Item *item = self.datasource[indexPath.row];
    [self.delegate didSelectComboboxItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
