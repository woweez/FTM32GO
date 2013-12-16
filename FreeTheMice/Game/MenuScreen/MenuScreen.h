//
//  HelloWorldLayer.h
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "sound.h"
#import "AppDelegate.h"

#define PTM_RATIO 32


@interface MenuScreen : CCLayer {
	CCMenu *menu;
    sound *soundEffect;
    CCSprite *slidingBgForAbout;
    CCSprite *slidingBgForSettings;
    CCSprite *backgroundForSocial;
    CCMenu *gameCenterBtnMenu;
    CCMenu *storeBtnMenu;
    CCMenu *backFromSocial;
    CCMenu *postBtn;
    float scaleFactorX;
    float scaleFactorY;
    float xScale;
    float yScale;
    
    CCMenuItem *soundOn;
    CCMenuItem *soundOff;
    float cScale;
}
@property (nonatomic,retain) IBOutlet UIWebView *_webView;
+(CCScene *) scene;
@end
