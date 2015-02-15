//
//  AuditoryList.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 23.01.15.
//  Copyright (c) 2015 Влад. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditoryList : UITableViewController{
    
    NSMutableData *mutableResponse;
}

@property (strong, nonatomic) UIButton *menuButton;

@end

NSMutableArray *auditoryList;