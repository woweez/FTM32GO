//
//  CommonEngine.mm
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//

#import "CommonEngine.h"
#import "AppDelegate.h"
#import "LevelScreen.h"
#import "FTMConstants.h"
#import "DB.h"
#import "HudLayer.h"
#import "FTMUtil.h"
#import "SimpleAudioEngine.h"
#import "LevelCompleteScreen.h"
#import "LevelFailedScreen.h"
#import "GameKitHelper.h"

@implementation CommonEngine

-(id) init
{
    if( (self=[super init])) {
        [FTMUtil sharedInstance].isSlowDownTimer = NO;
        [FTMUtil sharedInstance].isRespawnMice = NO;
        currentAnim = 0;
        isLandingAnimationAdded = NO;
        clockIntervalCounter = 0;
        soundManager = [[sound alloc]  init];
        [soundManager stopPlayingMusic];
        if ([FTMUtil sharedInstance].mouseClicked == FTM_STRONG_MICE_ID) {
            cache = [CCSpriteFrameCache sharedSpriteFrameCache];

            [cache addSpriteFramesWithFile:@"strong0_boots.plist"];
            bootsSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_boots.png"];
            
            [self addChild:bootsSpriteSheet z:100];
        }

    }
    return self;
}

-(void) playPushRedBtnAnimation:(CCSprite *) sprite{
    [cache addSpriteFramesWithFile:@"redBtnAnim.plist"];
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= 19; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"push_btn_red_%d.png",i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.05f];
    [sprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
}

-(void) resetRedPushBtn :(CGPoint) position{
    [pushButtonSprite removeFromParentAndCleanup:YES];
    pushButtonSprite = [CCSprite spriteWithFile:@"push_button.png"];
    pushButtonSprite.tag = 10;
    pushButtonSprite.position = position;
    pushButtonSprite.scaleY = 0.35;
    pushButtonSprite.scaleX = 0.55;
    [self addChild:pushButtonSprite z: 1];
}
-(void) playStaticCheeseAnimation:(CCSprite *) sprite{
    [cache addSpriteFramesWithFile:@"cheeseStaticAnim.plist"];
    [cache addSpriteFramesWithFile:@"cheeseCollectedAnim.plist"];
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= 39; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"CHEESE_%d.png",i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.05f];
    [sprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
}
-(void) playCheeseCollectedAnimation:(CCSprite *) sprite{
    CGPoint point =  CGPointMake([CCDirector sharedDirector].winSize.width *0.94, [CCDirector sharedDirector].winSize.height*0.95);
    CGPoint spritePos = [self convertToWorldSpace:sprite.position];
    spritePos = ccp(spritePos.x, spritePos.y + 50);
    float speed = 140;
    float distance = ccpDistance(spritePos, point);
    float time = distance/speed;
    int totalNoOfFrames = 56;
    float timePerFrame = time/totalNoOfFrames;
    sprite.visible = NO;
    CCSprite *collectSprite = [CCSprite spriteWithSpriteFrameName:@"collect_0.png"];
    collectSprite.scale = CHEESE_SCALE;
    collectSprite.position= spritePos;
    [hudLayer addChild:collectSprite z:9];
    
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= 55; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"collect_%d.png",i]];
        [animationFramesArr addObject:frame];
    }
    CCMoveTo *move = [CCMoveTo actionWithDuration:time position:point];
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(starsMovementDone:)];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:timePerFrame];
    CCSpawn *span = [CCSpawn actions:[CCAnimate actionWithAnimation:animation], [CCSequence actions:move, callback, nil], nil ];
    [collectSprite runAction:span];
}
-(void) starsMovementDone: (id) sender{
    CCSprite *starsImage = (CCSprite*)sender;
    [starsImage removeFromParentAndCleanup:YES];
    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue: 5];
}

