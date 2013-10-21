//
//  CheesePosition.m
//  FreeTheMice
//
//  Created by karthik gopal on 04/02/13.
//
//

#import "StrongGameFunc.h"
#import "cocos2d.h"

@implementation StrongGameFunc

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
@synthesize movePlatformChe;
@synthesize movePlatformX;
@synthesize movePlatformY;
@synthesize landMoveCount;
@synthesize stoolCount;
@synthesize honeyPotCount;
@synthesize honeyPotCount2;
@synthesize honeyBottleCount;
@synthesize honeyBottleCount2;
@synthesize pushChe;
@synthesize appleWoodCount;
@synthesize flowerFallRotate;
@synthesize flowerFallChe;
@synthesize siverPotCount;
@synthesize siverPotCount2;
@synthesize toasterBreadCount;
@synthesize boxCount;
@synthesize boxCount2;
@synthesize visibleWindowChe;
@synthesize teaPotCount;
@synthesize teaPotCount2;
@synthesize vesselsCount;
@synthesize vesselsCount2;
@synthesize vesselsMoveCount;
@synthesize moveChe;
@synthesize crackedMoveCount;
@synthesize crackRotateValue;
@synthesize trigoHeroAngle;
@synthesize trigoVisibleChe;
@synthesize trigoRunningCheck;
@synthesize trigoJumpPower;
@synthesize trappedVesselsChe;
@synthesize catStopWoodCount;
@synthesize domChe;
@synthesize domeMoveCount;
@synthesize domeAngle;
@synthesize domeEnterChe;
@synthesize domeSideChe;
@synthesize heightMoveChe;
@synthesize domeSwitchChe;
@synthesize milkRotateCount;
@synthesize exitCount;
@synthesize milkMoveCount;
@synthesize boxCount3;
@synthesize boxCount4;
@synthesize externCount;
@synthesize centerBoxChe;
@synthesize releasePushChe;
@synthesize gateOpenChe;
@synthesize  notCollideBlockChe;

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
            if(iValue==0)
                cheesePosition = ccp(235, 320);
            else if(iValue==1)
                cheesePosition = ccp(50, 328);
            else if(iValue==2)
                cheesePosition = ccp(773, 400);
            else if(iValue==3)
                cheesePosition = ccp(560, 566);
            else if(iValue==4)
                cheesePosition = ccp(828, 670);
        }else if(gLevel ==3){
            if(iValue==0)
                cheesePosition = ccp(300, 458);
            else if(iValue==1)
                cheesePosition = ccp(50, 608);
            else if(iValue==2)
                cheesePosition = ccp(670, 530);
            else if(iValue==3)
                cheesePosition = ccp(850, 530);
            else if(iValue==4)
                cheesePosition = ccp(740, 362);
        }else if(gLevel ==4){
            if(iValue==0)
                cheesePosition = ccp(400, 290);
            else if(iValue==1)
                cheesePosition = ccp(520, 570);
            else if(iValue==2)
                cheesePosition = ccp(820, 430);
            else if(iValue==3)
                cheesePosition = ccp(380, 520);
            else if(iValue==4)
                cheesePosition = ccp(900, 290);
            
        }else if(gLevel ==5){
            if(iValue==0)
                cheesePosition = ccp(30, 353);
            else if(iValue==1)
                cheesePosition = ccp(30, 620);
            else if(iValue==2)
                cheesePosition = ccp(480, 523);
            else if(iValue==3)
                cheesePosition = ccp(985, 643);
            else if(iValue==4)
                cheesePosition = ccp(895, 262);
        }else if(gLevel == 6){
            if(iValue==0)
                cheesePosition = ccp(670, 260);
            else if(iValue==1)
                cheesePosition = ccp(170, 413);
            else if(iValue==2)
                cheesePosition = ccp(400, 583);
            else if(iValue==3)
                cheesePosition = ccp(610, 483);
            else if(iValue==4)
                cheesePosition = ccp(910, 583);
        }else if(gLevel == 7){
            if(iValue==0)
                cheesePosition = ccp(920, 260);
            else if(iValue==1)
                cheesePosition = ccp(70, 500);
            else if(iValue==2)
                cheesePosition = ccp(720, 260);
            else if(iValue==3)
                cheesePosition = ccp(655, 374);
            else if(iValue==4)
                cheesePosition = ccp(925, 444);
        }else if(gLevel == 8){
            if(iValue==0)
                cheesePosition = ccp(50, 650);
            else if(iValue==1)
                cheesePosition = ccp(430, 430);
            else if(iValue==2)
                cheesePosition = ccp(960, 575);
            else if(iValue==3)
                cheesePosition = ccp(960, 520);
            else if(iValue==4)
                cheesePosition = ccp(900, 310);
        }else if(gLevel == 9){
            if(iValue==0)
                cheesePosition = ccp(50, 525);
            else if(iValue==1)
                cheesePosition = ccp(530, 570);
            else if(iValue==2)
                cheesePosition = ccp(590, 350);
            else if(iValue==3)
                cheesePosition = ccp(870, 280);
            else if(iValue==4)
                cheesePosition = ccp(970, 620);
        }else if(gLevel == 10){
            if(iValue==0)
                cheesePosition = ccp(170, 460);
            else if(iValue == 1)
                cheesePosition = ccp(530, 305);
            else if(iValue == 2)
                cheesePosition = ccp(880, 305);
            else if(iValue == 3)
                cheesePosition = ccp(30, 305);
            else if(iValue == 4)
                cheesePosition = ccp(520, 455);
            
        }else if(gLevel == 11){
            if(iValue==0)
                cheesePosition = ccp(220, 190);
            else if(iValue==1)
                cheesePosition = ccp(170, 380);
            else if(iValue==2)
                cheesePosition = ccp(120, 470);
            else if(iValue==3)
                cheesePosition = ccp(900, 190);
            else if(iValue==4)
                cheesePosition = ccp(20, 570);
        }else if(gLevel == 12){
            if(iValue==0)
                cheesePosition = ccp(170, 305);
            else if(iValue==1)
                cheesePosition = ccp(170, 405);
            else if(iValue==2)
                cheesePosition = ccp(480, 305);
            else if(iValue==3)
                cheesePosition = ccp(850, 305);
            else if(iValue==4)
                cheesePosition = ccp(470, 85);
            
        }else if(gLevel == 13){
            if(iValue==0)
                cheesePosition = ccp(15, 475);
            else if(iValue==1)
                cheesePosition = ccp(15, 597);
            else if(iValue==2)
                cheesePosition = ccp(445, 574);
            else if(iValue==3)
                cheesePosition = ccp(975, 534);
            else if(iValue==4)
                cheesePosition = ccp(425, 264);
        }else if(gLevel == 14){
            if(iValue==0)
                cheesePosition = ccp(30, 260);
            else if(iValue==1)
                cheesePosition = ccp(450, 320);
            else if(iValue==2)
                cheesePosition = ccp(714, 320);
            else if(iValue==3)
                cheesePosition = ccp(900, 320);
            else if(iValue==4)
                cheesePosition = ccp(570, 550);
        }
    }
    return cheesePosition;
}

-(CGPoint)getPlatformPosition:(int)level {
    CGPoint platformPosition;
    if(level==1)
        platformPosition=ccp(0,160);
    else if(level==2)
        platformPosition=ccp(0,230);
    else if(level==3)
        platformPosition=ccp(0,369);
    else if(level==4)
        platformPosition=ccp(0,300);
    else if(level==5)
        platformPosition=ccp(0,272);
    else if(level==6)
        platformPosition=ccp(0,269);
    else if(level==7)
        platformPosition=ccp(0,269);
    else if(level==8)
        platformPosition=ccp(0,269);
    else if(level==9)
        platformPosition=ccp(0,289);
    else if(level == 10)
        platformPosition=ccp(0,190);
    else if(level == 11)
        platformPosition=ccp(0,190);
    else if(level == 12)
        platformPosition=ccp(0,90);
    else if(level == 13)
        platformPosition=ccp(80,266);
    else if(level == 14)
        platformPosition=ccp(0,266);
    
    return platformPosition;
}

