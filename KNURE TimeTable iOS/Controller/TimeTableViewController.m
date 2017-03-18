//
//  TimeTableViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import "TimeTableViewController.h"
#import "MSCollectionViewCalendarLayout.h"
#import "LessonCollectionViewCell.h"
#import "Lesson+CoreDataClass.h"
#import "Item+CoreDataProperties.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PFNavigationDropdownMenu.h"
#import "ModalViewController.h"
#import "MBProgressHUD.h"
#import "Request.h"
#import "EventParser.h"

#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

NSString *const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString *const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString *const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

NSString *const TimetableCacheName = @"TimetableCacheName";
NSString *const TimetableSelectedItem = @"TimetableSelectedItem";
NSString *const TimetableVerticalMode = @"TimetableVerticalMode";
NSString *const TimetableIsDarkMode = @"TimetableIsDarkMode";
NSString *const TimetableShowEmptyDays = @"TimetableShowEmptyDays";
NSString *const TimetableBouncingCells = @"TimetableBouncingCells";

NSString *const TimetableDidUpdateDataNotification = @"TimetableDidUpdateDataNotification";

CGFloat const sectonWidth = 110;
CGFloat const timeRowHeaderWidth = 44;
CGFloat const dayColumnHeaderHeight = 40;

@interface TimeTableViewController() <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, ModalViewControllerDelegate, URLRequestDelegate>

@property (strong, nonatomic) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (strong, nonatomic) PFNavigationDropdownMenu *dropDownMenu;

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray <NSDate *>* pairDates;
@property (assign, nonatomic) short maxPairNumber;
@property (assign, nonatomic) short minPairNumber;

@property (assign, nonatomic) BOOL isRunningInFullScreen;

@property (assign, nonatomic) BOOL isVerticalMode;
@property (assign, nonatomic) BOOL isDarkMode;
@property (assign, nonatomic) BOOL showEmptyDays;

@end

@implementation TimeTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
        self.collectionViewCalendarLayout.delegate = self;
        //TODO: Fix
        self.isRunningInFullScreen = CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
        self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    if (selectedItem) {
        [self setupFetchRequestWithItem:selectedItem];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [self setupDropDownControllerWithItem:selectedItem];
        }
    }
    [self setupProperties];
    [self setupCollectionView];
    [self addDoubleTapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
}

#pragma mark - Setup

- (void)setupCollectionView {
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:LessonCollectionViewCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.timeRowHeaderWidth = timeRowHeaderWidth;
    self.collectionViewCalendarLayout.dayColumnHeaderHeight = dayColumnHeaderHeight;
    
    if (self.isVerticalMode) {
        self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeVerticalTile;
        self.collectionViewCalendarLayout.sectionWidth = self.collectionView.frame.size.width - timeRowHeaderWidth - 10;
        self.collectionViewCalendarLayout.hourHeight = 30;
    } else {
        self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
        self.collectionViewCalendarLayout.sectionWidth = sectonWidth;
        self.collectionViewCalendarLayout.hourHeight = (self.collectionView.frame.size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber) * 2);
        self.collectionViewCalendarLayout.cellMargin = UIEdgeInsetsMake(-64, 0, 64, 0);
    }
    
    [self.collectionViewLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    [self.collectionViewLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
}

- (void)setupProperties {
    self.isVerticalMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
    if (!self.isRunningInFullScreen) {
        self.isVerticalMode = YES;
    }
    self.isDarkMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
    self.showEmptyDays = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableShowEmptyDays];
    
    NSArray *pairNumbers = [self.fetchedResultsController.fetchedObjects valueForKey:@"number_pair"];
    self.maxPairNumber = [[pairNumbers valueForKeyPath:@"@max.intValue"] shortValue];
    self.minPairNumber = [[pairNumbers valueForKeyPath:@"@min.intValue"] shortValue] - 1;
    
    self.formatter = [[NSDateFormatter alloc]init];
    if (self.isVerticalMode) {
        [self.formatter setDateFormat:@"EEEE, dd MMMM"];
    } else {
        [self.formatter setDateFormat:@"dd.MM, EE"];
    }
    
    NSArray <NSDate *>*startTimeList = [self.fetchedResultsController.fetchedObjects valueForKey:@"start_time"];
    NSArray <NSDate *>*endTimeList = [self.fetchedResultsController.fetchedObjects valueForKey:@"end_time"];
    NSArray <NSDate *>*newArray = [startTimeList arrayByAddingObjectsFromArray:endTimeList];
    NSMutableArray <NSDate *>*dates = [[NSMutableArray alloc]init];
    for (NSDate *date in newArray) {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *component = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        [dates addObject:[calendar dateFromComponents:component]];
    }
    self.pairDates = [[[NSOrderedSet orderedSetWithArray:dates] array] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)setupFetchRequestWithItem:(NSDictionary *)selectedItem {
    NSFetchRequest *fetchRequest = [Lesson fetchRequest];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", [selectedItem valueForKey:@"id"]];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:@"day" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    [[self.fetchedResultsController fetchRequest] setPredicate:filter];
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)setupDropDownControllerWithItem:(NSDictionary *)item {
    NSArray <Item *>*items = [Item MR_findAllSortedBy:@"last_update" ascending:NO];
    NSMutableArray *itemTitles = [[NSMutableArray alloc]init];
    for (Item *item in items) {
        [itemTitles addObject:item.title];
    }
    self.dropDownMenu =  [[PFNavigationDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, 300, 44)
                                                                                       title:[item valueForKey:@"title"]
                                                                                       items:itemTitles
                                                                               containerView:self.view];
    
    self.dropDownMenu.cellTextLabelFont = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    self.dropDownMenu.cellTextLabelColor = [UIColor blackColor];
    self.dropDownMenu.arrowImage = [UIImage imageNamed:@"arrow_down_icon"];
    self.dropDownMenu.checkMarkImage = [UIImage imageNamed:@"checkmark_icon"];
    for (short index = 0; index < items.count; index++) {
        if ([item valueForKey:@"id"] == [items[index] valueForKey:@"id"]) {
            self.dropDownMenu.tableView.selectedIndexPath = index;
            break;
        }
    }
    
    __weak __typeof__(self) weakSelf = self;
    self.dropDownMenu.didSelectItemAtIndexHandler = ^(NSUInteger indexPath) {
        Item *item = items[indexPath];
        NSDictionary *selectedItem = @{@"id": item.id, @"title": item.title, @"type": [NSNumber numberWithInt:item.type]};
        [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:TimetableSelectedItem];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [NSFetchedResultsController deleteCacheWithName:TimetableCacheName];
        [weakSelf setupFetchRequestWithItem:selectedItem];
        [weakSelf setupProperties];
        CGSize size = CGSizeMake(weakSelf.view.frame.size.width, weakSelf.view.frame.size.height + weakSelf.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        [weakSelf resizeHeightForSize:size];
        [weakSelf.collectionView reloadData];
    };
    
    self.navigationItem.titleView = self.dropDownMenu;
}

- (void)addDoubleTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:doubleTapRecognizer];
}

