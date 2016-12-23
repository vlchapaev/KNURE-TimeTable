//
//  LessonCollectionViewCell.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson+CoreDataProperties.h"

@interface LessonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) Lesson *event;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIView *borderView;

@end
