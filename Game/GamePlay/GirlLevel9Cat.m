//
//  GirlLevel9Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/18/13.
//
//

#import "GirlLevel9Cat.h"

@implementation GirlLevel9Cat

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) runCurrentSequenceForFirstCat{
    catYPos = 237;
    moveXend = 850;
    moveXstart = 50;
    
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
    catYPos = 600;
    moveXend = 610;
    moveXstart = 310;
    
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
