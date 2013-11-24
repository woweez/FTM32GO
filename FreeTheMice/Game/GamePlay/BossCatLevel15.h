//
//  BossCatLevel15.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 24/11/2013.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "CommonEngine.h"

@interface BossCatLevel15 : CommonEngine{

CCTMXTiledMap *_tileMap;
CCTMXLayer *_background;
    int motherLevel;
    

}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
+(CCScene *) scene;
@end
