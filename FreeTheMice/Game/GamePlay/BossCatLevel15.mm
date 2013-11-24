//
//  BossCatLevel15.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 24/11/2013.
//
//

#import "BossCatLevel15.h"
#import "FTMConstants.h"
#import "FTMUtil.h"

@implementation BossCatLevel15

CCNode *layer15;
@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer15=[CCNode node];
    [scene addChild:layer15 z:1];
    BossCatLevel15 *layer = [BossCatLevel15 node];
    [scene addChild: layer z:0];
    return scene;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        self.background.position = ccp(0, 0);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;// bhai
        }
        [self addChild:_tileMap z:-1 tag:1];

        [self addHudLayerToTheScene];
        
    } 
    return self;
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 2;
    [layer15 addChild: hudLayer z:2000];
//    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
    
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted : 2];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


@end
