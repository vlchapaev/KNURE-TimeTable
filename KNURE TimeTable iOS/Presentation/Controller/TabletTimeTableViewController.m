////
////  TabletTimeTableViewController.m
////  KNURE TimeTable
////
////  Created by Vladislav Chapaev on 23.11.16.
////  Copyright © 2016 Vladislav Chapaev. All rights reserved.
////
//
//#import "TabletTimeTableViewController.h"
//#import "PopoverModalViewController.h"
//#import "PopoverComboBoxViewController.h"
//#import "Configuration.h"
//#import "LessonCollectionViewCell.h"
//
//@interface TabletTimeTableViewController() <PopoverModalViewControllerDelegate, PopoverComboBoxViewControllerDelegate, UIPopoverPresentationControllerDelegate>
//
//@property (assign, nonatomic) BOOL isDarkTheme;
//
//@end
//
//@implementation TabletTimeTableViewController
//
//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self.isDarkTheme = [Configuration isDarkTheme];
//    return [super initWithCoder:coder];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:TimetableDidUpdateDataNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidChangeTheme) name:ApplicationDidChangeThemeNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeGridLayout) name:TimetableDidChangeGridLayoutNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRemoveEmptyDays) name:TimetableDidRemoveEmptyDaysNotification object:nil];
//    
//    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
//    [self setupGroupButtonWithItem:[selectedItem transformToNSManagedObject]];
//}
//
//#pragma mark - Setup
//
//- (void)setupGroupButtonWithItem:(Item *)item {
//    [self.groupButton setTitle:item.title forState:UIControlStateNormal];
//}
//
//#pragma mark - Notification Center
//
//- (void)didReceiveNotification:(NSNotification *)notification {
//    [self setupFetchRequestWithItem:notification.object];
//    [self setupProperties];
//    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
//    [self resizeHeightForSize:size];
//    [self setupGroupButtonWithItem:notification.object];
//    [self.collectionView reloadData];
//}
//
//- (void)applicationDidChangeTheme {
//    self.isDarkTheme = [Configuration isDarkTheme];
//    [self.collectionViewCalendarLayout invalidateLayoutCache];
//    [self.collectionViewLayout invalidateLayout];
//    [self.collectionView reloadData];
//}
//
//- (void)didChangeGridLayout {
//    self.collectionViewCalendarLayout.isHourlyGridLayout = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableHourlyGridLayout];
//    [self.collectionViewCalendarLayout invalidateLayoutCache];
//    [self.collectionViewLayout invalidateLayout];
//    [self.collectionView reloadData];
//}
//
//- (void)didRemoveEmptyDays {
//    [self setupFetchRequestWithItem:[Item getSelectedItem]];
//    [self.collectionViewCalendarLayout invalidateLayoutCache];
//    [self.collectionViewLayout invalidateLayout];
//    [self.collectionView reloadData];
//}
//
//#pragma mark - UIContentContainer
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    CGSize newSize = CGSizeMake(size.width, size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
//    [super resizeHeightForSize:newSize];
//}
//
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    BOOL isRunningInFullScreen = CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
//    
//    if (!isRunningInFullScreen) {
//        self.menuButton.enabled = NO;
//        self.menuButton.tintColor = [UIColor clearColor];
//    } else {
//        self.menuButton.enabled = YES;
//        self.menuButton.tintColor = nil;
//    }
//    
//    UIViewController *presentedViewController = [self presentedViewController];
//    if (presentedViewController) {
//        [presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }
//    
//    [super traitCollectionDidChange];
//}
//
//#pragma mark - Events
//
//- (IBAction)refreshCurrentTimeTable {
//    [super refreshCurrentTimeTable];
//}
//
//- (IBAction)groupListButtonTap:(UIButton *)sender {
//    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
//    
//    PopoverComboBoxViewController *modalViewController = [[PopoverComboBoxViewController alloc]initWithDelegate:self];
//    modalViewController.selectedItemID = [selectedItem[@"id"] integerValue];
//    modalViewController.modalPresentationStyle = UIModalPresentationPopover;
//    
//    UIPopoverPresentationController *popoverPresentationController = modalViewController.popoverPresentationController;
//    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    popoverPresentationController.sourceRect = sender.bounds;
//    popoverPresentationController.sourceView = sender;
//    popoverPresentationController.delegate = self;
//    popoverPresentationController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
//    
//    [self presentViewController:modalViewController animated: YES completion: nil];
//}
//
//#pragma mark - UICollectionViewDelegate
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    LessonCollectionViewCell *cell = (LessonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    PopoverModalViewController *modalViewController = [[PopoverModalViewController alloc]initWithLesson:lesson];
//    modalViewController.delegate = self;
//    modalViewController.indexPath = indexPath;
//    modalViewController.modalPresentationStyle = UIModalPresentationPopover;
//    
//    UIPopoverPresentationController *popoverPresentationController = modalViewController.popoverPresentationController;
//    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    popoverPresentationController.sourceRect = cell.bounds;
//    popoverPresentationController.sourceView = cell;
//    popoverPresentationController.delegate = self;
//    popoverPresentationController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
//    
//    [self presentViewController:modalViewController animated: YES completion: nil];
//}
//
//#pragma mark - PopoverModalViewControllerDelegate
//
//- (void)didSelectItem:(Item *)item {
//    [super didSelectItem:item];
//}
//
//- (void)didDismissViewControllerWithSelectedIndexPath:(NSIndexPath *)indexPath {
//    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//}
//
//#pragma mark - PopoverComboBoxViewControllerDelegate 
//
//- (void)didSelectComboboxItem:(Item *)item {
//    [self setupGroupButtonWithItem:item];
//    [self setupFetchRequestWithItem:item];
//    [self setupProperties];
//    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
//    [self resizeHeightForSize:size];
//    [self.collectionView reloadData];
//    [item saveAsSelectedItem];
//}
//
//#pragma mark - UIPopoverPresentationControllerDelegate
//
//- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
//    return UIModalPresentationNone;
//}
//
//@end
