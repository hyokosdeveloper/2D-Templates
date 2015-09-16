//
//  IntroScene.m
//  Cocos2d_3_iAd
//
//  Created by Gururaj T on 18/02/14.
//  Copyright Gururaj T 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"iAd Banner" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.7f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *spinningButton = [CCButton buttonWithTitle:@"Show Banner" fontName:@"Verdana-Bold" fontSize:18.0f];
    spinningButton.positionType = CCPositionTypeNormalized;
    spinningButton.position = ccp(0.5f, 0.5f);
    [spinningButton setTarget:self selector:@selector(showBannerAd:)];
    [self addChild:spinningButton];

    // Next scene button
    CCButton *newtonButton = [CCButton buttonWithTitle:@"Hide Banner" fontName:@"Verdana-Bold" fontSize:18.0f];
    newtonButton.positionType = CCPositionTypeNormalized;
    newtonButton.position = ccp(0.5f, 0.4f);
    [newtonButton setTarget:self selector:@selector(hideBannerAd:)];
    [self addChild:newtonButton];
    
    
    mTogglePos = [CCButton buttonWithTitle:@"Banner On Top" fontName:@"Verdana-Bold" fontSize:18.0f];
    mTogglePos.positionType = CCPositionTypeNormalized;
    mTogglePos.position = ccp(0.5f, 0.3f);
    [mTogglePos setTarget:self selector:@selector(toggleBannerPos:)];
    [self addChild:mTogglePos];
	
    
    // done
	return self;
}

-(void)toggleBannerPos:(id)sender
{
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    if(app.isBannerOnTop)
    {
        app.isBannerOnTop = false;
        mTogglePos.title = @"Banner On Bottom";
    }
    else
    {
        app.isBannerOnTop = true;
        mTogglePos.title = @"Banner On Top";
    }
    
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)showBannerAd:(id)sender
{
    mTogglePos.visible=false;
    
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    
    [app ShowIAdBanner];

}

- (void)hideBannerAd:(id)sender
{
    mTogglePos.visible=true;

    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    
    [app hideIAdBanner];
}

// -----------------------------------------------------------------------
@end
