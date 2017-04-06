//
//  TabletTimeTableViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 23.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "TabletTimeTableViewController.h"
#import "PopoverModalViewController.h"
#import "PopoverComboBoxViewController.h"
#import "Configuration.h"
#import "LessonCollectionViewCell.h"

@interface TabletTimeTableViewController() <PopoverModalViewControllerDelegate, PopoverComboBoxViewControllerDelegate>

@property (assign, nonatomic) BOOL isDarkTheme;

@end

@implementation TabletTimeTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self.isDarkTheme = [Configuration isDarkTheme];
    return [super initWithCoder:coder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:TimetableDidUpdateDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidChangeTheme) name:ApplicationDidChangeThemeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeGridLayout) name:TimetableDidChangeGridLayoutNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRemoveEmptyDays) name:TimetableDidRemoveEmptyDaysNotification object:nil];
    
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    [self setupGroupButtonWithItem:[selectedItem transformToNSManagedObject]];
}

#pragma mark - Setup

- (void)setupGroupButtonWithItem:(Item *)item {
    [self.groupButton setTitle:item.title forState:UIControlStateNormal];
}

#pragma mark - Notification Center

- (void)didReceiveNotification:(NSNotification *)notification {
    [self setupFetchRequestWithItem:notification.object];
    [self setupProperties];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [self resizeHeightForSize:size];
    [self setupGroupButtonWithItem:notification.object];
    [self.collectionView reloadData];
}

- (void)applicationDidChangeTheme {
    self.isDarkTheme = [Configuration isDarkTheme];
}

- (void)didChangeGridLayout {
    
}

- (void)didRemoveEmptyDays {
    [self setupFetchRequestWithItem:[Item getSelectedItem]];
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

#pragma mark - UIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGSize newSize = CGSizeMake(size.width, size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [super resizeHeightForSize:newSize];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    BOOL isRunningInFullScreen = CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
    if (!isRunningInFullScreen) {
        self.menuButton.enabled = NO;
        self.menuButton.tintColor = [UIColor clearColor];
    } else {
        self.menuButton.enabled = YES;
        self.menuButton.tintColor = nil;
    }
    [super traitCollectionDidChange];
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    [super refreshCurrentTimeTable];
}

- (IBAction)groupListButtonTap:(UIButton *)sender {
    CGRect displayFrame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y - 44, sender.frame.size.width, sender.frame.size.height);
    
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    PopoverComboBoxViewController *modalViewController = [[PopoverComboBoxViewController alloc]initWithDelegate:self];
    modalViewController.selectedItemID = [selectedItem[@"id"] integerValue];
    
    UIPopoverController *popoverViewController = [[UIPopoverController alloc]initWithContentViewController:modalViewController];
    
    popoverViewController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
    
    [popoverViewController presentPopoverFromRect:displayFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LessonCollectionViewCell *cell = (LessonCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect displayFrame = CGRectMake(cell.frame.origin.x - collectionView.contentOffset.x, cell.frame.origin.y - collectionView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    
    Lesson *lesson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    PopoverModalViewController *modalViewController = [[PopoverModalViewController alloc]initWithLesson:lesson];
    modalViewController.delegate = self;
    modalViewController.indexPath = indexPath;
    UIPopoverController *popoverViewController = [[UIPopoverController alloc]initWithContentViewController:modalViewController];
    
    popoverViewController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
    
    [popoverViewController presentPopoverFromRect:displayFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopoverModalViewControllerDelegate

- (void)didSelectItem:(Item *)item {
    [super didSelectItem:item];
}

- (void)didDismissViewControllerWithSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - PopoverComboBoxViewControllerDelegate 

- (void)didSelectComboboxItem:(Item *)item {
    [self setupGroupButtonWithItem:item];
    [self setupFetchRequestWithItem:item];
    [self setupProperties];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [self resizeHeightForSize:size];
    [self.collectionView reloadData];
    [item saveAsSelectedItem];
}

@end
