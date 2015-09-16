//
//  AppDelegate.m
//  Cocos2d_3_iAd
//
//  Created by Gururaj T on 18/02/14.
//  Copyright Gururaj T 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "MyiAd.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(YES),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
	
    self.isBannerOn=false;

    if(IS_BANNER_ON_TOP)
    {
        self.isBannerOnTop = true;
    }
    else
    {
        self.isBannerOnTop = false;
    }
    
    
    mIAd = [[MyiAd alloc] init];

    
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [IntroScene scene];
}


-(void)ShowIAdBanner
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"adDisabled"]!=0)
    {
        self.isBannerOn = false;
        [self hideIAdBanner];
        return;
    }
    
    self.isBannerOn = true;
    
    if(mIAd)
    {
        [mIAd showBannerView];
    }
    else
    {
        mIAd = [[MyiAd alloc] init];
    }
}


-(void)hideIAdBanner
{
    self.isBannerOn = false;
    if(mIAd)
        [mIAd hideBannerView];
}

-(void)bannerDidFail
{
    mIAd = nil;
    
#if TARGET_IPHONE_SIMULATOR
    UIAlertView* alert= [[UIAlertView alloc] initWithTitle: @"Simulator_ShowAlert!" message: @"didFailToReceiveAdWithError:"
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL];
	[alert show];
#endif
}



@end
