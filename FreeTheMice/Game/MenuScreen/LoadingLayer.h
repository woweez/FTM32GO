//
//  LoadingLayer.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 23/11/2013.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
@interface LoadingLayer : CCLayer {
    
    float xScale;
    float yScale;
    float cScale;
    int currentMouse;
}
+(CCScene *) scene :(int) catId levelNo:(int) lvl;
-(void) addAnimation;
-(void) setLevel:(int)lvl;
@end
