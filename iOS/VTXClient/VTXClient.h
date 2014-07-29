//
//  VTXClient.h
//  VTXClient
//
//  Created by Adam Shao on 3/24/14.
//  Copyright (c) 2014 Jamdeo Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTXClient : NSObject

@property (copy) NSString *apiUrl;
@property (readonly) NSString *token;

- (id)initWithApiUrl:(NSString *)apiUrl Email:(NSString *)email Password:(NSString *)password;
- (id)initWithApiUrl:(NSString *)apiUrl;
- (id)initWithEmail:(NSString *)email Password:(NSString *)password;

+ (id)clientWithApiUrl:(NSString *)apiUrl Email:(NSString *)email Password:(NSString *)password;
+ (id)clientWithEmail:(NSString *)email Password:(NSString *)password;

- (void)login;
- (void)loginWithEmail:(NSString *)email Password:(NSString *)password;

- (id)callApi:(NSString *)apiName Params:(NSDictionary *) params;
- (id)callApi:(NSString *)apiName;

@end
