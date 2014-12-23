//
//  DDKeyChain.h
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 12/16/14.
//  Copyright (c) 2014 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDKeyChain : NSObject
/**
 Class method to create DDKeyChain instance
 
 @param aServiceNotNil A service name must not be nil
 @param aGroup         A group name
 
 @return DDKeyChain instance
 */
+ (DDKeyChain *)keychainWithService:(NSString *)aServiceNotNil group:(NSString *)aGroup;

/**
 Add desired data to keychain
 
 @param aKey  A key to pair with saving data
 @param aData Target data
 
 @return successful or not
 */
- (BOOL)addKey:(NSString *)aKey data:(NSData *)aData;

/**
 Remove target data with specified key
 
 @param aKey A key has been paired with saving data
 
 @return successful or not
 */
- (BOOL)removeKey:(NSString *)aKey;

/**
 Find target data with specified key
 
 @param aKey A key has been paired with saving data
 
 @return the retrieved data
 */
- (NSData *)findDataByKey:(NSString *)aKey;
@end
