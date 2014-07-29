//
//  main.m
//  VTXClient
//
//  Created by Adam Shao on 3/24/14.
//  Copyright (c) 2014 Jamdeo Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTXClient.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSString *apiUrl = @"http://api.video-tx.com/";
        NSString *email = @"qa@video-tx.com";
        NSString *password=@"tester";
        
        // init vtxclient
        VTXClient *client = [VTXClient clientWithApiUrl:apiUrl Email:email Password:password];
        // call api
        id videos = [client callApi:@"getRecentVideos" Params:@{@"maxResults":@10}];
        NSLog(@"token=%@", client.token);
        NSLog(@"%@", videos);
        id publisher = [client callApi:@"getPublisher"];
        NSLog(@"%@", publisher);
        
    }
    return 0;
}

