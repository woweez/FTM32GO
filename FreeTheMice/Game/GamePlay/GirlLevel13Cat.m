

//
//  GirlLevel13Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel13Cat.h"

@implementation GirlLevel13Cat

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) runCurrentSequence{
    
    catYPos = 590;
    moveXend = 960;
    moveXstart = 860;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    CCCallFuncN *jumpCheck = [CCCallFuncN actionWithTarget:self selector:@selector(jumpCompletionCallback:)];
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    CCSequence *sequence = [CCSequence actions: rightMove, afterMoveLeftOrRight, turn,flip1, leftMove, afterMoveLeftOrRight,jumpCheck,turn, flip2, nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction:sequence]];
    [self applyRunningAnimation];
    
}


-(void) jumpCompletionCallback:(id)sender{
    if (super.isJumpEnabled && !super.isSecondSequence) {
        super.isJumpEnabled = NO;

        super.isSecondSequence = YES;
        [catSprite stopAllActions];
        [catSprite removeFromParentAndCleanup:YES];
        catSprite = nil;
        
        catYPos = 553;
        moveXend = 960;
        moveXstart = 860;
        
        secondCatSprite.visible = YES;
        secondCatSprite.flipX = 1;
        secondCatSprite.position = ccp(moveXstart, catYPos);
        
        CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
        CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
        CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(secondFlipLeft:)];
        CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(secondFlipRight:)];
        CCAnimate *turn = [self getTurningAction];
        CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(secondAfterLeft:)];
        
        CCAnimate *startJump = [self getStartJumpAction];
        CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(800, 540)];
        CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(730, 450)];
        CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(730, 450) endPoint:CGPointMake(760, 450)];
        
        CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(840, 440)];
        CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(880, 370)];
        CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(880, 370) endPoint:CGPointMake(930, 370)];
        CCMoveTo *leftMove2 = [self getMoveRightAction:CGPointMake(930, 370) endPoint:CGPointMake(880, 370)];
        
        CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(840, 400)];
        CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(780, 280)];
        CCMoveTo *leftMove3 = [self getMoveRightAction:CGPointMake(780, 280) endPoint:CGPointMake(650, 280)];
        CCMoveTo *rightMove3 = [self getMoveRightAction:CGPointMake(660, 280) endPoint:CGPointMake(780, 280)];
        
        CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(840, 400)];
        CCSpawn *secondJump4 = [self getSecongJumpAction:CGPointMake(880, 360)];
        
        CCSpawn *firstJump4 = [self getFirstJumpAction:CGPointMake(800, 460)];
        CCSpawn *secondJump5 = [self getSecongJumpAction:CGPointMake(760, 450)];
        CCMoveTo *leftMove4 = [self getMoveLeftAction:CGPointMake(760, 450) endPoint:CGPointMake(730, 450)];
        
        CCSpawn *firstJump5 = [self getFirstJumpAction:CGPointMake(860, 550)];
        CCSpawn *secondJump6 = [self getSecongJumpAction:CGPointMake(880, 553)];
        
        CCSequence *sequence = [CCSequence actions:
                                startJump, firstJump, secondJump,
                                turn, flip2,rightMove1 ,afterMoveLeftOrRight,
                                startJump,firstJump1,secondJump1,
                                flip2,rightMove2,afterMoveLeftOrRight,
                                turn, flip1, leftMove2,afterMoveLeftOrRight,
                                startJump,firstJump2,secondJump3,
                                flip1,leftMove3,afterMoveLeftOrRight,
                                turn,flip2,rightMove3,afterMoveLeftOrRight,
                                startJump, firstJump3,secondJump4,
                                flip2,
                                rightMove2,afterMoveLeftOrRight,
                                turn,flip1, leftMove2, afterMoveLeftOrRight,
                                startJump,firstJump4,secondJump5,
                                flip1,leftMove4,afterMoveLeftOrRight,
                                turn,flip2, rightMove1,afterMoveLeftOrRight,
                                startJump, firstJump5,secondJump6,
                                flip2,rightMove,afterMoveLeftOrRight,
                                turn,flip1, leftMove, afterMoveLeftOrRight,
                                nil];
        sequence.tag = 15;
        [secondCatSprite runAction:[CCRepeatForever actionWithAction:sequence]];
        
    }
}

-(void) runCurrentSequenceForFirstCat{
    catYPos = 237;
    moveXend = 840;
    moveXstart = 585;
    
    catSprite.position = ccp(moveXend, catYPos);
    catSprite.flipX = 1;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            leftMove, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

-(void) runCurrentSequenceForSecondCat{
    catYPos = 538;
    moveXend = 285;
    moveXstart = 200;
    
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
