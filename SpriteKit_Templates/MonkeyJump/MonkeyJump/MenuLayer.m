//
//  MenuLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameScene.h"

#define kNewGameButtonTag 1

@implementation MenuLayer

- (void) onEnter {
    [super onEnter];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
	
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *background = [CCSprite spriteWithFile:@"bg_menu.png"];
    background.position = ccp(winSize.width * 0.5, winSize.height * 0.5);
    [self addChild:background];
    
    CCLabelBMFont *newGame = [CCLabelBMFont labelWithString:@"New Game" fntFile:@"jungle.fnt"];
    CCMenuItemLabel *newGameItem = [CCMenuItemLabel itemWithLabel:newGame target:self selector:@selector(menuButtonPressed:)];
    newGameItem.tag = kNewGameButtonTag;
    newGameItem.position = ccp(winSize.width * 0.5, winSize.height * 0.6);
    
    CCMenu *menu = [CCMenu menuWithItems:newGameItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
}

- (void) menuButtonPressed:(id) sender {
    CCMenuItemLabel *menuItemLabel = (CCMenuItemLabel*)sender;
    if (menuItemLabel.tag == kNewGameButtonTag) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionProgressRadialCCW transitionWithDuration:1.0f scene:[[GameScene alloc] init]]];
    }
}
@end
