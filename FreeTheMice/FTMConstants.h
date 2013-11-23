//
//  FTMConstants.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 24/09/2013.
//
//
//get ptm ratio
#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
//#define PTM_RATIO (isIPad ? 64 : 32)
#define DEVICESCALE (isIPad ? 2 : 1)

#ifndef FreeTheMice_FTMConstants_h
#define FreeTheMice_FTMConstants_h


#define IS_RETINA_SUPPORT ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define STRONG_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.3 : 0.65)
#define MAMA_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.6 : 0.8)
#define GIRL_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.3 : 0.65)
#define MAMA_RUN_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.6 : 0.8)
#define MAMA_PUSH_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.6 : 0.8)
#define CAT_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.2 : 0.6)
#define MICE_TAIL_SCALE (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? 1.2 : 0.6)
//bhai
//convenience measurements
#define SCREEN [[CCDirector sharedDirector] winSize]
#define CURTIME CACurrentMediaTime()

#define NON_RETINA_SCALE (!IS_RETINA_SUPPORT ? 0.5 : 1)
//convenience functions
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low




#define FTM_MAMA_MICE_ID     1
#define FTM_STRONG_MICE_ID   2
#define FTM_GIRL_MICE_ID     3

#define DOT_PLIST               @".plist"
#define DOT_PNG                 @".png"
#define DOT_PNG_WITH_INDEX      @"%d.png"
#define YELLOW_FONT             @"yellowFont.png"
#define RED_FONT                @"redFont.png"

#define MAGNIFIER_ITEM_ID       1
#define SLOWDOWN_TIME_ITEM_ID   2
#define BOOTS_ITEM_ID           3
#define SPEEDUP_ITEM_ID         4
#define SPECIAL_CHEESE_ITEM_ID  5
#define MASTER_KEY_ITEM_ID      6
#define BARKING_DOG_ITEM_ID     7



#define HERO_SPRITE_TAG         211 // don't know why karthik name mice sprite to hero..
#define HERO_RUN_SPRITE_TAG          212  
//                                  THESE ARE MAMA MOUSE SETTINGS.


#define MAMA_SHOCK_ANIM     1
#define MAMA_WATER_ANIM     2
#define MAMA_FLAME_ANIM     3
#define MAMA_KNIFE_ANIM     4

//              NO COSTUME
#define MAMA_KNIFE_ANIM_PATH                    @"mama_knives_animation"
#define MAMA_KNIFE_ANIM_FRAME_PATH              @"mm_knives_hit_"
#define MAMA_WATER_ANIM_PATH                    @"mama_water_animation"
#define MAMA_WATER_ANIM_FRAME_PATH              @"mm_water_"
#define MAMA_FLAME_ANIM_PATH                    @"mama_flame_animation"
#define MAMA_FLAME_ANIM_FRAME_PATH              @"mm_flame_"
#define MAMA_SHOCK_ANIM_PATH                    @"mama_shock_animation"
#define MAMA_SHOCK_ANIM_FRAME_PATH              @"mm_shock_"

//                                 THESE ARE STRONG/MUSSLE MOUSE SETTINGS.


#define DRAG_SPRITE_OFFSET_X     12
#define DRAG_SPRITE_OFFSET_Y     8

#define HERO_SPRITE_TAG          211
#define HERO_RUN_SPRITE_TAG      212



//#if (IS_RETINA)
//#define RETINADISPLAY       2
//#endif

//
//#if(RETINADISPLAY == 2)
////HD Scales
//#define STRONG_SCALE            1.3 //0.7 for no HD.
//#define MAMA_SCALE              1.6
//#define GIRL_SCALE              1.3
//#define MAMA_RUN_SCALE          1.6
//#define MAMA_PUSH_SCALE         1.6
//#define CAT_SCALE               1.2
//#define MICE_TAIL_SCALE         1.2
//#else
//#define STRONG_SCALE            0.65 //0.7 for no HD.
//#define GIRL_SCALE              0.65
//#define MAMA_SCALE              0.8
//#define MAMA_RUN_SCALE          0.8
//#define MAMA_PUSH_SCALE         0.8
//#define CAT_SCALE               0.6
//#define MICE_TAIL_SCALE         0.6
//#endif



#define STRONG_SHOCK_ANIM     1
#define STRONG_WATER_ANIM     2
#define STRONG_FLAME_ANIM     3
#define STRONG_KNIFE_ANIM     4

