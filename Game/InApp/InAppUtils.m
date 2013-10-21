//
//  InAppUtils.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 01/10/2013.
//
//

#import "InAppUtils.h"

@implementation InAppUtils
 NSMutableArray *_products;
@synthesize itemIndex;

+ (InAppUtils *)sharedInstance {
    static dispatch_once_t once;
    static InAppUtils * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.woweez.ftmtest.pieceofcheese",
                                      @"com.woweez.ftmtest.pieceofcake",
                                      @"com.woweez.ftmtest.cheesecontainer",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
