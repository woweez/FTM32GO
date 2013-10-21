//
//  InAppUtils.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 01/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "InAppManager.h"
@interface InAppUtils : InAppManager

+ (InAppUtils *)sharedInstance;
@property (nonatomic, retain) NSArray* _products;
@property int itemIndex;

@end
