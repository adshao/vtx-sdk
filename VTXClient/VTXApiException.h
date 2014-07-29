//
//  VTXApiException.h
//  VTXClient
//
//  Created by Adam Shao on 3/26/14.
//  Copyright (c) 2014 Jamdeo Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTXApiException : NSException

+ (id)exceptionWithCode:(NSString *)code Location:(NSString *)location Message:(NSString *)message;

@end
