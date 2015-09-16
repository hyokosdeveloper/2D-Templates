//
//  GameOverLayer.m
//  MonkeyJump
//
//  Created by Kauserali on 27/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "GameConstants.h"

#define kReplayButtonTag 1
#define kMainMenuButtonTag 2
#define kChallengeFriendsButtonTag 3

@interface GameOverLayer() {
    int64_t _score;
}
@end

@implementation GameOverLayer

- (id) initWithScore:(int64_t)score {
    self = [super init];
    if (self) {
        _score = score;
    }
    return self;
}

- (void) onEnter {
    [super onEnter];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *background = [CCSprite spriteWithFile:@"bg_menu.png"];
    background.position = ccp(winSize.width * 0.5, winSize.height * 0.5);
    [self addChild:background];
    
    CCLabelBMFont *playerScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Your score %lld", _score] fntFile:@"jungle_yellow.fnt"];
    playerScore.position = ccp(winSize.width * 0.5, winSize.height * 0.7);
    [self addChild:playerScore];
    
    CCLabelBMFont *replay = [CCLabelBMFont labelWithString:@"Replay" fntFile:@"jungle.fnt"];
    CCLabelBMFont *mainMenu = [CCLabelBMFont labelWithString:@"Main menu" fntFile:@"jungle.fnt"];
    CCLabelBMFont *challenge = [CCLabelBMFont labelWithString:@"Challenge friends" fntFile:@"jungle.fnt"];
    
    CCMenuItemLabel *replayGameItem = [CCMenuItemLabel itemWithLabel:replay target:self selector:@selector(menuButtonPressed:)];
    replayGameItem.tag = kReplayButtonTag;
    replayGameItem.scale = 0.7;
    replayGameItem.position = ccp(winSize.width * 0.2, winSize.height * 0.5);
    
    CCMenuItemLabel *mainMenuItem = [CCMenuItemLabel itemWithLabel:mainMenu target:self selector:@selector(menuButtonPressed:)];
    mainMenuItem.tag = kMainMenuButtonTag;
    mainMenuItem.scale = 0.7;
    mainMenuItem.position = ccp(winSize.width * 0.2, winSize.height * 0.35);
    
    CCMenuItemLabel *challengeItem = [CCMenuItemLabel itemWithLabel:challenge target:self selector:@selector(menuButtonPressed:)];
    challengeItem.tag = kChallengeFriendsButtonTag;
    challengeItem.scale = 0.7;
    challengeItem.position = ccp(winSize.width * 0.7, winSize.height * 0.5);
    
    CCMenu *menu = [CCMenu menuWithItems:replayGameItem, mainMenuItem, challengeItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
}

- (void) menuButtonPressed:(id) sender {
    CCMenuItemLabel *menuItem = (CCMenuItemLabel*) sender;
    if (menuItem.tag == kReplayButtonTag) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionProgressRadialCCW transitionWithDuration:1.0 scene:[[GameScene alloc] init]]];
    } else if(menuItem.tag == kChallengeFriendsButtonTag) {
        [[GameKitHelper sharedGameKitHelper] showFriendsPickerViewControllerForScore:_score];
    } else if(menuItem.tag == kMainMenuButtonTag) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[MenuScene alloc] init] withColor:ccWHITE]];
    }
}
@end
