//
//  MSDayColumnHeader.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 05.11.16.
//  Copyright (c) 2015 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface MSDayColumnHeader : UICollectionReusableView

@property (strong, nonatomic) NSDate *day;
@property (assign, nonatomic) BOOL currentDay;
@property (strong, nonatomic) NSDateFormatter *formatter;

@end
