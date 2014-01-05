//
//  TeacherListAddTeacher.m
//  KNURE-Sked
//
//  Created by Влад on 1/5/14.
//  Copyright (c) 2014 Влад. All rights reserved.
//

#import "TeacherListAddTeacher.h"

@interface TeacherListAddTeacher ()

@end

@implementation TeacherListAddTeacher

@synthesize teacherSearchBar;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allResults = [[NSMutableArray alloc] init];
    selectedTeachers = [[NSMutableArray alloc]init];
    [self getNameOfTeachers];
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

- (void) getNameOfTeachers{
    @try {
        
        NSString *matchAllResult;
        NSString *htmlResponseString;
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
        
        NSString *URL = @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_AJX_TEACHS?p_id_fac=";
        for (int count = 0; count != facults.count; count++)
        {
            if (count == 0) {kafedra = kafedra1;}
            if (count == 1) {kafedra = kafedra2;}
            if (count == 2) {kafedra = kafedra3;}
            if (count == 3) {kafedra = kafedra4;}
            if (count == 4) {kafedra = kafedra5;}
            if (count == 5) {kafedra = kafedra6;}
            if (count == 6) {kafedra = kafedra7;}
            if (count == 7) {kafedra = kafedra8;}
            if (count == 8) {kafedra = kafedra9;}
            if (count == 9) {kafedra = kafedra10;}
            
            for (int kafcount = 0; kafcount != kafedra.count; kafcount++) {
                NSArray *matches;
                
                NSString *request = [NSString stringWithFormat:@"%@%@&p_id_kaf=%@", URL, [facults objectAtIndex:count], [kafedra objectAtIndex:kafcount]];
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
    }
    @catch (NSException * e) {
        UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles: nil];
        [endGameMessage show];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        isFiltred = NO;
    } else {
        isFiltred = YES;
        searchResults = [[NSMutableArray alloc]init];
        for(NSString *teacher in allResults) {
            NSRange teacherNameRange = [teacher rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(teacherNameRange.location != NSNotFound) {
                [searchResults addObject:teacher];
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
    [selectedTeachers addObject:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:selectedTeachers forKey:@"selectedTeachers"];
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
