//
//  SBSocial.m
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 18/04/2014.
//  Copyright (c) 2014 TheWorkingBear. All rights reserved.
//

#import "SBSocial.h"

static const NSString *facebookAppID = @"409117739136575";

@interface SBSocial ()

@property (nonatomic, strong) ACAccountStore *facebookAccountStore;

@end

@implementation SBSocial

#pragma mark - SLComposeViewController Convenience Methods
+ (void)postTweetWithText:(NSString *)string andImage:(UIImage *)image fromViewController:(UIViewController *)controller
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetController setInitialText:string];
        [tweetController addImage:image];
        
        [controller presentViewController:tweetController animated:YES completion:^{
            //
        }];
        
        controller = nil;
        tweetController = nil;
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Twitter Service Type Not Available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

+ (void)postFBMessageWithText:(NSString *)string andImage:(UIImage *)image fromViewController:(UIViewController *)controller
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbController setInitialText:string];
        [fbController addImage:image];
        
        [controller presentViewController:fbController animated:YES completion:^{
            //
        }];
        
        controller = nil;
        fbController = nil;
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook Service Type Not Available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (void)postSLRequestToTwitterWithText:(NSString *)text andImage:(UIImage *)image
{
    if (_twitterAccessGranted) {
        SLRequest *postTweetToTwitter = ({
            // Set the Twitter URL endpoint
            NSMutableString *url = [NSMutableString new];
            
            if (image) {
                [url appendString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
            } else{
                [url appendString:@"https://api.twitter.com/1.1/statuses/update.json"];
            }
            
            NSURL *twitterPostURL = [[NSURL alloc] initWithString:url];
            
            // Set the tweet message
            NSDictionary *tweetDetails = @{@"status": text};
            
            // Create the Request
            postTweetToTwitter = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:twitterPostURL
                                                       parameters:tweetDetails];
            
            // Add the image to the Tweet
            if (image) {
                NSData *data = UIImageJPEGRepresentation(image, 0.5f);
                [postTweetToTwitter addMultipartData:data
                                            withName:@"media[]"
                                                type:@"image/jpeg"
                                            filename:@"image.jpg"];
            }
            
            // Set the Twitter account to use.
            [postTweetToTwitter setAccount:_twitterAccount];
            NSLog(@"%@", _twitterAccount.username);
            
            // Perform the request
            [postTweetToTwitter performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
             {
                 // Inform delegate that request is in progress
                 if ([self.delegate respondsToSelector:@selector(requestIsInProgress)]) {
                     [self.delegate requestIsInProgress];
                 }
                 
                 if ([urlResponse statusCode] == 200) {
                     if ([self.delegate respondsToSelector:@selector(didReceiveSuccessfulSLRequestReponse)]) {
                         [self.delegate didReceiveSuccessfulSLRequestReponse];
                     }
                     
                     // Inform delegate that request is complete
                     if ([self.delegate respondsToSelector:@selector(requestIsComplete)]) {
                         [self.delegate requestIsComplete];
                     }
                 }
                 
                 if ([urlResponse statusCode] != 200) {
                     if ([self.delegate respondsToSelector:@selector(didReceiveOtherSLRequestResponse:)]) {
                         [self.delegate didReceiveOtherSLRequestResponse:urlResponse];
                     }
                     
                     // Inform delegate that request is complete
                     if ([self.delegate respondsToSelector:@selector(requestIsComplete)]) {
                         [self.delegate requestIsComplete];
                     }
                 }
                 
                 if (error) {
                     if ([self.delegate respondsToSelector:@selector(didReceiveSLRequestError:)]) {
                         [self.delegate didReceiveSLRequestError:error];
                     }
                     
                     // Inform delegate that request is complete
                     if ([self.delegate respondsToSelector:@selector(requestIsComplete)]) {
                         [self.delegate requestIsComplete];
                     }
                 }
             }];
            
            postTweetToTwitter;
        });
        
        // Memory Management
        postTweetToTwitter = nil;
    }
    
    else
    {
        [self requestAccessToTwitterAccounts:^{
            SLRequest *postTweetToTwitter = ({
                // Set the Twitter URL endpoint
                NSMutableString *url = [NSMutableString new];
                
                if (image) {
                    [url appendString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
                } else{
                    [url appendString:@"https://api.twitter.com/1.1/statuses/update.json"];
                }
                
                NSURL *twitterPostURL = [[NSURL alloc] initWithString:url];
                
                // Set the tweet message
                NSDictionary *tweetDetails = @{@"status": text};
                
                // Create the Request
                postTweetToTwitter = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:twitterPostURL
                                                           parameters:tweetDetails];
                
                // Add the image to the Tweet
                if (image) {
                    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
                    [postTweetToTwitter addMultipartData:data
                                                withName:@"media[]"
                                                    type:@"image/jpeg"
                                                filename:@"image.jpg"];
                }
                
                // Set the Twitter account to use.
                postTweetToTwitter.account = self.twitterAccount;
                NSLog(@"%@", _twitterAccount.username);
                
                // Perform the request
                [postTweetToTwitter performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     // Inform delegate that request is in progress
                     if ([self.delegate respondsToSelector:@selector(requestIsInProgress)]) {
                         [self.delegate requestIsInProgress];
                     }
                     
                     if ([urlResponse statusCode] == 200) {
                         if ([self.delegate respondsToSelector:@selector(didReceiveSuccessfulSLRequestReponse)]) {
                             [self.delegate didReceiveSuccessfulSLRequestReponse];
                         }
                     }
                     
                     if ([urlResponse statusCode] != 200) {
                         if ([self.delegate respondsToSelector:@selector(didReceiveOtherSLRequestResponse:)]) {
                             [self.delegate didReceiveOtherSLRequestResponse:urlResponse];
                         }
                     }
                     
                     if (error) {
                         if ([self.delegate respondsToSelector:@selector(didReceiveSLRequestError:)]) {
                             [self.delegate didReceiveSLRequestError:error];
                         }
                     }
                 }];
                postTweetToTwitter;
            });
        }];
    }
}

