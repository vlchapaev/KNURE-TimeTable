//
//  PopoverModalViewController.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 01.03.17.
//  Copyright © 2017 Vladislav Chapaev. All rights reserved.
//

#import "PopoverModalViewController.h"
#import "Configuration.h"

@interface PopoverModalViewController ()

@property (assign, nonatomic) BOOL hideHints;
@property (assign, nonatomic) BOOL isDarkTheme;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString *auditory;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *teachers;
@property (strong, nonatomic) NSArray *groups;

@end

@implementation PopoverModalViewController

- (instancetype)initWithLesson:(Lesson *)lesson {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.hideHints = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationHideHint];
        self.isDarkTheme = [Configuration isDarkTheme];
        self.title = NSLocalizedString(@"ModalView_Details", nil);
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = lesson.title;
        self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.layer.cornerRadius = 10;
        
        self.type = lesson.type_title;
        self.auditory = lesson.auditory;
        self.groups = (NSArray *)lesson.groups;
        self.teachers = (NSArray *)lesson.teachers;
        
        [self.headerView addSubview:self.titleLabel];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerView.right).offset(-8);
            make.left.equalTo(self.headerView.left).offset(8);
            make.top.equalTo(self.headerView.top).offset(8);
            make.bottom.equalTo(self.headerView.bottom).offset(-8);
        }];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize neededSize = [self.titleLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 16, CGFLOAT_MAX)];
    
    CGFloat headerHeight = neededSize.height + 40;
    [self.headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate didDismissViewControllerWithSelectedIndexPath:self.indexPath];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.preferredContentSize = CGSizeMake(400, self.tableView.contentSize.height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 2; break;
        case 1: return self.teachers.count; break;
        case 2: return self.groups.count; break;
        default: return 0; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    }
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell1"];
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.type;
            cell.textLabel.text = NSLocalizedString(@"ModalView_Type", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.auditory;
            cell.textLabel.text = NSLocalizedString(@"ModalView_Auditory", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        
    }  else if (indexPath.section == 1) {
        cell.textLabel.text = [self.teachers[indexPath.row] valueForKey:@"full_name"];
        cell.tag = [[self.teachers[indexPath.row] valueForKey:@"id"] integerValue];
        
    } else if (indexPath.section == 2) {
        cell.textLabel.text = [self.groups[indexPath.row] valueForKey:@"name"];
        cell.tag = [[self.groups[indexPath.row] valueForKey:@"id"] integerValue];
    }
    
    cell.textLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return NSLocalizedString(@"ModalView_Teacher", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"ModalView_Groups", nil);
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.hideHints) { return nil; }
    if (section == 1 || section == 2) {
        return NSLocalizedString(@"ModalView_Hint", nil);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    headerView.textLabel.textColor = (self.isDarkTheme) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
}

#pragma mark - UITablViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    ItemType itemType;
    NSString *title;
    NSNumber *itemID;
    if (indexPath.section == 1) {
        itemType = ItemTypeTeacher;
        title = [self.teachers[indexPath.row] valueForKey:@"short_name"];
        itemID = [self.teachers[indexPath.row] valueForKey:@"id"];
    } else {
        itemType = ItemTypeGroup;
        title = [self.groups[indexPath.row] valueForKey:@"name"];
        itemID = [self.groups[indexPath.row] valueForKey:@"id"];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", itemID];
    Item *item = [Item MR_findFirstWithPredicate:predicate];
    if (item) {
        [self.delegate didSelectItem:item];
    } else {
        NSDictionary *parameters = @{@"id": itemID, @"title": title, @"type": [NSNumber numberWithInt:itemType]};
        [self.delegate didSelectItem:[parameters transformToNSManagedObject]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 25;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
