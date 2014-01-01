//
//  NewSkedCell.m
//  KNURE-Sked
//
//  Created by Влад on 12/4/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "NewSkedCell.h"
#import "ViewController.h"
#import "InitViewController.h"

@interface NewSkedCell ()

@end

@implementation NewSkedCell

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction) goBack:(id)sender {
    [self alertOKCancelAction];
}

-(IBAction) done:(id)sender {
    lessonData = lesson.text;
    noteData = note.text;
    
    NSString *userAddLesson = [NSString stringWithFormat:@"%@%@", @"userDataFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    NSString *userAddLessonText = [NSString stringWithFormat:@"%@%@", @"userDataTextFor-", [[NSUserDefaults standardUserDefaults]valueForKey:@"ID"]];
    NSUserDefaults *savedRectangles = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *savedText = [NSUserDefaults standardUserDefaults];
    NSArray *temp = [savedRectangles objectForKey:userAddLesson];
    NSArray *temp2 = [savedText objectForKey:userAddLessonText];
    NSMutableArray *userSkedRects = nil;
    NSMutableArray *userSkedText = nil;
    
    if(temp) {
        userSkedRects = [temp mutableCopy];
    } else {
        userSkedRects = [[NSMutableArray alloc]init];
    }
    
    if(temp2) {
        userSkedText = [temp2 mutableCopy];
    } else {
        userSkedText = [[NSMutableArray alloc]init];
    }
    
    [userSkedRects addObject:NSStringFromCGRect(newRect)];
    [userSkedText addObject:lessonData];
    [savedRectangles setObject:userSkedRects forKey:userAddLesson];
    [savedText setObject:userSkedText forKey:userAddLessonText];
    [savedRectangles synchronize];
    [savedText synchronize];
    
    InitViewController *ini;
    ini = [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
    ini.location = @"Расписание";
    InitViewController *first= [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
    [self presentViewController:first animated:YES completion:nil];
}

- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Создание пары" message:@"Вы уверены, что хотите покинуть меню?" delegate:self cancelButtonTitle:@"Да" otherButtonTitles:@"Нет", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0) {
        //NSLog(@"Да");
        InitViewController *ini;
        ini = [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
        ini.location = @"Расписание";
        InitViewController *first= [self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
        [self presentViewController:first animated:YES completion:nil];
    } else {
        NSLog(@"Нет");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [lesson becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
