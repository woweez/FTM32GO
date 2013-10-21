//
//  CheesePosition.h
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import <Foundation/Foundation.h>
#import "Trigo.h"

@interface GirlGameFunc : NSObject{
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
    BOOL visibleWindowChe;
    BOOL stickyChe;
    BOOL stickyChe2;
    int stickyCount;
    int saveTrigoCount[5];
    BOOL trigoVisibleChe;
    int trigoHeroAngle;
    BOOL trigoRunningCheck;
    int stickyReleaseCount;
    int plateWoodStopCount;
    BOOL domChe;
    CGFloat domeMoveCount;
    CGFloat domeAngle;
    BOOL domeEnterChe;
    BOOL domeSideChe;
    BOOL heightMoveChe;
    BOOL domeSwitchChe;
    CGFloat platformRotateCount;
    BOOL heroRotateChe;
    BOOL heroRotateDomeChe;
    BOOL gateOpenChe;
    BOOL closeOpenChe;
    CGFloat bridgeOpenCount;
    BOOL catFirstJumpChe;
        
}
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
@property (nonatomic, readwrite) BOOL visibleWindowChe;
@property (nonatomic, readwrite) BOOL stickyChe;
@property (nonatomic, readwrite) int stickyCount;
@property (nonatomic, readwrite) BOOL trigoVisibleChe;
@property (nonatomic, readwrite) int trigoHeroAngle;
@property (nonatomic, readwrite) BOOL trigoRunningCheck;
@property (nonatomic, readwrite) BOOL stickyChe2;
@property (nonatomic, readwrite) int stickyReleaseCount;
@property (nonatomic, readwrite) int plateWoodStopCount;
@property (nonatomic, readwrite) BOOL domChe;
@property (nonatomic, readwrite) CGFloat domeMoveCount;
@property (nonatomic, readwrite) CGFloat domeAngle;
@property (nonatomic, readwrite) BOOL domeEnterChe;
@property (nonatomic, readwrite) BOOL domeSideChe;
@property (nonatomic, readwrite) BOOL heightMoveChe;
@property (nonatomic, readwrite) BOOL domeSwitchChe;
@property (nonatomic, readwrite) CGFloat platformRotateCount;
@property (nonatomic, readwrite) BOOL heroRotateChe;
@property (nonatomic, readwrite) BOOL heroRotateDomeChe;
@property (nonatomic, readwrite) BOOL gateOpenChe;
@property (nonatomic, readwrite) BOOL closeOpenChe;
@property (nonatomic, readwrite) CGFloat bridgeOpenCount;
@property (nonatomic, readwrite) BOOL catFirstJumpChe;



-(CGPoint)getCheesePosition:(int)wLevel gameLevel:(int)gLevel iValue:(int)iValue;
-(CGPoint)getPlatformPosition:(int)level;
-(void)runningRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe;
-(void)render;
@end
