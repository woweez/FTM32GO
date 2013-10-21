//
//  GirLevel6Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel6Cat.h"

@implementation GirlLevel6Cat

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

-(void) runCurrentSequenceForFirstCat{
    catYPos = 378;
    moveXend = 710;
    moveXstart = 460;
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(760, 380)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(800, 235)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(800, 235) endPoint:CGPointMake(930, 235)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(930, 235) endPoint:CGPointMake(800, 235)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(740, 388)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(710, 378)];
        
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump, firstJump, secondJump,
                            flip2, rightMove1,afterMoveLeftOrRight,
                            turn,flip1, leftMove1,afterMoveLeftOrRight,
                            startJump, firstJump1,secondJump1,
                            flip1, leftMove,afterMoveLeftOrRight,
                            turn,flip2, nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
    
}

-(void) runCurrentSequenceForSecondCat{
    
    catYPos = 378;
    moveXend = 235;
    moveXstart = 50;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove, afterMoveLeftOrRight,
                            turn, flip2,
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
    
}


@end
