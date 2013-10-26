//
//  LevelFailedScreen.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 26/10/2013.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "sound.h"

@interface LevelFailedScreen : CCLayer{
    
    sound *soundEffect;
    CCMenu *menu;
    CCMenuItem *nextLevelMenuItem;
    float scaleFactorX;
    float scaleFactorY;
    float xScale;
    float yScale;
    float cScale;
}

-(void) setIfNextBtnDisable:(int) tag;
@end
