//
//  sound.m
//  Racing
//
//  Created by karthik gopal on 28/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "sound.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"
#import "FTMConstants.h"
#import "FTMUtil.h"

@implementation sound
-(void)initSound{
    
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_2];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_3];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BLOCKS_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BOXES_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BULD_SWAYING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_2];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_ACTIVATE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_DEACTIVATE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CAT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_ALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CORRECT_SWITCH];
    [[SimpleAudioEngine sharedEngine] preloadEffect: DOOR_CLOSE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ELECTRICITY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: EXTINGUISH_POT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FLOODING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FREEZING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FRIDGE_MOTOR_LOOP];
    [[SimpleAudioEngine sharedEngine] preloadEffect: HOT_POT_SMOKE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ICE_CUBES_APPEAR];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ICE_CUBES_FALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: KNIFE_TRAY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: LAMP_HIT_AWAY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: MILK_CARTOON];
    [[SimpleAudioEngine sharedEngine] preloadEffect: PLATES_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: POT_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: PUSHING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: SHELF_MOVING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: SPIL_MILK];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STOVE_NORMAL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STOVE_VIOLANT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TIMER];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TIMER_ALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TRAY_OPEN_CLOSE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: VENT_MIST];
    [[SimpleAudioEngine sharedEngine] preloadEffect: WATER_FALLING_FROM_VASE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: WATER_SINK_SPLASH];
    [[SimpleAudioEngine sharedEngine] preloadEffect: PULLING_TAIL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_4];
    [[SimpleAudioEngine sharedEngine] preloadEffect: MAMA_HURT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: MAMA_JUMP];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STRONG_HURT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STRONG_JUMP];
    [[SimpleAudioEngine sharedEngine] preloadEffect: GIRL_HURT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: GIRL_JUMP];
    
    //music
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: GAME_PLAY];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: LOSE];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: STORY_BOARD];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: GAME_PLAY];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: WIN];

}
-(void)cheeseCollectedSound{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_1 loop:NO];

}
-(void)blocks_hitting_ground{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:BLOCKS_HITTING_GROUND loop:NO];
}
-(void)boxes_hitting_ground{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:BOXES_HITTING_GROUND loop:NO];
}
-(void)bulb_swaying{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:BULD_SWAYING loop:NO];
}
-(void)button_1{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_1 loop:NO];
}
-(void)button_2{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_2 loop:NO];
}
-(void)cat{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CAT loop:NO];
}
-(void)cheese_1{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_1 loop:NO];
}
-(void)cheese_2{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_2 loop:NO];
}
-(void)cheese_3{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_3 loop:NO];
}
-(void)cheese_4{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_4 loop:NO];
}
-(void)cheese_all{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CHEESE_ALL loop:NO];
}
-(void)correct_switch{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:SWITCH loop:NO];
}
-(void)door_close{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:DOOR_CLOSE loop:NO];
}
-(void)electricity{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:ELECTRICITY loop:NO];
}
-(void)extinguish_pot{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:EXTINGUISH_POT loop:NO];
}
-(void)flooding{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:FLOODING loop:NO];
}
-(void)freezing{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:FREEZING loop:NO];
}
-(void)fridge_motor_loop{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:FRIDGE_MOTOR_LOOP loop:NO];
}
-(void)hot_pot_smoke{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:HOT_POT_SMOKE loop:NO];
}
-(void)ice_cubes_appear{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:ICE_CUBES_APPEAR loop:NO];
}
-(void)ice_cubes_fall{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:ICE_CUBES_FALL loop:NO];
}
-(void)knife_tray{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:KNIFE_TRAY loop:NO];
}
-(void)Lamp_hit_sway{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:LAMP_HIT_AWAY loop:NO];
}
-(void)milk_carton{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:MILK_CARTOON loop:NO];
}
-(void)plates_hitting_ground{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:PLATES_HITTING_GROUND loop:NO];
}
-(void)pot_hitting_ground{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:POT_HITTING_GROUND loop:NO];
}
-(void)pushing{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:PUSHING loop:NO];
}
-(void)shelf_moving{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:SHELF_MOVING loop:NO];
}
-(void)spil_milk{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:SPIL_MILK loop:NO];
}
-(void)stove_normal{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:STOVE_NORMAL loop:NO];
}
-(void)stove_violant{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:STOVE_VIOLANT loop:NO];
}
-(void)switchSound{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:CORRECT_SWITCH loop:NO];
}
-(void)timer{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:TIMER loop:NO];
}
-(void)timer_all{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:TIMER_ALL loop:NO];
}
-(void)tray_open_close{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:TRAY_OPEN_CLOSE loop:NO];
}
-(void)vent_mist{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:VENT_MIST loop:NO];
}
-(void)water_falling_from_vase{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:WATER_FALLING_FROM_VASE loop:NO];
}
-(void)water_sink_splash{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:WATER_SINK_SPLASH loop:NO];
}
-(void)pulling_tail{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:PULLING_TAIL loop:NO];
}
-(void) mama_hurt{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:MAMA_HURT loop:NO];
}
-(void) mama_jump{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:MAMA_JUMP loop:NO];
}
-(void) strong_hurt{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:STRONG_HURT loop:NO];
}
-(void) strong_jump{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:STRONG_JUMP loop:NO];
}
-(void) girl_hurt{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:GIRL_HURT loop:NO];
}
-(void) girl_jump{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:GIRL_JUMP loop:NO];
}



//music

-(void)playGamePlayMusic{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
     [[SimpleAudioEngine sharedEngine] playBackgroundMusic:GAME_PLAY loop:YES];
}

-(void)PlayWinMusic{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:WIN loop:NO];
}

-(void)playLoseMusic{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:LOSE loop:NO];
}

-(void)playStoryBoardMusic{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:STORY_BOARD loop:NO];
}

-(void)stopPlayingMusic{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) playMenuMusic{
    if (![FTMUtil sharedInstance].isGameSoundOn) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:MENU loop:YES];
}

-(BOOL)isMusicPlaying{
   return  [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
}

-(void)stopAllSoundEffects{
    [[SimpleAudioEngine sharedEngine] stopAllEffects];
}


-(void) dealloc {
	[super dealloc];
}
@end
