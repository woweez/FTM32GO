//
//  CheesePosition.m
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import "GirlGameFunc.h"
#import "cocos2d.h"

@implementation GirlGameFunc

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
@synthesize movePlatformChe;
@synthesize movePlatformX;
@synthesize movePlatformY;
@synthesize landMoveCount;
@synthesize visibleWindowChe;
@synthesize stickyChe;
@synthesize stickyCount;
@synthesize trigoVisibleChe;
@synthesize trigoHeroAngle;
@synthesize trigoRunningCheck;
@synthesize stickyChe2;
@synthesize stickyReleaseCount;
@synthesize plateWoodStopCount;
@synthesize domChe;
@synthesize domeMoveCount;
@synthesize domeAngle;
@synthesize domeEnterChe;
@synthesize domeSideChe;
@synthesize heightMoveChe;
@synthesize domeSwitchChe;
@synthesize platformRotateCount;
@synthesize heroRotateChe;
@synthesize heroRotateDomeChe;
@synthesize gateOpenChe;
@synthesize closeOpenChe;
@synthesize bridgeOpenCount;
@synthesize catFirstJumpChe;


-(id) init {
    if( (self=[super init])) {
        trigo=[[Trigo alloc] init];
        
        
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
            if(iValue ==0)
                cheesePosition = ccp(370, 290);
            else if(iValue ==1)
                cheesePosition = ccp(150, 430);
            else if(iValue ==2)
                cheesePosition = ccp(480, 540);
            else if(iValue ==3)
                cheesePosition = ccp(580, 360);
            else if(iValue ==4)
                cheesePosition = ccp(970, 610);
        }else if(gLevel ==3){
            if(iValue ==0)
                cheesePosition = ccp(50, 680);
            else if(iValue ==1)
                cheesePosition = ccp(280, 350);
            else if(iValue ==2)
                cheesePosition = ccp(700, 630);
            else if(iValue ==3)
                cheesePosition = ccp(950, 480);
            else if(iValue ==4)
                cheesePosition = ccp(900, 320);
        }else if(gLevel ==4){
            if(iValue ==0)
                cheesePosition = ccp(100, 680);
            else if(iValue ==1)
                cheesePosition = ccp(480, 410);
            else if(iValue ==2)
                cheesePosition = ccp(480, 500);
            else if(iValue ==3)
                cheesePosition = ccp(900, 700);
            else if(iValue ==4)
                cheesePosition = ccp(630, 221);
            
        }else if(gLevel ==5){
            if(iValue ==0)
                cheesePosition = ccp(30, 295);
            else if(iValue ==1)
                cheesePosition = ccp(30, 561);
            else if(iValue ==2)
                cheesePosition = ccp(370, 413);
            else if(iValue ==3)
                cheesePosition = ccp(810, 313);
            else if(iValue ==4)
                cheesePosition = ccp(980, 610);
        }else if(gLevel ==6){
            if(iValue ==0)
                cheesePosition = ccp(30, 364);
            else if(iValue ==1)
                cheesePosition = ccp(660, 220);
            else if(iValue ==2)
                cheesePosition = ccp(430, 364);
            else if(iValue ==3)
                cheesePosition = ccp(880, 520);
            else if(iValue ==4)
                cheesePosition = ccp(480, 650);
        }else if(gLevel ==7){
            if(iValue ==0)
                cheesePosition = ccp(340, 424);
            else if(iValue ==1)
                cheesePosition = ccp(150, 660);
            else if(iValue ==2)
                cheesePosition = ccp(700, 580);
            else if(iValue==3)
                cheesePosition = ccp(705, 374);
            else if(iValue==4)
                cheesePosition = ccp(945, 220);
        }else if(gLevel ==8){
            if(iValue ==0)
                cheesePosition = ccp(130, 650);
            else if(iValue ==1)
                cheesePosition = ccp(660, 420);
            else if(iValue ==2)
                cheesePosition = ccp(500, 280);
            else if(iValue ==3)
                cheesePosition = ccp(880, 700);
            else if(iValue ==4)
                cheesePosition = ccp(940, 270);
        }else if(gLevel ==9){
            if(iValue ==0)
                cheesePosition = ccp(280, 350);
            else if(iValue ==1)
                cheesePosition = ccp(280, 430);
            else if(iValue ==2)
                cheesePosition = ccp(470, 330);
            else if(iValue ==3)
                cheesePosition = ccp(850, 220);
            else if(iValue ==4)
                cheesePosition = ccp(940, 590);
        }else if(gLevel ==10){
            if(iValue ==0)
                cheesePosition = ccp(90, 420);
            else if(iValue ==1)
                cheesePosition = ccp(190, 510);
            else if(iValue ==2)
                cheesePosition = ccp(490, 210);
            else if(iValue ==3)
                cheesePosition = ccp(950, 190);
            else if(iValue ==4)
                cheesePosition = ccp(880, 340);
        }else if(gLevel ==11){
            if(iValue ==0)
                cheesePosition = ccp(250, 190);
            else if(iValue ==1)
                cheesePosition = ccp(60, 510);
            else if(iValue ==2)
                cheesePosition = ccp(60, 710);
            else if(iValue ==3)
                cheesePosition = ccp(720, 190);
        }else if(gLevel ==12){
            if(iValue ==0)
                cheesePosition = ccp(55, 120);
            else if(iValue ==1)
                cheesePosition = ccp(85, 490);
            else if(iValue ==2)
                cheesePosition = ccp(185, 550);
            else if(iValue ==3)
                cheesePosition = ccp(860, 390);
            else if(iValue ==4)
                cheesePosition = ccp(960, 310);
        }else if(gLevel ==13){
            if(iValue ==0)
                cheesePosition = ccp(910, 573);
            else if(iValue ==1)
                cheesePosition = ccp(960, 520);
            else if(iValue ==2)
                cheesePosition = ccp(970, 300);
            else if(iValue ==3)
                cheesePosition = ccp(30, 475);
            else if(iValue ==4)
                cheesePosition = ccp(450, 610);
            
        }
    }
    return cheesePosition;
}

