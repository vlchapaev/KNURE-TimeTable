//
//  PopoverMenuViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 26.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "PopoverMenuViewController.h"
#import "ItemsTableViewController.h"

@interface PopoverMenuViewController ()

@end

@implementation PopoverMenuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.preferredContentSize = CGSizeMake(400, 230);
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ItemsViewController"];
        controller.itemType = (ItemType)indexPath.row + 1;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
