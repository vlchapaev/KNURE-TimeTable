//
//  GroupListAddGroup.m
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "GroupListAddGroup.h"

@interface GroupListAddGroup ()

@end

@implementation GroupListAddGroup

@synthesize groupSearchBar;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allResults = [[NSMutableArray alloc]init];
    selectedGroups = [[NSMutableArray alloc]init];
    [self getNameOfGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (isFiltred==YES)?searchResults.count:allResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [allResults objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if(isFiltred == YES) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [allResults objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void) getNameOfGroup{
    @try {
        NSString *matchAllResult;
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
        NSString *URL = @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_AJX_GROUPS?p_id_fac=";
        for (int count = 0; count != facults.count; count++)
        {
            NSArray *matches;
            
            NSString *request = [NSString stringWithFormat:@"%@%@", URL, [facults objectAtIndex:count]];
            NSString *expression = [NSString stringWithFormat:@"[']+.+[']"];
            
            NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:request]];
            htmlResponseString = [[NSString alloc] initWithData:responseData encoding:NSWindowsCP1251StringEncoding];
            NSRegularExpression *matchAll = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
            matches = [matchAll matchesInString:htmlResponseString
                                        options:0
                                          range:NSMakeRange(0, [htmlResponseString length])];
            
            for (int i = 0; i != matches.count; i++) {
                matchAllResult = [htmlResponseString substringWithRange:[matches[i] range]];
                matchAllResult = [matchAllResult substringWithRange:NSMakeRange(1, [matchAllResult length]-1)];
                matchAllResult = [matchAllResult substringToIndex:[matchAllResult length] - 1];
                [allResults addObject:matchAllResult];
            }
        }
    }
    @catch (NSException * e) {
        UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удаеться загрузить спиcок групп, проверте ваще подключение к интеренету" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles: nil];
        [endGameMessage show];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        isFiltred = NO;
    } else {
        isFiltred = YES;
        searchResults = [[NSMutableArray alloc]init];
        for(NSString *group in allResults) {
            NSRange groupNameRange = [group rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(groupNameRange.location != NSNotFound) {
                [searchResults addObject:group];
            }
        }
    }
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedGroups addObject:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroups forKey:@"selectedGroups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

@end
