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


@synthesize tileMap = _tileMap;
@synthesize background = _background;



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
        
        
    } 
    return self;
}



-(void) moveTheBackground{
    int speed = 2;
    CGPoint point;
    
    if (forwardChe) {
        platformX += speed;
        point = ccp(platformX, platformY);
        
    }else{
        
        platformX -= speed;
        point = ccp(platformX, platformY);
    }
    
    [self setViewpointCenter:point];
}

-(void)setViewpointCenter:(CGPoint) position {
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);

    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
    
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
            [self schedule:@selector(moveTheBackground) interval:0.01];
        }else{
            forwardChe = YES;
            [self schedule:@selector(moveTheBackground) interval:0.01];
        }
        
    }
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}


@end
