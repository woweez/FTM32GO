//
//  sound.h
//  Racing
//
//  Created by karthik gopal on 28/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

@interface sound : NSObject {

}

-(void)initSound;
-(void)cheeseCollectedSound;
-(void)blocks_hitting_ground;
-(void)boxes_hitting_ground;
-(void)bulb_swaying;
-(void)button_1;
-(void)button_2;
-(void)cat;
-(void)cheese_1;
-(void)cheese_2;
-(void)cheese_3;
-(void)cheese_all;
-(void)correct_switch;
-(void)door_close;
-(void)electricity;
-(void)extinguish_pot;
-(void)flooding;
-(void)freezing;
-(void)fridge_motor_loop;
-(void)hot_pot_smoke;
-(void)ice_cubes_appear;
-(void)ice_cubes_fall;
-(void)knife_tray;
-(void)Lamp_hit_sway;
-(void)milk_carton;
-(void)plates_hitting_ground;
-(void)pot_hitting_ground;
-(void)pushing;
-(void)shelf_moving;
-(void)spil_milk;
-(void)stove_normal;
-(void)stove_violant;
-(void)switchSound;
-(void)timer;
-(void)timer_all;
-(void)tray_open_close;
-(void)vent_mist;
-(void)water_falling_from_vase;
-(void)water_sink_splash;

//music

-(void)playGamePlayMusic;
-(void)PlayWinMusic;
-(void)playLoseMusic;
-(void)playMenuMusic;
-(void)playStoryBoardMusic;

-(void)stopPlayingMusic;
-(BOOL)isMusicPlaying;
-(void)stopAllSoundEffects;



@end
