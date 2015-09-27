//
//  MainMenuViewController.h
//  MaskedCal
//
//  Created by Ray Wenderlich on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "AboutViewController.h"

@interface MainMenuViewController : UIViewController {
    RootViewController *_rootViewController;
    AboutViewController *_aboutViewController;
}

@property (retain) AboutViewController *aboutViewController;
@property (retain) RootViewController *rootViewController;

- (IBAction)aboutTapped:(id)sender;
- (IBAction)viewTapped:(id)sender;

@end
