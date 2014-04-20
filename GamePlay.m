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
    // enable touch interactions
    self.userInteractionEnabled = TRUE;
}

// propel the ship forward with each tap
- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_playerShip.physicsBody applyImpulse:ccp(0, scrollSpeed * 2)];
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
        // NSLog(@"ocean Y-coord = %f", oceanScreenPosition.y);
        if (oceanScreenPosition.y <= -1 * ocean.contentSize.height) {
            ocean.position = ccp(0, ocean.position.y + (2 * ocean.contentSize.height));
        }
    }
    
    // clamp forwards velocity of the ship, backwards velocity tied to scrollSpeed
    float yVelocity = clampf(_playerShip.physicsBody.velocity.y, -1 * scrollSpeed, scrollSpeed * 2);
    _playerShip.physicsBody.velocity = ccp(0, yVelocity);
}
@end
