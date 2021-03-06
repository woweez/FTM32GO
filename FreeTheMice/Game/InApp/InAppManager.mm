//
//  InAppManager.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 01/10/2013.
//
//

#import "InAppManager.h"
#import <StoreKit/StoreKit.h>
#import "InAppUtils.h"
#import "FTMConstants.h"
@interface InAppManager () <SKProductsRequestDelegate , SKPaymentTransactionObserver>
@end

@implementation InAppManager  

// 3
SKProductsRequest * _productsRequest;
// 4
RequestProductsCompletionHandler _completionHandler;
NSSet * _productIdentifiers;
NSMutableSet * _purchasedProductIdentifiers;
NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const StoreUpdateProductPurchasedNotification = @"StoreUpdateProductPurchasedNotification";

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];

    if ([transaction.payment.productIdentifier isEqualToString:[NSString stringWithFormat:@"com.woweez.ftmtest.pieceofcheese"]]) {
        cheese +=  100;
        [[GameKitHelper sharedGameKitHelper]reportAchievementIdentifier:kFtm100CheeseCategory percentComplete:100 maxValue:100 checkPercent:YES];
    }
    if ([transaction.payment.productIdentifier isEqualToString:[NSString stringWithFormat:@"com.woweez.ftmtest.pieceofcake"]]) {
        cheese +=  500;
        [[GameKitHelper sharedGameKitHelper]reportAchievementIdentifier:kFtm500CheeseCategory percentComplete:100 maxValue:100 checkPercent:YES];
    }
    if ([transaction.payment.productIdentifier isEqualToString:[NSString stringWithFormat:@"com.woweez.ftmtest.cheesecontainer"]]) {
        cheese +=  25000;
        [[GameKitHelper sharedGameKitHelper]reportAchievementIdentifier:kFtm1000CheeseCategory percentComplete:100 maxValue:100 checkPercent:YES];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:cheese] forKey:@"currentCheese"];
    [defaults synchronize];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:StoreUpdateProductPurchasedNotification object:nil userInfo:nil];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
   
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}
@end