//              NO COSTUME
#define STRONG_KNIFE_ANIM_PATH                  @"strong0_knife_anim"
#define STRONG_KNIFE_ANIM_FRAME_PATH            @"sm0_knives_hit_"
#define STRONG_WATER_ANIM_PATH                  @"strong0_water_anim"
#define STRONG_WATER_ANIM_FRAME_PATH            @"sm0_water_"
#define STRONG_FLAME_ANIM_PATH                  @"strong0_flame0_anim"
#define STRONG_FLAME_ANIM_FRAME_PATH            @"sm0_flame_"
#define STRONG_SHOCK_ANIM_PATH                  @"strong0_shock_anim"
#define STRONG_SHOCK_ANIM_FRAME_PATH            @"sm0_shock_"

//                                  THESE ARE GIRL MOUSE SETTINGS.


#define GIRL_SHOCK_ANIM     1
#define GIRL_WATER_ANIM     2
#define GIRL_FLAME_ANIM     3
#define GIRL_KNIFE_ANIM     4

//              NO COSTUME
#define GIRL_KNIFE_ANIM_PATH                    @"girl0_knife_anim"
#define GIRL_KNIFE_ANIM_FRAME_PATH              @"gm0_knives_hit_"
#define GIRL_WATER_ANIM_PATH                    @"girl0_water_anim"
#define GIRL_WATER_ANIM_FRAME_PATH              @"gm0_water_"
#define GIRL_FLAME_ANIM_PATH                    @"girl0_flame_anim"
#define GIRL_FLAME_ANIM_FRAME_PATH              @"gm0_flame_"
#define GIRL_SHOCK_ANIM_PATH                    @"girl0_shock_anim"
#define GIRL_SHOCK_ANIM_FRAME_PATH              @"gm0_shock_"



//Sound effects and music

#define BLOCKS_HITTING_GROUND               @"blocks_hitting_ground.mp3"
#define BOXES_HITTING_GROUND                @"boxes_hitting_ground.mp3"
#define BULD_SWAYING                        @"bulb_swaying.mp3"
#define BUTTON_1                            @"button_1.mp3"
#define BUTTON_2                            @"button_2.mp3"
#define BUTTON_ACTIVATE                     @"button_activate.mp3"
#define BUTTON_DEACTIVATE                   @"button_deactivate.mp3"
#define CAT                                 @"cat.mp3"
#define CHEESE_1                            @"cheese_1.mp3"
#define CHEESE_2                            @"cheese_2.mp3"
#define CHEESE_3                            @"cheese_3.mp3"
#define CHEESE_ALL                          @"cheese_all.mp3"
#define CORRECT_SWITCH                      @"correct_switch.mp3"
#define DOOR_CLOSE                          @"door_close.mp3"
#define ELECTRICITY                         @"electricity.mp3"
#define EXTINGUISH_POT                      @"extinguish_pot.mp3"
#define FLOODING                            @"flooding.mp3"
#define FREEZING                            @"freezing.mp3"
#define FRIDGE_MOTOR_LOOP                   @"fridge_motor_loop.mp3"
#define HOT_POT_SMOKE                       @"hot_pot_smoke.mp3"
#define ICE_CUBES_APPEAR                    @"ice_cubes_appear.mp3"
#define ICE_CUBES_FALL                      @"ice_cubes_fall.mp3"
#define KNIFE_TRAY                          @"knife_tray.mp3"
#define LAMP_HIT_AWAY                       @"Lamp_hit_sway.mp3"
#define MILK_CARTOON                        @"milk_carton.mp3"
#define PLATES_HITTING_GROUND               @"plates_hitting_ground.mp3"
#define POT_HITTING_GROUND                  @"pot_hitting_ground.mp3"
#define PUSHING                             @"pushing.mp3"
#define SHELF_MOVING                        @"shelf_moving.mp3"
#define SPIL_MILK                           @"spil_milk.mp3"
#define STOVE_NORMAL                        @"stove_normal.mp3"
#define STOVE_VIOLANT                       @"stove_violant.mp3"
#define SWITCH                              @"switch.mp3"
#define TIMER                               @"timer.mp3"
#define TIMER_ALL                           @"timer_all.mp3"
#define TRAY_OPEN_CLOSE                     @"tray_open_close.mp3"
#define VENT_MIST                           @"vent_mist.mp3"
#define WATER_FALLING_FROM_VASE             @"water_falling_from_vase.mp3"
#define WATER_SINK_SPLASH                   @"water_sink_splash.mp3"

//music

#define GAME_PLAY                           @"Game_Play.mp3"
#define LOSE                                @"Lose.mp3"
#define WIN                                 @"Win.mp3"
#define MENU                                @"Menu.mp3"
#define STORY_BOARD                         @"Opening_Storyboard.mp3"


#endif
