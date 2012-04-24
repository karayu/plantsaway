//
//  AppDelegate.h
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
