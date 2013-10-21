//
//  ToolShedScreen.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 28/09/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SWScrollView.h"
#import "sound.h"
@interface ToolShedScreen : CCLayer{

float scaleFactorX;
float scaleFactorY;
    SWScrollView *scrollView;
    CCMenuItem *powerUpItem;
    CCMenuItem *costumesItem;
    CCLabelAtlas *totalCheese;
    sound *soundEffect;
    
    float xScale;
    float yScale;
    float cScale;
}
+(CCScene *) scene;
-(void) updateCheeseCount : (NSString *) notifier;
@end
