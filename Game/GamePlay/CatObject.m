//
//  CatObject.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/14/13.
//
//

#import "CatObject.h"

@implementation CatObject

@synthesize isJumpEnabled;
@synthesize isSecondSequence;


- (id)init
{
    self = [super init];
    if (self) {
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"cat_default.plist"];
        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
        [self addChild:catSpriteSheet z:10];
        
        catSprite = [CCSprite spriteWithSpriteFrameName:@"cat_run1.png"];
        catSprite.position = ccp(100, 100);
        catSprite.scale = 0.6;
        [catSpriteSheet addChild:catSprite];
        
        secondCatSprite = [CCSprite spriteWithSpriteFrameName:@"cat_run1.png"];
        secondCatSprite.position = ccp(100, 100);
        secondCatSprite.scale = 0.6;
        secondCatSprite.visible = NO;
        [catSpriteSheet addChild:secondCatSprite];
        
        walkingSpeed = 60;
        
    }
    return self;
}

-(CCSprite *) getCatSprite{
    if (catSprite != nil) {
        return catSprite;
    }else{
        return secondCatSprite;
    }
    
}
-(CCAnimate *) getTurningAction{
    
    NSMutableArray *turnAnimFramesArr = [NSMutableArray array];
    for(int i = 1; i <= 10; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_turn_run%d.png", i]];
        [turnAnimFramesArr addObject:frame];
    }
    CCAnimation *turnAnim = [CCAnimation animationWithSpriteFrames:turnAnimFramesArr delay:0.06f];
    CCAnimate *turnAction = [CCAnimate actionWithAnimation:turnAnim];
    return turnAction;
//
//
//    CGPoint startPoint = CGPointMake(100, 100);
//    CGPoint endPoint = CGPointMake(300, 100);
//    CGPoint JumpPoint1 = CGPointMake(370, 170);
//    CGPoint JumpPoint2 = CGPointMake(420, 120);
//    CGFloat distance1 = ccpDistance(startPoint, endPoint);
//    CGFloat distance2 = ccpDistance(startPoint, JumpPoint2);
//    float time1 = distance1/walkingSpeed;
//     float time2 = distance2/walkingSpeed;
//    
//    CCMoveTo *moveRight = [CCMoveTo actionWithDuration:time1 position:endPoint];
//    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];
//    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
//    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
//    CCCallFuncN *afterJump = [CCCallFuncN actionWithTarget:self selector:@selector(afterJump:)];
//    CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:time2 position:CGPointMake(100, 130)];
//    
//    NSMutableArray *jumpFramesArr1 = [NSMutableArray array];
//    for(int i = 1; i <= 10; i++) {
//        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
//        [jumpFramesArr1 addObject:frame];
//    }
//    CCAnimation *jumpAnim1 = [CCAnimation animationWithSpriteFrames:jumpFramesArr1 delay:0.06f];
//    CCAnimate *jumpAction1 = [CCAnimate actionWithAnimation:jumpAnim1];
//    
//    jumpFramesArr1 = [NSMutableArray array];
//    for(int i = 11; i <= 13; i++) {
//        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
//        [jumpFramesArr1 addObject:frame];
//    }
//    jumpAnim1 = [CCAnimation animationWithSpriteFrames:jumpFramesArr1 delay:0.1f];
//    CCAnimate *jumpAction2 = [CCAnimate actionWithAnimation:jumpAnim1];
//    
//    jumpFramesArr1 = [NSMutableArray array];
//    for(int i = 14; i <= 21; i++) {
//        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
//        [jumpFramesArr1 addObject:frame];
//    }
//    jumpAnim1 = [CCAnimation animationWithSpriteFrames:jumpFramesArr1 delay:0.06125f];
//    CCAnimate *jumpAction3 = [CCAnimate actionWithAnimation:jumpAnim1];
//    
//    CCMoveTo *jumpAct1 = [CCMoveTo actionWithDuration:.5 position:JumpPoint1];
//    CCMoveTo *jumpAct2 = [CCMoveTo actionWithDuration:.5 position:JumpPoint2];
//    CCSpawn *jump1 = [CCSpawn actions:jumpAction2,jumpAct1, nil];
//    jump1.tag = 13;
//    CCSpawn *jump2 = [CCSpawn actions:jumpAction3,jumpAct2, nil];
//    jump2.tag = 14;
////    CCSequence *sequence = [CCSequence actions: moveRight,afterMoveLeftOrRight,jumpAction1, jump, afterJump, nil];
//  
//        CCSequence *sequence = [CCSequence actions: moveRight,afterMoveLeftOrRight,jumpAction1, jump1, jump2, afterJump ,flip1, moveLeft,afterMoveLeftOrRight,turnAction, flip2, nil];
//    [self applyRunningAnimation];
//    [catSprite runAction:sequence];
    
}