-(void) addGateImageAndAnimation:(CGPoint) position{
    [cache addSpriteFramesWithFile:@"door_animation.plist"];
    gateSprite=[CCSprite spriteWithSpriteFrameName:@"door_0.png"];
    gateSprite.scale = 1.6;
    gateSprite.position=ccp(position.x - 5, position.y);
    [self addChild:gateSprite z:9];
}
-(void) playDoorAnimation{
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= 5; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"door_%d.png",i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.04f];
    [gateSprite runAction:[CCAnimate actionWithAnimation:animation]];
    
}
-(void) showAnimationWithMiceIdAndIndex:(int)miceId andAnimationIndex:(int)animIndex{
    
    
    switch (miceId) {
        case FTM_MAMA_MICE_ID:
            [self showTrappingAnimationForMama:animIndex];
            break;
        case FTM_STRONG_MICE_ID:
            [self showTrappingAnimationForStrong:animIndex];
            break;
        case FTM_GIRL_MICE_ID:
            [self showTrappingAnimationForGirl:animIndex];
            break;
            
        default:
            break;
    }
}

-(CCSprite *) getTrappingAnimatedSprite{
    return trappingAnimationSprite;
}

-(CCSprite *) getFireAnimatedSprite{
    return flamesSprite;
}
-(void) showTrappingAnimationForMama: (int) animIndex{
    [soundManager mama_hurt];
    switch (animIndex) {
        case MAMA_FLAME_ANIM:
            [self playMamaFlameHitAnimation];
            break;
        case MAMA_KNIFE_ANIM:
            [self playMamaKniveHitAnimation];
            break;
        case MAMA_SHOCK_ANIM:
            [self playMamaShockHitAnimation];
            break;
        case MAMA_WATER_ANIM:
            [self playMamaWaterHitAnimation];
            break;
            
            
        default:
            break;
    }
}
-(void) showTrappingAnimationForGirl: (int) animIndex{
    [soundManager girl_hurt];
    switch (animIndex) {
        case GIRL_FLAME_ANIM:
            [self playGirlFlameHitAnimation];
            break;
        case GIRL_KNIFE_ANIM:
            [self playGirlKniveHitAnimation];
            break;
        case GIRL_SHOCK_ANIM:
            [self playGirlShockHitAnimation];
            break;
        case GIRL_WATER_ANIM:
            [self playGirlWaterHitAnimation];
            break;
        default:
            break;
    }
}

-(void) showTrappingAnimationForStrong: (int) animIndex{
    [soundManager strong_hurt];
    switch (animIndex) {
        case STRONG_FLAME_ANIM:
            [self playGirlFlameHitAnimation];
            break;
        case STRONG_KNIFE_ANIM:
            [self playStrongKniveHitAnimation];
            break;
        case STRONG_SHOCK_ANIM:
            [self playStrongShockHitAnimation];
            break;
        case STRONG_WATER_ANIM:
            [self playStrongWaterHitAnimation];
            break;
        default:
            break;
    }
}
-(void) playMamaKniveHitAnimation{
    [self addAnimation:MAMA_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:MAMA_KNIFE_ANIM_FRAME_PATH];
}
-(void)playStrongKniveHitAnimation{
    [self addAnimation:STRONG_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:STRONG_KNIFE_ANIM_FRAME_PATH];
}

-(void)playGirlKniveHitAnimation{
    [self addAnimation:GIRL_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:GIRL_KNIFE_ANIM_FRAME_PATH];
}


-(void)playMamaWaterHitAnimation{
    [self addAnimation:MAMA_WATER_ANIM_PATH noOfFrames:14 startingFrameName:MAMA_WATER_ANIM_FRAME_PATH];
}

-(void)playStrongWaterHitAnimation{
    [self addAnimation:STRONG_WATER_ANIM_PATH noOfFrames:14 startingFrameName:STRONG_WATER_ANIM_FRAME_PATH];
}

