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
#import "Lesson.h"
#import "Item.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PFNavigationDropdownMenu.h"
#import "ModalViewController.h"
#import "MBProgressHUD.h"
#import "Request.h"
#import "EventParser.h"
#import "Configuration.h"
#import "EAIntroView.h"

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

CGFloat const sectonWidth = 110;
CGFloat const timeRowHeaderWidth = 44;
CGFloat const dayColumnHeaderHeight = 40;

@interface TimeTableViewController() <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ModalViewControllerDelegate, URLRequestDelegate, PFNavigationDropdownMenuDelegate, EAIntroDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (strong, nonatomic) PFNavigationDropdownMenu *dropDownMenu;
@property (strong, nonatomic) NSArray <Item *>*allItems;
@property (strong, nonatomic) Item *selectedItem;

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray <NSDate *>* pairDates;
@property (assign, nonatomic) short maxPairNumber;
@property (assign, nonatomic) short minPairNumber;

@property (assign, nonatomic) BOOL isRunningInFullScreen;

@property (assign, nonatomic) BOOL isVerticalMode;
@property (assign, nonatomic) BOOL isDarkMode;
@property (assign, nonatomic) BOOL removeEmptyDays;

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
    
    Item *item = [Item getSelectedItem];
    if (item) {
        self.selectedItem = item;
        [self setupFetchRequestWithItem:item];
        [self setupProperties];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [self setupDropDownController];
        }
    } else {
        self.refreshButton.enabled = NO;
    }
    
    [self setupCollectionView];
    [self addDoubleTapGesture];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(0.5);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
        });
    });
}

#pragma mark - Setup

- (void)setupCollectionView {
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
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
        [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    }
    
    [self.collectionViewLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    [self.collectionViewLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
}

- (void)setupProperties {
    self.isVerticalMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
    self.isRunningInFullScreen = CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
    if (!self.isRunningInFullScreen) {
        self.isVerticalMode = YES;
    }
    self.isDarkMode = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationIsDarkTheme];
    
    NSArray *pairNumbers = [self.fetchedResultsController.fetchedObjects valueForKey:@"number_pair"];
    self.maxPairNumber = [[pairNumbers valueForKeyPath:@"@max.intValue"] shortValue];
    self.minPairNumber = [[pairNumbers valueForKeyPath:@"@min.intValue"] shortValue]-1;
    if (self.minPairNumber < 0) { self.minPairNumber = 0; }
    
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
        component.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Kiev"];
        [dates addObject:[calendar dateFromComponents:component]];
    }
    self.pairDates = [[[NSOrderedSet orderedSetWithArray:dates] array] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)setupFetchRequestWithItem:(Item *)selectedItem {
    NSFetchRequest *fetchRequest = [Lesson fetchRequest];
    self.removeEmptyDays = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableRemoveEmptyDays];
    NSPredicate *filter = (self.removeEmptyDays) ? [NSPredicate predicateWithFormat:@"item_id == %@ AND isDummy == NO", selectedItem.id] : [NSPredicate predicateWithFormat:@"item_id == %@", selectedItem.id];
    
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

- (void)setupDropDownController {
    self.allItems = [Item MR_findAllSortedBy:@"last_update" ascending:NO];
    self.dropDownMenu = [[PFNavigationDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, 300, 44) title:self.selectedItem.title items:[self.allItems valueForKey:@"title"] containerView:self.view];
    self.dropDownMenu.delegate = self;
    
    self.dropDownMenu.cellTextLabelFont = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    self.dropDownMenu.cellTextLabelColor = (self.isDarkMode) ? ApplicationThemeDarkFontPrimaryColor : ApplicationThemeLightFontPrimaryColor;
    self.dropDownMenu.cellBackgroundColor = (self.isDarkMode) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
    self.dropDownMenu.arrowImage = (self.isDarkMode) ? [UIImage imageNamed:@"arrow_down_icon-1"] : [UIImage imageNamed:@"arrow_down_icon"];
    self.dropDownMenu.checkMarkImage = (self.isDarkMode) ? [UIImage imageNamed:@"checkmark_icon-1"] : [UIImage imageNamed:@"checkmark_icon"];
    
    for (short index = 0; index < self.allItems.count; index++) {
        if (self.selectedItem.id == self.allItems[index].id) {
            self.dropDownMenu.tableView.selectedIndexPath = index;
        }
    }
    
    self.navigationItem.titleView = self.dropDownMenu;
}

- (EAIntroView *)setupIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"intro-1"];
    page1.title = @"оловылфволыфо лволфы олво фылдов лоыфдлво лдфыовлд оыфлдводлыфовдлоыфлд овлд оыфдвд оыфдо вдфыд овдофдлы ово фдыовд офыдво ыфдло вдоыфо воф двод фыов дыфо";
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"intro-2"];
    page2.title = @"ваивышоавт атвышщ тащшвты шщатвы шщташщты шщватщшы втщаштвшщы тащштыв щшташщвы тщшат щывта щтвыщш тащвшыт шатвышщ ташщывт шатщ ывшта щшы";
    
    return [[EAIntroView alloc] initWithFrame:self.navigationController.view.bounds andPages:@[page1, page2]];
}

