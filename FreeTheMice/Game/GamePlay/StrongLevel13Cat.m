//
//  StrongLevel13Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/16/13.
//
//

#import "StrongLevel13Cat.h"

@implementation StrongLevel13Cat

- (id)init
{
    self = [super init];
    if (self) {
        
        catYPos = 553;
        moveXend = 960;
        moveXstart = 880;
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
    CCSequence *sequence = [CCSequence actions: rightMove, afterMoveLeftOrRight, turn,flip1, leftMove, afterMoveLeftOrRight,jumpCheck,turn, flip2, nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction:sequence]];
    [self applyRunningAnimation];

}
-(void) jumpCompletionCallback:(id)sender{
    if (super.isJumpEnabled && !super.isSecondSequence) {
        super.isJumpEnabled = NO;
    
    catSprite.flipX = 1;
    super.isSecondSequence = YES;
    [catSprite stopAllActions];
    [catSprite removeFromParentAndCleanup:YES];
    catSprite = nil;
    
    catYPos = 548;
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
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(800, 535)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(730, 445)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(730, 445) endPoint:CGPointMake(760, 445)];
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(840, 435)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(880, 365)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(880, 365) endPoint:CGPointMake(930, 365)];
    CCMoveTo *leftMove2 = [self getMoveRightAction:CGPointMake(930, 365) endPoint:CGPointMake(880, 365)];
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(840, 395)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(780, 275)];
    CCMoveTo *leftMove3 = [self getMoveRightAction:CGPointMake(780, 275) endPoint:CGPointMake(650, 275)];
    CCMoveTo *rightMove3 = [self getMoveRightAction:CGPointMake(660, 275) endPoint:CGPointMake(780, 275)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(840, 395)];
    CCSpawn *secondJump4 = [self getSecongJumpAction:CGPointMake(880, 355)];
    
    CCSpawn *firstJump4 = [self getFirstJumpAction:CGPointMake(800, 455)];
    CCSpawn *secondJump5 = [self getSecongJumpAction:CGPointMake(760, 445)];
    CCMoveTo *leftMove4 = [self getMoveLeftAction:CGPointMake(760, 445) endPoint:CGPointMake(730, 445)];
    
    CCSpawn *firstJump5 = [self getFirstJumpAction:CGPointMake(860, 545)];
    CCSpawn *secondJump6 = [self getSecongJumpAction:CGPointMake(880, 548)];
        
        CCSequence *sequence = [CCSequence actions: startJump, firstJump, secondJump, turn, flip2,rightMove1 ,afterMoveLeftOrRight,startJump,firstJump1,secondJump1, flip2,rightMove2,afterMoveLeftOrRight,turn, flip1, leftMove2,afterMoveLeftOrRight, startJump,firstJump2,secondJump3, flip1,leftMove3,afterMoveLeftOrRight,turn,flip2,rightMove3,afterMoveLeftOrRight,startJump, firstJump3,secondJump4, flip2, rightMove2,afterMoveLeftOrRight, turn,flip1, leftMove2, afterMoveLeftOrRight,startJump,firstJump4,secondJump5, flip1,leftMove4,afterMoveLeftOrRight,turn,flip2, rightMove1,afterMoveLeftOrRight,startJump, firstJump5,secondJump6, flip2,rightMove,afterMoveLeftOrRight, turn,flip1, leftMove, afterMoveLeftOrRight,nil];
    sequence.tag = 15;
    [secondCatSprite runAction:[CCRepeatForever actionWithAction:sequence]];
    
    }
}


@end
