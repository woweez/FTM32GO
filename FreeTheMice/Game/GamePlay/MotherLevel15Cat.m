//
//  MotherLevel15Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 12/5/13.
//
//

#import "MotherLevel15Cat.h"

@implementation MotherLevel15Cat

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) runCurrentSequenceForFirstCat{
    catYPos = 500;
    moveXend = 180;
    moveXstart = 50;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(230, 505)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(260, 380)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(290, 380) endPoint:CGPointMake(340, 380)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(340, 380) endPoint:CGPointMake(250, 380)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(400, 510)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(410, 500)];
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(380, 514)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(330, 380)];
    
    CCMoveTo *rightMove3 = [self getMoveRightAction:CGPointMake(410, 500) endPoint:CGPointMake(560, 500)];
    CCMoveTo *leftMove3 = [self getMoveLeftAction:CGPointMake(560, 500) endPoint:CGPointMake(410, 500)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(220, 505)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(180, 500)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            startJump, firstJump,secondJump,
                            flip2,rightMove2,afterMoveLeftOrRight,
                            startJump,firstJump1,secondJump1,
                            flip2, rightMove3, afterMoveLeftOrRight,
                            turn, flip1, leftMove3, afterMoveLeftOrRight,
                            startJump, firstJump2, secondJump2,
                            flip1, leftMove2, afterMoveLeftOrRight,
                            startJump, firstJump3, secondJump3,
                            flip1, leftMove, afterMoveLeftOrRight,
                            turn,flip2,
                            
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

-(void) runCurrentSequenceForSecondCat{
    catYPos = 500;
    moveXend = 841;
    moveXstart = 971;
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 1;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCMoveTo *leftMove = [self getMoveLeftAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
    
    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(811, 510)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(761, 380)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(661, 380) endPoint:CGPointMake(731, 380)];
    CCMoveTo *leftMove2 = [self getMoveLeftAction:CGPointMake(731, 380) endPoint:CGPointMake(661, 380)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(611, 510)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(590, 500)];
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(611, 514)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(661, 380)];
    
    CCMoveTo *rightMove3 = [self getMoveRightAction:CGPointMake(450, 500) endPoint:CGPointMake(590, 500)];
    CCMoveTo *leftMove3 = [self getMoveLeftAction:CGPointMake(590, 500) endPoint:CGPointMake(450, 500)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(811, 510)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(841, 500)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            leftMove,afterMoveLeftOrRight,
                            startJump, firstJump, secondJump,
                            flip1, leftMove2, afterMoveLeftOrRight,
                            startJump, firstJump1, secondJump1,
                            flip1, leftMove3, afterMoveLeftOrRight,
                            turn, flip2, rightMove3, afterMoveLeftOrRight,
                            startJump, firstJump2, secondJump2,
                            flip2, rightMove2, afterMoveLeftOrRight,
                            startJump, firstJump3, secondJump3,
                            flip2, rightMove, afterMoveLeftOrRight,
                            turn, flip1,
                            nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}


@end
