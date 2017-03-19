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

@interface TabletTimeTableViewController() <UIPopoverControllerDelegate, PopoverModalViewControllerDelegate, PopoverComboBoxViewControllerDelegate>

@end

@implementation TabletTimeTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [super initWithCoder:coder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:TimetableDidUpdateDataNotification object:nil];
    
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]valueForKey:TimetableSelectedItem];
    [self setupGroupButtonWithItem:selectedItem];
}

#pragma mark - Setup

- (void)setupGroupButtonWithItem:(NSDictionary *)item {
    [self.groupButton setTitle:item[@"title"] forState:UIControlStateNormal];
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

#pragma mark - UIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGSize newSize = CGSizeMake(size.width, size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [super resizeHeightForSize:newSize];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
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
    popoverViewController.delegate = self;
    
    [popoverViewController presentPopoverFromRect:displayFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    Lesson *lesson = [super.fetchedResultsController objectAtIndexPath:indexPath];
    
    CGRect displayFrame = CGRectMake(cell.frame.origin.x - collectionView.contentOffset.x, cell.frame.origin.y - collectionView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    
    PopoverModalViewController *modalViewController = [[PopoverModalViewController alloc]initWithDelegate:self andLesson:lesson];
    UIPopoverController *popoverViewController = [[UIPopoverController alloc]initWithContentViewController:modalViewController];
    popoverViewController.delegate = self;
    
    [popoverViewController presentPopoverFromRect:displayFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopoverModalViewControllerDelegate

- (void)didSelectItemWithParameters:(NSDictionary *)parameters {
    [super didSelectItemWithParameters:parameters];
}

#pragma mark - PopoverComboBoxViewControllerDelegate 

- (void)didSelectComboboxItemWithParameters:(NSDictionary *)item {
    [self setupGroupButtonWithItem:item];
    [self setupFetchRequestWithItem:item];
    [self setupProperties];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    [self resizeHeightForSize:size];
    [self.collectionView reloadData];
    [[NSUserDefaults standardUserDefaults]setObject:item forKey:TimetableSelectedItem];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
