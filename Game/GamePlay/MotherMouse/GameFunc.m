//
//  CheesePosition.m
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import "GameFunc.h"
#import "cocos2d.h"

@implementation GameFunc

@synthesize objectWidth;
@synthesize objectHeight;
@synthesize sideValueForObject;
@synthesize xPosition;
@synthesize yPosition;
@synthesize reverseJump;
@synthesize landingChe;
@synthesize jumpDiff;
@synthesize jumpDiffChe;
@synthesize autoJumpChe;
@synthesize autoJumpChe2;
@synthesize autoJumpYPos2;
@synthesize minimumJumpingChe;
@synthesize gameLevel;
@synthesize topHittingCollisionChe;
@synthesize objectJumpChe;
@synthesize trappedChe;
@synthesize  runChe;
@synthesize switchCount;
@synthesize autoJumpSpeedValue;
@synthesize moveCount;
@synthesize moveCount2;
@synthesize moveCount3;
@synthesize movePlatformChe;
@synthesize movePlatformX;
@synthesize movePlatformY;
@synthesize landMoveCount;
@synthesize trigoVisibleChe;
@synthesize trigoHeroAngle;
@synthesize trigoRunningCheck;
@synthesize horizandalMoveChe;
@synthesize heightDivide;
@synthesize moveSideChe;
@synthesize heightMoveChe;
@synthesize switchStrChe;
@synthesize domChe;
@synthesize domeAngle;
@synthesize domeEnterChe;
@synthesize domeSideChe;
@synthesize domeMoveCount;
@synthesize domeSwitchChe;
@synthesize vegetableCount;
@synthesize level8PlatforChe;
@synthesize switchChe2;
@synthesize screenMoveValue;
@synthesize vegetableTouchChe;
@synthesize switchStatusChe;
@synthesize switchStatusChe2;
@synthesize switchStatusChe3;
@synthesize switchHitValue;
@synthesize visibleLevel9Che;
@synthesize switchStatusValue;
@synthesize speedReverseJump;
@synthesize gateOpenChe;

-(id) init {
    if( (self=[super init])) {
        trigo=[[Trigo alloc] init];
        heightDivide=234;
        moveSideChe=NO;
        domeAngle=0;
        vegetableCount=0;
        moveCount2=0;
        switchStatusChe=YES;
    }
    return self;
}

-(CGPoint)getCheesePosition:(int)wLevel gameLevel:(int)gLevel iValue:(int)iValue{
    
    
    CGPoint cheesePosition;
    if(wLevel ==1){
        if(gLevel ==1){
            if(iValue ==0)
                cheesePosition = ccp(200, 160);
            else if(iValue==1)
                cheesePosition = ccp(325, 160);
            else if(iValue==2)
                cheesePosition = ccp(450, 160);
            else if(iValue==3)
                cheesePosition = ccp(575, 160);
            else if(iValue==4)
                cheesePosition = ccp(700, 160);
        }else if(gLevel ==2){
            if(iValue==0)
                cheesePosition = ccp(340, 320);
            else if(iValue==1)
                cheesePosition = ccp(616, 394);
            else if(iValue==2)
                cheesePosition = ccp(480, 584);
            else if(iValue==3)
                cheesePosition = ccp(616, 453);
            else if(iValue==4)
                cheesePosition = ccp(800, 450);
        }else if(gLevel == 3){
            if(iValue==0)
                cheesePosition = ccp(373, 440);
            else if(iValue==1)
                cheesePosition = ccp(686, 477);
            else if(iValue==2)
                cheesePosition = ccp(828, 477);
            else if(iValue==3)
                cheesePosition = ccp(438, 360);
            else if(iValue==4)
                cheesePosition = ccp(736, 345);
        }else if(gLevel == 4){
            if(iValue==0)
                cheesePosition = ccp(200, 334);
            else if(iValue==1)
                cheesePosition = ccp(950, 559);
            else if(iValue==2)
                cheesePosition = ccp(330, 537);
            else if(iValue==3)
                cheesePosition = ccp(915, 354);
            else if(iValue==4)
                cheesePosition = ccp(540, 260);
        }else if(gLevel == 5){
            if(iValue==0)
                cheesePosition = ccp(970, 613);
            else if(iValue==1)
                cheesePosition = ccp(732, 471);
            else if(iValue==2)
                cheesePosition = ccp(350, 471);
            else if(iValue==3)
                cheesePosition = ccp(40, 562);
            else if(iValue==4)
                cheesePosition = ccp(50, 369);
        }else if(gLevel == 6){
            if(iValue==0)
                cheesePosition = ccp(464, 259);
            else if(iValue==1)
                cheesePosition = ccp(672, 259);
            else if(iValue==2)
                cheesePosition = ccp(750, 443);
            else if(iValue==3)
                cheesePosition = ccp(920, 601);
            else if(iValue==4)
                cheesePosition = ccp(20, 517);
        }else if(gLevel == 7){
            if(iValue==0)
                cheesePosition = ccp(387, 360);
            else if(iValue==1)
                cheesePosition = ccp(277, 272);
            else if(iValue==2)
                cheesePosition = ccp(107, 550);
            else if(iValue==3)
                cheesePosition = ccp(655, 374);
            else if(iValue==4)
                cheesePosition = ccp(895, 258);
        }else if(gLevel == 8){
            if(iValue==0)
                cheesePosition = ccp(445, 425);
            else if(iValue==1)
                cheesePosition = ccp(277, 505);
            else if(iValue==2)
                cheesePosition = ccp(850, 584);
            else if(iValue==3)
                cheesePosition = ccp(550, 295);
            else if(iValue==4)
                cheesePosition = ccp(950, 258);
        }else if(gLevel == 9){
            if(iValue==0)
                cheesePosition = ccp(340, 425);
            else if(iValue==1)
                cheesePosition = ccp(350, 555);
            else if(iValue==2)
                cheesePosition = ccp(530, 258);
            else if(iValue==3)
                cheesePosition = ccp(960, 588);
            else if(iValue==4)
                cheesePosition = ccp(700, 334);
            
        }else if(gLevel == 10){
            if(iValue==0)
                cheesePosition = ccp(120, 295);
            else if(iValue==1)
                cheesePosition = ccp(200, 392);
            else if(iValue==2)
                cheesePosition = ccp(540, 298);
            else if(iValue==3)
                cheesePosition = ccp(930, 185);
            else if(iValue==4)
                cheesePosition = ccp(870, 315);
        }else if(gLevel == 11){
            if(iValue==0)
                cheesePosition = ccp(220, 185);
            else if(iValue==1)
                cheesePosition = ccp(30, 305);
            else if(iValue==2)
                cheesePosition = ccp(830, 205);
            else if(iValue==3)
                cheesePosition = ccp(30, 520);
            else if(iValue==4)
                cheesePosition = ccp(30, 620);
        }else if(gLevel == 12){
            if(iValue==0)
                cheesePosition = ccp(40, 90);
            else if(iValue==1)
                cheesePosition = ccp(800, 175);
            else if(iValue==2)
                cheesePosition = ccp(490, 300);
            else if(iValue==3)
                cheesePosition = ccp(210, 400);
            else if(iValue==4)
                cheesePosition = ccp(1120, 480);
        }else if(gLevel == 13){
            if(iValue==0)
                cheesePosition = ccp(20, 260);
            else if(iValue==1)
                cheesePosition = ccp(485, 260);
            else if(iValue==2)
                cheesePosition = ccp(25, 596);
            else if(iValue==3)
                cheesePosition = ccp(415, 539);
            else if(iValue==4)
                cheesePosition = ccp(960, 260);
            
        }else if(gLevel == 14){
            if(iValue==0)
                cheesePosition = ccp(30, 260);
            else if(iValue==1)
                cheesePosition = ccp(580, 362);
            else if(iValue==2)
                cheesePosition = ccp(350, 546);
            else if(iValue==3)
                cheesePosition = ccp(795, 541);
            else if(iValue==4)
                cheesePosition = ccp(940, 260);
            
        }
    }
    return cheesePosition;
}

