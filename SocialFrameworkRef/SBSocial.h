//
//  SBSocial.h
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 18/04/2014.
//  Copyright (c) 2014 TheWorkingBear. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Social;
@import Accounts;


#pragma mark - SBSocialNotifications Protocol Reference
@protocol SBSocialNotifications <NSObject>

@optional
// SLRequest Progress
-(void)requestIsInProgress;
-(void)requestIsComplete;

// SLRequest Post Response
-(void)didReceiveSuccessfulSLRequestReponse;
-(void)didReceiveOtherSLRequestResponse:(NSHTTPURLResponse *)response;

// Optional Error Handling
-(void)didReceiveErrorForFacebookAccountAccess:(NSError *)error;
-(void)didReceiveErrorForTwitterAccountAccess:(NSError *)error;
-(void)didReceiveSLRequestError:(NSError *)error;

@end


@interface SBSocial : NSObject

@property (nonatomic, assign) id<SBSocialNotifications>delegate;

#pragma mark - Public Properties Related to Twitter
/**
 The selected twitter account of the user. The default is the first account in the array of accounts; however, this can be changed either in code or by the user using the changeTwitterAccountToAccountAtIndex:(int)i method.
 */
@property (readonly, nonatomic) ACAccount *twitterAccount;

/**
 An array of the user's Twitter accounts setup in the settings app.
 */
@property (readonly, nonatomic) NSArray *twitterAccounts;

/**
 Boolean letting other classes know if Twitter access has been granted.
 */
@property (readonly, nonatomic, assign) __block BOOL twitterAccessGranted;

#pragma mark - Public Properties Related to Facebook
/**
 The Facebook account of the user. Unlike Twitter, there is only one Facebook account.
 */
@property (readonly, nonatomic) ACAccount *facebookAccount;

/**
 Boolean specifying if the user has given the appilcation permission to read from the user's Facebook account.
 */
@property (readonly, nonatomic, assign) __block BOOL readAccessGranted;

/**
 Boolean specifying if the user has given the appilcation permission to write to the user's Facebook wall.
 */
@property (readonly, nonatomic, assign) __block BOOL writeAccessGranted;


#pragma mark - SLComposeViewController Convenience Methods
/**
 *  This will instantiate an SLComposeViewController for Twitter and attach both a string and image.
 *
 *  @param string Tweet text. Can be nil.
 *  @param image  Image to attach. Can be nil.
 *  @param controller The controller from which the Tweet sheet should be presented. Usually self.
 */
+(void)postTweetWithText:(NSString *)string
                andImage:(UIImage *)image
      fromViewController:(UIViewController *)controller;

/**
 *  This will instantiate an SLComposeViewController for Facebook and attach both a string and image.
 *
 *  @param string Message text. Can be nil.
 *  @param image  Image to attach. Can be nil.
 *  @param controller The controller from which the post sheet should be presented. Usually self.
 */
+(void)postFBMessageWithText:(NSString *)string
                    andImage:(UIImage *)image
          fromViewController:(UIViewController *)controller;

#pragma mark - SLRequest Methods - Twitter
/**
 *  This will post a tweet to twitter using SLRequest.
 *
 *  @param text  Tweet text.
 *  @param image Tweet image.
 */
- (void)postSLRequestToTwitterWithText:(NSString *)text andImage:(UIImage *)image;

/**
 This will change the currently active Twitter account for SLRequest methods.
 @param i An integer that relates to the index of the selected account in the account array within the settings app.
 */
- (void)changeTwitterAccountToAccountAtIndex:(long)i;

- (void)requestAccessToTwitterAccounts:(void (^)(void))completion;

#pragma mark - SLRequest Methods - Facebook
/**
 *  This will post a message to the signed in user's feed.
 *
 *  @param url         The Facebook endpoint to which the URL should be posted.
 *  @param link        The link component of the message.
 *  @param message     The text component of the message.
 *  @param picture     The image component of the message - passed as URL.
 *  @param name        The name/title component of the message.
 *  @param caption     The caption component of the message.
 *  @param description The description of the message.
 *  @see http://f.cl.ly/items/0h0W1g011B2g0m2K1j0p/FB_Message.png
 */
- (void)postSLRequestToFacebookAtURL:(NSURL *)url withLink:(NSString *)link withMessage:(NSString *)message withPicture:(NSString *)picture withName:(NSString *)name withCaption:(NSString *)caption andDescription:(NSString *)description;

- (void)requestReadAccessToFacebookAccount:(void (^)(void))completion;







@end