-(void)playGirlWaterHitAnimation{
    [self addAnimation:GIRL_WATER_ANIM_PATH noOfFrames:14 startingFrameName:GIRL_WATER_ANIM_FRAME_PATH];
}


-(void)playMamaShockHitAnimation{
    [self addAnimation:MAMA_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:MAMA_SHOCK_ANIM_FRAME_PATH];
}

-(void)playStrongShockHitAnimation{
    [self addAnimation:STRONG_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:STRONG_SHOCK_ANIM_FRAME_PATH];
}

-(void)playGirlShockHitAnimation{
    [self addAnimation:GIRL_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:GIRL_SHOCK_ANIM_FRAME_PATH];
}


-(void)playMamaMistHitAnimation{
    
}

-(void)playStrongMistHitAnimation{
    
}

-(void)playGirlMistHitAnimation{
    
}

-(void)playMamaFlameHitAnimation{
    [self addAnimation:MAMA_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:MAMA_FLAME_ANIM_FRAME_PATH];
}

-(void)playStrongFlameHitAnimation{
    [self addAnimation:STRONG_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:STRONG_FLAME_ANIM_FRAME_PATH];
}

-(void)playGirlFlameHitAnimation{
    [self addAnimation:GIRL_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:GIRL_FLAME_ANIM_FRAME_PATH];
}


-(void) addAnimation:(NSString *)plistName noOfFrames:(int)frames startingFrameName:(NSString *)startFrame{

//    if (trappingAnimationSprite != nil) {
//        [trappingAnimationSprite removeFromParentAndCleanup:YES];
//        trappingAnimationSprite = nil;
//    }
    [cache addSpriteFramesWithFile:[plistName stringByAppendingString:DOT_PLIST]];
    CCSpriteBatchNode *spriteSheets = [CCSpriteBatchNode batchNodeWithFile:[plistName stringByAppendingString:DOT_PNG]];
    [self addChild:spriteSheets z:10];
    
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= frames; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX],i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.03f];
    
    trappingAnimationSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX], 0]];
    if(!forwardChe){
        trappingAnimationSprite.position = ccp(heroSprite.position.x+heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }else{
        trappingAnimationSprite.position = ccp(heroSprite.position.x-heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        trappingAnimationSprite.scale = 1;
    }else{
        trappingAnimationSprite.scale=0.5;
    }
    [spriteSheets addChild:trappingAnimationSprite];
    
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:animation];
    [trappingAnimationSprite runAction:[CCRepeatForever actionWithAction:actionOne ]];

}

-(void)updateAnimationOnCurrentType:(int)frameToLoad animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"]){
        currentAnim =1;
        if (jumpingChe && frameToLoad == 1) {
            [self playJumpingAnimation];
            
        }else if (frameToLoad == 6 && !isLandingAnimationAdded){
            [self playLandingAnimation];
            
        }
        else if (frameToLoad == 0){
            fStr=[NSString stringWithFormat:[self getJumpingFrameNameForMice],1];
            isLandingAnimationAdded = NO;
            [self removeHeroSpriteFromBatchNode];
            heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
            heroSprite.tag = HERO_SPRITE_TAG;
            heroSprite.scale = STRONG_SCALE;
            if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
                [bootsSpriteSheet addChild:heroSprite z:10];
            }else{
                [spriteSheet addChild:heroSprite z:10];
            }
        }
        
    }
    else if([type isEqualToString:@"stand"] && currentAnim != 2){
        [self playStandingAnimation];
    }
    else if(heroSprite != nil && !heroSprite.visible && !landingChe){
        heroSprite.visible = YES;
    }
    
    heroSprite.position = ccp(platformX, platformY +5);
    heroSprite.scale = STRONG_SCALE;

}
-(void) playJumpingAnimation{
    NSString *frameName = [self getJumpingFrameNameForMice];
    isLandingAnimationAdded = NO;
    [self removeHeroSpriteFromBatchNode];
    heroSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,2]];
    heroSprite.tag = HERO_SPRITE_TAG;
    heroSprite.scale = STRONG_SCALE;
    NSMutableArray *animFrames2 = [NSMutableArray array];
    for(int i = 2; i <= 10; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
        [animFrames2 addObject:frame];
    }
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.03f];
    [heroSprite runAction:[CCAnimate actionWithAnimation:animation2]];
    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        [bootsSpriteSheet addChild:heroSprite z:10];
    }else{
        [spriteSheet addChild:heroSprite z:10];
    }

}

