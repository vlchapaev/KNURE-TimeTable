//
//  ModalViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.12.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString *auditory;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *teachers;
@property (strong, nonatomic) NSArray *groups;

@end

@implementation ModalViewController

- (instancetype)initWithDelegate:(id)delegate andLesson:(Lesson *)lesson {
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.view.backgroundColor = [UIColor clearColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 70, self.view.frame.size.width - 60, self.view.frame.size.height - 140) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 10;
        self.tableView.autoresizesSubviews = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
        self.tableView.tableHeaderView = self.headerView;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        [blurEffectView setFrame:self.view.frame];
        self.tableView.backgroundView = blurEffectView;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor whiteColor];
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
        [self.view addSubview:self.tableView];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                     } completion:nil];
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.right).offset(-8);
        make.left.equalTo(self.headerView.left).offset(8);
        make.top.equalTo(self.headerView.top).offset(8);
        make.bottom.equalTo(self.headerView.bottom).offset(-8);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGRect newFrame = self.headerView.frame;
    newFrame.size.height = newFrame.size.height + self.titleLabel.frame.size.height;
    self.headerView.frame = newFrame;
    [self.tableView setTableHeaderView:self.headerView];
    
    if (self.tableView.contentSize.height < self.view.frame.size.height) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.contentSize.width, self.tableView.contentSize.height)];
        self.tableView.center = self.view.center;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; break;
        case 1: return 1; break;
        case 2: return self.teachers.count; break;
        case 3: return self.groups.count; break;
        default: return 0; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = self.type;
        cell.textLabel.text = @"Type";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        
    } else if (indexPath.section == 1) {
        cell.detailTextLabel.text = self.auditory;
        cell.textLabel.text = @"Auditory";
        
    } else if (indexPath.section == 2) {
        cell.detailTextLabel.text = [self.teachers[indexPath.row] valueForKey:@"full_name"];
        cell.tag = [[self.teachers[indexPath.row] valueForKey:@"id"] integerValue];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Teachers";
        }
        
    } else if (indexPath.section == 3) {
        cell.detailTextLabel.text = [self.groups[indexPath.row] valueForKey:@"name"];
        cell.tag = [[self.groups[indexPath.row] valueForKey:@"id"] integerValue];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Groups";
        }
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITablViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ItemType itemType;
    NSString *title;
    NSNumber *itemID;
    if (indexPath.section == 1) {
        itemType = ItemtypeAuditory;
        title = self.auditory;
        //TODO: auditory id
    } else if (indexPath.section == 2) {
        itemType = ItemTypeTeacher;
        title = [self.teachers[indexPath.row] valueForKey:@"short_name"];
        itemID = [self.teachers[indexPath.row] valueForKey:@"id"];
    } else {
        itemType = ItemTypeGroup;
        title = [self.groups[indexPath.row] valueForKey:@"name"];
        itemID = [self.groups[indexPath.row] valueForKey:@"id"];
    }
    
    [self.delegate didSelectItem:itemID title:title ofType:itemType];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
