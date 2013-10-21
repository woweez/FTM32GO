//
//  GirlLevel4Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel4Cat.h"

@implementation GirlLevel4Cat

- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 538;
        moveXend = 120;
        moveXstart = 50;
    }
    return self;
}

-(void) runCurrentSequenceForFirstCat{
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(155, 548)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(180, 445)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(180, 445) endPoint:CGPointMake(220, 445)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(220, 445) endPoint:CGPointMake(180, 445)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(150, 455)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(130, 330)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(130, 330) endPoint:CGPointMake(50, 330)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(50, 330) endPoint:CGPointMake(270, 330)];
    CCMoveTo *leftMove3 = [self getMoveLeftAction:CGPointMake(270, 330) endPoint:CGPointMake(120, 330)];
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(150, 455)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(180, 445)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(160, 548)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(120, 538)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump,firstJump, secondJump,
                            flip2,rightMove1, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1, afterMoveLeftOrRight,
                            startJump, firstJump1,secondJump1,
                            flip1, leftMove2,afterMoveLeftOrRight,
                            turn, flip2, rightMove2,afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove3,afterMoveLeftOrRight,
                            turn,flip2,afterMoveLeftOrRight,
                            startJump, firstJump2,secondJump2,
                            flip2, rightMove1, afterMoveLeftOrRight,
                            turn, flip1, leftMove1,afterMoveLeftOrRight,
                            startJump, firstJump3, secondJump3,
                            flip1, leftMove, afterMoveLeftOrRight,
                            turn,flip2 ,nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];

}

-(void) runCurrentSequenceForSecondCat{
    
    catYPos = 600;
    moveXend = 680;
    moveXstart = 420;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(730, 610)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(790, 540)];

    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(830, 550)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(860, 400)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(860, 400) endPoint:CGPointMake(930, 400)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(930, 400) endPoint:CGPointMake(860, 400)];
    
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(840, 410)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(780, 238)];
    CCMoveTo *leftMove3 = [self getMoveLeftAction:CGPointMake(780, 238) endPoint:CGPointMake(630, 238)];
    CCMoveTo *rightMove3 = [self getMoveRightAction:CGPointMake(630, 238) endPoint:CGPointMake(915, 238)];
    CCMoveTo *leftMove4 = [self getMoveLeftAction:CGPointMake(915, 238) endPoint:CGPointMake(790, 238)];

    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(840, 410)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(860, 400)];
    
    CCSpawn *firstJump4 = [self getFirstJumpAction:CGPointMake(810, 550)];
    CCSpawn *secondJump4 = [self getSecongJumpAction:CGPointMake(790, 540)];
    
    CCSpawn *firstJump5 = [self getFirstJumpAction:CGPointMake(700, 610)];
    CCSpawn *secondJump5 = [self getSecongJumpAction:CGPointMake(680, 600)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump,firstJump,secondJump,
                            startJump,firstJump1,secondJump1,
                            flip2,rightMove2,afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove2,afterMoveLeftOrRight,
                            startJump,firstJump2,secondJump2,
                            flip1, leftMove3,afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove3, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove4,afterMoveLeftOrRight,
                            turn,flip2, afterMoveLeftOrRight,
                            startJump, firstJump3,secondJump3,
                            flip2, rightMove2,afterMoveLeftOrRight,
                            turn,flip1, leftMove2,afterMoveLeftOrRight,
                            startJump, firstJump4,secondJump4,
                            startJump, firstJump5,secondJump5,
                            flip1,leftMove, afterMoveLeftOrRight,
                            turn, flip2,
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];

}

@end
