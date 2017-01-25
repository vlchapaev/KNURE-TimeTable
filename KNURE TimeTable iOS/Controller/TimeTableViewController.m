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

NSString *const TimeTableCacheName = @"TimeTableCacheName";
NSString *const TimetableSelectedItem = @"TimetableSelectedItem";
NSString *const TimetableVerticalMode = @"TimetableVerticalMode";
NSString *const TimetableIsDarkMode = @"TimetableIsDarkMode";
NSString *const TimetableDrawEmptyDays = @"TimetableDrawEmptyDays";

CGFloat const sectonWidth = 110;
CGFloat const timeRowHeaderWidth = 44;
CGFloat const dayColumnHeaderHeight = 40;

@interface TimeTableViewController() <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, ModalViewControllerDelegate, URLRequestDelegate>

@property (strong, nonatomic) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray <NSDate *>* pairDates;
@property (assign, nonatomic) short maxPairNumber;
@property (assign, nonatomic) short minPairNumber;

@property (assign, nonatomic) BOOL isVerticalMode;
@property (assign, nonatomic) BOOL isDarkMode;

@end

@implementation TimeTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
        self.collectionViewCalendarLayout.delegate = self;
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
        self.collectionViewCalendarLayout.hourHeight = (self.collectionView.frame.size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber)*2);
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
    self.isDarkMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
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
    PFNavigationDropdownMenu *dropDownMenu =  [[PFNavigationDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, 300, 44)
                                                                                       title:[item valueForKey:@"title"]
                                                                                       items:itemTitles
                                                                               containerView:self.view];
    
    dropDownMenu.cellTextLabelFont = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    dropDownMenu.cellTextLabelColor = [UIColor blackColor];
    dropDownMenu.arrowImage = [UIImage imageNamed:@"arrow_down_icon"];
    dropDownMenu.checkMarkImage = [UIImage imageNamed:@"checkmark_icon"];
    for (short index = 0; index < items.count; index++) {
        if ([item valueForKey:@"id"] == [items[index] valueForKey:@"id"]) {
            dropDownMenu.tableView.selectedIndexPath = index;
            break;
        }
    }
    dropDownMenu.didSelectItemAtIndexHandler = ^(NSUInteger indexPath) {
        Item *item = items[indexPath];
        NSDictionary *selectedItem = @{@"id": item.id, @"title": item.title, @"type": [NSNumber numberWithInt:item.type]};
        [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:TimetableSelectedItem];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [NSFetchedResultsController deleteCacheWithName:TimeTableCacheName];
        [self setupFetchRequestWithItem:selectedItem];
        [self setupProperties];
        if (!self.isVerticalMode) {
            self.collectionViewCalendarLayout.hourHeight = (self.view.frame.size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber)*2);
        }
        [self.collectionViewCalendarLayout invalidateLayoutCache];
        [self.collectionView reloadData];
    };
    
    self.navigationItem.titleView = dropDownMenu;
}

- (void)addDoubleTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:doubleTapRecognizer];
}

#pragma mark - UIContentContainer

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.collectionViewCalendarLayout.sectionWidth = sectonWidth;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
    }];
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
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        dayColumnHeader.formatter = self.formatter;
        
        return dayColumnHeader;
        
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        return timeRowHeader;
    }
    return view;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
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
        [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
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

- (void)didSelectItem:(NSNumber *)itemID title:(NSString *)title ofType:(ItemType)itemType {
    //TODO: implementation
}

#pragma mark - URLRequestDelegate

- (void)requestDidFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestDidFinishLoading {
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    [self setupFetchRequestWithItem:selectedItem];
    [self.collectionView reloadData];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    [Request loadTimeTableOfType:[selectedItem[@"type"] intValue] itemID:selectedItem[@"id"] delegate:self];
}

- (void)doubleTapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Нет расписания";
    
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
