//
//  ToolShedScreen.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 28/09/2013.
//
//

#import "ToolShedScreen.h"
#import "MenuScreen.h"
#import "cocos2d.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
#import "SWScrollView.h"
#import "SWTableView.h"
#import "ExampleTable.h"
#import "SWMultiColumnTableView.h"
#import "StoreScreen.h"


@implementation ToolShedScreen
NSString *const ToolShedUpdateProductPurchasedNotification = @"ToolShedUpdateProductPurchasedNotification";
+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
    ToolShedScreen *layer = [ToolShedScreen node];
    [scene addChild: layer];
	
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        scaleFactorX = screenSize.width/480;
        scaleFactorY = screenSize.height/320;
        
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            xScale = 1 * scaleFactorX;
            yScale = 1 * scaleFactorY;
            cScale = 1;
        }else{
            xScale = 0.5 * scaleFactorX;
            yScale = 0.5 * scaleFactorY;
            cScale = 0.5;
        }
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        CCSprite *shedBg = [CCSprite spriteWithFile: @"shed_bg.png"];
        shedBg.position = ccp(240 *scaleFactorX, 160 *scaleFactorY);
        shedBg.scaleX = xScale;
        shedBg.scaleY = yScale;
        [self addChild:shedBg];
    
        soundEffect = [[sound alloc] init];
        CCSprite *currentCheeseBg = [CCSprite spriteWithFile: @"cheese_available.png"];
        currentCheeseBg.position = ccp(160 *scaleFactorX, 300 *scaleFactorY);
        currentCheeseBg.scaleX = xScale;
         currentCheeseBg.scaleY = yScale;
        [self addChild:currentCheeseBg];
        
        int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
        totalCheese = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", cheese] charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'];
        totalCheese.position= ccp(155 *scaleFactorX, 294 *scaleFactorY);
        totalCheese.scale=cScale;
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            totalCheese.position= ccp(155 *scaleFactorX, 294 *scaleFactorY);
            totalCheese.scale=cScale/2;
        }
        [self addChild:totalCheese z:11];
        
        CCSprite *mrToolBag = [CCSprite spriteWithFile: @"mr_tool_bag.png"];
        
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            mrToolBag.position = ccp(395 *scaleFactorX, 60 *scaleFactorY + mrToolBag.contentSize.height/4);
        }else{
            if([FTMUtil sharedInstance].isIphone5){
                mrToolBag.position = ccp(390 *scaleFactorX, 15 *scaleFactorY + mrToolBag.contentSize.height/4);
            }
            else{
                mrToolBag.position = ccp(402 *scaleFactorX, 17 *scaleFactorY + mrToolBag.contentSize.height/4);
            }
        }
        mrToolBag.scale = cScale;
        [self addChild:mrToolBag z:10];
        
        CCSprite *tapPowerupInfo = [CCSprite spriteWithFile: @"tap_powerup_popup.png"];
        
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            tapPowerupInfo.position = ccp(410 *scaleFactorX, 132 *scaleFactorY + mrToolBag.contentSize.height/2);
        }else{
            if([FTMUtil sharedInstance].isIphone5){
                tapPowerupInfo.position = ccp(405 *scaleFactorX, 38 *scaleFactorY + mrToolBag.contentSize.height/2);
            }
            else{
                tapPowerupInfo.position = ccp(420 *scaleFactorX, 40 *scaleFactorY + mrToolBag.contentSize.height/2);

            }
        }
        tapPowerupInfo.scale = cScale;
        [self addChild:tapPowerupInfo z:10];
        
        CCMenuItem *buyCheeseItem = [CCMenuItemImage itemWithNormalImage:@"buy_cheese_btn.png" selectedImage:@"buy_cheese_btn.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[StoreScreen node]];
//            open up the store here for inApp..
		}];
        
        [buyCheeseItem setScaleX:xScale];
        [buyCheeseItem setScaleY:yScale];
        
        CCMenu *buyBtnMenu = [CCMenu menuWithItems:buyCheeseItem, nil];
        buyBtnMenu.position = ccp(226*scaleFactorX, 300 *scaleFactorY);
        [self addChild:buyBtnMenu];
        
    
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
            
		}];
        CCMenu *menu = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu alignItemsVerticallyWithPadding:30.0];
        menu.position=ccp(205 *scaleFactorX, 15 *scaleFactorY);
        [self addChild: menu z:100];
        
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            [backMenuItem setScaleX:0.6 *scaleFactorX];
            [backMenuItem setScaleY:0.6 *scaleFactorY];
            menu.position=ccp(205 *scaleFactorX, 18 *scaleFactorY);
        }else{
            backMenuItem.scale = 0.3;
//            [backMenuItem setScaleY:0.6 *scaleFactorY];
        }
        
       

        powerUpItem = [CCMenuItemImage itemWithNormalImage:@"powerups_btn.png" selectedImage:@"powerups_btn_disable.png" disabledImage:@"powerups_btn_disable.png"  block:^(id sender) {
            [soundEffect button_1];
//            [[CCDirector sharedDirector] replaceScene:[MenuScreen node]];
            [powerUpItem selected];
            powerUpItem.isEnabled = NO;
            [costumesItem unselected];
            costumesItem.isEnabled = YES;
            // open up the store here for inApp..
		}];
        [powerUpItem setScaleX:xScale];
        [powerUpItem setScaleY:yScale];
        [powerUpItem selected];
        powerUpItem.isEnabled = NO;
        CCMenu *powerUpMenu = [CCMenu menuWithItems:powerUpItem, nil];
        powerUpMenu.position = ccp(124*scaleFactorX, 243 *scaleFactorY);
        [self addChild:powerUpMenu z:10];
        
        
        costumesItem = [CCMenuItemImage itemWithNormalImage:@"costumes_btn.png" selectedImage:@"costumes_btn_disable.png" disabledImage:@"costumes_btn_disable.png"  block:^(id sender) {
            [soundEffect button_1];
            [self removeChildByTag:8888 cleanup:YES];
            [powerUpItem unselected];
            powerUpItem.isEnabled = YES;
            [costumesItem selected];
            costumesItem.isEnabled = NO;
            [self addScrollVIew];
		}];
        
        [costumesItem setScaleX:xScale];
        [costumesItem setScaleY:yScale];
        CCMenu *costumesMenu = [CCMenu menuWithItems:costumesItem, nil];
        costumesMenu.position = ccp(273*scaleFactorX, 243 *scaleFactorY);
        [self addChild:costumesMenu z:10];
        
        [self addScrollVIew];
        [self addScrollBar];
