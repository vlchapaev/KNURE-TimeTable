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
#import "YSLDraggableCardContainer.h"
#import "ModalView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
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

@interface TimeTableViewController() <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate, DZNEmptyDataSetSource, ModalViewDelegate, YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>

@property (strong, nonatomic) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) YSLDraggableCardContainer *container;
@property (strong, nonatomic) ModalView *modalView;

@property (assign, nonatomic) short maxPairNumber;
@property (assign, nonatomic) short minPairNumber;

@property (assign, nonatomic) BOOL isVerticalMode;
@property (assign, nonatomic) BOOL isDarkMode;

@end

@implementation TimeTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
        self.collectionViewCalendarLayout.delegate = self;
        self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
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
        [self setupDropDownControllerWithItem:selectedItem];
    }
    [self setupProperties];
    [self setupCollectionView];
    [self setupModalView];
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
    } else {
        self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
        self.collectionViewCalendarLayout.sectionWidth = sectonWidth;
        self.collectionViewCalendarLayout.hourHeight = (self.collectionView.frame.size.height - 64 - timeRowHeaderWidth)/((self.maxPairNumber - self.minPairNumber) * 2.1);
    }
    
    [self.collectionViewLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    [self.collectionViewLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
}

- (void)setupModalView {
    self.modalView = [[ModalView alloc]init];
    self.modalView.delegate = self;
    
    self.container = [[YSLDraggableCardContainer alloc]init];
    self.container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.container.backgroundColor = [UIColor clearColor];
    self.container.dataSource = self;
    self.container.delegate = self;
    self.container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp | YSLDraggableDirectionDown;
}

- (void)setupProperties {
    self.isVerticalMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
    self.isDarkMode = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
    NSArray *pairNumbers = [self.fetchedResultsController.fetchedObjects valueForKey:@"number_pair"];
    self.maxPairNumber = [[pairNumbers valueForKeyPath:@"@max.intValue"] shortValue];
    self.minPairNumber = [[pairNumbers valueForKeyPath:@"@min.intValue"] shortValue] - 1;
}

- (void)setupFetchRequestWithItem:(NSDictionary *)selectedItem {
    NSFetchRequest *fetchRequest = [Lesson fetchRequest];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"item_id == %@", [selectedItem valueForKey:@"id"]];
    
    if (!self.fetchedResultsController) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start_time" ascending:YES]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"day" cacheName:TimeTableCacheName];
        self.fetchedResultsController.delegate = self;
    }
    
    [[self.fetchedResultsController fetchRequest] setPredicate:filter];
    
    [self.fetchedResultsController performFetch:nil];
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
        [self.collectionView.collectionViewLayout invalidateLayout];
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
    self.modalView = [[[NSBundle mainBundle] loadNibNamed:@"ModalView" owner:self options:nil] objectAtIndex:0];
    [self.modalView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.modalView.lesson.text = lesson.title;
    self.modalView.type.text = lesson.type_title;
    self.modalView.auditory.text = lesson.auditory;
    
    [self.view addSubview:self.container];
    [self.container reloadCardContainer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (!self.isVerticalMode) {
        [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
    }
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

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
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSURLRequest *request = [Request getTimetable:itemID ofType:itemType];
    [manager GET:request.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [[EventParser sharedInstance]parseTimeTable:responseObject itemID:itemID callBack:^{
            
            //NSDate *lastUpdate = [NSDate date];
            
            //item.last_update = lastUpdate;
            //[[item managedObjectContext] MR_saveToPersistentStoreAndWait];
            
            [[NSUserDefaults standardUserDefaults]setObject:@{@"id": itemID, @"title": title, @"type": [NSNumber numberWithInt:itemType]} forKey:TimetableSelectedItem];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        }];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - YSLDraggableCardContainerDataSource

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index {
    return self.modalView;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index {
    return 1;
}

#pragma mark - YSLDraggableCardContainerDelegate

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection {
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container; {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container removeFromSuperview];
    });
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    //TODO: implementation
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSURLRequest *request = [Request getTimetable:@2 ofType:1];
    [manager GET:request.URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [[EventParser sharedInstance]parseTimeTable:responseObject itemID:@2 callBack:^{
            
            //NSDate *lastUpdate = [NSDate date];
            
            //item.last_update = lastUpdate;
            //[[item managedObjectContext] MR_saveToPersistentStoreAndWait];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        }];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Interface_Error", @"") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)doubleTapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
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
