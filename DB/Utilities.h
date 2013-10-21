//
//  Utilities.h
//  Amigle
//
//  Created by Muthu Arumugam on 10/18/08.
//  Copyright 2008 Amigle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface Utilities : NSObject {
    
}

+ (void)showMessage:(NSString *)strMessage inView:(UIView *)viewName;
+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)overwriteEditableCopyOfDatabaseIfNeeded;
+ (NSString *)baseURL;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image withSize:(int)kMaxResolution;
+ (NSString *)getFilePath;
+ (BOOL)connectedToNetwork;
@end