- (void)addDoubleTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:doubleTapRecognizer];
}

#pragma mark - Container resize

- (void)resizeHeightForSize:(CGSize)size {
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionViewCalendarLayout invalidateLayout];
    if (!self.isVerticalMode) {
        self.collectionViewCalendarLayout.hourHeight = (size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber)*2);
    }
}

- (void)traitCollectionDidChange {
    [self setupProperties];
    
    if (self.isVerticalMode) {
        self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeVerticalTile;
        self.collectionViewCalendarLayout.sectionWidth = [UIApplication sharedApplication].delegate.window.frame.size.width - timeRowHeaderWidth - 10;
        self.collectionViewCalendarLayout.hourHeight = 30;
    } else {
        self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
        self.collectionViewCalendarLayout.sectionWidth = sectonWidth;
        self.collectionViewCalendarLayout.hourHeight = (self.collectionView.frame.size.height - 24 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber) * 2);
    }
    
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionViewCalendarLayout invalidateLayout];
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
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                    [self setupDropDownController];
                }
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

#pragma mark - PFNavigationDropdownMenuDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItem = self.allItems[indexPath.row];
    [self.selectedItem saveAsSelectedItem];
    [NSFetchedResultsController deleteCacheWithName:ApplicationCacheName];
    [self setupFetchRequestWithItem:self.selectedItem];
    [self setupProperties];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [self resizeHeightForSize:size];
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
    } else {
        [aScrollView setContentOffset:CGPointMake(0, aScrollView.contentOffset.y)];
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

- (void)didSelectItem:(Item *)item {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [Request loadTimeTableForItem:item delegate:self];
}

#pragma mark - URLRequestDelegate

- (void)requestDidFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Interface_Ok", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestDidLoadTimeTable:(id)data forItem:(Item *)item {
    [[EventParser sharedInstance]parseTimeTable:data itemID:item.id callBack:^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        item.last_update = [NSDate date];
        [item saveAsSelectedItem];
        self.selectedItem = item;
        [[item managedObjectContext] MR_saveToPersistentStoreAndWait];
        [self setupFetchRequestWithItem:item];
        [self setupProperties];
        CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        [self resizeHeightForSize:size];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [self setupDropDownController];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:TimetableDidUpdateDataNotification object:item];
        }
        [self.collectionViewCalendarLayout invalidateLayoutCache];
        [self.collectionViewCalendarLayout invalidateLayout];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", selectedItem[@"id"]];
    Item *item = [Item MR_findFirstWithPredicate:predicate];
    [Request loadTimeTableForItem:item delegate:self];
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

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = (state == UIControlStateNormal) ? ApplicationThemeLightTintColor : [UIColor colorWithRed:0.78 green:0.87 blue:0.98 alpha:1.00];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"TimeTable_Tutorial", nil) attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    EAIntroView *introView = [self setupIntro];
    introView.delegate = self;
    introView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    introView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [introView.skipButton setTitleColor:[UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [introView.skipButton setTitleColor:[UIColor colorWithRed:0.78 green:0.87 blue:0.98 alpha:1.00] forState:UIControlStateHighlighted];
    [introView showInView:self.navigationController.view animateDuration:0.3];
}

@end
