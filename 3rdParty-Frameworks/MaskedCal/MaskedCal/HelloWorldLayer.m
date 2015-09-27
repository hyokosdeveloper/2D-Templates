//
//  HelloWorldLayer.m
//  MaskedCal
//
//  Created by Ray Wenderlich on 7/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize tapRecognizer = _tapRecognizer;
@synthesize doubleTapRecognizer = _doubleTapRecognizer;
@synthesize swipeLeftRecognizer = _swipeLeftRecognizer;
@synthesize swipeRightRecognizer = _swipeRightRecognizer;
@synthesize curImage = _curImage;

+(CCScene *) sceneWithCalendar:(int)calendar rootViewController:(RootViewController *)rootViewController 
{
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] 
                               initWithCalendar:calendar rootViewController:rootViewController] autorelease]; // new
    [scene addChild: layer];	
    return scene;
}

- (CCSprite *)maskedSpriteWithSprite:(CCSprite *)textureSprite maskSprite:(CCSprite *)maskSprite { 
    
    // 1
    CCRenderTexture * rt = [CCRenderTexture renderTextureWithWidth:maskSprite.contentSize.width height:maskSprite.contentSize.height];
    
    // 2
    maskSprite.position = ccp(maskSprite.contentSize.width/2, maskSprite.contentSize.height/2);
    textureSprite.position = ccp(textureSprite.contentSize.width/2, textureSprite.contentSize.height/2);
    
    // 3
    [maskSprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
    //[textureSprite setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
    
    // 4
    [rt begin];
    //[maskSprite visit];        
    [textureSprite visit];    
    [rt end];
    
    // 5
    CCSprite *retval = [CCSprite spriteWithTexture:rt.sprite.texture];
    retval.flipY = YES;
    
    // 6
    self.curImage = [rt getUIImageFromBuffer];
    
    return retval;
    
}

// on "init" you need to initialize your instance
-(id) initWithCalendar:(int)calendar rootViewController:(RootViewController *)rootViewController
{
	if( (self=[super init])) {
                
        _rootViewController = rootViewController;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        calendarNum = calendar;        
        int MAX_CALENDAR = 5;
        int MIN_CALENDAR = 1;
        if (calendarNum > MAX_CALENDAR) {
            calendarNum = MIN_CALENDAR;
        } else if (calendarNum < MIN_CALENDAR) {
            calendarNum = MAX_CALENDAR;
        }
        NSLog(@"Calendar %d", calendarNum);
        
        NSString * spriteName = [NSString stringWithFormat:@"Calendar%d.png", calendarNum];
        
        CCSprite * cal = [CCSprite spriteWithFile:spriteName];
        
        CCSprite * mask = [CCSprite spriteWithFile:@"CalendarMask.png"];        
        CCSprite * maskedCal = [self maskedSpriteWithSprite:cal maskSprite:mask];
        maskedCal.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:maskedCal];
        
	}
	return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    CCLOG(@"Tap!");
    CCScene *scene = [HelloWorldLayer sceneWithCalendar:calendarNum+1 rootViewController:_rootViewController];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.25 scene:scene]];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubletapRecognizer {
    CCLOG(@"Double Tap!");    
    [_rootViewController toggleUI];
}

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    CCLOG(@"Swipe Left!");
    CCScene *scene = [HelloWorldLayer sceneWithCalendar:calendarNum+1 rootViewController:_rootViewController];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.25 scene:scene]];    
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    CCLOG(@"Swipe Right!");
    CCScene *scene = [HelloWorldLayer sceneWithCalendar:calendarNum-1 rootViewController:_rootViewController];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.25 scene:scene]];    
}

- (void)onEnter {
    self.doubleTapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)] autorelease];
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_doubleTapRecognizer];
    
    self.tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    [_tapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_tapRecognizer];
    
    self.swipeLeftRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)] autorelease];
    _swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeLeftRecognizer];    
    
    self.swipeRightRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)] autorelease];
    _swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeRightRecognizer];    
}

- (void)onExit {
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_tapRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_doubleTapRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeLeftRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeRightRecognizer];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_tapRecognizer release];
    _tapRecognizer = nil;
    [_doubleTapRecognizer release];
    _doubleTapRecognizer = nil;
    [_swipeLeftRecognizer release];
    _swipeLeftRecognizer = nil;
    [_swipeRightRecognizer release];
    _swipeRightRecognizer = nil;
	[_curImage release];
    _curImage = nil;
	[super dealloc];
}
@end
