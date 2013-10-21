//
//  CatObject.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/14/13.
//
//

#import <cocos2d.h>
#import "CCSprite.h"

@interface CatObject : CCSprite {

    CCSpriteFrameCache *cache;
    CCSpriteBatchNode *catSpriteSheet;
    CCSprite *catSprite;
    CCSprite *secondCatSprite;
    int walkingSpeed;
    int catYPos;
    int moveXend;
    int moveXstart;
    
}

@property (readwrite) BOOL isJumpEnabled;
@property (readwrite) BOOL isSecondSequence;
-(CCAnimate *)  getTurningAction;
-(CCMoveTo *)   getMoveRightAction: (CGPoint) startPoint endPoint:(CGPoint ) endPoint;
-(CCMoveTo *)   getMoveLeftAction:  (CGPoint ) startPoint endPoint:(CGPoint ) endPoint;
-(CCSpawn *)    getFirstJumpAction: (CGPoint ) endPoint;
-(CCSpawn *)    getSecongJumpAction:(CGPoint ) endPoint;
-(CCAnimate *)  getStartJumpAction;
-(void) applyRunningAnimation;
-(CCSprite *) getCatSprite;
@end