-(CGPoint)getPlatformPosition:(int)level {
    CGPoint platformPosition;
    if(level==1)
        platformPosition=ccp(0,160);
    else if(level==2)
        platformPosition=ccp(0,150);
    else if(level==3)
        platformPosition=ccp(0,328);
    else if(level==4)
        platformPosition=ccp(0,228);
    else if(level==5)
        platformPosition=ccp(0,228);
    else if(level==6)
        platformPosition=ccp(0,228);
    else if(level==7)
        platformPosition=ccp(0,228);
    else if(level==8)
        platformPosition=ccp(0,228);
    else if(level==9)
        platformPosition=ccp(0,228);
    else if(level==10)
        platformPosition=ccp(0,183);
    else if(level==11)
        platformPosition=ccp(0,183);
    else if(level==12)
        platformPosition=ccp(0,100);
    else if(level==13)
        platformPosition=ccp(0,228);
    else if(level==14)
        platformPosition=ccp(0,228);
    
    return platformPosition;
}

-(void)render{
    if(stickyReleaseCount>=1){
        stickyReleaseCount+=1;
        stickyReleaseCount=(stickyReleaseCount>50?0:stickyReleaseCount);
    }
    
    if(gameLevel==4){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
        if(moveCount>=1){
            moveCount+=1;
            moveCount=(moveCount>1600?1:moveCount);
            moveCount2=(moveCount<=800?moveCount:800-(moveCount-800));
        }
    }else if(gameLevel == 6){
        if(plateWoodStopCount>=1){
            plateWoodStopCount+=1;
            plateWoodStopCount=(plateWoodStopCount>95?95:plateWoodStopCount);
        }
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }else if(gameLevel == 7){
        if(domeSwitchChe){
            if(!heightMoveChe){
                if(moveCount2!=0){
                    moveCount2+=0.5;
                    domeMoveCount+=0.5;
                    if(moveCount2>=180){
                        moveCount2=180;
                        domeMoveCount=180;
                        heightMoveChe=YES;
                    }
                }
            }else {
                if(moveCount2>0)
                    moveCount2-=0.5;
            }
        }
        if(!heroRotateDomeChe)
            [self domFunc];
    }else if(gameLevel == 8){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }else if(gameLevel == 9){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }else if(gameLevel == 11){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }else if(gameLevel == 12){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }else if(gameLevel == 13){
        if(moveCount!=0){
            if(!catFirstJumpChe)
                moveCount-=0.3;
            moveCount=(moveCount<-350?-1:moveCount);
            if(moveCount>=-175){
                moveCount2=moveCount;
                if(moveCount2<=-173.0&& moveCount2>=-174.0&&!catFirstJumpChe){
                    catFirstJumpChe=YES;
                    moveCount=-176;
                }
            }else{
                moveCount2=-175-(moveCount + 175);
                
            }
            
        }
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
        if(plateWoodStopCount>=1){
            plateWoodStopCount+=1;
            plateWoodStopCount=(plateWoodStopCount>=150?150:plateWoodStopCount);
        }
    }else if(gameLevel == 14){
        if(stickyCount>=1){
            stickyCount+=1;
            stickyCount=(stickyCount>50?0:stickyCount);
        }
    }
}
-(void)runningRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe{
    xPosition=xPos;
    yPosition=yPos;
    
    [self runTransaction:-12 heroY:760 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self runTransaction:990 heroY:760 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self runTransaction:0 heroY:760 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    [self runTransaction:0 heroY:0 objectW:1000 objectH:12 fChe:fChe  sideValue:0];
    
    if(gameLevel == 2){
        [self runTransaction:335 heroY:284 objectW:700 objectH:400 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:420 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:343 heroY:530 objectW:90 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:431 heroY:577 objectW:12 objectH:163 fChe:fChe sideValue:0];
        [self runTransaction:431 heroY:587 objectW:260 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:431 heroY:420 objectW:312 objectH:15 fChe:fChe sideValue:0];
        [self runTransaction:657 heroY:523 objectW:85 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:732 heroY:510 objectW:12 objectH:95 fChe:fChe sideValue:0];
        [self runTransaction:555 heroY:350 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:427 heroY:310 objectW:60 objectH:30 fChe:fChe sideValue:0];
    }else if(gameLevel == 3){
        [self runTransaction:235 heroY:540 objectW:12 objectH:230 fChe:fChe sideValue:0];
        [self runTransaction:235 heroY:548 objectW:195 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:465 objectW:102 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:435 heroY:470 objectW:95 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:520 heroY:460 objectW:12 objectH:160 fChe:fChe sideValue:0];
        [self runTransaction:230 heroY:390 objectW:200 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:675 heroY:471 objectW:340 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:680 heroY:520 objectW:40 objectH:55 fChe:fChe sideValue:0];
        [self runTransaction:838 heroY:545 objectW:25 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:680 heroY:365 objectW:40 objectH:55 fChe:fChe sideValue:0];
    }else if(gameLevel == 4){
        [self runTransaction:0 heroY:305 objectW:295 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:0 heroY:515 objectW:155 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:505 objectW:155 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:168 heroY:420 objectW:112 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:35+moveCount2 heroY:735 objectW:130 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:280 heroY:690 objectW:12 objectH:125 fChe:fChe sideValue:0];
        [self runTransaction:280 heroY:575 objectW:12 objectH:180 fChe:fChe sideValue:0];
        [self runTransaction:280 heroY:405 objectW:420 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:690 heroY:560 objectW:12 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:390 heroY:575 objectW:300 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:285 heroY:490 objectW:280 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:850 heroY:374 objectW:280 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:850 heroY:364 objectW:280 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:700 heroY:515 objectW:110 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:700 heroY:505 objectW:110 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:433 heroY:238 objectW:70 objectH:30 fChe:fChe sideValue:0];
        
    }else if(gameLevel == 5){
        [self runTransaction:0 heroY:285 objectW:155 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:552 objectW:77 objectH:142 fChe:fChe sideValue:0];
        [self runTransaction:170 heroY:552 objectW:180 objectH:160 fChe:fChe sideValue:0];
        [self runTransaction:350 heroY:404 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:105 heroY:340 objectW:45 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:470 heroY:248 objectW:300 objectH:45 fChe:fChe sideValue:0];
        [self runTransaction:465+moveCount2 heroY:405 objectW:130 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:465+moveCount2 heroY:395 objectW:130 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:865 heroY:345 objectW:150 objectH:12 fChe:fChe sideValue:0];
        [self trigoRunningFunc:fChe];
    }else if(gameLevel == 6){
        [self runTransaction:0 heroY:355 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:525 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:405 heroY:355 objectW:330 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:385 heroY:503 objectW:12 objectH:145 fChe:fChe sideValue:0];
        [self runTransaction:372 heroY:503 objectW:12 objectH:145 fChe:fChe sideValue:16];
        [self runTransaction:545 heroY:505 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:615 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:970 heroY:515 objectW:15 objectH:150 fChe:fChe sideValue:16];
        
        [self runTransaction:255 heroY:760-plateWoodStopCount objectW:12 objectH:145 fChe:fChe sideValue:0];
        [self runTransaction:540 heroY:280 objectW:60 objectH:70 fChe:fChe sideValue:0];
    }else if(gameLevel == 7){
        [self runTransaction:206 heroY:375 objectW:188 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:206 heroY:463 objectW:310 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:367 heroY:282 objectW:143 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:10 heroY:535 objectW:15 objectH:140 fChe:fChe sideValue:16];
        [self runTransaction:206 heroY:580 objectW:310 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:500 heroY:570 objectW:12 objectH:190 fChe:fChe sideValue:0];
        [self runTransaction:500 heroY:275 objectW:12 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:210 heroY:365 objectW:12 objectH:100 fChe:fChe sideValue:0];
        if(moveCount2<=0&&domeMoveCount>=130){
            if(platformRotateCount==180)
                [self runTransaction:606 heroY:362+moveCount2 objectW:188 objectH:15 fChe:fChe sideValue:0];
        }else{
            [self runTransaction:596 heroY:372+moveCount2 objectW:208 objectH:15 fChe:fChe sideValue:15];
        }
        [self runTransaction:845 heroY:515 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:805 heroY:270 objectW:50 objectH:70 fChe:fChe sideValue:0];
        [self runTransaction:500 heroY:720 objectW:12 objectH:150 fChe:fChe sideValue:0];
    }else if(gameLevel == 8){
        [self runTransaction:0 heroY:305 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:278 heroY:573 objectW:425 objectH:16 fChe:fChe sideValue:0];
        [self runTransaction:278 heroY:563 objectW:12 objectH:110 fChe:fChe sideValue:0];
        [self runTransaction:278 heroY:405 objectW:425 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:635 heroY:495 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:385 heroY:725 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:392 heroY:390 objectW:15 objectH:190 fChe:fChe sideValue:16];
        [self runTransaction:835 heroY:355 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:820 heroY:635 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:690 heroY:485 objectW:12 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:720 heroY:250 objectW:300 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:960 heroY:340 objectW:12 objectH:200 fChe:fChe sideValue:0];
        [self runTransaction:412 heroY:390 objectW:12 objectH:190 fChe:fChe sideValue:0];
        if(!gateOpenChe)
            [self runTransaction:952 heroY:400 objectW:50 objectH:60 fChe:fChe sideValue:0];
        if(!closeOpenChe)
            [self runTransaction:870 heroY:343 objectW:12 objectH:200 fChe:fChe sideValue:0];
    }else if(gameLevel == 9){
        
        [self runTransaction:230 heroY:576 objectW:12 objectH:400 fChe:fChe sideValue:0];
        [self runTransaction:360 heroY:395 objectW:12 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:240 heroY:405 objectW:405 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:230 heroY:574 objectW:410 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:632 heroY:478 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:632 heroY:495 objectW:112 objectH:15 fChe:fChe sideValue:0];
        [self runTransaction:210 heroY:465 objectW:15 objectH:125 fChe:fChe sideValue:16];
        [self runTransaction:10 heroY:580 objectW:15 objectH:125 fChe:fChe sideValue:16];
        [self runTransaction:360 heroY:740 objectW:180 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:913 heroY:575 objectW:100 objectH:500 fChe:fChe sideValue:0];
        [self runTransaction:775 heroY:283+moveCount2 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:475 heroY:375 objectW:170 objectH:20 fChe:fChe sideValue:15];
    }else if(gameLevel ==10){
        [self runTransaction:0 heroY:323 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:362 heroY:303 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:323 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:493 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:362 heroY:473 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:802 heroY:533 objectW:210 objectH:12 fChe:fChe sideValue:0];
        //ice Box
        [self runTransaction:455 heroY:465 objectW:12 objectH:120 fChe:fChe sideValue:0];
        [self runTransaction:455 heroY:400 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:620 heroY:390 objectW:30 objectH:90 fChe:fChe sideValue:0];
        
        [self runTransaction:400 heroY:210 objectW:180 objectH:60 fChe:fChe sideValue:0];
    }else if(gameLevel == 11){
        [self runTransaction:140 heroY:265 objectW:20 objectH:120 fChe:fChe sideValue:0];
        [self runTransaction:290 heroY:365 objectW:110 objectH:120 fChe:fChe sideValue:0];
        [self runTransaction:390 heroY:265 objectW:12 objectH:50 fChe:fChe sideValue:0];
        [self runTransaction:540 heroY:280 objectW:130 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:620 heroY:340 objectW:150 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:290 objectW:80 objectH:80 fChe:fChe sideValue:0];
        if(switchCount==1)
            [self runTransaction:0 heroY:545 objectW:185 objectH:15 fChe:fChe sideValue:15];
        else
            [self runTransaction:0 heroY:545 objectW:380 objectH:15 fChe:fChe sideValue:15];
        
        if(switchCount==1){
            if(platformRotateCount==0)
                [self runTransaction:195+moveCount2 heroY:555 objectW:190 objectH:12 fChe:fChe sideValue:0];
        }
        [self runTransaction:0 heroY:565 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:130 heroY:745 objectW:660 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:755 heroY:578 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:750 heroY:485 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:750 heroY:472 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:0 heroY:665 objectW:135 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 12){
        
        [self runTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:360 heroY:253 objectW:100 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:510 heroY:270 objectW:110 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:425 heroY:305 objectW:105 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:370 objectW:225 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:380 heroY:370 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:285 heroY:150 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:235+moveCount2 heroY:372 objectW:140 objectH:12 fChe:fChe sideValue:5];
        [self runTransaction:0 heroY:532 objectW:225 objectH:15 fChe:fChe sideValue:0];
        [self runTransaction:380 heroY:532 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:370 objectW:200 objectH:12 fChe:fChe sideValue:0];
        
        if(bridgeOpenCount<70)
            [self runTransaction:890 heroY:640 objectW:12 objectH:130 fChe:fChe sideValue:0];
        else
            [self runTransaction:775 heroY:530 objectW:240 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 13){
        
        [self runTransaction:380 heroY:315 objectW:135 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:335 objectW:200 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:325 objectW:200 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:173 heroY:515+moveCount2 objectW:135 objectH:10 fChe:fChe sideValue:5];
        [self runTransaction:173 heroY:503+moveCount2 objectW:135 objectH:15 fChe:fChe sideValue:15];
        [self runTransaction:0 heroY:465 objectW:125 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:585 objectW:67 objectH:60 fChe:fChe sideValue:0];
        if(fChe)
            [self runTransaction:0 heroY:455 objectW:77 objectH:400 fChe:fChe sideValue:0];
        
        [self runTransaction:585 heroY:435 objectW:190 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:585 heroY:425 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:355 heroY:525 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:810 heroY:565 objectW:190 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:555 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:810 heroY:750+plateWoodStopCount objectW:12 objectH:190 fChe:fChe sideValue:0];
        [self runTransaction:355 heroY:600 objectW:190 objectH:65 fChe:fChe sideValue:0];
        [self runTransaction:440 heroY:305 objectW:12 objectH:150 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        
        [self runTransaction:495 heroY:355 objectW:170 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:495 heroY:345 objectW:170 objectH:15 fChe:fChe sideValue:15];
        
        [self runTransaction:850 heroY:335 objectW:160 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:850 heroY:325 objectW:160 objectH:15 fChe:fChe sideValue:15];
        if(platformRotateCount==0)
            [self runTransaction:240 heroY:515 objectW:190 objectH:15 fChe:fChe sideValue:0];
        
        [self runTransaction:725 heroY:525 objectW:265 objectH:10 fChe:fChe sideValue:0];
        [self runTransaction:725 heroY:515 objectW:265 objectH:15 fChe:fChe sideValue:15];
    }
}

-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe{
    xPosition=xPos;
    yPosition=yPos;
    
    [self jumpTransaction:0 heroY:760 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:990 heroY:760 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:760 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:0 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    
    if(gameLevel == 2){
        [self jumpTransaction:335 heroY:284 objectW:700 objectH:400 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:420 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:343 heroY:530 objectW:90 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:431 heroY:577 objectW:12 objectH:163 fChe:fChe sideValue:0];
        [self jumpTransaction:431 heroY:587 objectW:260 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:431 heroY:420 objectW:312 objectH:15 fChe:fChe sideValue:0];
        [self jumpTransaction:657 heroY:523 objectW:85 objectH:20 fChe:fChe sideValue:11];
        [self jumpTransaction:732 heroY:510 objectW:12 objectH:95 fChe:fChe sideValue:9];
        [self jumpTransaction:555 heroY:350 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:427 heroY:310 objectW:60 objectH:30 fChe:fChe sideValue:0];
    }else if(gameLevel == 3){
        [self jumpTransaction:235 heroY:540 objectW:12 objectH:230 fChe:fChe sideValue:0];
        [self jumpTransaction:235 heroY:548 objectW:195 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:465 objectW:102 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:435 heroY:470 objectW:95 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:520 heroY:460 objectW:12 objectH:160 fChe:fChe sideValue:0];
        [self jumpTransaction:230 heroY:390 objectW:200 objectH:12 fChe:fChe sideValue:11];
        [self jumpTransaction:675 heroY:471 objectW:340 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:680 heroY:520 objectW:40 objectH:55 fChe:fChe sideValue:0];
        [self jumpTransaction:838 heroY:545 objectW:25 objectH:80 fChe:fChe sideValue:9];
        [self jumpTransaction:680 heroY:365 objectW:40 objectH:55 fChe:fChe sideValue:0];
    }else if(gameLevel == 4){
        [self jumpTransaction:0 heroY:305 objectW:295 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:515 objectW:155 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:505 objectW:155 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:168 heroY:420 objectW:112 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:35+moveCount2 heroY:735 objectW:130 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:280 heroY:690 objectW:12 objectH:125 fChe:fChe sideValue:0];
        [self jumpTransaction:280 heroY:575 objectW:12 objectH:180 fChe:fChe sideValue:0];
        [self jumpTransaction:280 heroY:405 objectW:420 objectH:20 fChe:fChe sideValue:0];
        
        [self jumpTransaction:690 heroY:560 objectW:12 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:390 heroY:575 objectW:300 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:285 heroY:490 objectW:280 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:850 heroY:374 objectW:280 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:850 heroY:364 objectW:280 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:700 heroY:515 objectW:110 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:700 heroY:505 objectW:110 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:433 heroY:238 objectW:70 objectH:30 fChe:fChe sideValue:0];
    }else if(gameLevel == 5){
        [self jumpTransaction:0 heroY:285 objectW:155 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:552 objectW:77 objectH:142 fChe:fChe sideValue:0];
        [self jumpTransaction:170 heroY:552 objectW:180 objectH:160 fChe:fChe sideValue:0];
        [self jumpTransaction:350 heroY:404 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:105 heroY:340 objectW:45 objectH:60 fChe:fChe sideValue:9];
        [self jumpTransaction:470 heroY:248 objectW:300 objectH:45 fChe:fChe sideValue:0];
        [self jumpTransaction:480 heroY:280 objectW:290 objectH:32 fChe:fChe sideValue:6];
        [self jumpTransaction:465+moveCount2 heroY:405 objectW:130 objectH:10 fChe:fChe sideValue:5];
        [self jumpTransaction:465+moveCount2 heroY:395 objectW:130 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:865 heroY:345 objectW:150 objectH:12 fChe:fChe sideValue:0];
        
        [self trigoJumpingFunc:890 yPosition:563+(fChe?13:0) angle:20 radiusLength:50 fChe:fChe];
        [self trigoReverseFunc:940 yPosition:428 angle:108 radiusLength:58];
    }else if(gameLevel == 6){
        [self jumpTransaction:0 heroY:355 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:525 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:405 heroY:355 objectW:330 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:405 heroY:345 objectW:330 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:385 heroY:503 objectW:12 objectH:145 fChe:fChe sideValue:0];
        [self jumpTransaction:372 heroY:503 objectW:12 objectH:145 fChe:fChe sideValue:16];
        
        [self jumpTransaction:545 heroY:505 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:615 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:970 heroY:515 objectW:15 objectH:150 fChe:fChe sideValue:16];
        [self jumpTransaction:255 heroY:760-plateWoodStopCount objectW:12 objectH:145 fChe:fChe sideValue:0];
        
        [self jumpTransaction:540 heroY:280 objectW:60 objectH:70 fChe:fChe sideValue:0];
    }else if(gameLevel == 7){
        
        [self jumpTransaction:206 heroY:375 objectW:188 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:500 heroY:570 objectW:12 objectH:190 fChe:fChe sideValue:0];
        [self jumpTransaction:500 heroY:275 objectW:12 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:367 heroY:282 objectW:143 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:206 heroY:463 objectW:310 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:206 heroY:580 objectW:310 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:10 heroY:535 objectW:15 objectH:140 fChe:fChe sideValue:16];
        [self jumpTransaction:210 heroY:365 objectW:12 objectH:100 fChe:fChe sideValue:0];
        
        if(moveCount2<=0&&domeMoveCount>=130){
            if(platformRotateCount==180)
                [self jumpTransaction:606 heroY:362+moveCount2 objectW:188 objectH:15 fChe:fChe sideValue:18];
        }else{
            if(domeMoveCount!=0)
                [self jumpTransaction:606 heroY:362+moveCount2 objectW:188 objectH:15 fChe:fChe sideValue:0];
        }
        
        [self jumpTransaction:845 heroY:515 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:805 heroY:270 objectW:50 objectH:70 fChe:fChe sideValue:0];
        [self jumpTransaction:500 heroY:720 objectW:12 objectH:150 fChe:fChe sideValue:0];
    }else if(gameLevel == 8){
        [self jumpTransaction:0 heroY:305 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:278 heroY:573 objectW:425 objectH:16 fChe:fChe sideValue:0];
        [self jumpTransaction:278 heroY:563 objectW:12 objectH:110 fChe:fChe sideValue:0];
        [self jumpTransaction:278 heroY:405 objectW:425 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:635 heroY:495 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:385 heroY:725 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:392 heroY:390 objectW:15 objectH:190 fChe:fChe sideValue:16];
        [self jumpTransaction:835 heroY:355 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:820 heroY:635 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:690 heroY:485 objectW:12 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:720 heroY:250 objectW:300 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:960 heroY:340 objectW:12 objectH:200 fChe:fChe sideValue:0];
        [self jumpTransaction:412 heroY:390 objectW:12 objectH:190 fChe:fChe sideValue:0];
        if(!gateOpenChe)
            [self jumpTransaction:952 heroY:400 objectW:50 objectH:60 fChe:fChe sideValue:0];
        if(!closeOpenChe)
            [self jumpTransaction:870 heroY:343 objectW:12 objectH:200 fChe:fChe sideValue:0];
    }else if(gameLevel == 9){
        
        [self jumpTransaction:235 heroY:566 objectW:12 objectH:400 fChe:fChe sideValue:0];
        [self jumpTransaction:360 heroY:395 objectW:12 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:240 heroY:405 objectW:405 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:230 heroY:574 objectW:410 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:632 heroY:478 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:632 heroY:495 objectW:112 objectH:15 fChe:fChe sideValue:0];
        [self jumpTransaction:210 heroY:465 objectW:15 objectH:125 fChe:fChe sideValue:16];
        [self jumpTransaction:10 heroY:580 objectW:15 objectH:125 fChe:fChe sideValue:16];
        [self jumpTransaction:360 heroY:740 objectW:180 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:913 heroY:575 objectW:100 objectH:500 fChe:fChe sideValue:0];
        [self jumpTransaction:775 heroY:283+moveCount2 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:475 heroY:375 objectW:170 objectH:20 fChe:fChe sideValue:15];
        
    }else if(gameLevel ==10){
        [self jumpTransaction:0 heroY:323 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:362 heroY:303 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:770 heroY:323 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:493 objectW:207 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:362 heroY:473 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:802 heroY:533 objectW:210 objectH:12 fChe:fChe sideValue:0];
        
        //ice Box
        [self jumpTransaction:455 heroY:465 objectW:12 objectH:120 fChe:fChe sideValue:0];
        [self jumpTransaction:455 heroY:400 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:620 heroY:390 objectW:30 objectH:90 fChe:fChe sideValue:0];
        
        [self jumpTransaction:400 heroY:210 objectW:180 objectH:60 fChe:fChe sideValue:0];
    }else if(gameLevel == 11){
        
        [self jumpTransaction:140 heroY:265 objectW:20 objectH:120 fChe:fChe sideValue:9];
        [self jumpTransaction:290 heroY:365 objectW:110 objectH:120 fChe:fChe sideValue:9];
        [self jumpTransaction:390 heroY:265 objectW:12 objectH:50 fChe:fChe sideValue:0];
        [self jumpTransaction:540 heroY:280 objectW:130 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:620 heroY:340 objectW:150 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:770 heroY:290 objectW:80 objectH:80 fChe:fChe sideValue:0];
        if(switchCount==1)
            [self jumpTransaction:0 heroY:545 objectW:185 objectH:15 fChe:fChe sideValue:15];
        else
            [self jumpTransaction:0 heroY:545 objectW:380 objectH:15 fChe:fChe sideValue:15];
        if(switchCount==1){
            if(platformRotateCount==0)
                [self jumpTransaction:195+moveCount2 heroY:555 objectW:190 objectH:12 fChe:fChe sideValue:18];
        }
        [self jumpTransaction:0 heroY:565 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:130 heroY:745 objectW:660 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:755 heroY:578 objectW:260 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:750 heroY:485 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:750 heroY:472 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:0 heroY:665 objectW:135 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 12){
        
        [self jumpTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:360 heroY:253 objectW:100 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:510 heroY:270 objectW:110 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:425 heroY:305 objectW:105 objectH:80 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:370 objectW:225 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:380 heroY:370 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:285 heroY:150 objectW:190 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:235+moveCount2 heroY:372 objectW:140 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:0 heroY:532 objectW:225 objectH:15 fChe:fChe sideValue:0];
        [self jumpTransaction:380 heroY:532 objectW:280 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:370 objectW:200 objectH:12 fChe:fChe sideValue:0];
        
        if(bridgeOpenCount<70)
            [self jumpTransaction:890 heroY:640 objectW:12 objectH:130 fChe:fChe sideValue:0];
        else
            [self jumpTransaction:775 heroY:530 objectW:240 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 13){
        [self jumpTransaction:380 heroY:315 objectW:135 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:335 objectW:200 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:325 objectW:200 objectH:15 fChe:fChe sideValue:15];
        [self jumpTransaction:173 heroY:515+moveCount2 objectW:135 objectH:10 fChe:fChe sideValue:5];
        [self jumpTransaction:173 heroY:503+moveCount2 objectW:135 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:0 heroY:465 objectW:125 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:585 objectW:67 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:455 objectW:77 objectH:400 fChe:fChe sideValue:0];
        
        [self jumpTransaction:585 heroY:435 objectW:190 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:585 heroY:425 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:355 heroY:525 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:810 heroY:565 objectW:190 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:555 objectW:190 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:810 heroY:750+plateWoodStopCount objectW:12 objectH:190 fChe:fChe sideValue:0];
        [self jumpTransaction:355 heroY:600 objectW:190 objectH:65 fChe:fChe sideValue:0];
        [self jumpTransaction:440 heroY:305 objectW:12 objectH:150 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        [self jumpTransaction:495 heroY:355 objectW:170 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:495 heroY:345 objectW:170 objectH:15 fChe:fChe sideValue:15];
        
        [self jumpTransaction:850 heroY:335 objectW:160 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:850 heroY:325 objectW:160 objectH:15 fChe:fChe sideValue:15];
        
        if(platformRotateCount==0)
            [self jumpTransaction:240 heroY:515 objectW:190 objectH:15 fChe:fChe sideValue:18];
        
        
        [self jumpTransaction:725 heroY:525 objectW:265 objectH:10 fChe:fChe sideValue:0];
        [self jumpTransaction:725 heroY:515 objectW:265 objectH:15 fChe:fChe sideValue:15];
    }
}

-(void)jumpTransaction:(CGFloat)heroX  heroY:(CGFloat)heroY objectW:(CGFloat)objectW objectH:(CGFloat)objectH fChe:(BOOL)fChe sideValue:(int)sValue{
    if(!fChe){
        //reverseJump
        if(!reverseJump&&!landingChe){
            if(xPosition >= heroX-50 && xPosition<=((heroX-50)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY){
                topHittingCollisionChe=NO;
                if(sValue!=16&&sValue!=15){
                    reverseJump=YES;
                    xPosition=heroX-50;
                    if(sValue==6&&!trappedChe){
                        trappedChe=YES;
                    }
                }
            }
            //Land
            if(xPosition >= heroX-25 && xPosition<=((heroX-35)+objectW+20) && yPosition > heroY && yPosition <= heroY+17){
                if(sValue!=15){
                    if(sValue!=8){
                        if(sValue!=1){
                            if(stickyReleaseCount==0){
                                landingChe=YES;
                                yPosition=heroY+17;
                            }
                            if(sValue!=9){
                                jumpDiff=xPosition-(heroX-50);
                                jumpDiffChe=YES;
                            }
                            if(sValue==5){
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
                            }else if(sValue==6&&!trappedChe){
                                trappedChe=YES;
                            }else  if(sValue==11&&!visibleWindowChe)
                                visibleWindowChe=YES;
                            else if(sValue==18&&stickyReleaseCount==0){
                                heroRotateChe=YES;
                                if(gameLevel ==11){
                                    movePlatformChe=YES;
                                    movePlatformX=xPosition;
                                    movePlatformY=yPosition;
                                    landMoveCount=moveCount2;
                                }
                            }
                            if(gameLevel == 5&&sValue==15){
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
                            }
                        }else{
                            autoJumpChe2=YES;
                            autoJumpSpeedValue=1;
                        }
                    }
                }else{
                    topHittingCollisionChe=NO;
                    reverseJump=YES;
                    xPosition=heroX-35;
                }
            }
        }
    }else{
        if(!reverseJump&&!landingChe){
            if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
                topHittingCollisionChe=NO;
                if(sValue!=16&&sValue!=15){
                    reverseJump=YES;
                    xPosition=(heroX-10)+objectW;
                    if(sValue==6&&!trappedChe){
                        trappedChe=YES;
                    }
                }
            }
            //Land
            if(xPosition >= heroX-30 && xPosition<=((heroX-10)+objectW-20) && yPosition > heroY && yPosition <= heroY+17){
                if(sValue!=15){
                    if(sValue!=8){
                        if(sValue!=1){
                            
                            if(stickyReleaseCount==0){
                                landingChe=YES;
                                yPosition=heroY+17;
                            }
                            if(sValue!=9){
                                jumpDiff=((heroX-10)+objectW-20)-xPosition;
                                jumpDiffChe=YES;
                            }
                            if(sValue==5){
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
                            }else if(sValue==6&&!trappedChe){
                                trappedChe=YES;
                            }else  if(sValue==11&&!visibleWindowChe)
                                visibleWindowChe=YES;
                            else if(sValue==18&&stickyReleaseCount==0){
                                heroRotateChe=YES;
                                if(gameLevel ==11){
                                    movePlatformChe=YES;
                                    movePlatformX=xPosition;
                                    movePlatformY=yPosition;
                                    landMoveCount=moveCount2;
                                }
                            }
                            if(gameLevel == 5&&sValue==15){
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
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
    }
    
    
    if(backHeroY<yPosition){
        int iValue=(fChe?33:0);
        if(xPosition-iValue >= heroX-40+(sValue==15?12:0) && xPosition-iValue<=((heroX-50)+objectW+20)-(sValue==15?12:0) && yPosition > heroY-(objectH+20) && yPosition <= heroY-(objectH)&&!topHittingCollisionChe&&!stickyChe){
            if(sValue!=18){
                if(sValue!=15){
                    topHittingCollisionChe=YES;
                    reverseJump=YES;
                }else{
                    if(stickyCount==0){
                        stickyChe=YES;
                        landingChe=YES;
                        yPosition=heroY-22;
                        if(gameLevel == 4){
                            if(yPosition>=710){
                                if(moveCount==0)
                                    moveCount=1;
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
                            }
                        }else if(gameLevel == 5){
                            movePlatformChe=YES;
                            movePlatformX=xPosition;
                            movePlatformY=yPosition;
                            landMoveCount=moveCount2;
                        }else if(gameLevel == 13){
                            if(xPosition<320){
                                
                                movePlatformChe=YES;
                                movePlatformX=xPosition;
                                movePlatformY=yPosition;
                                landMoveCount=moveCount2;
                            }
                        }
                    }
                }
            }else{
                if(stickyReleaseCount==0){
                    heroRotateChe=YES;
                    landingChe=YES;
                    if(gameLevel ==11){
                        movePlatformChe=YES;
                        movePlatformX=xPosition;
                        movePlatformY=yPosition;
                        landMoveCount=moveCount2;
                    }
                }
            }
        }
    }
    if(sValue==16){
        if(!fChe){
            if(xPosition >= heroX-30 && xPosition<=((heroX-30)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY&&!stickyChe2&&stickyReleaseCount==0){
                if(!stickyChe2){
                    xPosition=heroX-30;
                    landingChe=YES;
                    stickyChe2=YES;
                }
            }
        }else{
            if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
                xPosition=(heroX-10)+objectW;
                landingChe=YES;
                stickyChe2=YES;
            }
        }
    }
    
    backHeroY=yPosition;
}
-(void)runTransaction:(CGFloat)heroX  heroY:(CGFloat)heroY objectW:(CGFloat)objectW objectH:(CGFloat)objectH fChe:(BOOL)fChe sideValue:(int)sValue{
    if(!fChe){
        int aValue=(trigoVisibleChe?10:0);
        //Running
        if(xPosition >= heroX-45+aValue && xPosition<=((heroX-45)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=heroX-45;
            trigoRunningCheck=YES;
            if(sValue==6&&!trappedChe)
                trappedChe=YES;
        }else if(xPosition >= ((heroX-10)+(objectW-10)) && xPosition<=((heroX-10)+(objectW)) && yPosition > heroY && yPosition <= heroY+17&&!autoJumpChe){
            autoJumpChe=YES;
            if(movePlatformChe)
                movePlatformChe=NO;
        }
    }else{
        if(xPosition >= ((heroX-15)+(objectW-20)) && xPosition<=((heroX+5)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=(heroX+5)+objectW;
            trigoRunningCheck=YES;
            if(sValue==6&&!trappedChe)
                trappedChe=YES;
        }else if(xPosition >= heroX-50 && xPosition<=((heroX-50)+30) && yPosition > heroY && yPosition <= heroY+17&&!autoJumpChe){
            autoJumpChe=YES;
            if(movePlatformChe)
                movePlatformChe=NO;
        }
    }
    
    
    if(stickyChe&&sValue==15){
        if(!fChe){
            if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition > heroY-50 && yPosition <= heroY+17&&!autoJumpChe){
                autoJumpChe=YES;
                if(movePlatformChe)
                    movePlatformChe=NO;
            }
        }else{
            if(xPosition >= heroX-30 && xPosition<=((heroX-50)+30) && yPosition > heroY-50 && yPosition <= heroY+17&&!autoJumpChe){
                autoJumpChe=YES;
                if(movePlatformChe)
                    movePlatformChe=NO;
            }
        }
    }
}
-(void)trigoJumpingFunc:(CGFloat)xPos yPosition:(CGFloat)yPos angle:(int)angle radiusLength:(int)rLength fChe:(BOOL)fChe{
    
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
        CGFloat yy=[trigo circley:i*2 a:angle]+yPos-10;
        
        if(xPosition>xx &&xPosition<xx+10 && yPosition>yy && yPosition<yy+10&&!reverseJump){
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
            CGFloat xx=[trigo circlex:82 a:i]+680;
            CGFloat yy=[trigo circley:60 a:i]+360+domeMoveCount;
            if(xPosition>xx+20+fValue &&xPosition<xx+30+fValue && yPosition>yy-12 && yPosition<yy+32&&!autoJumpChe){
                if(i>4){
                    landingChe=YES;
                    yPosition=yy+18;
                    domeAngle=i;
                    domChe=YES;
                    if(i<=90)
                        domeSideChe=YES;
                }
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
        
        CGFloat xx=[trigo circlex:82 a:domeAngle]+680;
        CGFloat yy=[trigo circley:60 a:domeAngle]+360+domeMoveCount;
        
        xPosition=xx;
        yPosition=yy;
        
    }
    
}



@end
