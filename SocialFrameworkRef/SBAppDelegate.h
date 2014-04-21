//
//  SBAppDelegate.h
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 10/10/2013.
//  Copyright (c) 2013 Stuart Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSocial.h"

@interface SBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SBSocial *socialInstance;

@end
