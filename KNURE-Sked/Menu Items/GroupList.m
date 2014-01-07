//
//  HistoryList.m
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Влад. All rights reserved.
//

#import "GroupList.h"
#import "ECSlidingViewController.h"
#import "TabsViewController.h"
#import "Settings.h"
#import "InitViewController.h"

@interface GroupList ()

@property (strong, nonatomic) NSMutableArray *historyTable;

@end

@implementation GroupList
@synthesize menuBtn;
@synthesize historyTable;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *selectedGroups = [[NSMutableArray alloc]init];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedGroups"] != nil) {
        selectedGroups = [[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedGroups"] mutableCopy];
    }
    historyList = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedGroups"] != nil) {
        historyList = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedGroups"] mutableCopy];
    }
    fullList = [[NSMutableArray alloc] init];
    fullList = [[historyList arrayByAddingObjectsFromArray:selectedGroups] mutableCopy];
    
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (id key in dict) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedGroups"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fullList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [fullList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self getGroupId:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) getGroupId:(NSString *)grName {
    @try {
        NSError *error=nil;
        int i=0;
        NSArray *matches;
        NSString *htmlResponseString;
        NSArray *facults = [NSArray arrayWithObjects:@"95",
                            @"114",
                            @"56",
                            @"152",
                            @"192",
                            @"287",
                            @"237",
                            @"2",
                            @"672"
                            @"6",
                            @"2001",
                            @"64",
                            @"128", nil];
        NSString *matchAllResult;
        NSString *URL = @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_AJX_GROUPS?p_id_fac=";
        do {
            NSString *request = [NSString stringWithFormat:@"%@%@", URL, [facults objectAtIndex:i]];
            NSString *expression = [NSString stringWithFormat:@"%@%@%@%@", @"\'", grName, @"\'", @"+[,]+[0-9]+[0-9]+[0-9]"];
            NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:request]];
            htmlResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
            NSRegularExpression *matchAll = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
            matches = [matchAll matchesInString:htmlResponseString
                                        options:0
                                          range:NSMakeRange(0, [htmlResponseString length])];
            i++;
        } while (matches.count == 0);
        
        matchAllResult = [htmlResponseString substringWithRange:[matches[0] range]];
        
        
        NSLog(@"%@",matchAllResult);
        NSRegularExpression *finalMatch = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[0-9]+[0-9]"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:&error];
        NSArray *finalMatchResult = [finalMatch matchesInString:matchAllResult
                                                        options:0
                                                          range:NSMakeRange(0, [matchAllResult length])];
        NSString* result = [matchAllResult substringWithRange:[finalMatchResult[0] range]];
        NSLog(@"%@",result);
        
        NSUserDefaults *fullData = [NSUserDefaults standardUserDefaults];
        [fullData setValue:result forKey:grName];
        [fullData setValue:result forKey:@"ID"];
        [self getGroupUpdate];
        [fullData setValue:grName forKey:@"curName"];
        [fullData synchronize];
    }
    @catch (NSException * e) {
        UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Такая группа не найдена" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles: nil];
        [endGameMessage show];
    }
}

