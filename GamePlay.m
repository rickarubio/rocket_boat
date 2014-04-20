//
//  GamePlay.m
//  RocketBoat
//
//  Created by Ricardo Rubio on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

static const CGFloat scrollSpeed = 50.f;
static CGFloat firstEnemyYPosition = 0.f;
static const CGFloat distanceBetweenEnemies = 300.f;

@implementation GamePlay {
    CCSprite *_playerShip;
    CCPhysicsNode *_physicsNode;
    CCNode *_ocean1;
    CCNode *_ocean2;
    NSArray *_oceans;
    NSMutableArray *_enemyShips;
}

- (void)spawnEnemyShip {
    CCNode *previousEnemyShip = [_enemyShips lastObject];
    CGFloat previousEnemyYPosition = previousEnemyShip.position.y;
    if (!previousEnemyShip) {
        previousEnemyYPosition = firstEnemyYPosition;
    }
    CCNode *enemyShip = [CCBReader load:@"leftEnemy"];
    enemyShip.position = ccp(0, previousEnemyYPosition + distanceBetweenEnemies);
    [_physicsNode addChild:enemyShip];
    [_enemyShips addObject:enemyShip];
}

- (void) didLoadFromCCB {
    _oceans = @[_ocean1, _ocean2];
    // enable touch interactions
    self.userInteractionEnabled = TRUE;
    // spawn enemy ship
    _enemyShips = [NSMutableArray array];
    [self spawnEnemyShip];
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
    float yVelocity = clampf(_playerShip.physicsBody.velocity.y, -1.4 * scrollSpeed, scrollSpeed * 2);
    _playerShip.physicsBody.velocity = ccp(0, yVelocity);
    
    // spawn enemy ships after previous enemies leaves the screen
    NSMutableArray *offScreenEnemies = nil;
    for (CCNode *enemy in _enemyShips) {
        CGPoint enemyWorldPosition = [_physicsNode convertToWorldSpace:enemy.position];
        CGPoint enemyScreenPosition = [self convertToNodeSpace:enemyWorldPosition];
        if (enemyScreenPosition.y <= -1 * enemy.contentSize.height) {
            if (!offScreenEnemies) {
                offScreenEnemies = [NSMutableArray array];
            }
            [offScreenEnemies addObject:enemy];
        }
        // update location of next enemy ship
        firstEnemyYPosition = enemy.position.y + 700;
    }
    // delete the enemy that went off screen
    for (CCNode *enemyToRemove in offScreenEnemies) {
        [enemyToRemove removeFromParent];
        [_enemyShips removeObject:enemyToRemove];
        // for each removed obstacle, add a new one
        [self spawnEnemyShip];
    }
}
@end
