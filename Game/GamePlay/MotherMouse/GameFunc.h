//
//  CheesePosition.h
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import <Foundation/Foundation.h>
#import "Trigo.h"

@interface GameFunc : NSObject{
    Trigo *trigo;
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
    int saveTrigoCount[5];
    BOOL trigoVisibleChe;
    int trigoHeroAngle;
    BOOL trigoRunningCheck;
    BOOL horizandalMoveChe;
    BOOL heightMoveChe;
    BOOL moveSideChe;
    BOOL switchStrChe;
    BOOL switchCheckChe;
    BOOL domChe;
    //level 5
    CGFloat moveCount,moveCount2;
    CGFloat moveCount3;
    CGFloat heightDivide;
    CGFloat domeAngle;
    BOOL domeEnterChe;
    BOOL domeSideChe;
    CGFloat domeMoveCount;
    BOOL domeSwitchChe;
    int vegetableCount;
    BOOL level8PlatforChe;
    BOOL switchChe2;
    int screenMoveValue;
    BOOL vegetableTouchChe;
    BOOL switchStatusChe;
    BOOL switchStatusChe2;
    BOOL switchStatusChe3;
    int switchStatusValue;
    int switchHitValue;
    BOOL visibleLevel9Che;
    int speedReverseJump;
    BOOL gateOpenChe;
    int objectWidth;
    int objectHeight;
    int sideValueForObject;
    
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
@property (nonatomic, readwrite) CGFloat moveCount3;
@property (nonatomic, readwrite) BOOL movePlatformChe;
@property (nonatomic, readwrite) int movePlatformX;
@property (nonatomic, readwrite) int movePlatformY;
@property (nonatomic, readwrite) int landMoveCount;
@property (nonatomic, readwrite) BOOL trigoVisibleChe;
@property (nonatomic, readwrite) int trigoHeroAngle;
@property (nonatomic, readwrite) BOOL trigoRunningCheck;
@property (nonatomic, readwrite) BOOL horizandalMoveChe;
@property (nonatomic, readwrite) CGFloat heightDivide;
@property (nonatomic, readwrite) BOOL moveSideChe;
@property (nonatomic, readwrite) BOOL heightMoveChe;
@property (nonatomic, readwrite) BOOL switchStrChe;
@property (nonatomic, readwrite) BOOL domChe;
@property (nonatomic, readwrite)  CGFloat domeAngle;
@property (nonatomic, readwrite) BOOL domeEnterChe;
@property (nonatomic, readwrite) BOOL domeSideChe;
@property (nonatomic, readwrite) CGFloat domeMoveCount;
@property (nonatomic, readwrite)  BOOL domeSwitchChe;
@property (nonatomic, readwrite) int vegetableCount;
@property (nonatomic, readwrite)  BOOL level8PlatforChe;
@property (nonatomic, readwrite)  BOOL switchChe2;
@property (nonatomic, readwrite) int screenMoveValue;
@property (nonatomic, readwrite)  BOOL vegetableTouchChe;
@property (nonatomic, readwrite)   BOOL switchStatusChe;
@property (nonatomic, readwrite)   BOOL switchStatusChe2;
@property (nonatomic, readwrite)   BOOL switchStatusChe3;
@property (nonatomic, readwrite)    int switchHitValue;
@property (nonatomic, readwrite)   BOOL visibleLevel9Che;
@property (nonatomic, readwrite)    int switchStatusValue;
@property (nonatomic, readwrite)     int speedReverseJump;
@property (nonatomic, readwrite)    BOOL gateOpenChe;

-(CGPoint)getCheesePosition:(int)wLevel gameLevel:(int)gLevel iValue:(int)iValue;
-(CGPoint)getPlatformPosition:(int)level;
-(void)runningRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)render;
@end
