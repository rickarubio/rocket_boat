//
//  GamePlay.m
//  RocketBoat
//
//  Created by Ricardo Rubio on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

static const CGFloat scrollSpeed = 80.f;

@implementation GamePlay {
    CCSprite *_playerShip;
}

- (void)update:(CCTime)delta {
    _playerShip.position = ccp(_playerShip.position.x, _playerShip.position.y + delta * scrollSpeed);
}

@end
