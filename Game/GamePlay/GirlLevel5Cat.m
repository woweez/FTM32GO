//
//  GirlLevel5Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel5Cat.h"

@implementation GirlLevel5Cat

- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 577;
        moveXend = 60;
        moveXstart = 40;
    }
    return self;
}

-(void) runCurrentSequence{
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(130, 615)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(200, 577)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(200, 577) endPoint:CGPointMake(320, 577)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(390, 580)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(435, 430)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(435, 430) endPoint:CGPointMake(390, 430)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(390, 430) endPoint:CGPointMake(435, 430)];
    
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(365, 587)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(320, 577)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(320, 577) endPoint:CGPointMake(200, 577)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(135, 615)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(60, 577)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump, firstJump,secondJump,
                            flip2, rightMove1,afterMoveLeftOrRight,
                            startJump, firstJump1, secondJump1,
                            turn,flip1,
                            leftMove1, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove2, afterMoveLeftOrRight,
                            turn,flip1,afterMoveLeftOrRight,
                            startJump, firstJump2, secondJump2,
                            flip1, leftMove2,
                            afterMoveLeftOrRight,
                            startJump, firstJump3, secondJump3,
                            flip1, leftMove,afterMoveLeftOrRight,
                            turn, flip2,
                            /* 
                            turn,flip1,leftMove,afterMoveLeftOrRight,
                            turn,flip2,
                            
                           
                        
                             */
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

@end
