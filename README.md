Key Chain Access
----------------

The sample code demonstrates how to access the keychain information through Apple's API. 

Usage
----------
###Create DDKeyChain
Specify group name and service name for your basic keychain informations. Service name should not be nil, otherwise the crash happens when adding or retrieving the key.

```objective-c
DDKeyChain *myKeyChain = [DDkeyChain keychainWithService:aServiceNotNil group:aGroup];                                             
```

###Add Key

```objective-c
NSString *passwordKey = @"passwordKey";
NSData *aKeyChainData = [@"thisIsNotMyPassword" dataUsingEncoding:NSUTF8StringEncoding];
BOOL isSuccessful = [myKeyChain addKey:passwordKey data:aKeyChainData];
```

###Remove Key

```objective-c
BOOL isRemoved = [myKeyChain removeKey:passwordKey];
```

###Find Data

```objective-c
NSData *myData = [myKeyChain findDataByKey:passwordKey];
```