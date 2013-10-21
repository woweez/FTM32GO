//
//  StrongLevel14Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/16/13.
//
//

#import "StrongLevel14Cat.h"

@implementation StrongLevel14Cat

- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 560;
        moveXend = 390;
        moveXstart = 260;
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
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(450, 550)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(510, 480)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(510, 480) endPoint:CGPointMake(640, 480)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(640, 480) endPoint:CGPointMake(510, 480)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(700, 570)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(740, 560)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(740, 560) endPoint:CGPointMake(860, 560)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(860, 560) endPoint:CGPointMake(740, 560)];
    
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(690, 550)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(640, 480)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(430, 570)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(390, 560)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove, afterMoveLeftOrRight,
                            startJump,firstJump,secondJump,
                            flip2,
                            rightMove1, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1,afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove1, afterMoveLeftOrRight,
                            startJump,firstJump1,secondJump1,
                            flip2, rightMove2, afterMoveLeftOrRight,
                            turn, flip1,
                            leftMove2,afterMoveLeftOrRight,
                            turn,flip2,
                            rightMove2, afterMoveLeftOrRight,
                            turn, flip1,
                            leftMove2,afterMoveLeftOrRight,
                            startJump,firstJump2,secondJump2,
                            flip1, leftMove1, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove1, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1, afterMoveLeftOrRight,
                            turn,flip2,
                            rightMove1,afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1,afterMoveLeftOrRight,
                            startJump, firstJump3, secondJump3,
                            flip1, leftMove,afterMoveLeftOrRight,
                            turn, flip2,
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

@end
