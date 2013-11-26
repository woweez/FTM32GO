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
        winSize = [CCDirector sharedDirector].winSize;
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        self.background.position = ccp(0, 0);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;// bhai
        }
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"girl_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"girl_default.png"];
        
        [self addChild:spriteSheet z:10];
        
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"girl_run1.png"];
        heroRunSprite.position = ccp(20, 200);
        heroRunSprite.scale = GIRL_SCALE;
        [spriteSheet addChild:heroRunSprite];
        
        heroSprite = [CCSprite spriteWithSpriteFrameName:@"girl_stand1.png"];
        heroSprite.position = ccp(20, 200);
        heroSprite.scale = GIRL_SCALE;
        [spriteSheet addChild:heroSprite];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_run%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.07f];
        [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        heroRunSprite.visible = NO;
        
        NSMutableArray *animFramesForStanding = [NSMutableArray array];
        for(int i = 1; i <= 2; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_stand%d.png",i]];
            [animFramesForStanding addObject:frame];
        }
        CCAnimation *standAnimation = [CCAnimation animationWithSpriteFrames:animFramesForStanding delay:1];
        [heroSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:standAnimation]]];
        
        [self addChild:_tileMap z:-1 tag:1];

        [self addHudLayerToTheScene];
        
    } 
    return self;
}

-(void) runTheMice{
    int speed = 2;
    CGPoint point = heroRunSprite.position;

    if (forwardChe) {
        heroRunSprite.position = ccp(heroRunSprite.position.x + speed, heroRunSprite.position.y);
    }else{
        if (heroRunSprite.flipX == 0) {
            heroRunSprite.position = ccp(heroRunSprite.position.x + 36, heroRunSprite.position.y);
        }
        heroRunSprite.flipX = 1;
        heroSprite.flipX = 1;
        heroRunSprite.position = ccp(heroRunSprite.position.x - speed, heroRunSprite.position.y);
    }
    
//    CGPoint point = heroRunSprite.position;
    [self setViewpointCenter:point];
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 2;
    [layer15 addChild: hudLayer z:2000];
//    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
    
}

-(void)setViewpointCenter:(CGPoint) position {
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
//    if(x<=winSize.width/2)
//        heroSprite.position.x=position.x;
//    else if(x>=_tileMap.mapSize.width-winSize.width/2)
//        screenHeroPosX=(position.x-x)+winSize.width/2;
//    if(y<=winSize.height/2)
//        screenHeroPosY=position.y;
//    else if(y>=_tileMap.mapSize.height-winSize.height/2)
//        screenHeroPosY=(position.y-y)+winSize.height/2;
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
    
}
-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted : 2];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    if((location.x < 70 || location.x > winSize.width - 70) && location.y < 70){
        heroSprite.visible = NO;
        if (location.x < 70) {
            forwardChe = NO;
            [self schedule:@selector(runTheMice) interval:0.01];
        }else{
            if (heroRunSprite.flipX == 1) {
                heroRunSprite.position = ccp(heroRunSprite.position.x - 36, heroRunSprite.position.y);
            }
            heroRunSprite.flipX = 0;
            heroSprite.flipX = 0;
            forwardChe = YES;
            [self schedule:@selector(runTheMice) interval:0.01];
        }
        
        heroRunSprite.visible = YES;
    }
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (heroRunSprite.visible) {
        heroRunSprite.visible = NO;
        heroSprite.visible = YES;
        heroSprite.position = ccp(heroRunSprite.position.x, heroRunSprite.position.y);
        [self unschedule:@selector(runTheMice)];
    }
}


@end
