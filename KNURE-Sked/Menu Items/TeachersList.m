//
//  TeachersList.m
//  KNURE-Sked
//
//  Created by Влад on 11/10/13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "TeachersList.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"

@interface TeachersList ()
@property (strong, nonatomic) NSMutableArray *teachersTable;

@end

@implementation TeachersList
@synthesize menuBtn;
@synthesize teachersTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    teachersList = [[NSMutableArray alloc] init];
    self.teachersTable = teachersList;
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[TabsViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(13, 30, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [teachersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [teachersList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    @try {
        NSString *teacher = cell.textLabel.text;
        NSError *error = nil;
        NSArray *matches;
        NSString *htmlResponseString;
        int i = 0;
        int j = 0;
        NSArray *facults = [NSArray arrayWithObjects:@"95", @"114", @"56", @"152", @"192", @"287", @"237", @"6", @"64", @"128",nil];
        NSArray *kafedra;
        NSArray *kafedra1 = [NSArray arrayWithObjects:@"97", @"356", @"118", @"136", @"669", nil];
        NSArray *kafedra2 = [NSArray arrayWithObjects:@"19", @"671", @"28", @"18", nil];
        NSArray *kafedra3 = [NSArray arrayWithObjects:@"4", @"57", @"75", @"83", @"1761", nil];
        NSArray *kafedra4 = [NSArray arrayWithObjects:@"191", @"153", @"185", @"154", nil];
        NSArray *kafedra5 = [NSArray arrayWithObjects:@"210", @"193", @"227", @"236", nil];
        NSArray *kafedra6 = [NSArray arrayWithObjects:@"337", @"308", @"338", @"5",nil];
        NSArray *kafedra7 = [NSArray arrayWithObjects:@"238", @"276", @"248", nil];
        NSArray *kafedra8 = [NSArray arrayWithObjects:@"7", @"455", @"96", nil];
        NSArray *kafedra9 = [NSArray arrayWithObjects:@"2002", nil];
        NSArray *kafedra10 = [NSArray arrayWithObjects:@"2000", nil];
        NSString* matchAllResult;
        NSString *URL = @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_AJX_TEACHS?p_id_fac=";
        do {
            if (i == 0) {kafedra = kafedra1;}
            if (i == 1) {kafedra = kafedra2;}
            if (i == 2) {kafedra = kafedra3;}
            if (i == 3) {kafedra = kafedra4;}
            if (i == 4) {kafedra = kafedra5;}
            if (i == 5) {kafedra = kafedra6;}
            if (i == 6) {kafedra = kafedra7;}
            if (i == 7) {kafedra = kafedra8;}
            if (i == 8) {kafedra = kafedra9;}
            if (i == 9) {kafedra = kafedra10;}
            if (j == [kafedra count]){i++; j = 0;}
            NSString *request = [NSString stringWithFormat:@"%@%@&p_id_kaf=%@", URL, [facults objectAtIndex:i], [kafedra objectAtIndex:j]];
            NSString *expression = [NSString stringWithFormat:@"%@%@%@%@%@", @"\'", teacher,@"?[\\S]", @"\'", @"+[,]+(\\d*\\d)"];
            NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:request]];
            htmlResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
            NSRegularExpression *matchAll = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
            matches = [matchAll matchesInString:htmlResponseString
                                        options:0
                                          range:NSMakeRange(0, [htmlResponseString length])];
            j++;
        }while (matches.count == 0);
        matchAllResult = [htmlResponseString substringWithRange:[matches[0] range]];
        NSLog(@"%@",matchAllResult);
        NSRegularExpression *finalMatch = [NSRegularExpression regularExpressionWithPattern:@"\\d*\\d"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:&error];
        NSArray *finalMatchResult = [finalMatch matchesInString:matchAllResult
                                                        options:0
                                                          range:NSMakeRange(0, [matchAllResult length])];
        NSString* result = [matchAllResult substringWithRange:[finalMatchResult[0] range]];
        NSLog(@"%@",result);
        NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
        [fullData setValue:result forKey:@"ID"];
        [self getTeachersUpdate];
        [fullData setValue:teacher forKey:@"curName"];
        [fullData synchronize];
    }
    @catch (NSException * e) {
        UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введенно неверное имя" delegate:self cancelButtonTitle:@"Далее" otherButtonTitles: nil];
        [endGameMessage show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) getTeachersUpdate {
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    NSString *curRequest = [NSString stringWithFormat:@"%@%@%@",@"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_TEACHER_KAF_RASP?ATypeDoc=4&Aid_sotr=", curId, @"&Aid_kaf=0&ADateStart=01.09.2013&ADateEnd=31.01.2014&AMultiWorkSheet=0"];
    NSLog(@"%@",curRequest);
    NSError *error = nil;
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:curRequest]];
    NSString *csvResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    //NSLog(@"%@", csvResponseString);
    NSString *modifstr = [csvResponseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *modifstr2 = [modifstr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    //NSLog(@"%@", modifstr2);
    NSRegularExpression *delGRP = [NSRegularExpression regularExpressionWithPattern:@"[А-ЯІЇЄҐ;]+[-]+[0-9]+[-]+[0-9]"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSString *delgrp = [delGRP stringByReplacingMatchesInString:modifstr2
                                                        options:0
                                                          range:NSMakeRange(0, [modifstr2 length])
                                                   withTemplate:@""];
    NSRegularExpression *delTIME = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[:]+[0-9]+[0-9:0-9]+[0-9]"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSString *deltime = [delTIME stringByReplacingMatchesInString:delgrp
                                                          options:0
                                                            range:NSMakeRange(0, [delgrp length])
                                                     withTemplate:@""];
    NSString *delSpace = [deltime stringByReplacingOccurrencesOfString:@"   " withString:@" "];
    NSArray *list = [delSpace componentsSeparatedByString:@"\r"];
    [fullLessonsData setObject:list forKey: curId];
    [fullLessonsData synchronize];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.teachersTable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   */
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)addTeacher:(id)sender {
    [teachersList addObject:self.teacherField.text];
    self.teacherField.text = @"Введите имя преподавателя";
    NSUInteger indx;
    NSArray * indxArray;
    indx = [teachersList count]-1;
    UITableView *tabv = (UITableView *)self.view;
    
    [self.tableView beginUpdates];
    indxArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indx inSection:0]];
    [tabv insertRowsAtIndexPaths:indxArray withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}
@end
