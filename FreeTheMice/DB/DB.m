//
//  DB.m
//  FinLit TV
//
//  Created by Muthu Arumugam on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DB.h"

@implementation DB

- init
{
	NSLog(@"Opening DB....");
	if(![super init]) return nil;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"base.sqlite"];
	
	db = [FMDatabase databaseWithPath:path];
	[db setLogsErrors:TRUE];
	[db setTraceExecution:TRUE];
	
    if (![db open]) {
        NSLog(@"Could not open db.");
        return 0;
    } else {
		//NSLog(@"oooooooohooo. DB Open....");
	}
	
	return self;
}

- (void)dealloc
{
	NSLog(@"Closing DB....");
	[db close];
	[super dealloc];
}

- (NSString *)getSettingsFor:(NSString *)strCode
{
	FMResultSet *rs = [db executeQuery:@"SELECT value FROM settings where code = ?", strCode];
	NSString *strToReturn = @"";
	
	while ([rs next]) {
		strToReturn = [rs stringForColumn:@"value"];
	}
	
	return [[strToReturn retain] autorelease];
}

- (void)setSettingsFor:(NSString *)strCode withValue:(NSString *)val
{
	
	[db executeUpdate:@"update settings set value = ? where code = ?", val, strCode];
}

@end