- (void)postSLRequestToFacebookAtURL:(NSURL *)url
                            withLink:(NSString *)link
                         withMessage:(NSString *)message
                         withPicture:(NSString *)picture
                            withName:(NSString *)name
                         withCaption:(NSString *)caption
                      andDescription:(NSString *)description
{
    // Inform delegate that request is in progress
    if ([self.delegate respondsToSelector:@selector(requestIsInProgress)]) {
        [self.delegate requestIsInProgress];
    }
    
    [self requestReadAccessToFacebookAccount:^{
        [self requestWriteAccessToFacebook:^{
            SLRequest *postToMyWall = ({
                
                // Create a dictionary of post elements
                NSDictionary *postDict = @{
                                           @"link": link,
                                           @"message" : message,
                                           @"picture" : picture,
                                           @"name" : name,
                                           @"caption" : caption,
                                           @"description" : description
                                           };
                
                postToMyWall = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                  requestMethod:SLRequestMethodPOST
                                                            URL:url
                                                     parameters:postDict];
                
                // Set the account
                postToMyWall.account = self.facebookAccount;
                
                [postToMyWall performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    // Check for errors, output in alertview
                    NSLog(@"Status Code: %li", (long)[urlResponse statusCode]);
                    NSLog(@"Response Data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                    
                    if (error)
                    {
                        NSLog(@"Error message: %@", [error localizedDescription]);
                        if ([self.delegate respondsToSelector:@selector(didReceiveSLRequestError:)]) {
                            [self.delegate didReceiveSLRequestError:error];
                        }
                    }
                    
                    if ([urlResponse statusCode] == 200) {
                        if ([self.delegate respondsToSelector:@selector(didReceiveSuccessfulSLRequestReponse)]) {
                            [self.delegate didReceiveSuccessfulSLRequestReponse];
                        }
                    }
                    
                    if ([urlResponse statusCode] != 200) {
                        if ([self.delegate respondsToSelector:@selector(didReceiveOtherSLRequestResponse:)]) {
                            [self.delegate didReceiveOtherSLRequestResponse:urlResponse];
                        }
                        
                        if (urlResponse.statusCode == 400) {
                            [self renewFacebookCredentials];
                        }
                    }
                }];
                postToMyWall;
            });
        }];
    }];
}

#pragma mark - Twitter Account Access Request
/**
 *  This method is used when Twitter access has not been granted, but the user wishes to post. It will call the completion handler if Twitter access is granted.
 *
 *  @param completion Posts to twitter if twitter access is granted.
 */
