//
//  AppDelegate.h
//  MaskedCal
//
//  Created by Ray Wenderlich on 7/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
