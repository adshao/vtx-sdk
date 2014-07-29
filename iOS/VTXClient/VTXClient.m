//
//  VTXClient.m
//  VTXClient
//
//  Created by Adam Shao on 3/24/14.
//  Copyright (c) 2014 Jamdeo Cloud. All rights reserved.
//

#import "VTXClient.h"
#import "VTXApiException.h"

@interface VTXClient ()

@property (copy) NSString *email;
@property (copy) NSString *password;
@property NSString *token;

@end

@implementation VTXClient

- (id)initWithApiUrl:(NSString *)apiUrl Email:(NSString *)email Password:(NSString *)password {
    self = [super init];
    if (self) {
        if (apiUrl) {
            _apiUrl = [apiUrl copy];
        }
        else {
            _apiUrl = @"http://api.aliyun.video-tx.com/";
        }
        if (email) {
            _email = [email copy];
        }
        if (password) {
            _password = [password copy];
        }
    }
    return self;
}

- (id)initWithApiUrl:(NSString *)apiUrl {
    return [self initWithApiUrl:apiUrl Email:nil Password:nil];
}

- (id)initWithEmail:(NSString *)email Password:(NSString *)password {
    return [self initWithApiUrl:nil Email:nil Password:nil];
}

+ (id)clientWithApiUrl:(NSString *)apiUrl Email:(NSString *)email Password:(NSString *)password {
    return [[self alloc] initWithApiUrl:apiUrl Email:email Password:password];
}

+ (id)clientWithEmail:(NSString *)email Password:(NSString *)password {
    VTXClient *client = [[self alloc] initWithEmail:email Password:password];
    return client;
}


- (id)mCallApi:(NSString *)apiName Params:(NSDictionary *)params {
    // set api url
    NSString *url = [NSString stringWithFormat:@"%@%@", self.apiUrl, apiName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // set token
    if (self.token) {
        NSDictionary *headers = [request allHTTPHeaderFields];
        [headers setValue:@"Authorization" forKey:self.token];
    }
    [request setHTTPMethod:@"POST"];
    // combine post body
    NSMutableArray *paramStrArray = [NSMutableArray new];
    for (NSString *key in params) {
        [paramStrArray addObject:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
    }
    NSString *paramStr = [paramStrArray componentsJoinedByString:@"&"];
    NSData *data = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *error;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(@"%@", [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]);
    id ret = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:nil];
    // check if api error
    if ([ret isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)ret;
        if ([d objectForKey:@"error"]) {
            @throw [VTXApiException exceptionWithCode:[d objectForKey:@"error"] Location:[d objectForKey:@"location"] Message:[d objectForKey:@"message"]];
        }
    }
    return ret;
}

- (void)login {
    [self loginWithEmail:self.email Password:self.password];
}

- (void)loginWithEmail:(NSString *)email Password:(NSString *)password {
    NSDictionary *mParams = @{@"email":email, @"passwd":password};
    id result = [self mCallApi:@"login" Params:mParams];
    NSDictionary *d = (NSDictionary *)result;
    NSString *status = [d objectForKey:@"status"];
    if ([@"SUCCESS" isEqualToString:status]) {
        self.token = [d objectForKey:@"token"];
    }
    else {
        @throw [VTXApiException exceptionWithCode:[d objectForKey:@"error"] Location:[d objectForKey:@"location"] Message:[d objectForKey:@"message"]];
    }
}

- (id)callApi:(NSString *)apiName Params:(NSDictionary *)params {
    if (![apiName hasPrefix:@"public/"] && !self.token) {
        // login first if no token found and api is not public
        [self login];
    }
    return [self mCallApi:apiName Params:params];
}

- (id)callApi:(NSString *)apiName {
    return [self callApi:apiName Params:nil];
}


@end
