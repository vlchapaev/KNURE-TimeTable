//
//  MSTimeRowHeader.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAS_SHORTHAND

@interface MSTimeRowHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSDate *time;

@end
