//
//  SBTwitterViewController.m
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 10/10/2013.
//  Copyright (c) 2013 Stuart Breckenridge. All rights reserved.
//

#import "SBTwitterViewController.h"
#import "SBTwitterFriendsViewController.h"
#import "SBAppDelegate.h"

@interface SBTwitterViewController ()

/**
 UIButton used for selecting the specific Twitter Account that the user wants to use.
 */
@property (nonatomic, weak) IBOutlet UIButton * accountSelector;
@property (nonatomic, weak) SBAppDelegate *appDelegate;

@end

@implementation SBTwitterViewController


#pragma mark - View Loading
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!self.appDelegate) {
        self.appDelegate = [[UIApplication sharedApplication] delegate];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.appDelegate.socialInstance.twitterAccessGranted) {
        self.accountSelector.titleLabel.text = self.appDelegate.socialInstance.twitterAccount.username;
    }
    else{
        [self.appDelegate.socialInstance requestAccessToTwitterAccounts:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.accountSelector.titleLabel.text = self.appDelegate.socialInstance.twitterAccount.username;
            });
        }];
    }
}

#pragma mark - Twitter Posting Methods
- (IBAction)postTextWithSLComposeViewController:(id)sender
{
    [SBSocial postTweetWithText:@"This is a test tweet with text only" andImage:nil fromViewController:self];
}

- (IBAction)postTextAndImageWithSLComposeViewController:(id)sender {
    [SBSocial postTweetWithText:@"This is a test tweet with text and image" andImage:[UIImage imageNamed:@"FlickrImage"] fromViewController:self];
}

- (IBAction)postTextWithSLRequest:(id)sender {
    SBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.socialInstance.delegate = self;
    [appDelegate.socialInstance postSLRequestToTwitterWithText:@"Test Tweet" andImage:nil];
}


- (IBAction)postTextAndImageWithSLRequest:(id)sender {
    SBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.socialInstance.delegate = self;
    [appDelegate.socialInstance postSLRequestToTwitterWithText:@"Test Tweet with image" andImage:[UIImage imageNamed:@"FlickrImage"]];
}

#pragma mark - SBSocialNotifications
-(void)didReceiveSLRequestError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"An error occurred: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    });
}

-(void)didReceiveSuccessfulSLRequestReponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentSuccessAlert];
    });
}

-(void)didReceiveOtherSLRequestResponse:(NSHTTPURLResponse *)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The request received response code %i: %@", response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    });
}

-(void)requestIsInProgress
{
    NSLog(@"Posting is in progress");
};

#pragma mark - UIAlerts
-(void)presentSuccessAlert
{
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The Twitter request was successful." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [success show];
    
    // Memory Management
    success = nil;
}

#pragma mark - Memory Warnings
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end