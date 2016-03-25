//
//  GroupList.m
//  KNURE-Sked
//
//  Created by Oksana Kubiria on 08.11.13.
//  Copyright (c) 2013 Shogunate. All rights reserved.
//

#import "ItemsTableView.h"
#import "InitViewController.h"
#import "EventHandler.h"
#import "ItemTableViewCell.h"

@implementation ItemsTableView

#pragma mark - ViewController lificycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsCell" bundle:nil] forCellReuseIdentifier:@"SelectedItems"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    groupList = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SavedGroups"] mutableCopy];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSUserDefaults standardUserDefaults] setValue:groupList forKey:@"SavedGroups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc]init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Interface_Error", @"")
                                                   message:[error localizedDescription]
                                                  delegate:self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groupList.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupID = [[groupList objectAtIndex:indexPath.row]valueForKey:@"key"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:groupID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [groupList removeObjectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
    NSString *CellIdentifier = @"SelectedItems";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 30, 30);
    cell.accessoryView = spinner;
    cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 10.0f];
    cell.textLabel.text = [[groupList objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [[groupList objectAtIndex:indexPath.row] valueForKey:@"updated"];
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
                [NSString stringWithFormat:@"http://cist.nure.ua/ias/app/tt/P_API_EVENT_JSON?timetable_id=%@",
                [[groupList objectAtIndex:indexPath.row]valueForKey:@"key"]]]];
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
                                
                               NSString *groupID = [[groupList objectAtIndex:indexPath.row]valueForKey:@"key"];
                               [[NSUserDefaults standardUserDefaults] setObject:parsedData forKey:groupID];
                               [[NSUserDefaults standardUserDefaults] setValue:[[groupList objectAtIndex:indexPath.row] valueForKey:@"key"] forKey:@"ID"];
                               [[NSUserDefaults standardUserDefaults] setValue:[[groupList objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"curName"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                                
                               NSDate *currDate = [NSDate date];
                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                               [dateFormatter setDateFormat:@"dd.MM.YY"];
                               NSString *dateString = [dateFormatter stringFromDate:currDate];
                               cell.detailTextLabel.text = [NSString stringWithFormat:@"Обновлено: %@", dateString];
                                
                               NSMutableDictionary *temp = [[groupList objectAtIndex:indexPath.row]mutableCopy];
                               [temp setValue:cell.detailTextLabel.text forKey:@"updated"];
                               [groupList replaceObjectAtIndex:indexPath.row withObject:temp];
                                
                               [spinner stopAnimating];
                               [spinner removeFromSuperview];
                           }
    ];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