//        [self addPowerUpsUi];

    }
    return self;
}

-(void) updateCheeseCount :(NSString *) notifier{
    int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
    [totalCheese setString:[NSString stringWithFormat:@"%d", cheese]];
}
-(void) addScrollVIew{
    
    ExampleTable *exampleTable = [[ExampleTable alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCheeseCount:) name:ToolShedUpdateProductPurchasedNotification object:nil];
    CGSize tSize = CGSizeMake(288 *scaleFactorX, 202 *scaleFactorY);//195
    myTable = [SWMultiColumnTableView viewWithDataSource:exampleTable size:tSize];
    myTable.position = ccp(52 *scaleFactorX, 42 *scaleFactorY);
    myTable.delegate = exampleTable; //set if you need touch detection on cells.
    myTable.colCount = 2;
    myTable.tag = 8888;
    myTable.verticalFillOrder = SWTableViewFillTopDown;
    myTable.direction = SWScrollViewDirectionVertical;
    [self addChild:myTable];
    [myTable reloadData];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    initialPos= [[CCDirector sharedDirector] convertToGL:location];
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (initialPos.x > movingBar.position.x +10 && initialPos.x < movingBar.position.x +10+ myTable.contentSize.width
        &&  initialPos.y > 45 && initialPos.y < 240) {
        
        if (location.x > movingBar.position.x +10 && location.x < movingBar.position.x +10+ myTable.contentSize.width) {
            if(initialPos.y < location.y){
                if (movingBar.position.y < 180 ) {
                    return;
                }
                movingBar.position = ccp(movingBar.position.x, movingBar.position.y - 2);
            }else{
                if (movingBar.position.y > 210 ) {
                    return;
                }
                movingBar.position = ccp(movingBar.position.x, movingBar.position.y + 2);
            }
        }
        
    }
}

-(void) addScrollBar{
    
    CCSprite * scrollBas = [CCSprite spriteWithFile:@"scroll_base.png"];
    scrollBas.position = ccp( 44 *scaleFactorX, 163 * scaleFactorY);
    [self addChild:scrollBas z:10000];
    
    int dividend = [FTMUtil sharedInstance].isRetinaDisplay ? 2:4;
    CCSprite * upArrow = [CCSprite spriteWithFile:@"up_arrow_btn.png"];
    upArrow.position = ccp( 44 *scaleFactorX, (168 + scrollBas.contentSize.height/dividend)  * scaleFactorY);
    [self addChild:upArrow z:10000];
    
    CCSprite * downArrow = [CCSprite spriteWithFile:@"down_arrow_btn.png"];
    downArrow.position = ccp( 44 *scaleFactorX, (158  - scrollBas.contentSize.height/dividend) * scaleFactorY);
    [self addChild:downArrow z:10000];
    
    movingBar = [CCSprite spriteWithFile:@"scroll_bar_btn.png"];
    movingBar.position = ccp( 44 *scaleFactorX, (163 + scrollBas.contentSize.height/dividend -movingBar.contentSize.height/dividend) * scaleFactorY);
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        scrollBas.scaleX = xScale;
        upArrow.scaleX = xScale;
        downArrow.scaleX = xScale;
        movingBar.scaleY = yScale/2;
    }else{
        scrollBas.scale = cScale;
        upArrow.scale = cScale;
        downArrow.scale = cScale;
        movingBar.scaleX = cScale;
        movingBar.scaleY = cScale/2;
    }
    
    [self addChild:movingBar z:10000];
}

//-(void) addPowerUpsUi {
//    [self makePowerUpItem:MAGNIFIER_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SPECIAL_CHEESE_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SPEEDUP_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SLOWDOWN_TIME_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:BARKING_DOG_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:BOOTS_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:MASTER_KEY_ITEM_ID cost: 100 multiplier: 3];
//}

-(void) addNewCostumesUi {
    
}

-(void) hidePowerUpUi{
    
}

-(void) hideNewConstumesUi{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ToolShedUpdateProductPurchasedNotification object:nil];
    [super dealloc];
}

@end
