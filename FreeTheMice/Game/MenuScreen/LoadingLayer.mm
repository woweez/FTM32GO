//
//  LoadingLayer.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 23/11/2013.
//
//

#import "LoadingLayer.h"
#import "cocos2d.h"
#import "GameEngine.h"
#import "MenuScreen.h"
#import "GameEngine01.h"
#import "GameEngine02.h"
#import "GameEngine03.h"
#import "GameEngine04.h"
#import "GameEngine05.h"
#import "GameEngine06.h"
#import "GameEngine07.h"
#import "GameEngine08.h"
#import "GameEngine09.h"
#import "GameEngine10.h"
#import "GameEngine11.h"
#import "GameEngine12.h"
#import "GameEngine13.h"
#import "GameEngine14.h"
#import "StrongMouseEngine01.h"
#import "StrongMouseEngine02.h"
#import "StrongMouseEngine03.h"
#import "StrongMouseEngine04.h"
#import "StrongMouseEngine05.h"
#import "StrongMouseEngine06.h"
#import "StrongMouseEngine07.h"
#import "StrongMouseEngine08.h"
#import "StrongMouseEngine09.h"
#import "StrongMouseEngine10.h"
#import "StrongMouseEngine11.h"
#import "StrongMouseEngine12.h"
#import "StrongMouseEngine13.h"
#import "StrongMouseEngine14.h"
#import "GirlMouseEngine01.h"
#import "GirlMouseEngine02.h"
#import "GirlMouseEngine03.h"
#import "GirlMouseEngine04.h"
#import "GirlMouseEngine05.h"
#import "GirlMouseEngine06.h"
#import "GirlMouseEngine07.h"
#import "GirlMouseEngine08.h"
#import "GirlMouseEngine09.h"
#import "GirlMouseEngine10.h"
#import "GirlMouseEngine11.h"
#import "GirlMouseEngine12.h"
#import "GirlMouseEngine13.h"
#import "GirlMouseEngine14.h"
#import "BossCatLevel15.h"
#import "FTMUtil.h"
#import "FTMConstants.h"

@implementation LoadingLayer

+(CCScene *) scene :(int)catId levelNo:(int)lvl{
	
    
    CCScene *scene = [CCScene node];
	LoadingLayer *layer = [LoadingLayer node];
    layer.tag = catId;
    [layer setLevel:lvl];
    [layer addAnimation];
	[scene addChild: layer];
	
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) setLevel:(int)lvl{
    currentMouse = lvl;
}

-(void) addAnimation{
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float scaleFactorX = winSize.width/480;
    float scaleFactorY = winSize.height/320;
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        xScale = 1 * scaleFactorX;
        yScale = 1 * scaleFactorY;
        cScale = 1;
    }else{
        xScale = 0.5 * scaleFactorX;
        yScale = 0.5 * scaleFactorY;
        cScale = 0.5;
    }
    
    NSString *miceDefault;
    NSString *micePlist;
    NSString *miceRun01;
    NSString *miceRunArr;
    int framesLength;
    if (currentMouse == FTM_MAMA_MICE_ID) {
        miceDefault = @"mother_mouse_default.png";
        micePlist = @"mother_mouse_default.plist";
        miceRun01 = @"mother_run01.png";
        miceRunArr = @"mother_run0%d.png";
        framesLength = 8;
    }else if (currentMouse == FTM_STRONG_MICE_ID){
        miceDefault = @"strong0_default.png";
        micePlist = @"strong0_default.plist";
        miceRun01 = @"strong_run01.png";
        miceRunArr = @"strong_run0%d.png";
        framesLength = 12;
    }else{
        miceDefault = @"girl_default.png";
        micePlist = @"girl_default.plist";
        miceRun01 = @"girl_run1.png";
        miceRunArr = @"girl_run%d.png";
        framesLength = 8;
    }
    CCSprite *background = [CCSprite spriteWithFile:@"Select_Level_background.png"];
    background.position = ccp(240 *scaleFactorX, 160*scaleFactorY);
    [background setScaleX:xScale];
    [background setScaleY:yScale];
    [self addChild: background z:0];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:miceDefault];
    [self addChild:spriteSheet];
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:micePlist];
    CCSprite *heroRunSprite = [CCSprite spriteWithSpriteFrameName:miceRun01];
    heroRunSprite.position = ccp(-10, winSize.height/3);
    heroRunSprite.scale = MAMA_SCALE;
    [spriteSheet addChild:heroRunSprite];
    

    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 1; i < 8; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:miceRunArr,i]];
        [animFrames addObject:frame];
    }
    int seconds = 3;
    if (currentMouse == FTM_STRONG_MICE_ID) {
        seconds = 5;
    }
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:seconds position:CGPointMake(winSize.width, winSize.height/3)];
    CCCallFunc *callback = [CCCallFunc actionWithTarget:self selector:@selector(callbackForMoving)];
    CCSequence *seq = [CCSequence actions:moveTo,callback, nil];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.06f];
//    [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
//    [heroRunSprite runAction:seq];
    [self schedule:@selector(callbackForMoving)];
    
}

-(void) callbackForMoving{
    
    if(self.tag==1){
        [[CCDirector sharedDirector] replaceScene:[BossCatLevel15 scene]];
        return;
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine01 scene]];
        else if(currentMouse ==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine01 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine01 scene]];
        
    }else if(self.tag==2){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine02 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine02 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine02 scene]];
        
    }else if(self.tag==3){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine03 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine03 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine03 scene]];
        
    }else if(self.tag==4){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine04 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine04 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine04 scene]];
        
    }else if(self.tag==5){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine05 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine05 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine05 scene]];
        
    }else if(self.tag==6){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine06 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine06 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine06 scene]];
        
        
    }else if(self.tag==7){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine07 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine07 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine07 scene]];
    }else if(self.tag==8){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine08 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine08 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine08 scene]];
    }else if(self.tag==9){
        if(currentMouse==1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine09 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine09 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine09 scene]];
    }else if(self.tag==10){
        if(currentMouse == 1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine10 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine10 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine10 scene]];
    }else if(self.tag==11){
        if(currentMouse == 1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine11 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine11 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine11 scene]];
    }else if(self.tag==12){
        if(currentMouse == 1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine12 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine12 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine12 scene]];
    }else if(self.tag==13){
        if(currentMouse == 1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine13 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine13 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine13 scene]];
    }else if(self.tag==14){
        if(currentMouse == 1)
            [[CCDirector sharedDirector] replaceScene:[GameEngine14 scene]];
        else if(currentMouse==2)
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine14 scene]];
        else if(currentMouse==3)
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine14 scene]];
    }

}
@end
