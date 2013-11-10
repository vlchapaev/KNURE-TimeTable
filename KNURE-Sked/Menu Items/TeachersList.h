//
//  TeachersList.h
//  KNURE-Sked
//
//  Created by Влад on 11/10/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachersList : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *teacherField;
@property (strong, nonatomic) UIButton *menuBtn;
- (IBAction)addTeacher:(id)sender;

@end
NSMutableArray *teachersList;
