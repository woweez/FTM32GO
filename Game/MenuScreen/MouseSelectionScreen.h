
//  Created by Muhammad Kamran on 15/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "sound.h"
#import "AppDelegate.h"

#define PTM_RATIO 32


@interface MouseSelectionScreen : CCLayer {
	CCMenu *menu;
    CCMenu *menu3;
    sound *soundEffect;
    int currentMouse;
    float xScale;
    float yScale;
    float cScale;
}

+(CCScene *) scene;
@end
