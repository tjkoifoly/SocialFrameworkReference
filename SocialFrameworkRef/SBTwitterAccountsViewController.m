//
//  SBTwitterAccountsViewController.m
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 13/10/2013.
//  Copyright (c) 2013 Stuart Breckenridge. All rights reserved.
//

#import "SBTwitterAccountsViewController.h"
#import "SBAppDelegate.h"
#import "SBTwitterAccountCell.h"
@import Accounts;

@interface SBTwitterAccountsViewController ()

@property (nonatomic, weak) SBAppDelegate *appDelegate;

@end

@implementation SBTwitterAccountsViewController

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
    
    if (!self.appDelegate) {
        self.appDelegate = [[UIApplication sharedApplication] delegate];
    }
    
    [self.appDelegate.socialInstance requestAccessToTwitterAccounts:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)navigateBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 //
                             }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.appDelegate.socialInstance twitterAccounts] count];
}

- (SBTwitterAccountCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SBTwitterAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.screenName.text = nil;
    cell.fullName.text = nil;
    cell.currentlySelected.image = nil;
    
    ACAccount *theAccount = [self.appDelegate.socialInstance.twitterAccounts objectAtIndex:indexPath.row];
    
    cell.screenName.text = theAccount.accountDescription;
    cell.fullName.text = theAccount.username;
    
    if ([cell.screenName.text isEqualToString:self.appDelegate.socialInstance.twitterAccount.accountDescription]) {
        cell.currentlySelected.image = [UIImage imageNamed:@"Thumbs"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.appDelegate.socialInstance changeTwitterAccountToAccountAtIndex:indexPath.row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
}


@end
