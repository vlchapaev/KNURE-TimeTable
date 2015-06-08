//
//  TeachersList.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 11.10.2013.
//  Copyright (c) 2013 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherList : UITableViewController {
    
    NSMutableData *mutableResponse;
}

@property (strong, nonatomic) UIButton *menuButton;

@end

NSMutableArray *teacherList;