-(CGPoint)getPlatformPosition:(int)level {
    CGPoint platformPosition;
    if(level==1)
        platformPosition=ccp(-50,160);
    else if(level==2)
        platformPosition=ccp(-50,230);
    else if(level==3)
        platformPosition=ccp(-50,353);
    else if(level==4)
        platformPosition=ccp(-50,266);
    else if(level==5)
        platformPosition=ccp(-50,266);
    else if(level==6)
        platformPosition=ccp(-50,266);
    else if(level==7)
        platformPosition=ccp(-50,266);
    else if(level==8)
        platformPosition=ccp(-50,266);
    else if(level==9)
        platformPosition=ccp(-50,266);
    else if(level==10)
        platformPosition=ccp(-50,190);
    else if(level==11)
        platformPosition=ccp(-50,190);
    else if(level==12)
        platformPosition=ccp(-50,90);
    else if(level==13)
       platformPosition=ccp(80,266);
    else if(level==14)
        platformPosition=ccp(120,266);
    
    return platformPosition;
}

-(void)render{
    
    if(gameLevel==5){
        moveCount+=0.6;
        moveCount=(moveCount>300?0:moveCount);
        moveCount2=(moveCount<=150?moveCount:150-(moveCount-150));
    }else if(gameLevel==6){
        if(!moveSideChe){
            if(!heightMoveChe){
                if(!horizandalMoveChe){
                    moveCount2+=0.6;
                    if(moveCount2>=163){
                        moveCount2=163;
                        heightMoveChe=YES;
                    }
                }else
                    heightMoveChe=YES;
            }else {
                moveCount2-=0.6;
                if(moveCount2<=0){
                    moveCount2=0;
                    heightMoveChe=NO;
                    if(horizandalMoveChe){
                        moveSideChe=YES;
                        horizandalMoveChe=NO;
                        landMoveCount=0;
                        movePlatformX=xPosition;
                        movePlatformY=yPosition;
                        switchCheckChe=NO;
                    }
                }
            }
        }else{
            if(!heightMoveChe){
                if(!horizandalMoveChe){
                    moveCount3+=0.6;
                    if(moveCount3>=518){
                        moveCount3=518;
                        heightMoveChe=YES;
                    }
                }else
                    heightMoveChe=YES;
            }else {
                moveCount3-=0.6;
                if(moveCount3<=0){
                    moveCount3=0;
                    heightMoveChe=NO;
                    if(horizandalMoveChe){
                        moveSideChe=NO;
                        horizandalMoveChe=NO;
                        landMoveCount=0;
                        movePlatformX=xPosition;
                        movePlatformY=yPosition;
                        switchCheckChe=NO;
                    }
                }
            }
        }
    }else if(gameLevel ==7){
        if(domeSwitchChe){
            if(!heightMoveChe){
                if(moveCount2!=0){
                    moveCount2+=0.5;
                    domeMoveCount+=0.5;
                    if(moveCount2>=130){
                        moveCount2=130;
                        domeMoveCount=130;
                        heightMoveChe=YES;
                    }
                }
            }else {
                if(moveCount2>-20)
                    moveCount2-=0.5;
            }
        }
        [self domFunc];
    }else if(gameLevel == 8){
        if(!level8PlatforChe){
            if(moveCount2!=0){
                moveCount2+=0.3;
                if(moveCount2>=100){
                    moveCount2=100;
                }
            }
        }else{
            moveCount2-=0.3;
            if(moveCount2<=0){
                moveCount2=0;
                level8PlatforChe=NO;
                switchCount=0;
            }
        }
        
    }else if(gameLevel == 9){
        if(switchStatusChe){
            moveCount2-=0.6;
            if(switchStatusValue==3){
                if(moveCount2<=-80)
                    moveCount2=-80;
            }else{
                if(moveCount2<=0)
                    moveCount2=0;
            }
        }
        if(switchStatusChe2){
            if(switchStatusValue==1){
                moveCount2+=0.6;
                if(moveCount2>=170)
                    moveCount2=170;
            }
        }
        if(switchStatusChe3){
            if(switchStatusValue==2){
                moveCount2-=0.6;
                if(moveCount2<=50)
                    moveCount2=50;
            }else if(switchStatusValue == 0){
                moveCount2+=0.5;
                if(moveCount2>=50)
                    moveCount2=50;
            }
        }
    }else if(gameLevel == 11){
        if(moveCount2!=0){
            
            moveCount+=0.6;
            moveCount=(moveCount>440?1:moveCount);
            moveCount2=(moveCount<=220?moveCount:220-(moveCount-220));
            
            
        }
    }else if(gameLevel == 12){
        if(moveCount2!=0){
            moveCount2+=1.0;
            if(moveCount2>=233)
                moveCount2=233;
        }
    }else if(gameLevel == 13){
        if(switchCount!=0){
            moveCount+=0.4;
            moveCount=(moveCount>300?0:moveCount);
            moveCount2=(moveCount<=150?moveCount:150-(moveCount-150));
        }
    }else if(gameLevel == 14){
        if(moveCount2!=0){
            //moveCount2+=0.4;
            //moveCount2=(moveCount2>65?65:moveCount2);
        }
        
        if(speedReverseJump>=1){
            speedReverseJump+=1;
            speedReverseJump=(speedReverseJump>=50?0:speedReverseJump);
        }
    }
}
-(void)runningRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe{
    xPosition=xPos;
    yPosition=yPos;
    
    [self runTransaction:-12 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self runTransaction:990 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self runTransaction:0 heroY:700 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    [self runTransaction:0 heroY:0 objectW:1000 objectH:12 fChe:fChe  sideValue:0];
    
    if(gameLevel==2){
        [self runTransaction:300 heroY:310 objectW:90 objectH:94 fChe:fChe sideValue:0];
        [self runTransaction:395 heroY:384 objectW:605 objectH:214 fChe:fChe sideValue:0];
        [self runTransaction:520 heroY:443 objectW:184 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 3){
        [self runTransaction:280 heroY:430 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:578 heroY:468 objectW:432 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:618 heroY:370 objectW:43 objectH:35 fChe:fChe sideValue:0];
        [self runTransaction:735 heroY:535 objectW:15 objectH:70 fChe:fChe sideValue:0];
        [self runTransaction:460 heroY:423 objectW:10 objectH:95 fChe:fChe sideValue:0];
    }else if(gameLevel ==4){
        [self runTransaction:0 heroY:324 objectW:252 objectH:12 fChe:fChe  sideValue:0];
        [self runTransaction:0 heroY:429 objectW:128 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:242 heroY:526 objectW:446 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:356 heroY:516 objectW:332 objectH:132 fChe:fChe sideValue:0];
        [self runTransaction:408 heroY:585 objectW:45 objectH:70 fChe:fChe sideValue:9];
        [self runTransaction:814 heroY:343 objectW:196 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:692 heroY:445 objectW:102 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:826 heroY:550 objectW:184 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:620 heroY:275 objectW:60 objectH:27 fChe:fChe sideValue:0];
        [self runTransaction:400 heroY:388 objectW:80 objectH:140 fChe:fChe sideValue:0];
        
    }else if(gameLevel ==5){
        [self runTransaction:0 heroY:360 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:510 heroY:307 objectW:75 objectH:62 fChe:fChe sideValue:0];
        [self runTransaction:510 heroY:277 objectW:75 objectH:30 fChe:fChe sideValue:0];
        [self runTransaction:307+moveCount2 heroY:462 objectW:90 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:812 heroY:362 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:553 objectW:168 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:662 heroY:462 objectW:132 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:250 heroY:425 objectW:50 objectH:67 fChe:fChe sideValue:0];
        
        [self trigoRunningFunc:fChe];
    }else if(gameLevel == 6){
        [self runTransaction:760 heroY:290 objectW:60 objectH:45 fChe:fChe  sideValue:6];
        [self runTransaction:317 heroY:359 objectW:293 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:535 heroY:345 objectW:60 objectH:99 fChe:fChe sideValue:0];
        [self runTransaction:677-moveCount3 heroY:432+moveCount2 objectW:148 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:843 heroY:591 objectW:160 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:506 objectW:115 objectH:128 fChe:fChe sideValue:0];
    }else if(gameLevel == 7){
        [self runTransaction:227 heroY:353 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:227 heroY:340 objectW:25 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:227 heroY:433 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:768 heroY:312 objectW:52 objectH:70 fChe:fChe sideValue:0];
        [self runTransaction:735 heroY:338 objectW:16 objectH:50 fChe:fChe sideValue:0];
        [self runTransaction:845 heroY:446 objectW:160 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:556 heroY:362+moveCount2 objectW:188 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 8){
        [self runTransaction:0 heroY:353 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:245 heroY:413 objectW:323 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:160 heroY:462 objectW:94 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:254 heroY:530 objectW:12 objectH:55 fChe:fChe sideValue:0];
        [self runTransaction:246 heroY:543 objectW:334 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:570 heroY:538 objectW:12 objectH:148 fChe:fChe sideValue:0];
        [self runTransaction:735 heroY:406 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:740 heroY:574 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:575 heroY:494 objectW:110 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:916-moveCount2 heroY:307 objectW:84 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:855 heroY:290 objectW:70 objectH:90 fChe:fChe sideValue:6];
        [self runTransaction:470 heroY:292 objectW:270 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:568 heroY:407 objectW:12 objectH:80 fChe:fChe sideValue:0];
        if(vegetableCount<100)
            [self runTransaction:568 heroY:327 objectW:12 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:498 heroY:407 objectW:12 objectH:180 fChe:fChe sideValue:0];
        [self runTransaction:400 heroY:407 objectW:12 objectH:170 fChe:fChe sideValue:0];
    }else if(gameLevel == 9){
        [self runTransaction:100 heroY:362 objectW:105 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:250 heroY:410 objectW:220 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:465 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:260 heroY:535 objectW:12 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:250 heroY:545 objectW:220 objectH:35 fChe:fChe sideValue:0];
        [self runTransaction:458 heroY:535 objectW:12 objectH:135 fChe:fChe sideValue:0];
        [self runTransaction:405 heroY:270 objectW:80 objectH:80 fChe:fChe sideValue:0];
        
        if(moveCount2!=170){
            [self runTransaction:595 heroY:403+moveCount2 objectW:200 objectH:12 fChe:fChe sideValue:0];
            [self runTransaction:784 heroY:573 objectW:230 objectH:400 fChe:fChe sideValue:0];
        }else{
            [self runTransaction:595 heroY:403+moveCount2 objectW:420 objectH:30 fChe:fChe sideValue:0];
            [self runTransaction:784 heroY:553 objectW:230 objectH:400 fChe:fChe sideValue:0];
        }
    }else if(gameLevel== 10){
        [self runTransaction:0 heroY:285 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:367 heroY:283 objectW:250 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:450 heroY:383 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:620 heroY:373 objectW:30 objectH:110 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:285 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:432 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:383 objectW:267 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:367 heroY:550 objectW:260 objectH:115 fChe:fChe sideValue:0];
        [self runTransaction:460 heroY:440 objectW:40 objectH:55 fChe:fChe sideValue:0];
        [self runTransaction:664 heroY:245 objectW:12 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:490 heroY:276 objectW:12 objectH:60 fChe:fChe sideValue:0];
        
    }else if(gameLevel == 11){
        [self runTransaction:133 heroY:245 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:230 heroY:325 objectW:105 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:320 heroY:260 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:490 heroY:255 objectW:160 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:650 heroY:270 objectW:100 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:555 heroY:310 objectW:132 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:720 heroY:422 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:217+moveCount2 heroY:497 objectW:205 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:592 objectW:425 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:757 heroY:580 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:495 objectW:187 objectH:12 fChe:fChe sideValue:0];
        
    }else if(gameLevel ==12){
        [self runTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:366 heroY:282 objectW:250 objectH:124 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:382 objectW:270 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:445 heroY:396 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:1004-moveCount2 heroY:454 objectW:233 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 13){
        [self runTransaction:144 heroY:359+moveCount2 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:357 heroY:529 objectW:190 objectH:160 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:358 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:570 heroY:456 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:548 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:440 heroY:378 objectW:12 objectH:150 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:586 objectW:80 objectH:260 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        [self runTransaction:515 heroY:354+moveCount2 objectW:130 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:840 heroY:354 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:920 heroY:442 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:700 heroY:532 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:250 heroY:532 objectW:187 objectH:12 fChe:fChe sideValue:0];
        if(!gateOpenChe)
            [self runTransaction:946 heroY:300 objectW:60 objectH:70 fChe:fChe sideValue:0];
    }
}


-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe{
    xPosition=xPos;
    yPosition=yPos;
    
    [self jumpTransaction:0 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:990 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:700 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:0 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    
    if(gameLevel == 1){
    }else if(gameLevel ==2 ){
        [self jumpTransaction:300 heroY:310 objectW:90 objectH:94 fChe:fChe sideValue:0];
        [self jumpTransaction:395 heroY:384 objectW:605 objectH:214 fChe:fChe sideValue:0];
        [self jumpTransaction:520 heroY:443 objectW:184 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:564 heroY:665 objectW:163 objectH:140 fChe:fChe sideValue:0];
    }else if(gameLevel == 3){
        [self jumpTransaction:280 heroY:430 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:578 heroY:468 objectW:432 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:618 heroY:370 objectW:43 objectH:35 fChe:fChe sideValue:1];
        [self jumpTransaction:735 heroY:535 objectW:15 objectH:70 fChe:fChe sideValue:1];
        [self jumpTransaction:460 heroY:422 objectW:10 objectH:95 fChe:fChe sideValue:0];
        
    }else if(gameLevel ==4){
        [self jumpTransaction:0 heroY:324 objectW:252 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:429 objectW:128 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:252 heroY:526 objectW:436 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:356 heroY:516 objectW:332 objectH:132 fChe:fChe sideValue:0];
        
        [self jumpTransaction:408 heroY:585 objectW:45 objectH:70 fChe:fChe sideValue:9];
        [self jumpTransaction:814 heroY:343 objectW:196 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:692 heroY:445 objectW:102 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:826 heroY:550 objectW:184 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:620 heroY:275 objectW:60 objectH:27 fChe:fChe sideValue:0];
        [self jumpTransaction:400 heroY:388 objectW:80 objectH:140 fChe:fChe sideValue:0];
        
        if(!fChe){
            if(xPosition>850&&xPosition<900 &&yPosition>450&&yPosition<510&&switchCount==0)
                switchCount=1;
        }else{
            if(xPosition>880&&xPosition<940 &&yPosition>450&&yPosition<510 &&switchCount==0)
                switchCount=1;
        }
    }else if(gameLevel == 5){
        [self jumpTransaction:0 heroY:360 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:510 heroY:307 objectW:75 objectH:40 fChe:fChe sideValue:6];
        [self jumpTransaction:510 heroY:277 objectW:75 objectH:30 fChe:fChe sideValue:0];
        [self jumpTransaction:307+moveCount2 heroY:462 objectW:90 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:812 heroY:362 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:553 objectW:168 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:662 heroY:462 objectW:132 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:250 heroY:425 objectW:50 objectH:67 fChe:fChe sideValue:0];
        [self jumpTransaction:945 heroY:426 objectW:65 objectH:12 fChe:fChe sideValue:0];
        
        
        [self trigoJumpingFunc:890 yPosition:563 angle:20 radiusLength:50];
        [self trigoReverseFunc:940 yPosition:428 angle:108 radiusLength:58];
        if(!fChe){
            if(xPosition>480&&xPosition<530 &&yPosition>540&&yPosition<600&&switchCount==0 )
                switchCount=1;
        }else{
            if(xPosition>510&&xPosition<570 &&yPosition>540&&yPosition<600 &&switchCount==0)
                switchCount=1;
        }
    }else if(gameLevel == 6){
        [self jumpTransaction:760 heroY:290 objectW:60 objectH:45 fChe:fChe sideValue:6];
        [self jumpTransaction:317 heroY:359 objectW:293 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:535 heroY:345 objectW:60 objectH:99 fChe:fChe sideValue:0];
        [self jumpTransaction:677-moveCount3 heroY:432+moveCount2 objectW:148 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:843 heroY:591 objectW:160 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:506 objectW:115 objectH:128 fChe:fChe sideValue:0];
        
        if(xPosition>420&&xPosition<490 &&yPosition>230&&yPosition<290&&!fChe){
            if(!horizandalMoveChe&&!switchCheckChe){
                horizandalMoveChe=YES;
                switchStrChe=(switchStrChe?NO:YES);
                switchCheckChe=YES;
            }
        }else if(xPosition>450&&xPosition<520 &&yPosition>230&&yPosition<290&&fChe){
            if(!horizandalMoveChe&&!switchCheckChe){
                horizandalMoveChe=YES;
                switchStrChe=(switchStrChe?NO:YES);
                switchCheckChe=YES;
            }
        }
    }else if(gameLevel == 7){
        [self jumpTransaction:227 heroY:353 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:227 heroY:340 objectW:25 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:227 heroY:433 objectW:190 objectH:12 fChe:fChe sideValue:0];
        if(domeMoveCount!=0)
            [self jumpTransaction:556 heroY:362+moveCount2 objectW:188 objectH:15 fChe:fChe sideValue:5];
        else
            [self jumpTransaction:546 heroY:372+moveCount2 objectW:208 objectH:15 fChe:fChe sideValue:8];
        
        [self jumpTransaction:768 heroY:312 objectW:52 objectH:70 fChe:fChe sideValue:0];
        [self jumpTransaction:730 heroY:338 objectW:16 objectH:50 fChe:fChe sideValue:0];
        [self jumpTransaction:845 heroY:446 objectW:160 objectH:12 fChe:fChe sideValue:0];
        
        if(fChe){
            if(xPosition>227&&xPosition<267 &&yPosition>260&&yPosition<330 &&!domeSwitchChe)
                domeSwitchChe=YES;
        }
        
        if(xPosition>267&&xPosition<327 &&yPosition>495&&yPosition<540 &&switchCount==0&&!fChe)
            switchCount=1;
        else if(xPosition>287&&xPosition<347 &&yPosition>495&&yPosition<540 &&switchCount==0&&fChe)
            switchCount=1;
        
    }else if(gameLevel == 8){
        [self jumpTransaction:0 heroY:353 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:245 heroY:413 objectW:323 objectH:12 fChe:fChe sideValue:11];
        [self jumpTransaction:160 heroY:462 objectW:94 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:254 heroY:530 objectW:12 objectH:55 fChe:fChe sideValue:0];
        [self jumpTransaction:246 heroY:543 objectW:334 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:570 heroY:538 objectW:12 objectH:148 fChe:fChe sideValue:0];
        [self jumpTransaction:735 heroY:406 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:740 heroY:574 objectW:280 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:575 heroY:494 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:916-moveCount2 heroY:307 objectW:84 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:855 heroY:290 objectW:70 objectH:90 fChe:fChe sideValue:6];
        
        
        if(xPosition>500&&xPosition<590 &&yPosition>400&&yPosition<510 &&!vegetableTouchChe&&switchCount==0&&!fChe){
            level8PlatforChe=NO;
            vegetableTouchChe=YES;
        }
        
        
        if(xPosition>920 &&yPosition>550&&!switchChe2&&!fChe&&screenMoveValue==0&&!vegetableTouchChe){
            moveCount2=1;
            switchChe2=YES;
            level8PlatforChe=NO;
        }else if(xPosition>920 &&yPosition>550&&switchCount==0&&!fChe&&screenMoveValue==1&&!vegetableTouchChe){
            switchCount=1;
            moveCount2=1;
            level8PlatforChe=NO;
        }
        
        [self jumpTransaction:470 heroY:292 objectW:270 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:568 heroY:407 objectW:12 objectH:80 fChe:fChe sideValue:0];
        if(vegetableCount<100)
            [self jumpTransaction:568 heroY:327 objectW:12 objectH:80 fChe:fChe sideValue:0];
        [self jumpTransaction:498 heroY:407 objectW:12 objectH:180 fChe:fChe sideValue:0];
        [self jumpTransaction:400 heroY:407 objectW:12 objectH:170 fChe:fChe sideValue:0];
    }else if(gameLevel == 9){
        [self jumpTransaction:100 heroY:362 objectW:105 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:250 heroY:410 objectW:220 objectH:12 fChe:fChe sideValue:11];
        [self jumpTransaction:0 heroY:465 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:260 heroY:535 objectW:12 objectH:80 fChe:fChe sideValue:0];
        [self jumpTransaction:250 heroY:545 objectW:220 objectH:35 fChe:fChe sideValue:0];
        [self jumpTransaction:458 heroY:535 objectW:12 objectH:135 fChe:fChe sideValue:0];
        [self jumpTransaction:405 heroY:270 objectW:80 objectH:80 fChe:fChe sideValue:0];
        
        if(moveCount2!=170){
            [self jumpTransaction:595 heroY:403+moveCount2 objectW:200 objectH:12 fChe:fChe sideValue:0];
            [self jumpTransaction:784 heroY:573 objectW:230 objectH:400 fChe:fChe sideValue:0];
        }else{
            [self jumpTransaction:595 heroY:403+moveCount2 objectW:420 objectH:30 fChe:fChe sideValue:0];
            [self jumpTransaction:784 heroY:553 objectW:230 objectH:400 fChe:fChe sideValue:0];
        }
        
        
        int iValue=(fChe?30:0);
        if(xPosition>280+iValue &&xPosition<330+iValue && yPosition>310&& yPosition<340&&!switchStatusChe){
            switchStatusChe=YES;
            switchHitValue=1;
            if(switchStatusValue==2){
                switchStatusValue=3;
            }else{
                switchStatusChe2=NO;
                switchStatusChe3=NO;
            }
        }
        if(xPosition>130+iValue && xPosition<170+iValue && yPosition>620 && yPosition<660 &&!switchStatusChe2){
            switchStatusChe2=YES;
            switchStatusChe=NO;
            switchStatusChe3=NO;
            switchStatusValue=1;
            switchHitValue=2;
        }
        if(xPosition>380+iValue && xPosition<450+iValue && yPosition>430 && yPosition<510 &&!switchStatusChe3&&!fChe){
            switchStatusChe3=YES;
            if(switchStatusValue==1)
                switchStatusValue=2;
            else {
                if(switchStatusChe)
                    switchStatusChe=NO;
                switchStatusValue=0;
            }
            switchHitValue=3;
        }
    }else if(gameLevel == 10){
        [self jumpTransaction:0 heroY:285 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:367 heroY:283 objectW:250 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:450 heroY:423 objectW:12 objectH:108 fChe:fChe sideValue:0];
        [self jumpTransaction:450 heroY:383 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:620 heroY:373 objectW:30 objectH:50 fChe:fChe sideValue:9];
        [self jumpTransaction:600 heroY:333 objectW:30 objectH:50 fChe:fChe sideValue:9];
        [self jumpTransaction:770 heroY:285 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:770 heroY:432 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:383 objectW:267 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:367 heroY:550 objectW:260 objectH:115 fChe:fChe sideValue:0];
        [self jumpTransaction:460 heroY:440 objectW:40 objectH:55 fChe:fChe sideValue:0];
        [self jumpTransaction:664 heroY:245 objectW:12 objectH:100 fChe:fChe sideValue:9];
        [self jumpTransaction:490 heroY:276 objectW:12 objectH:60 fChe:fChe sideValue:0];
        int iValue=(fChe?30:0);
        if(xPosition<40+iValue && yPosition>280&& yPosition<320&&switchCount==0){
            if(switchHitValue==0)
                switchHitValue=1;
            else if(switchHitValue>=50)
                switchCount=1;
        }
    }else if(gameLevel == 11){
        
        [self jumpTransaction:133 heroY:245 objectW:12 objectH:90 fChe:fChe sideValue:1];
        [self jumpTransaction:230 heroY:325 objectW:105 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:320 heroY:260 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:490 heroY:255 objectW:160 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:650 heroY:270 objectW:100 objectH:130 fChe:fChe sideValue:0];
        
        [self jumpTransaction:555 heroY:310 objectW:132 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:720 heroY:422 objectW:190 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:217+moveCount2 heroY:497 objectW:205 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:0 heroY:592 objectW:420 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:757 heroY:580 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:495 objectW:187 objectH:12 fChe:fChe sideValue:0];
        
        int iValue=(fChe?30:0);
        if(xPosition<50+iValue && yPosition>330&& yPosition<360&&switchCount==0){
            if(switchHitValue==0)
                switchHitValue=1;
            else if(switchHitValue>=50)
                switchCount=1;
        }
    }else if(gameLevel == 12){
        [self jumpTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:366 heroY:282 objectW:250 objectH:124 fChe:fChe sideValue:0];
        [self jumpTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:382 objectW:270 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:445 heroY:396 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:1004-moveCount2 heroY:454 objectW:233 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
        
        int iValue=(fChe?40:0);
        if(xPosition>450+iValue &&xPosition<510+iValue && yPosition>315&& yPosition<345&&!switchStatusChe){
            switchStatusChe=YES;
            switchStatusChe2=NO;
            switchStatusChe3=NO;
            switchStatusValue=1;
            switchHitValue=1;
        }
        if(xPosition>500+iValue && xPosition<570+iValue && yPosition>445 && yPosition<475 &&!switchStatusChe2){
            switchStatusChe2=YES;
            switchHitValue=2;
            if(switchStatusValue==1)
                switchStatusValue=2;
            else{
                switchStatusValue=0;
                switchStatusChe=NO;
                switchStatusChe3=NO;
            }
        }
        if(xPosition>160+iValue && xPosition<220+iValue && yPosition>435 && yPosition<470 &&!switchStatusChe3){
            switchStatusChe3=YES;
            if(switchStatusValue==2)
                switchStatusValue=3;
            else {
                switchStatusValue=0;
                switchStatusChe=NO;
                switchStatusChe2=NO;
            }
            switchHitValue=3;
        }
    }else if(gameLevel ==13){
        [self jumpTransaction:144 heroY:359+moveCount2 objectW:133 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:357 heroY:529 objectW:190 objectH:160 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:358 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:570 heroY:456 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:548 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:440 heroY:378 objectW:12 objectH:150 fChe:fChe sideValue:0];
        
        if(xPosition>360 &&xPosition<450 && yPosition>245&& yPosition<320&&switchCount==0&&!fChe){
            switchCount=1;
            switchHitValue=1;
        }
        
        [self jumpTransaction:0 heroY:586 objectW:80 objectH:260 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        [self jumpTransaction:515 heroY:354+moveCount2 objectW:130 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:840 heroY:354 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:920 heroY:442 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:700 heroY:532 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:250 heroY:532 objectW:187 objectH:12 fChe:fChe sideValue:0];
        if(!gateOpenChe)
        [self jumpTransaction:946 heroY:300 objectW:60 objectH:70 fChe:fChe sideValue:1];
        
        for(int i=0;i<150;i++){
            CGFloat xx=0;
            CGFloat yy=0;
            if(i<=100){
                xx=[trigo circlex:i a:90]+128;
                yy=[trigo circley:i a:90]+550;
            }else{
                xx=[trigo circlex:i a:124]+258;
                yy=[trigo circley:i a:124]+360;
            }
            
            if(xPosition >= xx-20 && xPosition<=xx+10 && yPosition >= yy-20 && yPosition <= yy&&!reverseJump&&speedReverseJump==0){
                reverseJump=YES;
                xPosition=xx-20;
                speedReverseJump=1;
            }
        }
        
    }
}

-(void)jumpTransaction:(CGFloat)heroX  heroY:(CGFloat)heroY objectW:(CGFloat)objectW objectH:(CGFloat)objectH fChe:(BOOL)fChe sideValue:(int)sValue{
    
    if(!fChe){
        //reverseJump
        if(!reverseJump&&!landingChe){
            if(xPosition >= heroX-50 && xPosition<=((heroX-50)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY){
                topHittingCollisionChe=NO;
                reverseJump=YES;
                xPosition=heroX-50;
                if(sValue==6&&!trappedChe){
                    trappedChe=YES;
                    objectWidth = objectW;
                    objectHeight = objectH;
                    sideValueForObject = sValue;
                }
            }
            //Land
            if(xPosition >= heroX-50 && xPosition<=((heroX-50)+objectW+20) && yPosition > heroY && yPosition <= heroY+17){
                if(sValue!=8){
                    if(sValue!=1){
                        landingChe=YES;
                        yPosition=heroY+17;
                        if(sValue!=9){
                            jumpDiff=xPosition-(heroX-50);
                            jumpDiffChe=YES;
                        }
                        if(sValue==5){
                            movePlatformChe=YES;
                            movePlatformX=xPosition;
                            movePlatformY=yPosition;
                            landMoveCount=(!moveSideChe?moveCount2:moveCount3);
                        }else if(sValue==6&&!trappedChe){
                            trappedChe=YES;
                            objectWidth = objectW;
                            objectHeight = objectH;
                            sideValueForObject = sValue;
                        }
                        if(sValue==11&&!visibleLevel9Che)
                            visibleLevel9Che=YES;
                    }else{
                        autoJumpChe2=YES;
                        autoJumpSpeedValue=1;
                    }
                }else{
                    topHittingCollisionChe=NO;
                    reverseJump=YES;
                    xPosition=heroX-50;
                }
            }
        }
    }else{
        if(!reverseJump&&!landingChe){
            if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
                topHittingCollisionChe=NO;
                reverseJump=YES;
                xPosition=(heroX-10)+objectW;
                if(sValue==6&&!trappedChe){
                    trappedChe=YES;
                    objectWidth = objectW;
                    objectHeight = objectH;
                    sideValueForObject = sValue;
                }
            }
            //Land
            if(xPosition >= heroX-30 && xPosition<=((heroX-10)+objectW-20) && yPosition > heroY && yPosition <= heroY+17){
                if(sValue!=8){
                    if(sValue!=1){
                        landingChe=YES;
                        yPosition=heroY+17;
                        if(sValue!=9){
                            jumpDiff=((heroX-10)+objectW-20)-xPosition;
                            jumpDiffChe=YES;
                        }
                        if(sValue==5){
                            movePlatformChe=YES;
                            movePlatformX=xPosition;
                            movePlatformY=yPosition;
                            landMoveCount=(!moveSideChe?moveCount2:moveCount3);
                        }else if(sValue==6&&!trappedChe){
                            trappedChe=YES;
                            objectWidth = objectW;
                            objectHeight = objectH;
                            sideValueForObject = sValue;
                        }
                    }else{
                        autoJumpChe2=YES;
                        autoJumpSpeedValue=1;
                    }
                }else{
                    topHittingCollisionChe=NO;
                    reverseJump=YES;
                    xPosition=(heroX-30)+objectW;
                }
            }
        }
    }
    
    if(backHeroY<yPosition){
        if(xPosition >= heroX-50 && xPosition<=((heroX-50)+objectW+20) && yPosition > heroY-(objectH+20) && yPosition <= heroY-(objectH)&&!topHittingCollisionChe){
            topHittingCollisionChe=YES;
            reverseJump=YES;
        }
    }
    
    backHeroY=yPosition;
}
-(void)runTransaction:(CGFloat)heroX  heroY:(CGFloat)heroY objectW:(CGFloat)objectW objectH:(CGFloat)objectH fChe:(BOOL)fChe sideValue:(int)sValue{
    
    if(!fChe){
        int aValue=(trigoVisibleChe?10:0);
        //Running
        if(xPosition >= heroX-60+aValue && xPosition<=((heroX-60)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=heroX-60;
            trigoRunningCheck=YES;
            if(sValue==6&&!trappedChe){
                trappedChe=YES;
                objectWidth = objectW;
                objectHeight = objectH;
                sideValueForObject = sValue;
            }
        }else if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition > heroY && yPosition <= heroY+17&&!autoJumpChe){
            autoJumpChe=YES;
            if(movePlatformChe)
                movePlatformChe=NO;
        }
    }else{
        if(xPosition >= ((heroX-0)+(objectW-20)) && xPosition<=((heroX-0)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=(heroX-0)+objectW;
            trigoRunningCheck=YES;
            if(sValue==6&&!trappedChe){
                trappedChe=YES;
                objectWidth = objectW;
                objectHeight = objectH;
                sideValueForObject = sValue;
            }
        }else if(xPosition >= heroX-50 && xPosition<=((heroX-50)+20) && yPosition > heroY && yPosition <= heroY+17&&!autoJumpChe){
            autoJumpChe=YES;
            if(movePlatformChe)
                movePlatformChe=NO;
        }
    }
    
}

-(void)trigoJumpingFunc:(CGFloat)xPos yPosition:(CGFloat)yPos angle:(int)angle radiusLength:(int)rLength{
    
    for(int i=-10;i<rLength;i++){
        CGFloat xx=[trigo circlex:i*2 a:angle]+xPos;
        CGFloat yy=[trigo circley:i*2 a:angle]+yPos;
        
        if(xPosition>xx &&xPosition<xx+10 && yPosition>yy+12 && yPosition<yy+22){
            landingChe=YES;
            yPosition=yy+18;
            saveTrigoCount[0]=xPos;
            saveTrigoCount[1]=yPos+15;
            saveTrigoCount[2]=i;
            saveTrigoCount[3]=angle;
            saveTrigoCount[4]=rLength;
            trigoHeroAngle=angle;
            trigoVisibleChe=YES;
            break;
        }
    }
}

-(void)trigoRunningFunc:(BOOL)fChe{
    if(trigoVisibleChe){
        if(!fChe){
            if(!trigoRunningCheck)
                saveTrigoCount[2]+=1;
            if(saveTrigoCount[2]>=saveTrigoCount[4]){
                trigoVisibleChe=NO;
                autoJumpChe=YES;
            }
        }else{
            if(!trigoRunningCheck)
                saveTrigoCount[2]-=1;
            if(saveTrigoCount[2]<-10){
                trigoVisibleChe=NO;
                autoJumpChe=YES;
            }
        }
        CGFloat xx=[trigo circlex:saveTrigoCount[2]*2 a:saveTrigoCount[3]]+saveTrigoCount[0];
        CGFloat yy=[trigo circley:saveTrigoCount[2]*2 a:saveTrigoCount[3]]+saveTrigoCount[1];
        xPosition=xx;
        yPosition=yy;
    }
}

-(void)trigoReverseFunc:(CGFloat)xPos yPosition:(CGFloat)yPos angle:(int)angle radiusLength:(int)rLength{
    for(int i=-10;i<rLength;i++){
        
        CGFloat xx=[trigo circlex:i*2 a:angle]+xPos-50;
        CGFloat yy=[trigo circley:i*2 a:angle]+yPos;
        
        if(xPosition>xx &&xPosition<xx+10 && yPosition>yy && yPosition<yy+10){
            topHittingCollisionChe=NO;
            reverseJump=YES;
            xPosition=xx;
            break;
        }
    }
    
}

-(void)domFunc{
    if(!domChe){
        int fValue=-40;
        for(int i=0;i<180;i++){
            CGFloat xx=[trigo circlex:82 a:i]+630;
            CGFloat yy=[trigo circley:60 a:i]+360+domeMoveCount;
            if(xPosition>xx+20+fValue &&xPosition<xx+30+fValue && yPosition>yy+22 && yPosition<yy+32){
                landingChe=YES;
                yPosition=yy+18;
                domeAngle=i;
                domChe=YES;
                if(i<=90)
                    domeSideChe=YES;
                break;
            }
        }
    }else{
        if(!domeEnterChe)
            domeEnterChe=YES;
        if(!domeSideChe)
            domeAngle+=0.8;
        else
            domeAngle-=0.8;
        
        CGFloat xx=[trigo circlex:82 a:domeAngle]+630;
        CGFloat yy=[trigo circley:60 a:domeAngle]+360+domeMoveCount;
        
        xPosition=xx;
        yPosition=yy;
    }
    
}

@end