-(void) playLandingAnimation{
    //kamran
    isLandingAnimationAdded = YES;
    NSString *frameName = [self getJumpingFrameNameForMice];
    [self removeHeroSpriteFromBatchNode];
    heroSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,11]];
    heroSprite.tag = HERO_SPRITE_TAG;
    heroSprite.scale = STRONG_SCALE;
    NSMutableArray *animFrames2 = [NSMutableArray array];
    int length = 16;
    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        length = 11;
    }
    for(int i = 11; i <= length; i++) {

        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
        [animFrames2 addObject:frame];
    }
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.03f];
    [heroSprite runAction:[CCAnimate actionWithAnimation:animation2]];

    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        [bootsSpriteSheet addChild:heroSprite z:10];
    }else{
        [spriteSheet addChild:heroSprite z:10];
    }
    
    
}

-(void) playStandingAnimation{
    currentAnim = 2;
    NSString *frameName = [self getStandingFrameNameForMice];
    [heroSprite removeAllChildrenWithCleanup:YES];
    [self removeHeroSpriteFromBatchNode];
    heroSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName, 1]];
    heroSprite.tag = HERO_SPRITE_TAG;
    heroSprite.scale = STRONG_SCALE;
    NSMutableArray *animFrames2 = [NSMutableArray array];

    if([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        for(int i =1; i <= 25; i++) {//kamran

            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
            [animFrames2 addObject:frame];
        }
        [bootsSpriteSheet addChild:heroSprite z:10];
    }else{
        for(int i =1; i <= 26; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
            [animFrames2 addObject:frame];
        }
        [spriteSheet addChild:heroSprite z:10];
    }
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.03];
    [heroSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
    
}

-(void) removeHeroSpriteFromBatchNode{
    if ([spriteSheet getChildByTag:HERO_SPRITE_TAG] != nil) {
        [spriteSheet removeChild:heroSprite cleanup:YES];
    }
    if ([bootsSpriteSheet getChildByTag:HERO_SPRITE_TAG] != nil) {
        [bootsSpriteSheet removeChild:heroSprite cleanup:YES];
    }
}
-(void) removeHeroRunningSpriteFromBatchNode{
    if ([spriteSheet getChildByTag:HERO_RUN_SPRITE_TAG] != nil) {
        [spriteSheet removeChild:heroSprite cleanup:YES];
    }
    if ([bootsSpriteSheet getChildByTag:HERO_RUN_SPRITE_TAG] != nil) {
        [bootsSpriteSheet removeChild:heroSprite cleanup:YES];
    }
}
-(void)progressBarFunc{
    if(isScheduledTime){
        return;
    }
    isScheduledTime = YES;
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        heroRunSprite.scale = 1.6;
        heroPushSprite.scale = 1.6;
        heroSprite.scale = 1.6;
    }
    [self schedule:@selector(startTheHudLayerTimer) interval:1];
}

