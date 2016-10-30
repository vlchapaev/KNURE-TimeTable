//
//  MainViewController.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 24.10.2013.
//  Copyright (c) 2016 Vlad Chapaev. All rights reserved.
//

#import "MainViewController.h"
#import "MSCollectionViewCalendarLayout.h"
#import "AFNetworking.h"

@interface TimeTableViewController() <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSArray *datasource;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Item"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *json = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    self.datasource = [parsed valueForKey:@"events"];
    
    NSLog(@"%@", self.datasource);
}

#pragma mark - Setters

- (void)addDoubleTapGesture {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:doubleTapRecognizer];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout {
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger date = [[self.datasource[indexPath.row] valueForKey:@"start_time"] integerValue];
    return [[NSDate alloc]initWithTimeIntervalSince1970:date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger date = [[self.datasource[indexPath.row] valueForKey:@"end_time"] integerValue];
    return [[NSDate alloc]initWithTimeIntervalSince1970:date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section {
    NSInteger dateUnix = [[self.datasource[section] valueForKey:@"start_time"] integerValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:dateUnix];
    return [[NSCalendar currentCalendar] startOfDayForDate:date];
}

#pragma mark - Events

- (IBAction)refreshCurrentTimeTable {
    
}

- (IBAction)groupButtonTap {
    
}

- (void)doubleTapGestureRecognized:(UIGestureRecognizer *)recognizer {
    
}

@end