- (void)requestAccessToTwitterAccounts:(void (^)(void))completion
{
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    // Create an account type
    ACAccountType *twitterAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         // If access is granted:
         if (granted)
         {
             // Specify the twitter account to use
             _twitterAccount = [[ACAccount alloc] initWithAccountType:twitterAccountType];
             _twitterAccounts = [twitter accountsWithAccountType:twitterAccountType];
             
             if ([_twitterAccounts count] == 0) {
                 NSLog(@"There are no Twitter accounts.");
             } else{
                 _twitterAccount = [_twitterAccounts firstObject];
                 
                 // If you wish to see the username of the account being used uncomment out the next line of code
                 
                 //NSLog(@"Username: %@", _twitterAccount.username);
                 _twitterAccessGranted = YES;
             }
             
             completion();
         }
         
         // If permission is not granted to use the Twitter account:
         else
         {
             _twitterAccessGranted = NO;
         }
         
         if (error) {
             if ([self.delegate respondsToSelector:@selector(didReceiveErrorForTwitterAccountAccess:)]) {
                 [self.delegate didReceiveErrorForTwitterAccountAccess:error];
             }
         }
     }];
}

- (void)changeTwitterAccountToAccountAtIndex:(long)i
{
    _twitterAccount = [_twitterAccounts objectAtIndex:i];
}

#pragma mark - Facebook Account Access Request
- (void)requestReadAccessToFacebookAccount:(void (^)(void))completion
{
    if (!_readAccessGranted)
    {
        // Specify the permissions required
        NSArray *permissions = @[@"read_stream", @"email"];
        
        // Specify the audience
        NSDictionary *facebookOptions = [NSDictionary new];
        facebookOptions = @{ACFacebookAppIdKey : facebookAppID,
                            ACFacebookAudienceKey :  ACFacebookAudienceFriends,
                            ACFacebookPermissionsKey : permissions};
        
        // Create an Account Store
        _facebookAccountStore = [[ACAccountStore alloc] init];
        
        
        // Specify the Account Type
        ACAccountType *accountType = [_facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        if (!accountType.accessGranted) {
            _readAccessGranted = NO;
            _writeAccessGranted = NO;
        }
        
        // Perform the permission request
        [_facebookAccountStore requestAccessToAccountsWithType:accountType options:facebookOptions completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                _readAccessGranted = YES;

                NSArray *array = [_facebookAccountStore accountsWithAccountType:accountType];
                _facebookAccount = [array lastObject];
                
                // If access is granted, call the completion handler.
                if (completion == nil) {
                    //
                } else
                {
                    completion();
                }
            }
            if (error) {
                if (error.code == 6) {
                    NSLog(@"Error: There is no Facebook account setup.");
                } else
                {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            }
        }];
    }
}

- (void)requestWriteAccessToFacebook:(void (^)(void))completion
{
    // Publish permissions will only be requested if read access has been granted, otherwise an alert will be generated.
    if (_readAccessGranted)
    {
        // Specify the permissions required
        NSArray *permissions = @[@"publish_stream"];
        
        // Specify the audience
        NSDictionary *facebookOptions = [NSDictionary new];
        facebookOptions = @{ACFacebookAppIdKey : facebookAppID,
                            ACFacebookAudienceKey :  ACFacebookAudienceFriends,
                            ACFacebookPermissionsKey : permissions};
        
        // Specify the Account Type
        ACAccountType *accountType = [_facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        if (!accountType.accessGranted) {
            _readAccessGranted = NO;
            _writeAccessGranted = NO;
        }
        
        // Perform the permission request
        [_facebookAccountStore requestAccessToAccountsWithType:accountType options:facebookOptions completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                _writeAccessGranted = YES;
                NSArray *array = [_facebookAccountStore accountsWithAccountType:accountType];
                _facebookAccount = [array lastObject];
                
                NSLog(@"Write permissions granted.");
                
                completion();
            }
            
            if (error) {
                if (error.code == 6) {
                    NSLog(@"Error: There is no Facebook account setup.");
                } else
                {
                    
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
            }
        }];
    }
    
    else
    {
        UIAlertView *readPermission = [[UIAlertView alloc] initWithTitle:@"Permissions Required" message:@"Read permissions are required before requesting publish permissions." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [readPermission show];
        readPermission = nil;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReadAccessGranted"
     object:nil];
}

-(void)renewFacebookCredentials
{
    [_facebookAccountStore renewCredentialsForAccount:_facebookAccount
                                           completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                                               if (error) {
                                                   NSLog(@"Error Renewing Credentials:%@", [error localizedDescription]);
                                               } else{
                                                   [self requestReadAccessToFacebookAccount:^{
                                                       [self requestWriteAccessToFacebook:nil];
                                                   }];
                                               }
                                               
                                               NSLog(@"ACAccountCredentialRenewResult: %ld", (long)renewResult);
                                           }];
}




@end
