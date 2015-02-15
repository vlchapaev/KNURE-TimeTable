//
//  GroupListAddGroup.m
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "AddGroup.h"
#import "GroupList.h"
#import "EventHandler.h"

@interface AddGroup ()

@end

@implementation AddGroup

@synthesize groupSearchBar, tableViewGroups;

#pragma mark - view

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    shoudOffPanGesture = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setValue:groupList forKeyPath:@"SavedGroups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    allResults = [[NSMutableArray alloc]init];
    selectedGroups = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedGroups"] != nil) {
        selectedGroups = [[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"SavedGroups"] mutableCopy];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Загружаю список...";
    [self getGroupsList];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    shoudOffPanGesture = NO;
    [[NSUserDefaults standardUserDefaults] setValue:selectedGroups forKey:@"SavedGroups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - logic

- (void)getGroupsList {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://cist.kture.kharkov.ua/ias/app/tt/P_API_GROUP_JSON"]];
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
                               [self.tableViewGroups reloadData];
                               [HUD hide:YES];
                           }
     ];
}

- (NSMutableArray *)getKeysAndTitles:(NSDictionary *)source {
    NSMutableArray *groupsAndKeys = [[NSMutableArray alloc] init];
    NSString *updated = @"Не обновлено";
    NSArray *facultList = [[source valueForKey:@"university"] valueForKey:@"faculties"];
    for(NSDictionary *facult in facultList) {
        for(NSDictionary *direction in [facult valueForKey:@"directions"]) {
            for(NSDictionary *group in [direction valueForKey:@"groups"]) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [group valueForKey:@"name"], @"title",
                                                [[group valueForKey:@"id"] stringValue], @"key",
                                                updated, @"updated", nil];
                [groupsAndKeys addObject:dictionary];
            }
            
            for(NSDictionary *speciality in [direction valueForKey:@"specialities"]) {
                for(NSDictionary *group in [speciality valueForKey:@"groups"]) {
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [group valueForKey:@"name"], @"title",
                                                    [[group valueForKey:@"id"] stringValue], @"key",
                                                    updated, @"updated", nil];
                    [groupsAndKeys addObject:dictionary];
                }
            }
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
        for(NSString *group in [allResults valueForKey:@"title"]) {
            NSString *groupCorrect = [searchText stringByReplacingOccurrencesOfString:@"и" withString:@"і"];
            NSRange groupNameRange = [group rangeOfString:groupCorrect options:NSCaseInsensitiveSearch];
            if(groupNameRange.location != NSNotFound) {
                [searchResults addObject:group];
            }
        }
    }
    [self.tableViewGroups reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
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
    cell.detailTextLabel.text = ([[selectedGroups valueForKey:@"title"] containsObject:cell.textLabel.text])? @"добавлено" : @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![[selectedGroups valueForKey:@"title"] containsObject:cell.textLabel.text]) {
        [selectedGroups addObject:[allResults objectAtIndex:[self getIndexOfString:cell.textLabel.text inArray:allResults]]];
    }
    cell.detailTextLabel.text = @"добавлено";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
