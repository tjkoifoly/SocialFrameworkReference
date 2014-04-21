//
//  SBFacebookViewController.m
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 10/10/2013.
//  Copyright (c) 2013 Stuart Breckenridge. All rights reserved.
//

#import "SBFacebookViewController.h"
#import "MBProgressHUD.h"
#import "SBAppDelegate.h"

@interface SBFacebookViewController ()

@property (nonatomic, weak) SBAppDelegate *appDelegate;
@property (nonatomic, weak) IBOutlet UILabel * accountName;

@end

@implementation SBFacebookViewController

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
    [self.appDelegate.socialInstance requestReadAccessToFacebookAccount:^{
        [self updateAccountName];
    }];
}

-(void)updateAccountName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.accountName.text = self.appDelegate.socialInstance.facebookAccount.userFullName;
    });
}

#pragma mark - Facebook - SLComposeViewController
-(IBAction)postTextWithSLComposeViewController
{
    [SBSocial postFBMessageWithText:@"This is test post with text only." andImage:nil fromViewController:self];
}

#pragma mark - Method 1 - Post Text and Image with SLComposeViewController
-(IBAction)postTextAndImageWithSLComposeViewController
{
    [SBSocial postFBMessageWithText:@"This is a test post with text and an image." andImage:[UIImage imageNamed:@"FlickrImage"] fromViewController:self];
}

-(IBAction)updateWallWithSLRequest
{
    SBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.socialInstance.delegate = self;
    [appDelegate.socialInstance postSLRequestToFacebookAtURL:[NSURL URLWithString:@"https://graph.facebook.com/me/feed"]
                                                    withLink:@"https://github.com/Stuart Breckenridge/SocialFrameworkReference"
                                                 withMessage:@"Testing Social Framework Reference for iOS 7"
                                                 withPicture:@"http://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/150px-Apple_logo_black.svg.png"
                                                    withName:@"Social Framework"
                                                 withCaption:@"GitHub"
                                              andDescription:@"The Social framework lets you integrate your app with supported social networking services. On iOS and OS X, this framework provides a template for creating HTTP requests. On iOS only, the Social framework provides a generalized interface for posting requests on behalf of the user."];
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
        [self showAlertViewWithString:@"Successfully posted."];
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

-(void)showAlertViewWithString:(NSString *)string
{
    //main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posted" message:[NSString stringWithFormat:@"%@", string] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
