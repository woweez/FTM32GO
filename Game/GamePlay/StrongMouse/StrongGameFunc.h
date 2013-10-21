//
//  CheesePosition.h
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import <Foundation/Foundation.h>
#import "Trigo.h"

@interface StrongGameFunc : NSObject{
    Trigo *trigo;
    int objectWidth;
    int objectHeight;
    int sideValueForObject;
    
    int gameLevel;
    CGFloat xPosition;
    CGFloat yPosition;
    BOOL reverseJump;
    BOOL landingChe;
    CGFloat jumpDiff;
    BOOL jumpDiffChe;
    BOOL autoJumpChe;
    BOOL autoJumpChe2;
    CGFloat autoJumpYPos2;
    BOOL minimumJumpingChe;
    BOOL topHittingCollisionChe;
    BOOL objectJumpChe;
    BOOL trappedChe;
    BOOL runChe;
    int switchCount;
    int autoJumpSpeedValue;
    int backHeroY;
    BOOL movePlatformChe;
    int movePlatformX;
    int movePlatformY;
    int landMoveCount;
    CGFloat stoolCount;
    CGFloat honeyPotCount;
    CGFloat honeyPotCount2;
    CGFloat honeyBottleCount;
    CGFloat honeyBottleCount2;
    BOOL pushChe;
    CGFloat appleWoodCount;
    CGFloat flowerFallRotate;
    BOOL flowerFallChe;
    CGFloat siverPotCount;
    CGFloat siverPotCount2;
    CGFloat toasterBreadCount;
    CGFloat boxCount;
    CGFloat boxCount2;
    CGFloat boxCount3;
    CGFloat boxCount4;
    BOOL visibleWindowChe;
    CGFloat teaPotCount;
    CGFloat teaPotCount2;
    CGFloat vesselsCount;
    CGFloat vesselsMoveCount;
    BOOL moveChe;
    CGFloat crackedMoveCount;
    CGFloat crackRotateValue;
    int saveTrigoCount[5];
    int trigoHeroAngle;
    BOOL trigoVisibleChe;
    BOOL trigoRunningCheck;
    int trigoJumpPower;
    BOOL trappedVesselsChe;
    CGFloat catStopWoodCount;
    BOOL domChe;
    CGFloat domeMoveCount;
    CGFloat domeAngle;
    BOOL domeEnterChe;
    BOOL domeSideChe;
    BOOL heightMoveChe;
    BOOL domeSwitchChe;
    CGFloat milkRotateCount;
    CGFloat combinationBoxPos[3][2];
    BOOL combinationChe[3];
    CGFloat exitCount;
    CGFloat milkMoveCount;
    CGFloat externCount;
    BOOL centerBoxChe;
    CGFloat blockCount[6][2];
    BOOL blockChe[6];
    BOOL releasePushChe;
    BOOL gateOpenChe;
    BOOL notCollideBlockChe;
    
}

