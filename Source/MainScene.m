//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
    CCButton *_startGame;
    
}

- (void) didLoadFromCCB {
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playBg:@"ocremix.mp3" loop:TRUE];
}

- (void)startGame {
    _startGame.visible = FALSE;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene: gameplayScene];
}

@end
