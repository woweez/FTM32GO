//
//  Trigo.h
//  Game
//
//  Created by karthik gopal on 13/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Trigo : NSObject {

}
-(int) sin:(int) angle;
-(int) cos:(int) angle;
-(float) circlex:(float) radius a:(float)angle;
-(float) circley:(float) radius a:(float) angle;
-(float) bounceCirclex:(float) radius a:(float)angle;
-(float) bounceCircley:(float) radius a:(float)angle;
-(CGFloat)findAngle:(CGFloat)mainX lmainY:(CGFloat)mainY lfindX:(CGFloat)findX lfindY:(CGFloat)findY angleChe:(BOOL)aChe;
@end