-(void) flipLeft:(id)sender{

    [self applyRunningAnimation];

    catSprite.flipX = 1;
}

-(void) secondFlipLeft:(id)sender{
    
    [self applySecondRunningAnimation];
    
    secondCatSprite.flipX = 1;
}
-(void) flipRight:(id)sender{
    
    [self applyRunningAnimation];
    catSprite.flipX = 0;    
}

-(void) secondFlipRight:(id)sender{
    
    [self applySecondRunningAnimation];
    secondCatSprite.flipX = 0;
}

-(void) afterJump:(id)sender{
    
// [catSprite stopActionByTag:13];
}



-(void) afterRight:(id)sender{
    
    [catSprite stopActionByTag:12];
}

-(CCMoveTo *) getMoveRightAction:(CGPoint) startPoint endPoint:(CGPoint) endPoint{
    CGFloat distance = ccpDistance(startPoint, endPoint);
    float time = distance/walkingSpeed;
    
    CCMoveTo *moveRight = [CCMoveTo actionWithDuration:time position:endPoint];
    return moveRight;
}

-(CCMoveTo *) getMoveLeftAction:(CGPoint) startPoint endPoint:(CGPoint) endPoint{
    CGFloat distance = ccpDistance(startPoint, endPoint);
    float time = distance/walkingSpeed;
    
    CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:time position:endPoint];
    return moveLeft;
}

-(CCSpawn *) getFirstJumpAction:(CGPoint) endPoint{
    NSMutableArray *jumpFramesArr = [NSMutableArray array];
    for(int i = 11; i <= 13; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
        [jumpFramesArr addObject:frame];
    }
    CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpFramesArr delay:0.06f];
    CCAnimate *jumpAction = [CCAnimate actionWithAnimation:jumpAnim];
    
    CCMoveTo *jumpAct = [CCMoveTo actionWithDuration:.5 position:endPoint];
    CCSpawn *jump = [CCSpawn actions:jumpAction,jumpAct, nil];
    return jump;
    
}
-(CCSpawn *) getSecongJumpAction:(CGPoint) endPoint{
    NSMutableArray *jumpFramesArr = [NSMutableArray array];
    for(int i = 14; i <= 21; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
        [jumpFramesArr addObject:frame];
    }
    CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpFramesArr delay:0.06125f];
    CCAnimate *jumpAction = [CCAnimate actionWithAnimation:jumpAnim];
    
    CCMoveTo *jumpAct = [CCMoveTo actionWithDuration:.5 position:endPoint];
    CCSpawn *jump = [CCSpawn actions:jumpAction,jumpAct, nil];
    return jump;
}

-(CCAnimate *) getStartJumpAction{
    NSMutableArray *jumpFramesArr = [NSMutableArray array];
    for(int i = 1; i <= 10; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_jump%d.png", i]];
        [jumpFramesArr addObject:frame];
    }
    CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpFramesArr delay:0.06f];
    CCAnimate *jumpAction = [CCAnimate actionWithAnimation:jumpAnim];
    return jumpAction;
}

-(void) afterLeft:(id)sender{
    if (isSecondSequence) {
        isSecondSequence = NO;
        return;
    }
    [catSprite stopActionByTag:12];
}

-(void) secondAfterLeft:(id)sender{

    [secondCatSprite stopActionByTag:12];
}
-(void) applyRunningAnimation{
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 1; i <= 30; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_run%d.png", i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.01f];
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:animation];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:actionOne];
    repeat.tag = 12;
    [catSprite runAction:repeat];
}

-(void) applySecondRunningAnimation{
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 1; i <= 30; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"cat_run%d.png", i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.01f];
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:animation];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:actionOne];
    repeat.tag = 12;
    [secondCatSprite runAction:repeat];
}

@end
