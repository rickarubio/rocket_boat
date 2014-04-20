//
//  GamePlay.m
//  RocketBoat
//
//  Created by Ricardo Rubio on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

static const CGFloat scrollSpeed = 50.f;

@implementation GamePlay {
    CCSprite *_playerShip;
    CCPhysicsNode *_physicsNode;
    CCNode *_ocean1;
    CCNode *_ocean2;
    NSArray *_oceans;
}

- (void) didLoadFromCCB {
    _oceans = @[_ocean1, _ocean2];
}

- (void)update:(CCTime)delta {
    // ship moves upwards
    _playerShip.position = ccp(_playerShip.position.x, _playerShip.position.y + delta * scrollSpeed);
    
    // physicsNode moves downwards
    _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y - (scrollSpeed * delta));
    
    // loop the ocean background
    for (CCNode *ocean in _oceans) {
        CGPoint oceanWorldPosition = [_physicsNode convertToWorldSpace:ocean.position];
        CGPoint oceanScreenPosition = [self convertToNodeSpace:oceanWorldPosition];
//        NSLog(@"ocean Y-coord = %f", oceanScreenPosition.y);
        if (oceanScreenPosition.y <= -1 * ocean.contentSize.height) {
            ocean.position = ccp(0, ocean.position.y + (2 * ocean.contentSize.height));
        }
    }
}
@end
