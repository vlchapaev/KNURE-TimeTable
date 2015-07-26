//
//  ModalViewController.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.10.14.
//  Copyright (c) 2014 Shogunate. All rights reserved.
//

#import "ModalViewController.h"
#import "EventHandler.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//TODO: сделать вывод более красивым и компактным

- (id)initWithDictionary:(NSDictionary *)sked index:(NSInteger)index isTablet:(BOOL)isTablet {
    self = [super init];
    
    EventHandler *eventHandler = [[EventHandler alloc]init];
    
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.layer.cornerRadius = 5.f;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.borderWidth = 5.f;
    self.view.layer.opacity = 0.4f;
    
    UILabel *typeLabel = [[UILabel alloc]init];
    UILabel *auditoryLabel = [[UILabel alloc] init];
    UILabel *teacherLabel = [[UILabel alloc]init];
    UILabel *groupLabel = [[UILabel alloc]init];
    
    UILabel *name = [[UILabel alloc]init];
    UILabel *type = [[UILabel alloc]init];
    UILabel *auditory = [[UILabel alloc]init];
    UILabel *teacher = [[UILabel alloc]init];
    UILabel *group = [[UILabel alloc]init];
    
    typeLabel.text =              NSLocalizedString(@"Type", nil);
    auditoryLabel.text =     NSLocalizedString(@"Auditory", nil);
    teacherLabel.text =  NSLocalizedString(@"Teacher", nil);
    groupLabel.text =           NSLocalizedString(@"Groups",nil);
    
    name.text = [eventHandler getBriefByID:[[[eventHandler.events objectAtIndex:index]valueForKey:@"subject_id"]integerValue] from:eventHandler.subjects shortName:NO];
    type.text = [eventHandler getTypeNameByID:[[[eventHandler.events objectAtIndex:index]valueForKey:@"type"]integerValue] from:eventHandler.types shortName:NO];
    teacher.text = [eventHandler getNameFromEvent:[[eventHandler.events objectAtIndex:index] valueForKey:@"teachers"] inArray:eventHandler.teachers isTeacher:YES];
    auditory.text = [[eventHandler.events objectAtIndex:index]valueForKey:@"auditory"];
    group.text = [eventHandler getNameFromEvent:[[eventHandler.events objectAtIndex:index] valueForKey:@"groups"] inArray:eventHandler.groups isTeacher:NO];
    
    name.textColor = [UIColor whiteColor];
    name.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.00];
    type.textColor = [UIColor whiteColor];
    auditory.textColor = [UIColor whiteColor];
    teacher.textColor = [UIColor whiteColor];
    typeLabel.textColor = [UIColor whiteColor];
    auditoryLabel.textColor = [UIColor whiteColor];
    teacherLabel.textColor = [UIColor whiteColor];
    groupLabel.textColor = [UIColor whiteColor];
    group.textColor = [UIColor whiteColor];
    
    if (!isTablet) {
    
        typeLabel.frame = CGRectMake(0, 90, 130, 30);
        auditoryLabel.frame = CGRectMake(0, 130, 130, 30);
        teacherLabel.frame = CGRectMake(0, 160, 130, 30);
        groupLabel.frame = CGRectMake(0, 215, 130, 30);
    
        name.frame = CGRectMake(0, 5, 280, 90);
        type.frame = CGRectMake(135, 95, 130, 30);
        auditory.frame = CGRectMake(135, 130, 130, 30);
        teacher.frame = CGRectMake(135, 165, 130, 50);
        group.frame = CGRectMake(135, 220, 130, 100);
    
        name.numberOfLines = 0;
        name.textAlignment = NSTextAlignmentCenter;
        name.layer.cornerRadius = 5.f;
        name.layer.borderWidth = 5.f;
        [name setFont:[UIFont fontWithName: @"Helvetica Neue" size: 20.0f]];
    
    
        type.numberOfLines = 0;
        [type sizeToFit];
        [type setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
    
        [auditory setFont:[UIFont fontWithName: @"Helvetica Neue" size: 18.0f]];
    
        teacher.numberOfLines = 0;
        [teacher setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
        [teacher sizeToFit];
    
        [typeLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 18.0f]];
        typeLabel.textAlignment = NSTextAlignmentRight;
    
        auditoryLabel.textAlignment = NSTextAlignmentRight;
        [auditoryLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 18.0f]];
    
        teacherLabel.textAlignment = NSTextAlignmentRight;
        [teacherLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
    
        groupLabel.textAlignment = NSTextAlignmentRight;
        [groupLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
    
        group.numberOfLines = 0;
        [group setFont:[UIFont fontWithName: @"Helvetica Neue" size: 16.0f]];
        [group sizeToFit];
    
        int height = group.frame.size.height +
                    teacher.frame.size.height +
                    auditory.frame.size.height +
                    name.frame.size.height +
                    type.frame.size.height;
    
        self.view.frame = CGRectMake(0, 0, 280, height + 45);
        
    } else {
        
        typeLabel.frame = CGRectMake(0, 180, 260, 60);
        auditoryLabel.frame = CGRectMake(0, 260, 260, 60);
        teacherLabel.frame = CGRectMake(0, 320, 260, 60);
        groupLabel.frame = CGRectMake(0, 430, 260, 60);
        
        name.frame = CGRectMake(0, 10, 560, 180);
        type.frame = CGRectMake(270, 190, 260, 60);
        auditory.frame = CGRectMake(270, 260, 260, 60);
        teacher.frame = CGRectMake(270, 330, 260, 100);
        group.frame = CGRectMake(270, 440, 260, 200);
        
        name.numberOfLines = 0;
        name.textAlignment = NSTextAlignmentCenter;
        name.layer.cornerRadius = 5.f;
        name.layer.borderWidth = 5.f;
        [name setFont:[UIFont fontWithName: @"Helvetica Neue" size: 40.0f]];
        
        type.numberOfLines = 0;
        [type setFont:[UIFont fontWithName: @"Helvetica Neue" size: 32.0f]];
        [type sizeToFit];
        
        [auditory setFont:[UIFont fontWithName: @"Helvetica Neue" size: 36.0f]];
        
        teacher.numberOfLines = 0;
        [teacher setFont:[UIFont fontWithName: @"Helvetica Neue" size: 32.0f]];
        [teacher sizeToFit];
        
        [typeLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 36.0f]];
        typeLabel.textAlignment = NSTextAlignmentRight;
        
        auditoryLabel.textAlignment = NSTextAlignmentRight;
        [auditoryLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 36.0f]];
        
        teacherLabel.textAlignment = NSTextAlignmentRight;
        [teacherLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 32.0f]];
        
        groupLabel.textAlignment = NSTextAlignmentRight;
        [groupLabel setFont:[UIFont fontWithName: @"Helvetica Neue" size: 32.0f]];
        
        group.numberOfLines = 0;
        [group setFont:[UIFont fontWithName: @"Helvetica Neue" size: 32.0f]];
        [group sizeToFit];
        
        int height = group.frame.size.height +
        teacher.frame.size.height +
        auditory.frame.size.height +
        name.frame.size.height +
        type.frame.size.height;
        
        self.view.frame = CGRectMake(0, 0, 560, height + 130);

    }
    [self.view addSubview:name];
    [self.view addSubview:type];
    [self.view addSubview:auditory];
    [self.view addSubview:teacher];
    [self.view addSubview:group];
    
    [self.view addSubview:typeLabel];
    [self.view addSubview:auditoryLabel];
    [self.view addSubview:teacherLabel];
    [self.view addSubview:groupLabel];

    return self;
}

@end