-(void) startTheHudLayerTimer{
    if (elapsedSeconds == 0) {
        [soundManager playGamePlayMusic];
    }
    elapsedSeconds += 1;
    
    if ([FTMUtil sharedInstance].isSlowDownTimer) {
        [self unschedule:@selector(startTheHudLayerTimer)];
        [FTMUtil sharedInstance].isSlowDownTimer = NO;
        [self schedule:@selector(startTheHudLayerTimer) interval:2];
        
    }
    
    int totalTimeInSec = 120;
    int oneMinInSec = 60;
    int remainigTimeInSec = totalTimeInSec - elapsedSeconds;
    int mins = remainigTimeInSec > oneMinInSec? 1:0;
    int seconnds = remainigTimeInSec>oneMinInSec?remainigTimeInSec-oneMinInSec:remainigTimeInSec;
    if(!mouseWinChe){
           [hudLayer updateTimeRemaining:mins andTimeInSec:seconnds];
        }
    if(remainigTimeInSec <= 0){
        [self stopTheHudLayerTimer];
    }
}

-(void) stopTheHudLayerTimer{
    
    [self unschedule:@selector(startTheHudLayerTimer)];
    // do after timer stuff here...
}

-(void) applyBoostPowerUpFeature{
    [FTMUtil sharedInstance].isBoostPowerUpEnabled = YES;
    
}

-(CCSprite *) addFireFlamesAnimation:(CGPoint) position{
    
    [cache addSpriteFramesWithFile:@"flamesAnimation.plist"];
    CCSprite * flames= [CCSprite spriteWithSpriteFrameName:@"flames_0.png"];
    flames.position = position;
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 32; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"flames_%d.png",i]];
        [animFrames addObject:frame4];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.03f];
    [flames runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];

    return flames;
}
-(void) addStrongMousePushingSprite{
    
    heroPushSprite = [CCSprite spriteWithSpriteFrameName:@"push1.png"];
    heroPushSprite.scale = STRONG_SCALE;
    heroPushSprite.position = ccp(200, 200);
    heroPushSprite.visible=NO;
    [spriteSheet addChild:heroPushSprite];
    NSMutableArray *animFrames2 = [NSMutableArray array];
    for(int i = 1; i < 23; i++) {
        CCSpriteFrame *frame2 = [cache spriteFrameByName:[NSString stringWithFormat:@"push%d.png",i]];
        [animFrames2 addObject:frame2];
    }
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.03f];
    [heroPushSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation2]]];

// for boots.
//    
//    [self removeHeroRunningSpriteFromBatchNode];
//    NSMutableArray *animFrames = [NSMutableArray array];
//    NSString *frameName = nil;
//    
//    if([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
//        frameName = @"sm1_run_%d.png";
//        heroRunSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,1]];
//        for(int i =0; i <= 11; i++) {//kamran
//            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
//            [animFrames addObject:frame];
//        }
//        [bootsSpriteSheet addChild:heroRunSprite z:10];
//    }
//    else{
//        frameName = @"strong_run0%d.png";
//        heroRunSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,1]];
//        for(int i =1; i <= 12; i++) {
//            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
//            [animFrames addObject:frame];
//        }
//        [spriteSheet addChild:heroRunSprite z:10];
//    }
//    
//    heroRunSprite.scale = 0.6;
//    heroRunSprite.tag = HERO_RUN_SPRITE_TAG;
//    heroRunSprite.position = ccp(200, 200);
//    heroRunSprite.visible = NO;
//    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.03f];
//    [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
}
-(void) addStrongMouseRunningSprite{
    [self removeHeroRunningSpriteFromBatchNode];
     NSMutableArray *animFrames = [NSMutableArray array];
    NSString *frameName = nil;
    
    if([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        frameName = @"strong_run_boots_%d.png";
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,1]];
        for(int i =1; i <= 11; i++) {//kamran

            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
            [animFrames addObject:frame];
        }
        [bootsSpriteSheet addChild:heroRunSprite z:10];
    }
    else{
        frameName = @"strong_run0%d.png";
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:frameName,1]];
        for(int i =1; i <= 12; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:frameName,i]];
            [animFrames addObject:frame];
        }
        [spriteSheet addChild:heroRunSprite z:10];
    }
    
    heroRunSprite.scale = STRONG_SCALE;
    heroRunSprite.tag = HERO_RUN_SPRITE_TAG;
    heroRunSprite.position = ccp(200, 200);
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.04f];

    [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
}

