//
//  StrongLevel6Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/16/13.
//
//

#import "StrongLevel6Cat.h"

@implementation StrongLevel6Cat


- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 430;
        moveXend = 200;
        moveXstart = 50;
    }
    return self;
}


-(void) runCurrentSequence{
    
    catSprite.position = ccp(moveXstart, catYPos);
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    CCCallFuncN *jumpCheck = [CCCallFuncN actionWithTarget:self selector:@selector(checkIfJumpEnabled:)];
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    CCSequence *sequence = [CCSequence actions: rightMove,jumpCheck, afterMoveLeftOrRight, turn,flip1, leftMove,afterMoveLeftOrRight,turn, flip2, nil];
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction:sequence]];
    [self applyRunningAnimation];
}

-(void) checkIfJumpEnabled:(id)sender{
    if (super.isJumpEnabled) {
        super.isJumpEnabled = NO;
        [catSprite stopAllActions];
        CCAnimate *act1 = [self getStartJumpAction];
        CCCallFuncN *jumpCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(jumpCompletionCallback:)];
        
        CCSpawn *jump1 = [self getFirstJumpAction:CGPointMake(moveXend + 150, catYPos + 20)];
        CCSpawn *jump2 = [self getSecongJumpAction:CGPointMake(moveXend + 230, catYPos - 45)];
        CCCallFuncN *afterJump = [CCCallFuncN actionWithTarget:self selector:@selector(afterJump:)];
        CCSequence *jumpSeq = [CCSequence actions:act1,jump1,jump2,afterJump,jumpCompleted, nil];
        [catSprite runAction: jumpSeq];
    }
}
-(void) jumpCompletionCallback:(id)sender{
    [catSprite stopAllActions];
    catYPos = 380;
    moveXend = 700;
    moveXstart = 430;
    [self runCurrentSequence];
}
@end
