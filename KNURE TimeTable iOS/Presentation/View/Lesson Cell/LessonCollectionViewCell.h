//
//  LessonCollectionViewCell.h
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 03.11.16.
//  Copyright © 2016 Vladislav Chapaev. All rights reserved.
//

@import UIKit;

@interface LessonCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *location;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIColor *mainColor;
@property (assign, nonatomic) CGFloat opacity;
@property (nonatomic, strong) UIView *borderView;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *textColorHighlighted;

@end
