//
//  AuditoryList.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 23.01.15.
//  Copyright (c) 2015 Влад. All rights reserved.
//

#import "AuditoryList.h"
#import "InitViewController.h"
#import "EventHandler.h"

@implementation AuditoryList

@synthesize menuButton;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    auditoryList = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedAuditories"] mutableCopy];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSUserDefaults standardUserDefaults] setValue:auditoryList forKey:@"SavedAuditories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - методы table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return auditoryList.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *auditoryID = [[auditoryList objectAtIndex:indexPath.row]valueForKey:@"key"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:auditoryID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [auditoryList removeObjectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 30, 30);
    cell.accessoryView = spinner;
    cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 10.0f];
    cell.textLabel.text = [[auditoryList objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [[auditoryList objectAtIndex:indexPath.row] valueForKey:@"updated"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 30, 30);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = spinner;
    [spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:
                              [NSString stringWithFormat:@"http://cist.nure.ua/ias/app/tt/P_API_EVENT_JSON?timetable_id=%@&type_id=3",
                               [[auditoryList objectAtIndex:indexPath.row]valueForKey:@"key"]]]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if(!data) {
                                   UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ошибка"
                                                                                      message:@"Не удалось получить ответ от сервера"
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"Понятно"
                                                                            otherButtonTitles:nil,
                                                             nil];
                                   [spinner stopAnimating];
                                   [alertView show];
                                   return;
                               }
                               
                               NSData *encData = [[EventHandler alloc]alignEncoding:data];
                               NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:encData options:0 error:&error];
                               
                               NSString *auditoryID = [[auditoryList objectAtIndex:indexPath.row]valueForKey:@"key"];
                               [[NSUserDefaults standardUserDefaults] setObject:parsedData forKey:auditoryID];
                               [[NSUserDefaults standardUserDefaults] setValue:[[auditoryList objectAtIndex:indexPath.row] valueForKey:@"key"] forKey:@"ID"];
                               [[NSUserDefaults standardUserDefaults] setValue:[[auditoryList objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"curName"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               
                               NSDate *currDate = [NSDate date];
                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                               [dateFormatter setDateFormat:@"dd.MM.YY"];
                               NSString *dateString = [dateFormatter stringFromDate:currDate];
                               cell.detailTextLabel.text = [NSString stringWithFormat:@"Обновлено: %@", dateString];
                               
                               NSMutableDictionary *temp = [[auditoryList objectAtIndex:indexPath.row]mutableCopy];
                               [temp setValue:cell.detailTextLabel.text forKey:@"updated"];
                               [auditoryList replaceObjectAtIndex:indexPath.row withObject:temp];
                               
                               [spinner stopAnimating];
                               [spinner removeFromSuperview];
                           }
    ];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
