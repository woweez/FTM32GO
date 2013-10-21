
//  Created by Muhammad Kamran on 21/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//

#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "sound.h"
#import "AppDelegate.h"

#define PTM_RATIO 32


@interface LevelCompleteScreen : CCLayer {
	CCMenu *menu;
    sound *soundEffect;
    float scaleFactorX;
    float scaleFactorY;

    CCSprite *levelCompleteBg;
    CCLayer *parentReference;

    CCLabelAtlas * score;
    
}
@end
