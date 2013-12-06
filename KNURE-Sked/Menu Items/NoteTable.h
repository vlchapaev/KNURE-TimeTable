//
//  NoteTable.h
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 03.12.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTable : UITableViewController
@property (strong, nonatomic) UIButton *menuBtn;
@end
NSString *datesRequest;
NSString *notesRequest;
NSString *XRequest;
NSString *YRequest;
NSMutableArray *notes;
NSMutableArray *notesX;
NSMutableArray *notesY;
NSMutableArray *dates;
