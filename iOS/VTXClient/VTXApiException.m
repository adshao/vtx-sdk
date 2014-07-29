//
//  VTXApiException.m
//  VTXClient
//
//  Created by Adam Shao on 3/26/14.
//  Copyright (c) 2014 Jamdeo Cloud. All rights reserved.
//

#import "VTXApiException.h"

@implementation VTXApiException

+ (id)exceptionWithCode:(NSString *)code Location:(NSString *)location Message:(NSString *)message {
    return [VTXApiException exceptionWithName:code reason:message userInfo:@{@"location":location}];
}

@end
