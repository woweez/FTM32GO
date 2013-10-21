//
//  StoreScreen.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 30/09/2013.
//
//

#import "StoreScreen.h"
#import "ToolShedScreen.h"
#import <StoreKit/StoreKit.h>
#import "InAppUtils.h"
#import "FTMConstants.h"

@implementation StoreScreen

NSString *const StoreUpdateProductPurchasedNotification = @"StoreUpdateProductPurchasedNotification";
+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
    StoreScreen *layer = [StoreScreen node];
    layer.tag = 128;
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
        
        if (RETINADISPLAY == 2) {
            xScale = 1 * scaleFactorX;
            yScale = 1 * scaleFactorY;
            cScale = 1;
        }else{
            xScale = 0.5 * scaleFactorX;
            yScale = 0.5 * scaleFactorY;
            cScale = 0.5;
        }
        
        
        CCSprite *storeBg = [CCSprite spriteWithFile: @"cheese_store_bg.png"];
        storeBg.position = ccp(240 *scaleFactorX, 160 *scaleFactorY);
        storeBg.scaleX = xScale;
        storeBg.scaleY = yScale;
        [self addChild:storeBg];
        int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
        totalCheese = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", cheese] charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'];
        totalCheese.position= ccp(225 *scaleFactorX, 38 *scaleFactorY);
        totalCheese.scale = 0.8;
        [self addChild:totalCheese z:0];
        soundEffect = [[sound alloc] init];
        CCMenuItem *backButtonItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[ToolShedScreen scene]];
        }];
        
        [backButtonItem setScale:cScale];
        CCMenu *backMenu = [CCMenu menuWithItems:backButtonItem, nil];
        backMenu.position = ccp(50 *scaleFactorX, 40 *scaleFactorY);
        [self addChild:backMenu];
        [self addBuyButtons];
        
        
//        [self schedule:@selector(loadThePricePoints) interval:5];
        
        
    }
    return self;
}

-(void) loadThePricePoints{
    [self unschedule:@selector(loadThePricePoints)];
    
    [[InAppUtils sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            [InAppUtils sharedInstance]._products = products;
            
            NSLog(@"No of products retrived successfully: %d", [InAppUtils sharedInstance]._products.count);
        }
    }];
    
}

- (void)updateStoreAboutPurchased:(NSString *) updateNotification {
    int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
    [totalCheese setString:[NSString stringWithFormat:@"%d", cheese]];
}
-(void) addBuyButtons{
    for (int i = 1; i<= 3; i++) {
        CCMenuItem *buyItem = [CCMenuItemImage itemWithNormalImage:@"buy-btn.png" selectedImage:@"buy-btn-press.png" block:^(id sender) {
            [soundEffect button_1];
            if ([[InAppUtils sharedInstance]._products count] <3) {
                return;
            }
            CCMenuItem *item = (CCMenuItem *)sender;
            SKProduct *product = [InAppUtils sharedInstance]._products[item.tag -1];
            NSLog(@"Buying %@...", product.productIdentifier);
            [[InAppUtils sharedInstance] buyProduct:product];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreAboutPurchased:) name:StoreUpdateProductPurchasedNotification object:nil];
        }];
        CGPoint pos;
        [buyItem setScale:cScale];
        buyItem.tag = i;
        switch (i) {
            case 1:
                pos = ccp(275 *scaleFactorX, (87) *scaleFactorY);
                break;
            case 2:
                pos = ccp(275 *scaleFactorX, (155) *scaleFactorY);
                break;
            case 3:
                pos = ccp(275 *scaleFactorX, (220) *scaleFactorY);
                break;

            default:
                break;
        }
        CCMenu *buyItemMenu = [CCMenu menuWithItems:buyItem, nil];
        buyItemMenu.position = pos;
        buyItemMenu.tag = i;
        [self addChild:buyItemMenu];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:StoreUpdateProductPurchasedNotification object:nil];
    [super dealloc];
}
- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [[InAppUtils sharedInstance]._products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"Transaction Is fully finalized. %@...", product.productIdentifier);
        }
    }];
    
}
@end
