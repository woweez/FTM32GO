//
//  StrongLevel7Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/16/13.
//
//

#import "StrongLevel7Cat.h"

@implementation StrongLevel7Cat

- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 380;
        moveXend = 280;
        moveXstart = 240;
    }
    return self;
}

-(void) runCurrentSequence{
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    CCCallFuncN *jumpCheck = [CCCallFuncN actionWithTarget:self selector:@selector(jumpCompletionCallback:)];
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    CCSequence *sequence =nil;
    if (!super.isSecondSequence) {
        sequence = [CCSequence actions: rightMove,jumpCheck, afterMoveLeftOrRight, turn,flip1, leftMove,jumpCheck, afterMoveLeftOrRight,turn, flip2, nil];
    }else{
        sequence = [CCSequence actions: rightMove, afterMoveLeftOrRight, turn,flip1, leftMove, afterMoveLeftOrRight,turn, flip2, nil];
    }
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction:sequence]];
    [self applyRunningAnimation];
}

-(void) jumpCompletionCallback:(id)sender{
    if (super.isJumpEnabled && !super.isSecondSequence) {
        super.isJumpEnabled = NO;
       
        catSprite.flipX = 0;
        super.isSecondSequence = YES;
        [catSprite stopAllActions];
        
        catYPos = 275;
        moveXend = 700;
        moveXstart = 230;
        
        catSprite.position = ccp(moveXstart, catYPos);
        CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
        CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
        CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
        CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
        CCAnimate *turn = [self getTurningAction];
        CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
        CCSequence *sequence = [CCSequence actions: rightMove, afterMoveLeftOrRight, turn,flip1, leftMove, afterMoveLeftOrRight,turn, flip2, nil];
        
        [self applyRunningAnimation];
        [catSprite runAction:[CCRepeatForever actionWithAction:sequence]];
        

    }
}

@end
