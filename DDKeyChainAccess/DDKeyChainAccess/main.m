//
//  main.m
//  DDKeyChainAccess
//
//  Created by LEE CHIEN-MING on 12/23/14.
//  Copyright (c) 2014 cheesecake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDKeyChain.h"

static NSString *const cheeseCakeService = @"cheeseCake";
static NSString *const kDDPasswordKey = @"DDPasswordKey";

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // Create DDKeyChain
        DDKeyChain *myKeyChain = [DDKeyChain keychainWithService:cheeseCakeService group:nil];
        
        NSData *password = [@"thisIsNotMyPassword" dataUsingEncoding:NSUTF8StringEncoding];
        
        // Add a key paired information to the keychain
        BOOL isSuccessful = [myKeyChain addKey:kDDPasswordKey data:password];
        if (isSuccessful) {
            NSLog(@"You successfully added a key, %@", kDDPasswordKey);
        }
        else {
            NSLog(@"You failed to add a key, %@", kDDPasswordKey);
        }
        
        // Find your data
        NSData *myData = [myKeyChain findDataByKey:kDDPasswordKey];
        if (myData) {
            NSLog(@"Got my data is: %@", [NSString stringWithUTF8String:[myData bytes]]);
        }
        else {
            NSLog(@"No data was found for key, %@.", kDDPasswordKey);
        }
        
        // Delete the data with your key
        BOOL isRemoved = [myKeyChain removeKey:kDDPasswordKey];
        if (isRemoved) {
            NSLog(@"%@ was removed from Keychain", kDDPasswordKey);
        }
        else {
            NSLog(@"Failed to remove %@ from Keychain", kDDPasswordKey);
        }
    }
    return 0;
}
