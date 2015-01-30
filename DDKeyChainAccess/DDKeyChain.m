//
//  DDKeyChain.m
//  ObjectiveCPractice
//
//  Created by LEE CHIEN-MING on 12/16/14.
//  Copyright (c) 2014 Derek. All rights reserved.
//

#import "DDKeyChain.h"

@interface DDKeyChain()
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *groupName;
@end

@implementation DDKeyChain
#pragma mark - Initialization
- (instancetype)initWithService:(NSString *)aServiceNotNil group:(NSString *)aGroup
{
    NSAssert(aServiceNotNil != nil, @"The string for service name must not be nil.");

    self = [super init];
    if (self) {
        _serviceName = aServiceNotNil;
        _groupName = aGroup;
    }
    return self;
}

+ (DDKeyChain *)keychainWithService:(NSString *)aServiceNotNil group:(NSString *)aGroup
{
    return [[self alloc] initWithService:aServiceNotNil group:aGroup];
}

#pragma mark - Private Methods
- (NSDictionary *)queryingForKey:(NSString *)aKey
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: self.serviceName,
                            (__bridge id)kSecAttrGeneric: aKey,
                            (__bridge id)kSecAttrAccount: aKey,
                            (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly: (__bridge id)kSecAttrAccessible
                            };
    if (self.groupName) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:query];
        dict[(__bridge id)kSecAttrAccessGroup] = self.groupName;
        query = [NSDictionary dictionaryWithDictionary:dict];
    }
    
    return query;
}

#pragma mark - Public Methods
- (BOOL)addKey:(NSString *)aKey data:(NSData *)aData
{
    NSDictionary *query = [self queryingForKey:aKey];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    if (status == errSecSuccess) {
        NSDictionary *updatedAttributes =
        @{(__bridge id)kSecValueData: aData};
        
        status = SecItemUpdate((__bridge CFDictionaryRef)query,
                      (__bridge CFDictionaryRef)updatedAttributes);
    } else {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:query];
        attributes[(__bridge id)kSecValueData] = aData;
        attributes[(__bridge id)kSecAttrAccessible] =
        (__bridge id)kSecAttrAccessibleAfterFirstUnlock;
        
        status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
    }
    
    if (status != errSecSuccess) {
        NSLog(@"Adding item for key, %@, was failed. Error: %d", aKey, status);
    }
    
    return (status == errSecSuccess);
}

- (BOOL)removeKey:(NSString *)aKey
{
    NSDictionary *query = [self queryingForKey:aKey];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != errSecSuccess) {
        NSLog(@"Removing item for key, %@, was failed. Error: %d", aKey, status);
    }
    
    return (status == errSecSuccess);
}

- (NSData *)findDataByKey:(NSString *)aKey
{
    NSDictionary *query = [self queryingForKey:aKey];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:query];
    attributes[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    attributes[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attributes, &result);
    
    if( status != errSecSuccess) {
        NSLog(@"Fetching item for key %@ was failed. Error: %d", aKey, status);
    }
    
    return (__bridge NSData *)result;
}

@end
