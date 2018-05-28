//
//  MSTimeRowHeader.h
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 05.11.16.
//  Copyright (c) 2015 Vladislav Chapaev. All rights reserved.
//

@import UIKit;

@interface MSTimeRowHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSDate *time;
@property (strong, nonatomic) UIColor *textColor;

@end
