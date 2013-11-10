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

@interface HistoryList ()
@property (strong, nonatomic) NSMutableArray *historyTable;

@end

@implementation HistoryList
@synthesize menuBtn;
@synthesize historyTable;

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

    historyList = [[NSMutableArray alloc] init];
    /*NSUserDefaults *fullHistory = [NSUserDefaults standardUserDefaults];
    historyList = (NSMutableArray *)[fullHistory objectForKey:@"LastHistory"];*/
    self.historyTable = historyList;
    // Do any additional setup after loading the view.
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
- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
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
    return [historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [historyList objectAtIndex:indexPath.row]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.historyTable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self updateHistoryData];
    }
    /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }*/
}

- (void)updateHistoryData {
    NSUserDefaults *fullHistory = [NSUserDefaults standardUserDefaults];
    [fullHistory setValue:historyList forKeyPath:@"LastHistory"];
    [fullHistory synchronize];
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

- (IBAction)addName:(id)sender {
    @try {
        
        [historyList addObject:self.nameField.text];
        NSString *group = @"КІ-10-4";
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
        NSString* matchAllResult;
        NSString *URL = @"http://cist.kture.kharkov.ua/ias/app/tt/WEB_IAS_TT_AJX_GROUPS?p_id_fac=";
        
        do {
            NSString *request = [NSString stringWithFormat:@"%@%@", URL, [facults objectAtIndex:i]];
            NSString *expression = [NSString stringWithFormat:@"%@%@%@%@", @"\'", group, @"\'", @"+[,]+[0-9]+[0-9]+[0-9]"];
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

        
        
        self.nameField.text = @"Введите вашу группу";
        NSUInteger index;
        NSArray * indexArray;
        index = [historyList count]-1;
        UITableView *tv = (UITableView *)self.view;
        [self.tableView beginUpdates];
        indexArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
        [tv insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        //[self updateHistoryData];
    }
    @catch (NSException * e) {
        UIAlertView *endGameMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введенно неверное название группы" delegate:self cancelButtonTitle:@"Далее" otherButtonTitles: nil];
        [endGameMessage show];
    }
    }
@end