- (void)resizeHeightForSize:(CGSize)size {
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionViewCalendarLayout invalidateLayout];
    if (!self.isVerticalMode) {
        self.collectionViewCalendarLayout.hourHeight = (size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber)*2);
    }
}

#pragma mark - UIContentContainer

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.collectionViewCalendarLayout.sectionWidth = sectonWidth;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
            if (selectedItem) {
                self.navigationItem.titleView = nil;
                [self setupDropDownControllerWithItem:selectedItem];
            }
        }
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGSize newSize = CGSizeMake(size.width, size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [self.dropDownMenu hideMenu];
    [self resizeHeightForSize:newSize];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LessonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    cell.event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.formatter = self.formatter;
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        return dayColumnHeader;
        
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        return timeRowHeader;
    }
    return [[UICollectionReusableView alloc]init];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ModalViewController *modalViewController = [[ModalViewController alloc]initWithDelegate:self andLesson:lesson];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (!self.isVerticalMode) {
        [aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x, 0)];
    }
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSArray <NSDate *>*)timeListForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout {
    return self.pairDates;
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout {
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return lesson.start_time;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return lesson.end_time;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    Lesson *lesson = [sectionInfo.objects firstObject];
    return lesson.day;
}

#pragma mark - ModalViewDelegate

- (void)didSelectItemWithParameters:(NSDictionary *)parameters {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [Request loadTimeTableWithParameters:parameters delegate:self];
}

#pragma mark - URLRequestDelegate

- (void)requestDidFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestDidLoadTimeTable:(id)data info:(NSDictionary *)selectedItem {
    [[EventParser sharedInstance]parseTimeTable:data itemID:selectedItem[@"id"] callBack:^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", selectedItem[@"id"]];
        Item *item = [Item MR_findFirstWithPredicate:predicate];
        
        NSDate *lastUpdate = [NSDate date];
        
        if (item) {
            [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:TimetableSelectedItem];
            [[NSUserDefaults standardUserDefaults]synchronize];
            item.last_update = lastUpdate;
            [[item managedObjectContext] MR_saveToPersistentStoreAndWait];
            [self setupFetchRequestWithItem:selectedItem];
            [self setupProperties];
            CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
            [self resizeHeightForSize:size];
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                [self setupDropDownControllerWithItem:selectedItem];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:TimetableDidUpdateDataNotification object:selectedItem];
            }
            [self.collectionView reloadData];
        } else {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                Item *item = [Item MR_createEntityInContext:localContext];
                item.id = selectedItem[@"id"];
                item.title = selectedItem[@"title"];
                item.last_update = lastUpdate;
                item.type = [selectedItem[@"type"]integerValue];
                [localContext MR_saveToPersistentStoreAndWait];
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                [self setupFetchRequestWithItem:selectedItem];
                [self setupProperties];
                CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
                [self resizeHeightForSize:size];
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                    [self setupDropDownControllerWithItem:selectedItem];
                } else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:TimetableDidUpdateDataNotification object:selectedItem];
                }
                [self.collectionView reloadData];
            }];
        }
    }];
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    [Request loadTimeTableWithParameters:selectedItem delegate:self];
}

- (void)doubleTapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"TimeTable_NoItems", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = NSLocalizedString(@"TimeTable_NoItemsMessage", nil);
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
