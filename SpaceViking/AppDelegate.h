//
//  AppDelegate.h
//  SpaceViking
//
//  Created by Mike Pattee on 8/19/11.
//  Copyright Cordax Software LLC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