-(NSString *) getJumpingFrameNameForMice{
    NSString *frameName = nil;
    switch ([FTMUtil sharedInstance].mouseClicked) {
        case FTM_MAMA_MICE_ID:
            frameName = @"mother_jump%d.png";
            break;
        case FTM_STRONG_MICE_ID:
            if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
                frameName = @"strong_jump_boots_%d.png";

            }else{
                frameName = @"strong_jump%d.png";
            }
            break;
        case FTM_GIRL_MICE_ID:
            frameName = @"girl_jump%d.png";
            break;
        default:
            break;
    }
    return frameName;
}

-(void) playDoorLockAnimation :(CGPoint) position{
    if (locker != nil) {
        [locker removeFromParentAndCleanup:YES];
    }
    
    locker = [CCSprite spriteWithFile:@"lock.png"];
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        locker.scale = 1.4;
    }else{
        locker.scale = 0.7;
    }
    
    locker.position = ccp(position.x + 35, position.y);
    [self addChild:locker z:9];
    
    for (int i = 0; i < 3; i++) {
        CCSprite *cheese = [CCSprite spriteWithFile:@"lockcheese.png"];
        cheese.scale = 0;
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            cheese.position = ccp(- 30 +25*i, 45);
        }else{
            cheese.position = ccp(- 35 +37*i, 72);
        }
        
        [locker addChild:cheese];
        if (i+1 > cheeseCollectedScore) {
            cheese.opacity = 128;
        }
        float scalUp = [FTMUtil sharedInstance].isRetinaDisplay ? 1.6: 1;
        float scalDown = [FTMUtil sharedInstance].isRetinaDisplay ? 1.3: 0.9;
        CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.1 scale: scalUp];
        CCScaleTo *scaleDown = [CCScaleTo actionWithDuration:0.1 scale: scalDown];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:i*0.15];
        [cheese runAction:[CCSequence actions:delay, scaleUp,scaleDown, nil]];
    }
}
-(NSString *) getStandingFrameNameForMice{
    NSString *frameName = nil;
    switch ([FTMUtil sharedInstance].mouseClicked) {
        case FTM_MAMA_MICE_ID:
            frameName = @"mother_stand%d.png";
            break;
        case FTM_STRONG_MICE_ID:
            if([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
                frameName = @"strong_stand_boots_%d.png";

            }else{
                frameName = @"strong_stand%d.png";
            }
            break;
        case FTM_GIRL_MICE_ID:
            frameName = @"girl_stand%d.png";
            break;
        default:
            break;
    }
    return frameName;
}

-(void) switchAnimationsForBootsPowerUp{
    [self playStandingAnimation];
    [self addStrongMouseRunningSprite];
    
}

-(void) startClockTimer{
    [soundManager timer];
    [cache addSpriteFramesWithFile:@"newClockAnim.plist"];
    newClockSprite = [CCSprite spriteWithSpriteFrameName:@"timer_0.png"];
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        newClockSprite.scale = NON_RETINA_SCALE/1.25;
    }
    newClockSprite.position = ccp(450,250);
    [hudLayer addChild:newClockSprite z:9989];
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 59; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"timer_%d.png",i]];
        [animFrames addObject:frame4];
    }
    CCCallFunc *animDone = [CCCallFunc actionWithTarget:self selector:@selector(newClockAnimationDone)];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.5];
    [newClockSprite runAction:[CCSequence actions:[CCAnimate actionWithAnimation:animation], animDone, nil]];
    [self schedule:@selector(stopClockTimer) interval:4];
}

-(void) newClockAnimationDone{
    if (newClockSprite != nil) {
        [newClockSprite removeFromParentAndCleanup:YES];
        newClockSprite = nil;
    }
}
-(void) stopClockTimer{
    clockIntervalCounter++;
    [soundManager timer];
    if (clockIntervalCounter == 6) {
        [soundManager timer_all];
        clockIntervalCounter = 0;
        [self unschedule:@selector(stopClockTimer)];
    }
}