@property (nonatomic, readwrite) int objectWidth;
@property (nonatomic, readwrite) int objectHeight;
@property (nonatomic, readwrite) int sideValueForObject;
@property (nonatomic, readwrite) CGFloat xPosition;
@property (nonatomic, readwrite) CGFloat yPosition;
@property (nonatomic, readwrite) BOOL reverseJump;
@property (nonatomic, readwrite) BOOL landingChe;
@property (nonatomic, readwrite) CGFloat jumpDiff;
@property (nonatomic, readwrite) BOOL jumpDiffChe;
@property (nonatomic, readwrite) BOOL autoJumpChe;
@property (nonatomic, readwrite) BOOL autoJumpChe2;
@property (nonatomic, readwrite) CGFloat autoJumpYPos2;
@property (nonatomic, readwrite) BOOL minimumJumpingChe;
@property (nonatomic, readwrite) int gameLevel;
@property (nonatomic, readwrite) BOOL topHittingCollisionChe;
@property (nonatomic, readwrite) BOOL objectJumpChe;
@property (nonatomic, readwrite) BOOL trappedChe;
@property (nonatomic, readwrite) BOOL runChe;
@property (nonatomic, readwrite) int switchCount;
@property (nonatomic, readwrite) int autoJumpSpeedValue;
@property (nonatomic, readwrite) CGFloat moveCount;
@property (nonatomic, readwrite) CGFloat moveCount2;
@property (nonatomic, readwrite) BOOL movePlatformChe;
@property (nonatomic, readwrite) int movePlatformX;
@property (nonatomic, readwrite) int movePlatformY;
@property (nonatomic, readwrite) int landMoveCount;
@property (nonatomic, readwrite) CGFloat stoolCount;
@property (nonatomic, readwrite) CGFloat honeyPotCount;
@property (nonatomic, readwrite) CGFloat honeyPotCount2;
@property (nonatomic, readwrite) CGFloat honeyBottleCount;
@property (nonatomic, readwrite) CGFloat honeyBottleCount2;
@property (nonatomic, readwrite) BOOL pushChe;
@property (nonatomic, readwrite) CGFloat appleWoodCount;
@property (nonatomic, readwrite) CGFloat flowerFallRotate;
@property (nonatomic, readwrite) BOOL flowerFallChe;
@property (nonatomic, readwrite) CGFloat siverPotCount;
@property (nonatomic, readwrite) CGFloat siverPotCount2;
@property (nonatomic, readwrite) CGFloat toasterBreadCount;
@property (nonatomic, readwrite) CGFloat boxCount;
@property (nonatomic, readwrite) CGFloat boxCount2;
@property (nonatomic, readwrite) BOOL visibleWindowChe;
@property (nonatomic, readwrite) CGFloat teaPotCount;
@property (nonatomic, readwrite) CGFloat teaPotCount2;
@property (nonatomic, readwrite) CGFloat vesselsCount;
@property (nonatomic, readwrite) CGFloat vesselsCount2;
@property (nonatomic, readwrite) CGFloat vesselsMoveCount;
@property (nonatomic, readwrite) BOOL moveChe;
@property (nonatomic, readwrite) CGFloat crackedMoveCount;
@property (nonatomic, readwrite) CGFloat crackRotateValue;
@property (nonatomic, readwrite) int trigoHeroAngle;
@property (nonatomic, readwrite) BOOL trigoVisibleChe;
@property (nonatomic, readwrite) BOOL trigoRunningCheck;
@property (nonatomic, readwrite) int trigoJumpPower;
@property (nonatomic, readwrite) BOOL trappedVesselsChe;
@property (nonatomic, readwrite) CGFloat catStopWoodCount;
@property (nonatomic, readwrite) BOOL domChe;
@property (nonatomic, readwrite) CGFloat domeMoveCount;
@property (nonatomic, readwrite) CGFloat domeAngle;
@property (nonatomic, readwrite) BOOL domeEnterChe;
@property (nonatomic, readwrite) BOOL domeSideChe;
@property (nonatomic, readwrite) BOOL heightMoveChe;
@property (nonatomic, readwrite) BOOL domeSwitchChe;
@property (nonatomic, readwrite) CGFloat milkRotateCount;
@property (nonatomic, readwrite) CGFloat exitCount;
@property (nonatomic, readwrite) CGFloat milkMoveCount;
@property (nonatomic, readwrite) CGFloat boxCount3;
@property (nonatomic, readwrite) CGFloat boxCount4;
@property (nonatomic, readwrite) CGFloat externCount;
@property (nonatomic, readwrite) BOOL centerBoxChe;
@property (nonatomic, readwrite) BOOL releasePushChe;
@property (nonatomic, readwrite) BOOL gateOpenChe;
@property (nonatomic, readwrite) BOOL notCollideBlockChe;



-(CGPoint)getCheesePosition:(int)wLevel gameLevel:(int)gLevel iValue:(int)iValue;
-(CGPoint)getPlatformPosition:(int)level;
-(void)runningRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)render;
-(CGFloat)getBox:(int)bValue pValue:(int)pValue;
-(void)setCombinationChe:(int)cValue;
-(void)setBoxValue:(int)iValue xValue:(CGFloat)xValue;
-(CGFloat)getBlockValue:(int)bValue pValue:(int)pValue;
-(void)setBlockChe:(int)cValue;
@end
