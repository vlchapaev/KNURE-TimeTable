//
//  MSDayColumnHeader.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

@import UIKit;

@interface MSDayColumnHeader : UICollectionReusableView

@property (strong, nonatomic) NSDate *day;
@property (assign, nonatomic) BOOL currentDay;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSString *itemTitle;

@end
