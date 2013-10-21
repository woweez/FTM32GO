//
//  GirlLevel8Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel8Cat.h"

@implementation GirlLevel8Cat


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void) runCurrentSequenceForFirstCat{
    catYPos = 330;
    moveXend = 235;
    moveXstart = 50;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(270, 340)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(290, 237)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(50, 237) endPoint:CGPointMake(290, 237)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(290, 237) endPoint:CGPointMake(50, 237)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(260, 340)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(235, 330)];
    

    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump, firstJump,secondJump,
                            turn, flip1, leftMove1, afterMoveLeftOrRight,
                            turn, flip2, rightMove2,afterMoveLeftOrRight,
                            turn, flip1, afterMoveLeftOrRight,
                            startJump, firstJump1, secondJump1,
                            flip1, leftMove, afterMoveLeftOrRight,
                            turn, flip2, nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

-(void) runCurrentSequenceForSecondCat{
    catYPos = 600;
    moveXend = 660;
    moveXstart = 330;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 1;
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
                            turn, flip2,nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

-(void) runCurrentSequenceForThirdCat{
    
    catYPos = 660;
    moveXend = 940;
    moveXstart = 840;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(790, 670)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(760, 520)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(810, 540)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(855, 380)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(855, 380) endPoint:CGPointMake(940, 380)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(940, 380) endPoint:CGPointMake(855, 380)];
    
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(800, 530)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(760, 520)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(800, 670)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(840, 660)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove, afterMoveLeftOrRight,
                            startJump,firstJump,secondJump,
                            turn, flip2, afterMoveLeftOrRight,startJump,firstJump1,secondJump1,
                            flip2, rightMove2,afterMoveLeftOrRight,
                            turn, flip1, leftMove1,afterMoveLeftOrRight,
                            startJump, firstJump2, secondJump2,
                            turn,flip2,afterMoveLeftOrRight, startJump, firstJump3, secondJump3,
                            flip2,nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}
@end
