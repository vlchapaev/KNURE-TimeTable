//
//  AddAuditory.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 23.01.15.
//  Copyright (c) 2015 Shogunate. All rights reserved.
//

#import "AddAuditory.h"
#import "AuditoryList.h"
#import "EventHandler.h"

@implementation AddAuditory

#pragma mark - view

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    shoudOffPanGesture = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setValue:auditoryList forKeyPath:@"SavedAuditories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    allResults = [[NSMutableArray alloc]init];
    selectedAuditory = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedAuditories"] != nil) {
        selectedAuditory = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedAuditories"] mutableCopy];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Загружаю список...";
    [self getAuditoryList];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    shoudOffPanGesture = NO;
    [[NSUserDefaults standardUserDefaults] setValue:selectedAuditory forKey:@"SavedAuditories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - logic

- (void)getAuditoryList {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://cist.nure.ua/ias/app/tt/P_API_AUDITORIES_JSON"]];
    [HUD show:YES];
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
                                   [HUD hide:YES];
                                   [alertView show];
                                   return;
                               }
                               NSData *encData = [[EventHandler alloc]alignEncoding:data];
                               NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:encData options:0 error:&error];
                               allResults = [self getKeysAndTitles:parsedData];
                               [self.tableViewAuditories reloadData];
                               [HUD hide:YES];
                           }
     ];
}

- (NSMutableArray *)getKeysAndTitles:(NSDictionary *)source {
    NSMutableArray *groupsAndKeys = [[NSMutableArray alloc] init];
    NSString *updated = @"Не обновлено";
    NSArray *buildings = [[source valueForKey:@"university"] valueForKey:@"buildings"];
    for(NSDictionary *building in buildings) {
        for (NSDictionary *auditory in [building valueForKey:@"auditories"]) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [auditory valueForKey:@"short_name"], @"title",
                                        [auditory valueForKey:@"id"], @"key",
                                        updated, @"updated", nil];
            [groupsAndKeys addObject:dictionary];
            
        }
    }
    
    return groupsAndKeys;
}

- (int)getIndexOfString:(NSString *)text inArray:(NSMutableArray *)array {
    for (int i = 0; i < array.count; i++) {
        if ([[array objectAtIndex:i] containsObject:text]) {
            return i;
        }
    }
    return 0;
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        isFiltred = NO;
    } else {
        isFiltred = YES;
        searchResults = [[NSMutableArray alloc]init];
        for(NSString *auditory in [allResults valueForKey:@"title"]) {
            NSRange auditoryNameRange = [auditory rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(auditoryNameRange.location != NSNotFound) {
                [searchResults addObject:auditory];
            }
        }
    }
    [self.tableViewAuditories reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (isFiltred)?searchResults.count:allResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [allResults objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = (isFiltred)?[searchResults objectAtIndex:indexPath.row]:[[allResults objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.detailTextLabel.text = ([[selectedAuditory valueForKey:@"title"] containsObject:cell.textLabel.text])? @"добавлено" : @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![[selectedAuditory valueForKey:@"title"] containsObject:cell.textLabel.text]) {
        [selectedAuditory addObject:[allResults objectAtIndex:[self getIndexOfString:cell.textLabel.text inArray:allResults]]];
    }
    cell.detailTextLabel.text = @"добавлено";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
