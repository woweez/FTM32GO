//
//  InAppManager.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 01/10/2013.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
@interface InAppManager : NSObject


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
