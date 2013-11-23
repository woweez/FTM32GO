//
//  ExampleTableView.m
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Martin Rehder on 06.05.13.
//

#import "ExampleTable.h"
#import "ExampleCell.h"
#import "FTMConstants.h"
#import "SWMultiColumnTableView.h"
#import "FTMUtil.h"
@implementation ExampleTable
NSString *const ToolShedUpdateProductPurchasedNotification = @"ToolShedUpdateProductPurchasedNotification";
//provide data to your table
//telling cell size to the table
-(Class)cellClassForTable:(SWTableView *)table {
    return [ExampleCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table
{
    return [ExampleCell cellSize];
}

//providing CCNode object for a cell at a given index
-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell *cell;
    
    cell = [table dequeueCell];
    scaleFactorX = [CCDirector sharedDirector].winSize.width/480;
    scaleFactorY = [CCDirector sharedDirector].winSize.height/320;
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        xScale = 1 * scaleFactorX;
        yScale = 1 * scaleFactorY;
        cScale = 1;
    }else{
        xScale = 0.5 * scaleFactorX;
        yScale = 0.5 * scaleFactorY;
        cScale = 0.5;
    }
    
    if (!cell)
    { //there is no recycled cells in the table
        cell = [[ExampleCell new] autorelease]; // create a new one
        cell.anchorPoint = CGPointZero;
        
    }else{
        
        [cell.children removeAllObjects];

    }
    soundEffect = [[sound alloc] init];

    int itemId = ++idx;
    NSString *path = [self getAppropriateImagePathWithItemID:itemId];
    CGPoint pos = [self getAppropriatePosWithItemID:itemId];
    
    CCSprite *powrUpSpr = [CCSprite spriteWithFile:path];
    powrUpSpr.position = pos;
    powrUpSpr.scale = cScale;
    powrUpSpr.tag = itemId;
        
    [cell addChild:powrUpSpr];
    if (itemId == BARKING_DOG_ITEM_ID || itemId == MAGNIFIER_ITEM_ID || itemId == BOOTS_ITEM_ID) {
        CCSprite *bg = [CCSprite spriteWithFile:[self getAppropriateBgPathWithItemID:itemId]];
        int dividend = [FTMUtil sharedInstance].isRetinaDisplay ? 2: 4;
        bg.position = ccp([ExampleCell cellSize].width, bg.contentSize.height/dividend -5);
        if (itemId == BARKING_DOG_ITEM_ID) {
            bg.position = ccp([ExampleCell cellSize].width -1, [ExampleCell cellSize].height/2);
        }else if (itemId == BOOTS_ITEM_ID){
            bg.position = ccp([ExampleCell cellSize].width, -3);
        }
        bg.scaleX = cScale * 1.19;
        bg.scaleY = cScale * 1.01;
        
        [cell addChild:bg z:-2];
    }
    
    CCMenuItem *buyItem = [CCMenuItemImage itemWithNormalImage:@"buy-btn.png" selectedImage:@"buy-btn-press.png" block:^(id sender) {
        [soundEffect button_1];
        CCMenuItem *item = (CCMenuItem *)sender;
        int cost = [self getCostWithItemID:item.tag];
        int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
        if(cheese < cost){
            return;
        }
        cheese -= cost;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:cheese] forKey:@"currentCheese"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:ToolShedUpdateProductPurchasedNotification object:nil userInfo:nil];
    
    }];
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        [buyItem setScale: 1];
    }else{
        [buyItem setScale:0.45];
    }
    buyItem.tag = itemId;
    CCMenu *buyItemMenu = [CCMenu menuWithItems:buyItem, nil];
    buyItemMenu.position = ccp(powrUpSpr.position.x + 90 *scaleFactorX, powrUpSpr.position.y *1.26);
    buyItemMenu.tag = itemId;
    buyItemMenu.contentSize = CGSizeMake(buyItem.contentSize.width/4 *scaleFactorX ,buyItem.contentSize.height/4 *scaleFactorY);
    [cell addChild:buyItemMenu];
    
    CCLabelBMFont *cost = [CCLabelBMFont labelWithString:[NSString stringWithFormat: @"Cost:%d", [self getCostWithItemID:itemId]] fntFile:@"font1.fnt"];
    cost.position= [self getAppropriateCostPosWithItemID:itemId andPoint:buyItemMenu.position];
    cost.scale = cScale * 0.6;
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        cost.scale=cScale * 0.6;
    }
    [cell addChild:cost z:0];
    
    CCLabelBMFont *name = [CCLabelBMFont labelWithString:[self getItemNameWithID:itemId] fntFile:@"font.fnt"];//Title_Yellow.fnt
    name.position= [self getNameAppropriatePosWithItemID:itemId];
    if (scaleFactorX > 1) {
        name.scale = cScale * 0.4;
        name.position= ccp(name.position.x - 12, name.position.y + 6);
    }
    else{
        name.position= ccp(name.position.x - 2, name.position.y + 6);
    }
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        name.scale = cScale * 0.8;
        name.position= ccp(name.position.x, name.position.y );
    }else{
        name.scale = 0.4;
    }
    
    [cell addChild:name z:99999];

    CCLabelBMFont *multiplier = [CCLabelBMFont labelWithString:[NSString stringWithFormat: @"x%d", [self getMultiplierWithItemID:itemId]] fntFile:@"font1.fnt"];
    multiplier.position= ccp(powrUpSpr.position.x + 34*scaleFactorX, powrUpSpr.position.y - 4.5 *scaleFactorY);
    multiplier.scale = cScale *0.6;
    [cell addChild:multiplier z:0];

    CCSprite *cheeseSpr = [CCSprite spriteWithFile:@"cheese_bite.png"];
    cheeseSpr.position = ccp(cost.position.x + 29*scaleFactorX, powrUpSpr.position.y - 12 *scaleFactorY);
    cheeseSpr.scale = cScale;
    
    if (itemId == SPECIAL_CHEESE_ITEM_ID || itemId == MASTER_KEY_ITEM_ID || itemId == BARKING_DOG_ITEM_ID) {
        cheeseSpr.position = ccp(cost.position.x + 32*scaleFactorX, powrUpSpr.position.y - 12 *scaleFactorY);
    }
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
         cheeseSpr.scale = cScale *1.3;
    }
   
    cheeseSpr.tag = itemId;
    [cell addChild:cheeseSpr];
    
    return cell;
}
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    //return a number
    return 7;
}