-(void) levelCompleted : (int) tag{
    isLevelCompleted = YES;
    if (newClockSprite != nil) {
        [self unschedule:@selector(stopClockTimer)];
        [newClockSprite removeFromParentAndCleanup:YES];
        newClockSprite = nil;
    }
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    [lvlCompleteLayer playStarImageAnimationAgainstLevel:cheeseCollectedScore];
    lvlCompleteLayer.tag = tag;
    [[GameKitHelper sharedGameKitHelper]submitScore:(int64_t)1000/(cheeseCollectedScore+1) category:kHighScoreLeaderboardCategory];
    [[GameKitHelper sharedGameKitHelper]reportAchievementIdentifier:kFtmFirstAchievementCategory percentComplete:100 maxValue:100 checkPercent:NO];
    [[[CCDirector sharedDirector] runningScene] addChild: lvlCompleteLayer z:2000];
}

-(void) showLevelFailedUI : (int) tag{
    hudLayer.visible = NO;
    if (newClockSprite != nil) {
        [self unschedule:@selector(stopClockTimer)];
        [newClockSprite removeFromParentAndCleanup:YES];
        newClockSprite = nil;
    }
    LevelFailedScreen *lvlFailedLayer = [[LevelFailedScreen alloc] init];
    [lvlFailedLayer setIfNextBtnDisable:tag];
    lvlFailedLayer.tag = tag;
    lvlFailedLayer.visible = YES;
    [[[CCDirector sharedDirector] runningScene] addChild: lvlFailedLayer z:999999];
}
-(void) playIceCubeApprearSound{
    [soundManager ice_cubes_appear];
}

-(void) scheduleFridgeMotorFallSound{
    [self schedule:@selector(playFridgeMotorSound) interval:1];
}

-(void) scheduleHotPotSmokeSound{
    [self schedule:@selector(playHotPotSound) interval:2];
}
-(void) unScheduleHotPotSmokeSound{
    [self unschedule:@selector(playHotPotSound)];
}
-(void) playFridgeMotorSound{
    [soundManager fridge_motor_loop];
}
-(void) playHotPotSound{
    [soundManager hot_pot_smoke];
}
-(void) mouseTrapped{
    
}
-(void) mamaAnimationWithType:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"]){
        if(fValue!=9)
            fStr=[NSString stringWithFormat:@"mother_jump0%d.png",fValue+1];
        else
            fStr=[NSString stringWithFormat:@"mother_jump%d.png",fValue+1];
    }else if([type isEqualToString:@"stand"])
        fStr=[NSString stringWithFormat:@"mother_stand0%d.png",fValue+1];
    else if([type isEqualToString:@"win"])
        fStr=@"mother_win01.png";
    
    [spriteSheet removeChild:heroSprite cleanup:YES];
    heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    heroSprite.position = ccp(platformX, platformY);
    heroSprite.scale = MAMA_SCALE;
    [spriteSheet addChild:heroSprite z:10];
  
}

-(void) girlAnimationWithType:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"girl_jump%d.png",fValue+1];
    else if([type isEqualToString:@"stand"]){
        fStr=[NSString stringWithFormat:@"girl_stand%d.png",fValue+1];
    }
    else if([type isEqualToString:@"win"])
        fStr=@"girl_win1.png";
    
    [spriteSheet removeChild:heroSprite cleanup:YES];
    heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    heroSprite.position = ccp(platformX, platformY);
    heroSprite.scale = GIRL_SCALE;
    [spriteSheet addChild:heroSprite z:10];
    
}
- (void)dealloc
{
    [[SimpleAudioEngine sharedEngine] stopAllEffects];
    [soundManager stopPlayingMusic];
    [super dealloc];
}

@end
