//
//  HelloWorldLayer.h
//  MaskedCal
//
//  Created by Ray Wenderlich on 7/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "RootViewController.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    int calendarNum;
    UITapGestureRecognizer * _tapRecognizer;
    UITapGestureRecognizer * _doubleTapRecognizer;
    UISwipeGestureRecognizer * _swipeLeftRecognizer;
    UISwipeGestureRecognizer * _swipeRightRecognizer;
    RootViewController * _rootViewController;
    UIImage * _curImage;
}

@property (retain) UITapGestureRecognizer * tapRecognizer;
@property (retain) UITapGestureRecognizer * doubleTapRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeRightRecognizer;
@property (retain) UIImage * curImage;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) sceneWithCalendar:(int)lastCalendar rootViewController:(RootViewController *)rootViewController;
- (id)initWithCalendar:(int)lastCalendar rootViewController:(RootViewController *)rootViewController;

@end