-(CGPoint) getNameAppropriatePosWithItemID:(int) itemId{
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 31*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 27 *scaleFactorY);
            break;
        case BOOTS_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 1*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 25 *scaleFactorY);
            break;
        case SPEEDUP_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 45*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 25 *scaleFactorY);
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 28*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 24 *scaleFactorY);
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 40*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 27 *scaleFactorY);
            break;
        case MASTER_KEY_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 26*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 24 *scaleFactorY);
            break;
        case BARKING_DOG_ITEM_ID:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 28*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 25 *scaleFactorY);
            break;
        default:
            return ccp([self getAppropriatePosWithItemID : itemId].x + 24*scaleFactorX, [self getAppropriatePosWithItemID : itemId].y - 27 *scaleFactorY);
            break;
    }
    
}


-(CGPoint) getAppropriatePosWithItemID:(int) itemId{
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return ccp(27 *scaleFactorX, 35 *scaleFactorY);//28
            break;
        case BOOTS_ITEM_ID:
            return ccp(27 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SPEEDUP_ITEM_ID:
            return ccp(27 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return ccp(27 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return ccp(27 *scaleFactorX, 35 *scaleFactorY);
            break;
        case MASTER_KEY_ITEM_ID:
            return ccp(27 *scaleFactorX, 35*scaleFactorY );
            break;
        case BARKING_DOG_ITEM_ID:
            return ccp(27 *scaleFactorX, 37 *scaleFactorY);
            break;
        default:
            return ccp(27 *scaleFactorX, 37 *scaleFactorY);
            break;
    }
    
}

-(CGPoint) getAppropriateCostPosWithItemID:(int) itemId andPoint:(CGPoint) point{
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return ccp(point.x -15 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case BOOTS_ITEM_ID:
            return ccp(point.x -15 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case SPEEDUP_ITEM_ID:
            return ccp(point.x -15 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return ccp(point.x -18 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return ccp(point.x -15 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case MASTER_KEY_ITEM_ID:
            return ccp(point.x -18 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        case BARKING_DOG_ITEM_ID:
            return ccp(point.x -18 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
        default:
            return ccp(point.x -15 *scaleFactorX, point.y - 13 *scaleFactorY);
            break;
    }
    
}


-(int) getMultiplierWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return 3;
            break;
        case BOOTS_ITEM_ID:
            return 3;
            break;
        case SPEEDUP_ITEM_ID:
            return 3;
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return 2;
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return 3;
            break;
        case MASTER_KEY_ITEM_ID:
            return 1;
            break;
        case BARKING_DOG_ITEM_ID:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

-(int) getCostWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return 20;
            break;
        case BOOTS_ITEM_ID:
            return 30;
            break;
        case SPEEDUP_ITEM_ID:
            return 30;
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return 150;
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return 40;
            break;
        case MASTER_KEY_ITEM_ID:
            return 1000;
            break;
        case BARKING_DOG_ITEM_ID:
            return 100;
            break;
        default:
            return 0;
            break;
    }
}


-(NSString *) getAppropriateImagePathWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return @"magnifier_glass.png";
            break;
        case BOOTS_ITEM_ID:
            return @"boots.png";
            break;
        case SPEEDUP_ITEM_ID:
            return @"speed_fire_cheese.png";
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return @"special_cheese_respawn.png";
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return @"slow_down_time.png";
            break;
        case MASTER_KEY_ITEM_ID:
            return @"master_key.png";
            break;
        case BARKING_DOG_ITEM_ID:
            return @"barking_sound.png";
            break;
        default:
            return @"barking_sound.png";
            break;
    }
}

-(NSString *) getAppropriateBgPathWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return @"Drawers_1.png";
            break;
        case BOOTS_ITEM_ID:
            return @"Drawers_2.png";
            break;
        case SPEEDUP_ITEM_ID:
            return @"drawer5.png";
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return @"drawer3.png";
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return @"drawer4.png";
            break;
        case MASTER_KEY_ITEM_ID:
            return @"drawer6.png";
            break;
        case BARKING_DOG_ITEM_ID:
            return @"drawer7.png";
            break;
        default:
            return @"drawer1.png";
            break;
    }
}


-(NSString *) getItemNameWithID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return @"Magnifier Glass";
            break;
        case BOOTS_ITEM_ID:
            return @"Boots";
            break;
        case SPEEDUP_ITEM_ID:
            return @"Speed:Fire Cheese";
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return @"Special Cheese";
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return @"Slow Down Time";
            break;
        case MASTER_KEY_ITEM_ID:
            return @"Master Key";
            break;
        case BARKING_DOG_ITEM_ID:
            return @"Barking Sound";
            break;
        default:
            return @"Barking Sound";
            break;
    }
}

//touch detection here
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell
{
        NSLog(@"Store item touched at index %d",cell.idx);
    
  
}

-(void)dealloc{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

    
    [super dealloc];
    
}

@end
