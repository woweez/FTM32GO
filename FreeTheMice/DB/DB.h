//
//  DB.h
//  FinLit TV
//
//  Created by Muthu Arumugam on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DB : NSObject {
	FMDatabase* db;
}

- (NSString *)getSettingsFor:(NSString *)strCode;
- (void)setSettingsFor:(NSString *)strCode withValue:(NSString *)val;

@end