- (void) getGroupUpdate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatterMonth = [[NSDateFormatter alloc] init];
    [dateFormatterMonth setDateFormat:@"MM"];
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"YYYY"];
    NSDateFormatter *dateFormatterDate = [[NSDateFormatter alloc] init];
    [dateFormatterDate setDateFormat:@"dd.MM.YYYY"];
    
    thisMonth = [[dateFormatterMonth stringFromDate:currentDateTime] integerValue];
    thisYear = [[dateFormatterYear stringFromDate:currentDateTime] integerValue];
    nextYear = thisYear + 1;
    previousYear = thisYear - 1;
    NSString *startDate;
    NSString *endDate;
    if (thisMonth>=8 && thisMonth<=12) {
        startDate = [NSString stringWithFormat:@"%@%ld", @"01.09.", (long)thisYear];
        endDate = [NSString stringWithFormat:@"%@%ld", @"02.02.", (long)nextYear];
    } else
        if (thisMonth == 1) {
            startDate = [NSString stringWithFormat:@"%@%ld", @"01.09.", (long)previousYear];
            endDate = [NSString stringWithFormat:@"%@%ld", @"31.07.", (long)thisYear];
        } else {
            startDate = [NSString stringWithFormat:@"%@%ld", @"01.02.", (long)thisYear];
            endDate = [NSString stringWithFormat:@"%@%ld", @"31.07.", (long)thisYear];
        }
    NSMutableArray *dateList = [NSMutableArray array];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    
    NSString *curId = [[NSUserDefaults standardUserDefaults] valueForKey:@"ID"];
    NSString *curRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                            @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_GNR_RASP.GEN_GROUP_POTOK_RASP?ATypeDoc=4&Aid_group=",
                            curId,
                            @"&Aid_potok=0&ADateStart=",
                            startDate,
                            @"&ADateEnd=" ,
                            endDate,
                            @"&AMultiWorkSheet=0"];
    //NSLog(@"%@",curRequest);
    NSError *error = nil;
    NSUserDefaults* fullLessonsData = [NSUserDefaults standardUserDefaults];
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:curRequest]];
    NSString *csvResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
    //NSLog(@"%@", csvResponseString);
    NSString *modifstr = [csvResponseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *modifstr2 = [modifstr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    //NSLog(@"%@%@",@"MODSTR2: ", modifstr2);
    NSRegularExpression *delGRP = [NSRegularExpression regularExpressionWithPattern:@"[А-ЯІЇЄҐ;]+[-]+[0-9]+[-]+[0-9]"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSString *delgrp = [delGRP stringByReplacingMatchesInString:modifstr2
                                                        options:0
                                                          range:NSMakeRange(0, [modifstr2 length])
                                                   withTemplate:@""];
    //NSLog(@"%@%@",@"DELGRP", delgrp);
    NSRegularExpression *delTIME = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[:]+[0-9]+[0-9:0-9]+[0-9]"
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    NSString *deltime = [delTIME stringByReplacingMatchesInString:delgrp
                                                          options:0
                                                            range:NSMakeRange(0, [delgrp length])
                                                     withTemplate:@""];
    NSString *delSpace = [deltime stringByReplacingOccurrencesOfString:@"   " withString:@" "];
    //NSLog(@"%@", delSpace);
    NSRegularExpression *delREST = [NSRegularExpression regularExpressionWithPattern:@"  (.*)"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSString *delRest = [delREST stringByReplacingMatchesInString:delSpace
                                                        options:0
                                                          range:NSMakeRange(0, [delSpace length])
                                                   withTemplate:@""];
    //NSLog(@"%@%@",@"DELSPASE: ", delRest);
    NSDate *currentDate = [[NSDate alloc]init];
    currentDate = [formatter dateFromString:startDate];
    [dateList addObject: currentDate];
    NSDate *endCurrentDate = [[NSDate alloc]init];
    endCurrentDate = [formatter dateFromString:endDate];
    
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    while ( [endCurrentDate compare: currentDate] != NSOrderedAscending) {
        [dateList addObject: currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    }
    NSMutableArray *normalDates = [NSMutableArray array];
    for (int i=0; i<dateList.count; i++) {
        NSString *dates = [NSString stringWithFormat:@"%@%@", [formatter stringForObjectValue:[dateList objectAtIndex:i]], @" "];
        [normalDates addObject:dates];
    }
    
    NSArray *list = [delRest componentsSeparatedByString:@"\r"];
    NSArray *list2 = [list arrayByAddingObjectsFromArray:normalDates];
    
    NSMutableArray *sorted = [[NSMutableArray alloc]init];
    for (NSString *str in list2) {
        if ([str isEqual:@""]) {
            continue;
        }
        NSRange rangeForSpace = [str rangeOfString:@" "];
        NSString *objectStr = [str substringFromIndex:rangeForSpace.location];
        NSString *dateStr = [str substringToIndex:rangeForSpace.location];
        NSDate *date = [formatter dateFromString:dateStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:objectStr, @"object", date, @"date", nil];
        [sorted addObject:dic];
    }
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [sorted sortUsingDescriptors:[NSArray arrayWithObjects:sortDesc, nil]];
    
    [fullLessonsData setObject:sorted forKey: curId];
    [fullLessonsData synchronize];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [fullList removeObjectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    [self.tableView reloadData];
    /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }*/
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)addName:(id)sender {
    [historyList addObject:self.nameField.text];
    self.nameField.text = @"Введите вашу группу";
    NSUInteger index;
    NSArray * indexArray;
    index = [historyList count]-1;
    UITableView *tv = (UITableView *)self.view;
    [self.tableView beginUpdates];
    indexArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
    [tv insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setValue:fullList forKeyPath:@"SavedGroups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
        return YES;
}

@end