-(void)render{
    
    if(gameLevel==2){
        if(honeyPotCount>=55){
            honeyPotCount2+=2.0;
            honeyPotCount2=(honeyPotCount2>67?67:honeyPotCount2);
        }
        if(!runChe){
            if(honeyPotCount>=30){
                honeyPotCount+=1;
                honeyPotCount=(honeyPotCount>=55?55:honeyPotCount);
            }
            if(honeyBottleCount>=30){
                honeyBottleCount+=1;
                honeyBottleCount=(honeyBottleCount>=58?58:honeyBottleCount);
            }
        }
        if(honeyBottleCount>=58){
            honeyBottleCount2+=2;
            honeyBottleCount2=(honeyBottleCount2>10?10:honeyBottleCount2);
        }
    }else if(gameLevel == 3){
        if(flowerFallRotate!=0){
            flowerFallRotate+=1;
            flowerFallRotate=(flowerFallRotate>90?90:flowerFallRotate);
            
        }
    }else if(gameLevel ==4){
        if(siverPotCount<=-155){
            siverPotCount-=1;
            siverPotCount=(siverPotCount<-175?-175:siverPotCount);
        }
        if(siverPotCount<=-175){
            siverPotCount2+=2;
            siverPotCount2=(siverPotCount2>=280?280:siverPotCount2);
        }
        
        if(siverPotCount>=180){
            siverPotCount+=1;
            siverPotCount=(siverPotCount>=200?200:siverPotCount);
        }
        if(siverPotCount>=200){
            siverPotCount2+=2;
            siverPotCount2=(siverPotCount2>42?42:siverPotCount2);
        }
        
        if(siverPotCount2>265){
            toasterBreadCount+=1;
            toasterBreadCount=(toasterBreadCount>40?40:toasterBreadCount);
        }
        
        if(boxCount<=-20){
            boxCount-=1;
            boxCount=(boxCount<-115?-115:boxCount);
        }
        if(boxCount<=-75){
            boxCount2+=2;
            boxCount2=(boxCount2>67?67:boxCount2);
        }
    }else if(gameLevel ==5){
        if(teaPotCount>=70){
            teaPotCount+=1;
            teaPotCount=(teaPotCount>=90?90:teaPotCount);
        }
        if(teaPotCount>=90){
            teaPotCount2+=1;
            teaPotCount2=(teaPotCount2>=90?90:teaPotCount2);
        }
        if(!moveChe){
            moveCount+=0.3;
            moveCount=(moveCount>200?0:moveCount);
            moveCount2=(moveCount<=100?moveCount:100-(moveCount-100));
            if(vesselsCount2==0)
                vesselsMoveCount=(moveCount<=100?moveCount:100-(moveCount-100));
        }
        if(vesselsCount<=-30){
            vesselsCount-=1;
            vesselsCount=(vesselsCount<=-50?-50:vesselsCount);
        }
        if(vesselsCount<=-50){
            vesselsCount2+=2;
            vesselsCount2=(vesselsCount2>262?262:vesselsCount2);
        }
        
        if(crackedMoveCount>=60){
            crackedMoveCount+=1;
            crackedMoveCount=(crackedMoveCount>=130?130:crackedMoveCount);
        }
        if(crackedMoveCount>=130){
            crackRotateValue+=0.3;
            crackRotateValue=(crackRotateValue>25?25:crackRotateValue);
            
        }
        if(trigoJumpPower>=1){
            trigoJumpPower+=1;
            trigoJumpPower=(trigoJumpPower>=30?0:trigoJumpPower);
        }
    }else if(gameLevel == 6){
        if(honeyPotCount>=80){
            catStopWoodCount+=0.5;
            catStopWoodCount=(catStopWoodCount>130?130:catStopWoodCount);
        }
    }else if(gameLevel == 7){
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
    }else if(gameLevel ==8){
        
        if(honeyPotCount>=50){
            honeyPotCount+=1;
            honeyPotCount=(honeyPotCount>=70?70:honeyPotCount);
        }
        if(honeyPotCount>=70){
            honeyPotCount2+=1;
            honeyPotCount2=(honeyPotCount2>65?65:honeyPotCount2);
        }
        if(milkRotateCount>=10){
            milkRotateCount+=1;
            milkRotateCount=(milkRotateCount>=90?90:milkRotateCount);
        }
    }else if(gameLevel ==9){
        if(milkRotateCount>=10){
            milkRotateCount+=1;
            milkRotateCount=(milkRotateCount>=90?90:milkRotateCount);
        }
        
        if(combinationBoxPos[0][1]>-115){
            if(combinationBoxPos[0][0]>=10){
                combinationBoxPos[0][0]+=1;
                combinationBoxPos[0][0]=(combinationBoxPos[0][0]>=30?30:combinationBoxPos[0][0]);
            }
            if(combinationBoxPos[0][0]>=30){
                combinationBoxPos[0][1]-=2;
                combinationBoxPos[0][1]=(combinationBoxPos[0][1]<=-115?-115:combinationBoxPos[0][1]);
            }
        }
        
        if(combinationBoxPos[1][1]>-115){
            if(combinationBoxPos[1][0]>=10){
                combinationBoxPos[1][0]+=1;
                combinationBoxPos[1][0]=(combinationBoxPos[1][0]>=30?30:combinationBoxPos[1][0]);
            }
            if(combinationBoxPos[1][0]>=30){
                combinationBoxPos[1][1]-=2;
                combinationBoxPos[1][1]=(combinationBoxPos[1][1]<=-115?-115:combinationBoxPos[1][1]);
            }
        }
        if(combinationBoxPos[2][1]>-115){
            if(combinationBoxPos[2][0]<=-10){
                combinationBoxPos[2][0]-=1;
                combinationBoxPos[2][0]=(combinationBoxPos[2][0]<=-30?-30:combinationBoxPos[2][0]);
            }
            if(combinationBoxPos[2][0]<=-30){
                combinationBoxPos[2][1]-=2;
                combinationBoxPos[2][1]=(combinationBoxPos[2][1]<=-115?-115:combinationBoxPos[2][1]);
            }
        }
        
    }else if(gameLevel ==11){
        if(moveCount2!=0){
            moveCount+=0.6;
            moveCount=(moveCount>440?1:moveCount);
            moveCount2=(moveCount<=220?moveCount:220-(moveCount-220));
        }
        if(honeyPotCount<=-20){
            honeyPotCount-=1;
            honeyPotCount=(honeyPotCount<-50?-50:honeyPotCount);
        }
        if(honeyPotCount<=-50){
            honeyPotCount2+=2;
            honeyPotCount2=(honeyPotCount2>30?30:honeyPotCount2);
        }
    }else if(gameLevel == 12){
        if(externCount!=0){
            if(boxCount2<=-70){
                externCount-=1;
                externCount=(externCount<=-70?-70:externCount);
            }
        }
        if(!centerBoxChe){
            if(boxCount3<=-130){
                boxCount3-=1;
                if(externCount==0)
                    boxCount3=(boxCount3<=-185?-185:boxCount3);
                else
                    boxCount3=(boxCount3<=-150?-150:boxCount3);
            }
            if(externCount==0){
                if(boxCount3<=-185){
                    boxCount4+=2;
                    if(externCount==0)
                        boxCount4=(boxCount4>235?235:boxCount4);
                }
            }else{
                if(boxCount3<=-150){
                    boxCount4+=2;
                    if(boxCount4>115){
                        boxCount4=115;
                        centerBoxChe=YES;
                    }
                }
            }
        }
    }else if(gameLevel == 13){
        if(honeyPotCount<=-225){
            honeyPotCount2+=1;
            honeyPotCount2=(honeyPotCount2>=10?10:honeyPotCount2);
        }
        
        if(moveCount2!=0){
            moveCount-=0.6;
            moveCount=(moveCount<-350?-1:moveCount);
            moveCount2=(moveCount>=-175?moveCount:-175-(moveCount + 175));
        }
        
        if(milkRotateCount>=10){
            milkRotateCount+=1;
            milkRotateCount=(milkRotateCount>=90?90:milkRotateCount);
        }
        
        if(catStopWoodCount!=0){
            catStopWoodCount+=1;
            catStopWoodCount=(catStopWoodCount>=100?100:catStopWoodCount);
        }
    }else if(gameLevel == 14){
        //1
        if(!blockChe[0]){
            if(blockCount[0][1] == 0){
                if(blockCount[0][0]<=-10){
                    releasePushChe=YES;
                    blockCount[0][0]-=1;
                    blockCount[0][0] = (blockCount[0][0]<=-40?-40:blockCount[0][0]);
                }
            }
            if(blockCount[0][0]<=-40){
                blockCount[0][1]+=2;
                blockCount[0][1] = (blockCount[0][1]>=285?285:blockCount[0][1]);
            }
        }
        
        //2
        if(!blockChe[1]){
            if(blockCount[1][1]==0){
                if(blockCount[1][0]>=10){
                    releasePushChe=YES;
                    blockCount[1][0]+=1;
                    blockCount[1][0] = (blockCount[1][0]>=40?40:blockCount[1][0]);
                }
            }
            if(blockCount[1][0]>=40){
                blockCount[1][1]+=2;
                blockCount[1][1] = (blockCount[1][1]>=285?285:blockCount[1][1]);
            }
        }
        
        //3
        if(!blockChe[2]){
            if(blockCount[2][1]==0){
                if(blockCount[2][0]<=-10){
                    releasePushChe=YES;
                    blockCount[2][0]-=1;
                    blockCount[2][0] = (blockCount[2][0]<=-40?-40:blockCount[2][0]);
                }
            }
            if(blockCount[2][0]<=-40){
                blockCount[2][1]+=2;
                blockCount[2][1] = (blockCount[2][1]>=205?205:blockCount[2][1]);
            }
        }
        
        //4
        if(!blockChe[3]){
            if(blockCount[3][1]==0){
                if(blockCount[3][0]<=-10){
                    releasePushChe=YES;
                    blockCount[3][0]-=1;
                    blockCount[3][0] = (blockCount[3][0]<=-40?-40:blockCount[3][0]);
                }
            }
            if(blockCount[3][0]<=-40){
                blockCount[3][1]+=2;
                blockCount[3][1] = (blockCount[3][1]>=285?285:blockCount[3][1]);
            }
        }
        
        //5
        if(!blockChe[4]){
            if(blockCount[4][1]==0){
                if(blockCount[4][0]>=10){
                    releasePushChe=YES;
                    blockCount[4][0]+=1;
                    blockCount[4][0] = (blockCount[4][0]>=40?40:blockCount[4][0]);
                }
            }
            if(blockCount[4][0]>=40){
                if(blockCount[4][1]<=60){
                    blockCount[4][1]+=2;
                    blockCount[4][1] = (blockCount[4][1]>=60?60:blockCount[4][1]);
                }
            }
            if(blockCount[4][1]==60){
                blockCount[4][0]-=1;
                blockCount[4][0]=(blockCount[4][0]<=20?20:blockCount[4][0]);
            }
            if(blockCount[4][0]<=20&&blockCount[4][1]>=60&&blockCount[4][1]<=181){
                blockCount[4][1]+=2;
                blockCount[4][1] = (blockCount[4][1]>=181?181:blockCount[4][1]);
            }
            if(blockCount[4][1]==181&&blockCount[4][0]<=-90){
                releasePushChe=YES;
                blockCount[4][0]-=1;
                blockCount[4][0] = (blockCount[4][0]<=-120?-120:blockCount[4][0]);
            }
            if(blockCount[4][1]>=181&&blockCount[4][0]<=-120){
                blockCount[4][1]+=2;
                blockCount[4][1] = (blockCount[4][1]>=285?285:blockCount[4][1]);
            }
        }
        
        //6
        if(!blockChe[5]){
            if(blockCount[5][1]==0){
                if(blockCount[5][0]<=-70){
                    releasePushChe=YES;
                    blockCount[5][0]-=1;
                    blockCount[5][0] = (blockCount[5][0]<=-100?-100:blockCount[5][0]);
                }
            }
            if(blockCount[5][0]<=-100){
                blockCount[5][1]+=2;
                blockCount[5][1] = (blockCount[5][1]>=105?105:blockCount[5][1]);
            }
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
    
    if(gameLevel == 2){
        [self runTransaction:0 heroY:318 objectW:190 objectH:15 fChe:fChe sideValue:0];
        [self runTransaction:190+stoolCount heroY:310 objectW:90 objectH:110 fChe:fChe sideValue:20];
        [self runTransaction:425 heroY:383 objectW:600 objectH:210 fChe:fChe sideValue:0];
        [self runTransaction:555 heroY:450 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:383 heroY:550 objectW:134 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:525 heroY:628 objectW:217 objectH:15 fChe:fChe sideValue:0];
        [self runTransaction:632 heroY:616 objectW:110 objectH:110 fChe:fChe sideValue:0];
        [self runTransaction:695+honeyPotCount heroY:498-honeyPotCount2 objectW:50 objectH:50 fChe:fChe sideValue:21];
        if(honeyPotCount2!=67)
            [self runTransaction:945 heroY:428 objectW:65 objectH:70 fChe:fChe sideValue:0];
        [self runTransaction:695+honeyBottleCount heroY:690-honeyBottleCount2 objectW:50 objectH:70 fChe:fChe sideValue:22];
    }else if(gameLevel==3){
        
        [self runTransaction:178+appleWoodCount heroY:445 objectW:173 objectH:100 fChe:fChe sideValue:23];
        [self runTransaction:606 heroY:523 objectW:410 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:555 heroY:380 objectW:80 objectH:80 fChe:fChe sideValue:0];
        if(flowerFallRotate==0)
            [self runTransaction:750 heroY:595 objectW:20 objectH:70 fChe:fChe sideValue:24];
        else{
            if(flowerFallChe)
                [self runTransaction:690 heroY:545 objectW:70 objectH:20 fChe:fChe sideValue:0];
            else
                [self runTransaction:750 heroY:545 objectW:70 objectH:20 fChe:fChe sideValue:0];
        }
    }else if(gameLevel == 4){
        [self runTransaction:0 heroY:394 objectW:165 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:265 heroY:552 objectW:12 objectH:138 fChe:fChe sideValue:0];
        [self runTransaction:255 heroY:562 objectW:340 objectH:20 fChe:fChe sideValue:0];
        [self runTransaction:585 heroY:552 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:265 heroY:420 objectW:330 objectH:20 fChe:fChe sideValue:11];
        [self runTransaction:605 heroY:420 objectW:420 objectH:20 fChe:fChe sideValue:0];
        
        [self runTransaction:0 heroY:504 objectW:94 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:400+siverPotCount heroY:620-siverPotCount2 objectW:35 objectH:70 fChe:fChe sideValue:25];
        [self runTransaction:262 heroY:355 objectW:80 objectH:85 fChe:fChe sideValue:0];
        if(toasterBreadCount==0)
            [self runTransaction:268 heroY:410 objectW:62 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:500 heroY:310 objectW:80 objectH:80 fChe:fChe sideValue:0];
        [self runTransaction:590 heroY:520 objectW:135 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:745 heroY:600 objectW:190 objectH:12 fChe:fChe sideValue:0];
        
        
        [self runTransaction:370 heroY:492 objectW:100 objectH:40 fChe:fChe sideValue:9];
        [self runTransaction:330 heroY:447 objectW:210 objectH:30 fChe:fChe sideValue:0];
        [self runTransaction:350 heroY:472 objectW:150 objectH:40 fChe:fChe sideValue:0];
        [self runTransaction:390+boxCount heroY:520-boxCount2 objectW:50 objectH:40 fChe:fChe sideValue:26];
        
    }else if(gameLevel == 5){
        [self runTransaction:0 heroY:345 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:107+teaPotCount heroY:410-teaPotCount2 objectW:55 objectH:75 fChe:fChe sideValue:27];
        [self runTransaction:0 heroY:612 objectW:85 objectH:140 fChe:fChe sideValue:0];
        [self runTransaction:165 heroY:612 objectW:163 objectH:140 fChe:fChe sideValue:0];
        
        [self runTransaction:378+vesselsCount+vesselsMoveCount heroY:572-vesselsCount2 objectW:85 objectH:30 fChe:fChe sideValue:0];
        [self runTransaction:378+vesselsCount+vesselsMoveCount heroY:552-vesselsCount2 objectW:85 objectH:42 fChe:fChe sideValue:28];
        [self runTransaction:413+moveCount2 heroY:515 objectW:132 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:865 heroY:405 objectW:180 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:705 heroY:515 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:773 heroY:335 objectW:133 objectH:12 fChe:fChe sideValue:0];
        
        if(crackedMoveCount<=70){
            [self runTransaction:890+crackedMoveCount heroY:635 objectW:12 objectH:65 fChe:fChe sideValue:0];
            [self runTransaction:775+crackedMoveCount heroY:635 objectW:12 objectH:125 fChe:fChe sideValue:29];
            [self runTransaction:850+crackedMoveCount heroY:635 objectW:40 objectH:20 fChe:fChe sideValue:0];
            [self runTransaction:783+crackedMoveCount heroY:518 objectW:92 objectH:12 fChe:fChe sideValue:0];
        }
        if(crackRotateValue>=25)
            [self trigoRunningFunc:fChe];
    }else if(gameLevel == 6){
        [self runTransaction:0 heroY:405 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:405 heroY:355 objectW:338 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:510 heroY:475 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:810 heroY:575 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:590+honeyPotCount heroY:332 objectW:60 objectH:90 fChe:fChe sideValue:30];
        [self runTransaction:255 heroY:525+catStopWoodCount objectW:12 objectH:130 fChe:fChe sideValue:0];
    }else if(gameLevel == 7){
        
        [self runTransaction:260 heroY:340 objectW:170 objectH:40 fChe:fChe sideValue:0];
        if(appleWoodCount!=-30)
            [self runTransaction:180+appleWoodCount heroY:440 objectW:185 objectH:100 fChe:fChe sideValue:31];
        else
            [self runTransaction:155 heroY:430 objectW:100 objectH:130 fChe:fChe sideValue:0];
        
        [self runTransaction:556 heroY:362+moveCount2 objectW:188 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:855 heroY:435 objectW:170 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:760 heroY:335 objectW:70 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:740 heroY:340 objectW:40 objectH:50 fChe:fChe sideValue:0];
        
    }else if(gameLevel ==8){
        [self runTransaction:0 heroY:365 objectW:145 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:113 heroY:485 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:213 heroY:570 objectW:12 objectH:86 fChe:fChe sideValue:0];
        [self runTransaction:213 heroY:576 objectW:394 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:596 heroY:570 objectW:12 objectH:165 fChe:fChe sideValue:0];
        [self runTransaction:213 heroY:410 objectW:394 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:730 heroY:290 objectW:280 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:325+moveCount2 objectW:120 objectH:37 fChe:fChe sideValue:0];
        [self runTransaction:335 heroY:486 objectW:155 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:420+honeyPotCount heroY:526-honeyPotCount2 objectW:40 objectH:40 fChe:fChe sideValue:32];
        [self runTransaction:895 heroY:400 objectW:115 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:765 heroY:565 objectW:270 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:605 heroY:495 objectW:135 objectH:12 fChe:fChe sideValue:0];
        if(milkRotateCount<90)
            [self runTransaction:820 heroY:630 objectW:50 objectH:70 fChe:fChe sideValue:33];
        [self runTransaction:370 heroY:290 objectW:85 objectH:70 fChe:fChe sideValue:0];
    }else if(gameLevel ==9){
        [self runTransaction:85 heroY:352 objectW:110 objectH:150 fChe:fChe sideValue:0];
        [self runTransaction:185 heroY:432 objectW:95 objectH:170 fChe:fChe sideValue:0];
        [self runTransaction:263 heroY:620 objectW:12 objectH:86 fChe:fChe sideValue:0];
        [self runTransaction:263 heroY:626 objectW:394 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:645 heroY:542 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:263 heroY:460 objectW:394 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:0 heroY:515 objectW:175 objectH:12 fChe:fChe sideValue:0];
        if(milkRotateCount<=50)
            [self runTransaction:85 heroY:568 objectW:35 objectH:53 fChe:fChe sideValue:34];
        [self runTransaction:643 heroY:554 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:913 heroY:603 objectW:130 objectH:500 fChe:fChe sideValue:0];
        
        [self runTransaction:347 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:527 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:707 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        
        [self runTransaction:425+combinationBoxPos[0][0] heroY:430+combinationBoxPos[0][1] objectW:30 objectH:45 fChe:fChe sideValue:35];
        [self runTransaction:605+combinationBoxPos[1][0] heroY:430+combinationBoxPos[1][1] objectW:30 objectH:45 fChe:fChe sideValue:36];
        [self runTransaction:705+combinationBoxPos[2][0] heroY:430+combinationBoxPos[2][1] objectW:30 objectH:45 fChe:fChe sideValue:37];
        [self runTransaction:923+exitCount heroY:475 objectW:200 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel ==10){
        [self runTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:360 heroY:282 objectW:255 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:424 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:363 heroY:436 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:803 heroY:484 objectW:215 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:750 heroY:383 objectW:140 objectH:12 fChe:fChe sideValue:0];
        
        //Center Box
        [self runTransaction:450 heroY:383 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:620 heroY:373 objectW:30 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:460 heroY:430 objectW:40 objectH:55 fChe:fChe sideValue:0];
        //milk
        [self runTransaction:676+milkMoveCount heroY:233 objectW:45 objectH:70 fChe:fChe sideValue:38];
        [self runTransaction:360 heroY:275 objectW:200 objectH:130 fChe:fChe sideValue:0];
    }else if(gameLevel == 11){
        [self runTransaction:133 heroY:245 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:230 heroY:325 objectW:105 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:320 heroY:260 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:490 heroY:255 objectW:160 objectH:100 fChe:fChe sideValue:0];
        [self runTransaction:650 heroY:270 objectW:100 objectH:130 fChe:fChe sideValue:0];
        [self runTransaction:555 heroY:310 objectW:132 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:720 heroY:422 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:552 objectW:420 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:757 heroY:580 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:455 objectW:187 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:217+moveCount2 heroY:457 objectW:205 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:333 objectW:67 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:70 heroY:362 objectW:140 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:65+honeyPotCount heroY:415-honeyPotCount2 objectW:50 objectH:55 fChe:fChe sideValue:39];
    }else if(gameLevel == 12){
        [self runTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        if(externCount==0)
            [self runTransaction:366 heroY:282 objectW:250 objectH:124 fChe:fChe sideValue:0];
        else
            [self runTransaction:296 heroY:282 objectW:320 objectH:124 fChe:fChe sideValue:0];
        [self runTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:382 objectW:230 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:350+boxCount heroY:150 objectW:45 objectH:90 fChe:fChe sideValue:40];
        [self runTransaction:75+boxCount2 heroY:365 objectW:45 objectH:90 fChe:fChe sideValue:41];
        [self runTransaction:506+boxCount3 heroY:473-boxCount4 objectW:45 objectH:90 fChe:fChe sideValue:42];
        [self runTransaction:405 heroY:396 objectW:250 objectH:12 fChe:fChe sideValue:0];
        if(boxCount3>=60)
            [self runTransaction:776 heroY:425 objectW:240 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 13){
        [self runTransaction:700+honeyPotCount heroY:295-honeyPotCount2 objectW:50 objectH:50 fChe:fChe sideValue:43];
        [self runTransaction:383 heroY:345 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:446 heroY:335 objectW:12 objectH:150 fChe:fChe sideValue:0];
        
        [self runTransaction:175 heroY:515+moveCount2 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:465 objectW:125 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:865 heroY:345 objectW:150 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:642 heroY:425 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:355 heroY:565 objectW:190 objectH:90 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:585 objectW:67 objectH:60 fChe:fChe sideValue:0];
        [self runTransaction:0 heroY:455 objectW:77 objectH:400 fChe:fChe sideValue:0];
        if(milkRotateCount<90)
            [self runTransaction:660 heroY:488 objectW:40 objectH:70 fChe:fChe sideValue:44];
        [self runTransaction:805 heroY:525 objectW:210 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:795 heroY:685+catStopWoodCount objectW:12 objectH:170 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        
        [self runTransaction:770 heroY:354 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:480 heroY:455 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:225 heroY:535 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:715 heroY:535 objectW:170 objectH:12 fChe:fChe sideValue:0];
        [self runTransaction:924 heroY:475 objectW:133 objectH:12 fChe:fChe sideValue:0];
        
        if(!notCollideBlockChe){
            [self runTransaction:225+blockCount[0][0] heroY:574-blockCount[0][1] objectW:40 objectH:40 fChe:fChe sideValue:51];
            [self runTransaction:375+blockCount[1][0] heroY:574-blockCount[1][1] objectW:40 objectH:40 fChe:fChe sideValue:52];
            [self runTransaction:480+blockCount[2][0] heroY:494-blockCount[2][1] objectW:40 objectH:40 fChe:fChe sideValue:53];
            [self runTransaction:725+blockCount[3][0] heroY:574-blockCount[3][1] objectW:40 objectH:40 fChe:fChe sideValue:54];
            [self runTransaction:855+blockCount[4][0] heroY:574-blockCount[4][1] objectW:40 objectH:40 fChe:fChe sideValue:55];
            [self runTransaction:830+blockCount[5][0] heroY:393-blockCount[5][1] objectW:40 objectH:40 fChe:fChe sideValue:56];
        }
        
        if(!gateOpenChe)
            [self runTransaction:946 heroY:300 objectW:60 objectH:70 fChe:fChe sideValue:0];
        
        [self runTransaction:115 heroY:700 objectW:12 objectH:200 fChe:fChe sideValue:0];
    }
}

-(void)jumpingRender:(CGFloat)xPos  yPosition:(CGFloat)yPos fChe:(BOOL)fChe{
    xPosition=xPos;
    yPosition=yPos;
    
    [self jumpTransaction:0 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:990 heroY:700 objectW:12 objectH:700 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:700 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    [self jumpTransaction:0 heroY:0 objectW:1000 objectH:12 fChe:fChe sideValue:0];
    
    if(gameLevel ==2){
        [self jumpTransaction:0 heroY:318 objectW:190 objectH:15 fChe:fChe sideValue:0];
        [self jumpTransaction:190+stoolCount heroY:310 objectW:90 objectH:110 fChe:fChe sideValue:0];
        [self jumpTransaction:425 heroY:383 objectW:600 objectH:210 fChe:fChe sideValue:0];
        [self jumpTransaction:555 heroY:450 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:383 heroY:550 objectW:134 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:525 heroY:628 objectW:217 objectH:15 fChe:fChe sideValue:0];
        [self jumpTransaction:632 heroY:616 objectW:110 objectH:110 fChe:fChe sideValue:0];
        [self jumpTransaction:695+honeyPotCount heroY:498-honeyPotCount2 objectW:50 objectH:50 fChe:fChe sideValue:0];
        if(honeyPotCount2!=67)
            [self jumpTransaction:945 heroY:428 objectW:65 objectH:70 fChe:fChe sideValue:1];
        
        [self jumpTransaction:695+honeyBottleCount heroY:690-honeyBottleCount2 objectW:50 objectH:70 fChe:fChe sideValue:1];
    }else if(gameLevel ==3){
        [self jumpTransaction:178+appleWoodCount heroY:445 objectW:173 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:606 heroY:523 objectW:410 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:555 heroY:380 objectW:80 objectH:80 fChe:fChe sideValue:0];
        if(flowerFallRotate==0)
            [self jumpTransaction:750 heroY:595 objectW:20 objectH:70 fChe:fChe sideValue:1];
        else{
            if(flowerFallChe)
                [self jumpTransaction:690 heroY:545 objectW:70 objectH:20 fChe:fChe sideValue:0];
            else
                [self jumpTransaction:750 heroY:545 objectW:70 objectH:20 fChe:fChe sideValue:0];
        }
    }else if(gameLevel == 4){
        [self jumpTransaction:0 heroY:394 objectW:165 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:265 heroY:552 objectW:12 objectH:138 fChe:fChe sideValue:0];
        [self jumpTransaction:255 heroY:562 objectW:340 objectH:20 fChe:fChe sideValue:0];
        [self jumpTransaction:585 heroY:552 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:265 heroY:420 objectW:330 objectH:20 fChe:fChe sideValue:11];
        [self jumpTransaction:605 heroY:420 objectW:420 objectH:20 fChe:fChe sideValue:0];
        
        [self jumpTransaction:0 heroY:504 objectW:94 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:400+siverPotCount heroY:620-siverPotCount2 objectW:35 objectH:70 fChe:fChe sideValue:9];
        [self jumpTransaction:262 heroY:355 objectW:80 objectH:85 fChe:fChe sideValue:9];
        if(toasterBreadCount==0)
            [self jumpTransaction:268 heroY:410 objectW:62 objectH:80 fChe:fChe sideValue:0];
        [self jumpTransaction:500 heroY:310 objectW:80 objectH:80 fChe:fChe sideValue:0];
        [self jumpTransaction:590 heroY:520 objectW:135 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:745 heroY:600 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:390+boxCount heroY:520-boxCount2 objectW:50 objectH:40 fChe:fChe sideValue:0];
        [self jumpTransaction:370 heroY:492 objectW:100 objectH:40 fChe:fChe sideValue:9];
        [self jumpTransaction:330 heroY:447 objectW:210 objectH:40 fChe:fChe sideValue:9];
        [self jumpTransaction:350 heroY:472 objectW:150 objectH:40 fChe:fChe sideValue:9];
        [self jumpTransaction:390+boxCount heroY:520-boxCount2 objectW:50 objectH:40 fChe:fChe sideValue:26];
        if(boxCount>-20)
            [self jumpTransaction:430+boxCount heroY:545 objectW:12 objectH:70 fChe:fChe sideValue:0];
    }else if(gameLevel == 5){
        [self jumpTransaction:0 heroY:345 objectW:185 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:107+teaPotCount heroY:410-teaPotCount2 objectW:55 objectH:75 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:612 objectW:85 objectH:140 fChe:fChe sideValue:0];
        [self jumpTransaction:165 heroY:612 objectW:163 objectH:170 fChe:fChe sideValue:0];
        
        [self jumpTransaction:378+vesselsCount+vesselsMoveCount heroY:572-vesselsCount2 objectW:85 objectH:30 fChe:fChe sideValue:6];
        [self jumpTransaction:378+vesselsCount+vesselsMoveCount heroY:552-vesselsCount2 objectW:85 objectH:42 fChe:fChe sideValue:0];
        [self jumpTransaction:413+moveCount2 heroY:515 objectW:132 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:865 heroY:405 objectW:180 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:690 heroY:515 objectW:148 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:773 heroY:335 objectW:133 objectH:12 fChe:fChe sideValue:0];
        
        if(crackedMoveCount<=70){
            [self jumpTransaction:890+crackedMoveCount heroY:635 objectW:12 objectH:65 fChe:fChe sideValue:0];
            [self jumpTransaction:775+crackedMoveCount heroY:635 objectW:12 objectH:125 fChe:fChe sideValue:9];
            [self jumpTransaction:860+crackedMoveCount heroY:645 objectW:40 objectH:20 fChe:fChe sideValue:0];
            [self jumpTransaction:783+crackedMoveCount heroY:518 objectW:92 objectH:12 fChe:fChe sideValue:0];
        }
        if(crackRotateValue>=25){
            [self trigoJumpingFunc:890 yPosition:598 angle:20 radiusLength:50];
            [self trigoReverseFunc:950 yPosition:463 angle:108 radiusLength:58];
            [self jumpTransaction:955 heroY:502 objectW:90 objectH:50 fChe:fChe sideValue:0];
        }
    }else if(gameLevel ==6){
        [self jumpTransaction:0 heroY:405 objectW:265 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:405 heroY:355 objectW:338 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:510 heroY:475 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:810 heroY:575 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:590+honeyPotCount heroY:332 objectW:60 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:255 heroY:525+catStopWoodCount objectW:12 objectH:130 fChe:fChe sideValue:0];
    }else if(gameLevel == 7){
        [self jumpTransaction:260 heroY:340 objectW:170 objectH:40 fChe:fChe sideValue:0];
        
        if(appleWoodCount!=-30)
            [self jumpTransaction:180+appleWoodCount heroY:440 objectW:185 objectH:100 fChe:fChe sideValue:0];
        else
            [self jumpTransaction:155 heroY:430 objectW:100 objectH:130 fChe:fChe sideValue:0];
        
        if(domeMoveCount!=0)
            [self jumpTransaction:556 heroY:362+moveCount2 objectW:188 objectH:15 fChe:fChe sideValue:5];
        else
            [self jumpTransaction:546 heroY:372+moveCount2 objectW:208 objectH:15 fChe:fChe sideValue:8];
        
        if(fChe){
            if(xPosition>227&&xPosition<267 &&yPosition>260&&yPosition<330 &&!domeSwitchChe)
                domeSwitchChe=YES;
        }
        [self jumpTransaction:855 heroY:435 objectW:170 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:760 heroY:335 objectW:70 objectH:90 fChe:fChe sideValue:9];
        [self jumpTransaction:740 heroY:340 objectW:40 objectH:50 fChe:fChe sideValue:0];
    }else if(gameLevel == 8){
        [self jumpTransaction:0 heroY:365 objectW:145 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:113 heroY:485 objectW:100 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:213 heroY:570 objectW:12 objectH:86 fChe:fChe sideValue:0];
        [self jumpTransaction:213 heroY:576 objectW:394 objectH:12 fChe:fChe sideValue:0];
        
        [self jumpTransaction:596 heroY:570 objectW:12 objectH:165 fChe:fChe sideValue:0];
        [self jumpTransaction:213 heroY:410 objectW:394 objectH:12 fChe:fChe sideValue:11];
        [self jumpTransaction:730 heroY:290 objectW:280 objectH:60 fChe:fChe sideValue:0];
        //knife
        [self jumpTransaction:770 heroY:325+moveCount2 objectW:120 objectH:37 fChe:fChe sideValue:5];
        [self jumpTransaction:335 heroY:486 objectW:155 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:420+honeyPotCount heroY:526-honeyPotCount2 objectW:40 objectH:40 fChe:fChe sideValue:9];
        [self jumpTransaction:895 heroY:400 objectW:115 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:765 heroY:565 objectW:270 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:605 heroY:495 objectW:135 objectH:12 fChe:fChe sideValue:0];
        if(milkRotateCount<90)
            [self jumpTransaction:820 heroY:630 objectW:50 objectH:70 fChe:fChe sideValue:9];
        [self jumpTransaction:370 heroY:290 objectW:85 objectH:70 fChe:fChe sideValue:0];
    }else if(gameLevel == 9){
        
        [self jumpTransaction:85 heroY:352 objectW:110 objectH:150 fChe:fChe sideValue:0];
        [self jumpTransaction:185 heroY:432 objectW:95 objectH:170 fChe:fChe sideValue:0];
        [self jumpTransaction:263 heroY:620 objectW:12 objectH:86 fChe:fChe sideValue:0];
        [self jumpTransaction:263 heroY:626 objectW:394 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:645 heroY:542 objectW:12 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:263 heroY:460 objectW:394 objectH:12 fChe:fChe sideValue:11];
        
        [self jumpTransaction:0 heroY:515 objectW:175 objectH:12 fChe:fChe sideValue:0];
        
        if(milkRotateCount<=50)
            [self jumpTransaction:85 heroY:568 objectW:35 objectH:53 fChe:fChe sideValue:9];
        [self jumpTransaction:643 heroY:554 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:913 heroY:603 objectW:130 objectH:500 fChe:fChe sideValue:0];
        
        [self jumpTransaction:347 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:527 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:707 heroY:386 objectW:105 objectH:12 fChe:fChe sideValue:0];
        
        
        
        [self jumpTransaction:425+combinationBoxPos[0][0] heroY:430+combinationBoxPos[0][1] objectW:30 objectH:45 fChe:fChe sideValue:9];
        [self jumpTransaction:605+combinationBoxPos[1][0] heroY:430+combinationBoxPos[1][1] objectW:30 objectH:45 fChe:fChe sideValue:9];
        [self jumpTransaction:705+combinationBoxPos[2][0] heroY:430+combinationBoxPos[2][1] objectW:30 objectH:45 fChe:fChe sideValue:9];
        
        [self jumpTransaction:923+exitCount heroY:475 objectW:200 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 10){
        [self jumpTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:360 heroY:282 objectW:255 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:424 objectW:208 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:363 heroY:436 objectW:300 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:803 heroY:484 objectW:215 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:750 heroY:383 objectW:140 objectH:12 fChe:fChe sideValue:0];
        
        //Center Box
        [self jumpTransaction:450 heroY:383 objectW:110 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:620 heroY:373 objectW:30 objectH:80 fChe:fChe sideValue:9];
        [self jumpTransaction:460 heroY:430 objectW:40 objectH:55 fChe:fChe sideValue:0];
        
        //milk
        [self jumpTransaction:676+milkMoveCount heroY:233 objectW:45 objectH:70 fChe:fChe sideValue:9];
        [self jumpTransaction:360 heroY:282 objectW:200 objectH:130 fChe:fChe sideValue:0];
    }else if(gameLevel == 11){
        [self jumpTransaction:133 heroY:245 objectW:12 objectH:90 fChe:fChe sideValue:1];
        [self jumpTransaction:230 heroY:325 objectW:105 objectH:90 fChe:fChe sideValue:0];
        
        [self jumpTransaction:320 heroY:260 objectW:12 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:490 heroY:255 objectW:160 objectH:100 fChe:fChe sideValue:0];
        [self jumpTransaction:650 heroY:270 objectW:100 objectH:130 fChe:fChe sideValue:0];
        [self jumpTransaction:555 heroY:310 objectW:132 objectH:60 fChe:fChe sideValue:0];
        
        [self jumpTransaction:720 heroY:422 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:552 objectW:420 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:757 heroY:580 objectW:260 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:455 objectW:187 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:217+moveCount2 heroY:457 objectW:205 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:0 heroY:333 objectW:67 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:70 heroY:362 objectW:140 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:65+honeyPotCount heroY:415-honeyPotCount2 objectW:50 objectH:55 fChe:fChe sideValue:0];
    }else if(gameLevel == 12){
        [self jumpTransaction:0 heroY:282 objectW:208 objectH:12 fChe:fChe sideValue:0];
        
        if(externCount==0)
            [self jumpTransaction:366 heroY:282 objectW:250 objectH:124 fChe:fChe sideValue:0];
        else
            [self jumpTransaction:296 heroY:282 objectW:320 objectH:124 fChe:fChe sideValue:9];
        
        [self jumpTransaction:770 heroY:282 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:382 objectW:230 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:164 objectW:875 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:350+boxCount heroY:150 objectW:45 objectH:90 fChe:fChe sideValue:9];
        [self jumpTransaction:75+boxCount2 heroY:365 objectW:45 objectH:90 fChe:fChe sideValue:9];
        [self jumpTransaction:506+boxCount3 heroY:473-boxCount4 objectW:45 objectH:90 fChe:fChe sideValue:9];
        
        [self jumpTransaction:405 heroY:396 objectW:250 objectH:12 fChe:fChe sideValue:0];
        if(boxCount3>=60)
            [self jumpTransaction:776 heroY:425 objectW:240 objectH:12 fChe:fChe sideValue:0];
    }else if(gameLevel == 13){
        [self jumpTransaction:700+honeyPotCount heroY:295-honeyPotCount2 objectW:50 objectH:50 fChe:fChe sideValue:0];
        [self jumpTransaction:383 heroY:345 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:446 heroY:335 objectW:12 objectH:150 fChe:fChe sideValue:0];
        [self jumpTransaction:175 heroY:515+moveCount2 objectW:133 objectH:12 fChe:fChe sideValue:5];
        [self jumpTransaction:0 heroY:465 objectW:125 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:865 heroY:345 objectW:150 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:642 heroY:425 objectW:133 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:355 heroY:565 objectW:190 objectH:90 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:585 objectW:67 objectH:60 fChe:fChe sideValue:0];
        [self jumpTransaction:0 heroY:455 objectW:77 objectH:400 fChe:fChe sideValue:0];
        if(milkRotateCount<90)
            [self jumpTransaction:660 heroY:488 objectW:40 objectH:70 fChe:fChe sideValue:9];
        
        [self jumpTransaction:805 heroY:525 objectW:210 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:795 heroY:685+catStopWoodCount objectW:12 objectH:170 fChe:fChe sideValue:0];
    }else if(gameLevel == 14){
        [self jumpTransaction:770 heroY:354 objectW:240 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:480 heroY:455 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:225 heroY:535 objectW:190 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:715 heroY:535 objectW:170 objectH:12 fChe:fChe sideValue:0];
        [self jumpTransaction:924 heroY:475 objectW:133 objectH:12 fChe:fChe sideValue:0];
        if(!notCollideBlockChe){
            [self jumpTransaction:225+blockCount[0][0] heroY:574-blockCount[0][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
            [self jumpTransaction:375+blockCount[1][0] heroY:574-blockCount[1][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
            [self jumpTransaction:480+blockCount[2][0] heroY:494-blockCount[2][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
            [self jumpTransaction:725+blockCount[3][0] heroY:574-blockCount[3][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
            [self jumpTransaction:855+blockCount[4][0] heroY:574-blockCount[4][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
            [self jumpTransaction:830+blockCount[5][0] heroY:393-blockCount[5][1] objectW:40 objectH:40 fChe:fChe sideValue:9];
        }
        if(!gateOpenChe)
            [self jumpTransaction:946 heroY:300 objectW:60 objectH:70 fChe:fChe sideValue:1];
        
        [self jumpTransaction:115 heroY:700 objectW:12 objectH:200 fChe:fChe sideValue:0];
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
                    if(gameLevel==5)
                        trappedVesselsChe=YES;
                }
            }
            //Land
            if(xPosition >= heroX-35 && xPosition<=((heroX-35)+objectW+20) && yPosition > heroY && yPosition <= heroY+17){
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
                            landMoveCount=moveCount2;
                        }else if(sValue==6&&!trappedChe){
                            trappedChe=YES;
                            if(gameLevel==5)
                                trappedVesselsChe=YES;
                        }else  if(sValue==11&&!visibleWindowChe)
                            visibleWindowChe=YES;
                    }else{
                        autoJumpChe2=YES;
                        autoJumpSpeedValue=1;
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
                reverseJump=YES;
                xPosition=(heroX-10)+objectW;
                if(sValue==6&&!trappedChe){
                    trappedChe=YES;
                    if(gameLevel==5)
                        trappedVesselsChe=YES;
                    
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
                            landMoveCount=moveCount2;
                            
                        }else if(sValue==6&&!trappedChe){
                            trappedChe=YES;
                            if(gameLevel==5)
                                trappedVesselsChe=YES;
                            
                        }if(sValue==11&&!visibleWindowChe)
                            visibleWindowChe=YES;
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
        if(xPosition >= heroX-45+aValue && xPosition<=((heroX-45)+20) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=heroX-45;
            if(sValue==6&&!trappedChe)
                trappedChe=YES;
            if(sValue==20){
                stoolCount+=1;
                stoolCount=(stoolCount>=144?144:stoolCount);
                pushChe=YES;
            }else if(sValue==21){
                honeyPotCount+=1;
                honeyPotCount=(honeyPotCount>=55?55:honeyPotCount);
                pushChe=YES;
            }else if(sValue==22){
                honeyBottleCount+=1;
                honeyBottleCount=(honeyBottleCount>=58?58:honeyBottleCount);
                pushChe=YES;
            }else if(sValue==23){
                appleWoodCount+=1;
                appleWoodCount=(appleWoodCount>=205?205:appleWoodCount);
                pushChe=YES;
            }else if(sValue==24){
                flowerFallChe=NO;
                flowerFallRotate=0.1;
                pushChe=YES;
            }else if(sValue==25){
                siverPotCount+=1;
                siverPotCount=(siverPotCount>200?200:siverPotCount);
                pushChe=YES;
            }else if(sValue==27){
                teaPotCount+=1;
                teaPotCount=(teaPotCount>90?90:teaPotCount);
                pushChe=YES;
            }else if(sValue==29){
                crackedMoveCount+=1;
                crackedMoveCount=(crackedMoveCount>100?100:crackedMoveCount);
                pushChe=YES;
            }else if(sValue==30){
                if(honeyPotCount>=1){
                    honeyPotCount+=1;
                    honeyPotCount=(honeyPotCount>80?80:honeyPotCount);
                    pushChe=YES;
                }
            }else if(sValue==32){
                honeyPotCount+=1;
                honeyPotCount=(honeyPotCount>70?70:honeyPotCount);
                pushChe=YES;
            }else if(sValue ==34){
                milkRotateCount+=1;
                milkRotateCount=(milkRotateCount>=90?90:milkRotateCount);
                pushChe=YES;
            }else if(sValue ==35){
                if(!combinationChe[0]){
                    if(combinationBoxPos[0][1]<-115){
                        combinationBoxPos[0][0]+=1;
                        combinationBoxPos[0][0]=(combinationBoxPos[0][0]>=30?30:combinationBoxPos[0][0]);
                    }else{
                        combinationBoxPos[0][0]+=1;
                        combinationBoxPos[0][0]=(combinationBoxPos[0][0]>=460?460:combinationBoxPos[0][0]);
                    }
                    pushChe=YES;
                }
            }else if(sValue ==36){
                if(!combinationChe[1]){
                    if(combinationBoxPos[1][1]< -115){
                        combinationBoxPos[1][0]+=1;
                        combinationBoxPos[1][0]=(combinationBoxPos[1][0]>=30?30:combinationBoxPos[1][0]);
                    }else{
                        combinationBoxPos[1][0]+=1;
                        combinationBoxPos[1][0]=(combinationBoxPos[1][0]>=280?280:combinationBoxPos[1][0]);
                    }
                    pushChe=YES;
                }
            }else if(sValue ==37){
                if(!combinationChe[2]){
                    combinationBoxPos[2][0]+=1;
                    combinationBoxPos[2][0]=(combinationBoxPos[2][0]>=180?180:combinationBoxPos[2][0]);
                    pushChe=YES;
                }
            }else if(sValue ==38){
                milkMoveCount+=1;
                milkMoveCount=(milkMoveCount>240?240:milkMoveCount);
                pushChe=YES;
            }else if(sValue == 42){
                boxCount3+=1;
                boxCount3=(boxCount3>60?60:boxCount3);
                pushChe=YES;
            }
            
            else if(sValue == 51){
                if(!blockChe[0]){
                    blockCount[0][0]+=1;
                    blockCount[0][0] = (blockCount[0][0]>=730?730:blockCount[0][0]);
                }
                pushChe=YES;
            }else if(sValue == 52){
                if(!blockChe[1]){
                    if(blockCount[1][1]==0){
                        blockCount[1][0]+=1;
                        blockCount[1][0] = (blockCount[1][0]>=40?40:blockCount[1][0]);
                    }else{
                        blockCount[1][0]+=1;
                        blockCount[1][0] = (blockCount[1][0]>=585?585:blockCount[1][0]);
                    }
                }pushChe=YES;
            }else if(sValue == 53){
                if(!blockChe[2]){
                    blockCount[2][0]+=1;
                    blockCount[2][0] = (blockCount[2][0]>=480?480:blockCount[2][0]);
                }
                pushChe=YES;
            }else if(sValue == 54){
                if(!blockChe[3]){
                    blockCount[3][0]+=1;
                    blockCount[3][0] = (blockCount[3][0]>=235?235:blockCount[3][0]);
                }
                pushChe=YES;
            }else if(sValue == 55){
                if(!blockChe[4]){
                    if(blockCount[4][1]==0){
                        blockCount[4][0]+=1;
                        blockCount[4][0] = (blockCount[4][0]>=40?40:blockCount[4][0]);
                    }else{
                        blockCount[4][0]+=1;
                        if(blockCount[4][1]==181){
                            if(blockCount[4][0]>=110)
                                blockCount[4][0]=110;
                        }else{
                            if(blockCount[4][0]>=110)
                                blockCount[4][0]=110;
                        }
                    }
                }
                pushChe=YES;
            }else if(sValue == 56){
                if(!blockChe[5]){
                    blockCount[5][0]+= 1;
                    blockCount[5][0] = (blockCount[5][0]>=120?120:blockCount[5][0]);
                }
                pushChe=YES;
            }
            if(crackRotateValue>=25)
                trigoRunningCheck=YES;
        }else if(xPosition >= ((heroX-10)+(objectW-20)) && xPosition<=((heroX-10)+(objectW)) && yPosition > heroY && yPosition <= heroY+17&&!autoJumpChe){
            autoJumpChe=YES;
            if(movePlatformChe)
                movePlatformChe=NO;
        }
    }else{
        if(xPosition >= ((heroX-15)+(objectW-20)) && xPosition<=((heroX-15)+(objectW)) && yPosition >= (heroY-objectH) && yPosition <= heroY){
            xPosition=(heroX-15)+objectW;
            if(sValue==6&&!trappedChe)
                trappedChe=YES;
            if(sValue==20){
                stoolCount-=1;
                stoolCount=(stoolCount<=0?0:stoolCount);
                pushChe=YES;
            }else if(sValue==23){
                appleWoodCount-=1;
                appleWoodCount=(appleWoodCount<=-170?-170:appleWoodCount);
                pushChe=YES;
            }else if(sValue==24){
                flowerFallChe=YES;
                flowerFallRotate=0.1;
                pushChe=YES;
            }else if(sValue==25){
                siverPotCount-=1;
                siverPotCount=(siverPotCount<-175?-175:siverPotCount);
                pushChe=YES;
            }else if(sValue==26){
                if(boxCount2!=40){
                    boxCount-=1;
                    boxCount=(boxCount<-40?-40:boxCount);
                    pushChe=YES;
                }
            }else if(sValue==28){
                vesselsCount-=2.2;
                vesselsCount=(vesselsCount<-50?-50:vesselsCount);
                pushChe=YES;
            }else if(sValue==30){
                honeyPotCount-=1;
                honeyPotCount=(honeyPotCount<-280?-280:honeyPotCount);
                pushChe=YES;
            }else if(sValue == 31){
                appleWoodCount-=1;
                appleWoodCount=(appleWoodCount<-30?-30:appleWoodCount);
                pushChe=YES;
            }else if(sValue ==33){
                milkRotateCount+=1;
                milkRotateCount=(milkRotateCount>=90?90:milkRotateCount);
                pushChe=YES;
            }else if(sValue ==35){
                if(!combinationChe[0]){
                    combinationBoxPos[0][0]-=1;
                    combinationBoxPos[0][0]=(combinationBoxPos[0][0]<=-145?-145:combinationBoxPos[0][0]);
                    pushChe=YES;
                }
            }else if(sValue ==36){
                if(!combinationChe[1]){
                    combinationBoxPos[1][0]-=1;
                    combinationBoxPos[1][0]=(combinationBoxPos[1][0]<=-325?-325:combinationBoxPos[1][0]);
                    pushChe=YES;
                }
                
            }else if(sValue ==37){
                if(!combinationChe[2]){
                    if(combinationBoxPos[2][1]<-115){
                        combinationBoxPos[2][0]-=1;
                        combinationBoxPos[2][0]=(combinationBoxPos[2][0]<=-30?-30:combinationBoxPos[2][0]);
                    }else{
                        combinationBoxPos[2][0]-=1;
                        combinationBoxPos[2][0]=(combinationBoxPos[2][0]<=-425?-425:combinationBoxPos[2][0]);
                    }
                    pushChe=YES;
                }
            }else if(sValue ==38){
                milkMoveCount-=1;
                milkMoveCount=(milkMoveCount<-105?-105:milkMoveCount);
                pushChe=YES;
            }else if(sValue == 39){
                honeyPotCount-=1;
                honeyPotCount=(honeyPotCount<-50?-50:honeyPotCount);
                pushChe=YES;
            }else if(sValue == 40){
                boxCount-=1;
                boxCount=(boxCount<-80?-80:boxCount);
                pushChe=YES;
            }else if(sValue == 41){
                boxCount2-=1;
                boxCount2=(boxCount2<-70?-70:boxCount2);
                pushChe=YES;
            }else if(sValue == 42){
                boxCount3-=1;
                boxCount3=(boxCount3<-155?-155:boxCount3);
                pushChe=YES;
            }else if(sValue == 43){
                honeyPotCount-=1;
                honeyPotCount=(honeyPotCount<-225?-225:honeyPotCount);
                pushChe=YES;
            }else if(sValue == 44){
                milkRotateCount+=1;
                milkRotateCount=(milkRotateCount>90?90:milkRotateCount);
                pushChe=YES;
            }
            else if(sValue == 51){
                if(!blockChe[0]){
                    if(blockCount[0][1] == 0){
                        blockCount[0][0]-=1;
                        blockCount[0][0] = (blockCount[0][0]<=-40?-40:blockCount[0][0]);
                    }else{
                        blockCount[0][0]-=1;
                        blockCount[0][0] = (blockCount[0][0]<=-115?-115:blockCount[0][0]);
                    }
                }
                pushChe=YES;
            }else if(sValue == 52){
                if(!blockChe[1]){
                    blockCount[1][0]-=1;
                    blockCount[1][0] = (blockCount[1][0]<=-260?-260:blockCount[1][0]);
                }
                pushChe=YES;
            }else if(sValue == 53){
                if(!blockChe[2]){
                    if(blockCount[2][1]==0){
                        blockCount[2][0]-=1;
                        blockCount[2][0] = (blockCount[2][0]<=-40?-40:blockCount[2][0]);
                    }else{
                        blockCount[2][0]-=1;
                        blockCount[2][0] = (blockCount[2][0]<=-365?-365:blockCount[2][0]);
                    }
                }
                
                pushChe=YES;
            }else if(sValue == 54){
                if(!blockChe[3]){
                    if(blockCount[3][1]==0){
                        blockCount[3][0]-=1;
                        blockCount[3][0] = (blockCount[3][0]<=-40?-40:blockCount[3][0]);
                    }else{
                        blockCount[3][0]-=1;
                        blockCount[3][0] = (blockCount[3][0]<=-613?-613:blockCount[3][0]);
                    }
                }
                pushChe=YES;
            }else if(sValue == 55){
                if(!blockChe[4]){
                    if(blockCount[4][1]==181){
                        blockCount[4][0]-=1;
                        blockCount[4][0] = (blockCount[4][0]<=-120?-120:blockCount[4][0]);
                        pushChe=YES;
                    }else{
                        blockCount[4][0]-=1;
                        blockCount[4][0] = (blockCount[4][0]<=-700?-700:blockCount[4][0]);
                    }
                }
                pushChe=YES;
            }else if(sValue == 56){
                if(!blockChe[5]){
                    if(blockCount[5][1]==0){
                        blockCount[5][0]-=1;
                        blockCount[5][0] = (blockCount[5][0]<=-100?-100:blockCount[5][0]);
                    }else{
                        blockCount[5][0]-=1;
                        blockCount[5][0] = (blockCount[5][0]<=-713?-713:blockCount[5][0]);
                    }
                }
                
                pushChe=YES;
                
            }
            
            
            
            if(crackRotateValue>=25)
                trigoRunningCheck=YES;
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
            //printf("%d \n",saveTrigoCount[2]);
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
        
        if(xPosition>xx &&xPosition<xx+10 && yPosition>yy && yPosition<yy+10&&!reverseJump&&trigoJumpPower==0){
            topHittingCollisionChe=NO;
            reverseJump=YES;
            trigoJumpPower=1;
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

-(CGFloat)getBox:(int)bValue pValue:(int)pValue{
    return combinationBoxPos[bValue][pValue];
}
-(void)setBoxValue:(int)iValue xValue:(CGFloat)xValue{
    combinationBoxPos[iValue][0]=xValue;
}
-(void)setCombinationChe:(int)cValue{
    combinationChe[cValue]=YES;
}
-(void)setBlockChe:(int)cValue{
    blockChe[cValue]=YES;
}
-(CGFloat)getBlockValue:(int)bValue pValue:(int)pValue{
    return blockCount[bValue][pValue];
}


@end
